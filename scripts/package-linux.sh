#!/usr/bin/env bash
# One-shot: build Md3 (library only) and package into a standalone folder.
#
# Usage:
#   ./scripts/package-linux.sh
#   PREFIX=$HOME/opt/Md3 ./scripts/package-linux.sh
#   CMAKE_PREFIX_PATH=$HOME/Qt/6.10.2/gcc_64 ./scripts/package-linux.sh
#
# Output (default):
#   dist/Md3/
#     lib/libMd3.a
#     lib/libMd3plugin.a          (if present)
#     lib/qml/Md3/                qmldir / qmltypes
#     lib/cmake/Md3/              Md3Config.cmake
#     lib/Md3/stubs/              static plugin init sources
#     include/Md3/                C++ headers
#   dist/Md3-linux-<arch>.tar.gz  (optional archive)

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${BUILD_DIR:-$ROOT/build-lib}"
PREFIX="${PREFIX:-$ROOT/dist/Md3}"
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

info "ROOT        = $ROOT"
info "BUILD_DIR   = $BUILD_DIR"
info "PREFIX      = $PREFIX"
info "Qt prefix   = $QT_PREFIX"
info "Generator   = $GENERATOR ($JOBS jobs, $BUILD_TYPE)"

# Always clean build tree so NO_CACHEGEN / install rules from latest sources apply
info "Clean build dir $BUILD_DIR"
rm -rf "$BUILD_DIR"

CMAKE_ARGS=(
    -S "$ROOT"
    -B "$BUILD_DIR"
    -G "$GENERATOR"
    -DMD3_BUILD_GALLERY=OFF
    -DCMAKE_BUILD_TYPE="$BUILD_TYPE"
    -DCMAKE_INSTALL_PREFIX="$PREFIX"
    -DCMAKE_PREFIX_PATH="$QT_PREFIX"
)

info "Configure"
cmake "${CMAKE_ARGS[@]}"

info "Build"
cmake --build "$BUILD_DIR" --parallel "$JOBS"

info "Install → $PREFIX"
rm -rf "$PREFIX"
cmake --install "$BUILD_DIR" --prefix "$PREFIX"

# Sanity layout
[[ -d "$PREFIX/include/Md3" ]] || die "missing include/Md3 after install"
[[ -d "$PREFIX/lib/cmake/Md3" ]] || die "missing lib/cmake/Md3 after install"

LIB_HIT=""
for n in libMd3.a libMd3.so; do
    if [[ -f "$PREFIX/lib/$n" ]]; then
        LIB_HIT="$PREFIX/lib/$n"
        break
    fi
done
[[ -n "$LIB_HIT" ]] || die "missing libMd3 under $PREFIX/lib"

# Guard: plugin must not require qmlcache symbols missing from the package
PLUGIN_HIT=""
for n in libMd3plugin.a libMd3plugin.so; do
    if [[ -f "$PREFIX/lib/$n" ]]; then
        PLUGIN_HIT="$PREFIX/lib/$n"
        break
    fi
done
if [[ -n "$PLUGIN_HIT" ]] && command -v nm >/dev/null 2>&1; then
    if nm -u "$PLUGIN_HIT" 2>/dev/null | grep -q "qInitResources_qmlcache"; then
        die "package still references qInitResources_qmlcache (NO_CACHEGEN not applied). Delete $BUILD_DIR and retry."
    fi
    if ! nm "$LIB_HIT" 2>/dev/null | grep -q "qml_register_types_Md3"; then
        die "libMd3 is missing qml_register_types_Md3 — package incomplete"
    fi
fi

cat > "$PREFIX/README.md" <<EOF
# Md3 packaged library

Built by \`scripts/package-linux.sh\` from QML_MD3.

## Layout

| Path | Content |
|------|---------|
| \`lib/libMd3.*\` | Core static/shared library |
| \`lib/libMd3plugin.*\` | QML plugin (static) |
| \`lib/Md3/stubs/\` | Static plugin / rcc init \`.cpp\` |
| \`lib/qml/Md3/\` | \`qmldir\` / qmltypes |
| \`lib/cmake/Md3/\` | \`find_package(Md3)\` config |
| \`include/Md3/\` | C++ headers (\`md3.h\`, …) |

## Use from CMake

\`\`\`cmake
list(APPEND CMAKE_PREFIX_PATH "${PREFIX}")
find_package(Md3 REQUIRED)
target_link_libraries(yourApp PRIVATE Md3::Md3)
if (TARGET Md3plugin)
    target_link_libraries(yourApp PRIVATE Md3plugin)
endif()
if (TARGET Md3plugin_init)
    target_link_libraries(yourApp PRIVATE Md3plugin_init)
endif()
\`\`\`

Qt used to build this package: \`${QT_PREFIX}\`
EOF

info "Package ready: $PREFIX"
ls -la "$PREFIX/lib" | sed -n '1,30p' || true

if [[ "$MAKE_TARBALL" == "1" ]]; then
    ARCH="$(uname -m)"
    OUT_TGZ="$ROOT/dist/Md3-linux-${ARCH}.tar.gz"
    mkdir -p "$ROOT/dist"
    tar -C "$(dirname "$PREFIX")" -czf "$OUT_TGZ" "$(basename "$PREFIX")"
    info "Archive: $OUT_TGZ"
fi

info "Done."
echo "  find_package: list(APPEND CMAKE_PREFIX_PATH \"$PREFIX\")"
echo "  run wizard with: -DMD3_ROOT still points at sources; for prebuilt use PREFIX above"
