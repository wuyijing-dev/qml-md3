#!/usr/bin/env bash
# One-shot: build Md3 (library only), stage to dist/Md3, then install to system.
#
# Usage:
#   ./scripts/package-linux.sh                 # SHARED=1 (default) → /usr/local
#   SHARED=0 ./scripts/package-linux.sh        # static .a package
#   PREFIX=$HOME/.local ./scripts/package-linux.sh
#   SYS_PREFIX=/opt/md3 ./scripts/package-linux.sh
#   SKIP_SYSTEM_INSTALL=1 ./scripts/package-linux.sh   # only dist/Md3
#   CMAKE_PREFIX_PATH=$HOME/Qt/6.10.2/gcc_64 ./scripts/package-linux.sh
#
# Outputs:
#   dist/Md3/                     staged package (always)
#   dist/Md3-linux-<arch>.tar.gz  optional archive
#   $SYS_PREFIX                   system install (default /usr/local)

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${BUILD_DIR:-$ROOT/build-lib}"
STAGE_PREFIX="${STAGE_PREFIX:-$ROOT/dist/Md3}"
# PREFIX overrides stage dir for backwards compat; SYS_PREFIX is system install root
PREFIX="${PREFIX:-$STAGE_PREFIX}"
SYS_PREFIX="${SYS_PREFIX:-/usr/local}"
SHARED="${SHARED:-1}"
SKIP_SYSTEM_INSTALL="${SKIP_SYSTEM_INSTALL:-0}"
JOBS="${JOBS:-$(nproc 2>/dev/null || echo 4)}"
BUILD_TYPE="${BUILD_TYPE:-Release}"
MAKE_TARBALL="${MAKE_TARBALL:-1}"
GENERATOR="${GENERATOR:-}"

die() { echo "error: $*" >&2; exit 1; }
info() { echo "==> $*"; }

detect_qt_prefix() {
    if [[ -n "${CMAKE_PREFIX_PATH:-}" ]]; then
        echo "${CMAKE_PREFIX_PATH%%:*}"
        return 0
    fi
    local qmake=""
    for c in qmake6 qtpaths6 qmake; do
        if command -v "$c" >/dev/null 2>&1; then
            qmake="$c"
            break
        fi
    done
    if [[ -n "$qmake" ]]; then
        if [[ "$qmake" == qtpaths6 ]] || [[ "$qmake" == qtpaths ]]; then
            "$qmake" --install-prefix 2>/dev/null && return 0
        else
            "$qmake" -query QT_INSTALL_PREFIX 2>/dev/null && return 0
        fi
    fi
    local cand
    for cand in \
        "$HOME/Qt"/6.*/gcc_64 \
        /opt/Qt/6.*/gcc_64 \
        /usr/lib/x86_64-linux-gnu/cmake/Qt6/../../.. \
        /usr
    do
        # shellcheck disable=SC2086
        for p in $cand; do
            if [[ -f "$p/lib/cmake/Qt6/Qt6Config.cmake" ]] || [[ -f "$p/lib/x86_64-linux-gnu/cmake/Qt6/Qt6Config.cmake" ]]; then
                echo "$p"
                return 0
            fi
        done
    done
    return 1
}

need_cmd() {
    command -v "$1" >/dev/null 2>&1 || die "missing command: $1"
}

install_to_prefix() {
    local dest="$1"
    info "Install → $dest"
    if mkdir -p "$dest" 2>/dev/null && [[ -w "$dest" ]]; then
        cmake --install "$BUILD_DIR" --prefix "$dest"
        return 0
    fi
    if command -v sudo >/dev/null 2>&1; then
        info "Need elevated rights for $dest — using sudo"
        sudo cmake --install "$BUILD_DIR" --prefix "$dest"
        return 0
    fi
    die "cannot write to $dest (try PREFIX=\$HOME/.local or install sudo)"
}

need_cmd cmake
need_cmd tar

if [[ -z "$GENERATOR" ]]; then
    if command -v ninja >/dev/null 2>&1; then
        GENERATOR=Ninja
    else
        GENERATOR="Unix Makefiles"
    fi
fi

QT_PREFIX="$(detect_qt_prefix)" || die \
    "Qt6 not found. Set CMAKE_PREFIX_PATH (e.g. \$HOME/Qt/6.10.2/gcc_64)."

if [[ "$SHARED" == "1" || "$SHARED" == "ON" || "$SHARED" == "on" || "$SHARED" == "true" ]]; then
    SHARED_ON=ON
    SHARED_LABEL=shared
else
    SHARED_ON=OFF
    SHARED_LABEL=static
fi

# If user set PREFIX to a system path, treat it as SYS_PREFIX and keep stage in dist/Md3
if [[ "$PREFIX" == "/usr" || "$PREFIX" == "/usr/local" || "$PREFIX" == /opt/* ]]; then
    SYS_PREFIX="$PREFIX"
    PREFIX="$STAGE_PREFIX"
fi

info "ROOT         = $ROOT"
info "BUILD_DIR    = $BUILD_DIR"
info "STAGE        = $PREFIX"
info "SYS_PREFIX   = $SYS_PREFIX"
info "SHARED       = $SHARED_ON ($SHARED_LABEL)"
info "Qt prefix    = $QT_PREFIX"
info "Generator    = $GENERATOR ($JOBS jobs, $BUILD_TYPE)"

info "Clean build dir $BUILD_DIR"
rm -rf "$BUILD_DIR"

CMAKE_ARGS=(
    -S "$ROOT"
    -B "$BUILD_DIR"
    -G "$GENERATOR"
    -DMD3_BUILD_GALLERY=OFF
    -DMD3_BUILD_SHARED="$SHARED_ON"
    -DCMAKE_BUILD_TYPE="$BUILD_TYPE"
    -DCMAKE_INSTALL_PREFIX="$PREFIX"
    -DCMAKE_PREFIX_PATH="$QT_PREFIX"
)

info "Configure"
cmake "${CMAKE_ARGS[@]}"

info "Build"
cmake --build "$BUILD_DIR" --parallel "$JOBS"

info "Stage → $PREFIX"
rm -rf "$PREFIX"
cmake --install "$BUILD_DIR" --prefix "$PREFIX"

[[ -d "$PREFIX/include/Md3" ]] || die "missing include/Md3 after stage"
[[ -d "$PREFIX/lib/cmake/Md3" ]] || die "missing lib/cmake/Md3 after stage"

LIB_HIT=""
find_lib() {
    local dir="$1" pattern="$2"
    # Prefer exact file, then glob (SONAME)
    if [[ -f "$dir/$pattern" ]]; then
        echo "$dir/$pattern"
        return 0
    fi
    local hit
    hit="$(compgen -G "$dir/$pattern" 2>/dev/null | head -n1 || true)"
    [[ -n "$hit" ]] && echo "$hit" && return 0
    return 1
}

if [[ "$SHARED_ON" == "ON" ]]; then
    for libdir in "$PREFIX/lib" "$PREFIX/lib64"; do
        [[ -d "$libdir" ]] || continue
        LIB_HIT="$(find_lib "$libdir" "libMd3.so" || find_lib "$libdir" "libMd3.so.*" || true)"
        [[ -n "$LIB_HIT" ]] && break
    done
    if [[ -z "$LIB_HIT" ]]; then
        for n in Md3.dll libMd3.dll; do
            if [[ -f "$PREFIX/bin/$n" ]]; then
                LIB_HIT="$PREFIX/bin/$n"
                break
            fi
        done
    fi
    [[ -n "$LIB_HIT" ]] || die "missing libMd3.so under $PREFIX/lib (shared build)"
else
    for n in libMd3.a libMd3.so; do
        if [[ -f "$PREFIX/lib/$n" ]]; then
            LIB_HIT="$PREFIX/lib/$n"
            break
        fi
        if [[ -f "$PREFIX/lib64/$n" ]]; then
            LIB_HIT="$PREFIX/lib64/$n"
            break
        fi
    done
    [[ -n "$LIB_HIT" ]] || die "missing libMd3 under $PREFIX/lib"

    PLUGIN_HIT=""
    for n in libMd3plugin.a libMd3plugin.so; do
        if [[ -f "$PREFIX/lib/$n" ]]; then
            PLUGIN_HIT="$PREFIX/lib/$n"
            break
        fi
        if [[ -f "$PREFIX/lib64/$n" ]]; then
            PLUGIN_HIT="$PREFIX/lib64/$n"
            break
        fi
    done
    if [[ -n "$PLUGIN_HIT" ]] && command -v nm >/dev/null 2>&1; then
        if nm -u "$PLUGIN_HIT" 2>/dev/null | grep -q "qInitResources_qmlcache"; then
            die "static package still references qInitResources_qmlcache. Delete $BUILD_DIR and retry."
        fi
        if ! nm "$LIB_HIT" 2>/dev/null | grep -q "qml_register_types_Md3"; then
            die "libMd3 is missing qml_register_types_Md3 — package incomplete"
        fi
    fi
fi

# Keep shared packaging behavior aligned with Windows:
# when staging a Release shared package, also stage Debug runtime bits for Debug kits.
if [[ "$SHARED_ON" == "ON" && "$BUILD_TYPE" == "Release" ]]; then
    DEBUG_BUILD_DIR="${ROOT}/build-lib-debug"
    DEBUG_STAGE="/tmp/md3-debug-stage-$$"
    info "Also building Debug shared Md3 (lib/debug + lib/qml-debug)"
    rm -rf "$DEBUG_BUILD_DIR" "$DEBUG_STAGE"
    cmake -S "$ROOT" -B "$DEBUG_BUILD_DIR" -G "$GENERATOR" \
        -DMD3_BUILD_GALLERY=OFF \
        -DMD3_BUILD_SHARED=ON \
        -DCMAKE_BUILD_TYPE=Debug \
        -DCMAKE_INSTALL_PREFIX="$DEBUG_STAGE" \
        -DCMAKE_PREFIX_PATH="$QT_PREFIX"
    cmake --build "$DEBUG_BUILD_DIR" --parallel "$JOBS"
    cmake --install "$DEBUG_BUILD_DIR" --prefix "$DEBUG_STAGE"

    mkdir -p "$PREFIX/lib/debug"
    if [[ -f "$DEBUG_STAGE/lib/libMd3.so" ]]; then
        cp -f "$DEBUG_STAGE/lib/libMd3.so" "$PREFIX/lib/debug/libMd3.so"
    else
        for cand in "$DEBUG_STAGE"/lib/libMd3.so.*; do
            [[ -e "$cand" ]] || continue
            cp -f "$cand" "$PREFIX/lib/debug/" || true
        done
    fi
    if [[ -d "$DEBUG_STAGE/lib/qml" ]]; then
        rm -rf "$PREFIX/lib/qml-debug"
        cp -a "$DEBUG_STAGE/lib/qml" "$PREFIX/lib/qml-debug"
    fi
    info "Debug Md3 staged: lib/debug + lib/qml-debug"
    rm -rf "$DEBUG_STAGE"
fi

cat > "$PREFIX/README.md" <<EOF
# Md3 packaged library ($SHARED_LABEL)

Built by \`scripts/package-linux.sh\` from QML_MD3.

## Layout

| Path | Content |
|------|---------|
| \`lib/libMd3.*\` | Core library ($SHARED_LABEL) |
| \`lib/libMd3plugin.*\` | QML plugin |
| \`lib/debug/\` | Debug \`libMd3.so*\` (shared Release packages) |
| \`lib/qml-debug/\` | Debug QML plugin tree (shared Release packages) |
| \`lib/Md3/stubs/\` | Static plugin init sources (static builds) |
| \`lib/qml/Md3/\` | qmldir / qmltypes |
| \`lib/cmake/Md3/\` | \`find_package(Md3)\` |
| \`include/Md3/\` | C++ headers |

## CMake

\`\`\`cmake
list(APPEND CMAKE_PREFIX_PATH "${SYS_PREFIX}")
# or: list(APPEND CMAKE_PREFIX_PATH "${PREFIX}")
find_package(Md3 REQUIRED)
target_link_libraries(yourApp PRIVATE Md3::Md3)
\`\`\`

Qt used: \`${QT_PREFIX}\`
EOF

info "Stage ready: $PREFIX ($SHARED_LABEL)"
ls -la "$PREFIX/lib" 2>/dev/null | sed -n '1,30p' || ls -la "$PREFIX/lib64" 2>/dev/null | sed -n '1,30p' || true

if [[ "$SKIP_SYSTEM_INSTALL" != "1" ]]; then
    install_to_prefix "$SYS_PREFIX"
    if [[ "$SHARED_ON" == "ON" ]] && [[ "$SYS_PREFIX" == "/usr" || "$SYS_PREFIX" == "/usr/local" ]]; then
        if command -v ldconfig >/dev/null 2>&1; then
            info "Running ldconfig"
            if [[ -w /etc/ld.so.cache ]] 2>/dev/null || [[ $(id -u) -eq 0 ]]; then
                ldconfig || true
            elif command -v sudo >/dev/null 2>&1; then
                sudo ldconfig || true
            else
                info "Skip ldconfig (no permission); run: sudo ldconfig"
            fi
        fi
    fi
    info "System install done: $SYS_PREFIX"
else
    info "SKIP_SYSTEM_INSTALL=1 — staged only at $PREFIX"
fi

if [[ "$MAKE_TARBALL" == "1" ]]; then
    ARCH="$(uname -m)"
    OUT_TGZ="$ROOT/dist/Md3-linux-${ARCH}-${SHARED_LABEL}.tar.gz"
    mkdir -p "$ROOT/dist"
    tar -C "$(dirname "$PREFIX")" -czf "$OUT_TGZ" "$(basename "$PREFIX")"
    info "Archive: $OUT_TGZ"
fi

info "Done ($SHARED_LABEL)."
echo "  staged:        $PREFIX"
if [[ "$SKIP_SYSTEM_INSTALL" != "1" ]]; then
    echo "  system:        $SYS_PREFIX"
    echo "  find_package:  list(APPEND CMAKE_PREFIX_PATH \"$SYS_PREFIX\")"
    if [[ "$SHARED_ON" == "ON" ]]; then
        echo "  runtime:       sudo ldconfig   # if libs not found at run time"
    fi
else
    echo "  find_package:  list(APPEND CMAKE_PREFIX_PATH \"$PREFIX\")"
fi
