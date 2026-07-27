#!/usr/bin/env bash
# Verify local tree matches origin/main and Gallery QML is tracked (not missing after pull).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "== Remote =="
git fetch origin 2>/dev/null || true
LOCAL="$(git rev-parse HEAD)"
REMOTE="$(git rev-parse origin/main 2>/dev/null || echo missing)"
echo "HEAD:        $LOCAL"
echo "origin/main: $REMOTE"
if [[ "$LOCAL" != "$REMOTE" ]]; then
    echo "WARN: not on latest origin/main — run: git pull --ff-only origin main"
else
    echo "OK: matches origin/main"
fi

echo ""
echo "== Gallery QML (must exist on disk) =="
MISS=0
while IFS= read -r f; do
    if [[ ! -f "$f" ]]; then
        echo "MISSING: $f"
        MISS=1
    fi
done < <(git ls-files 'gallery/*.qml' 'gallery/**/**/*.qml')
if [[ "$MISS" -eq 0 ]]; then
    echo "OK: $(git ls-files 'gallery/*.qml' 'gallery/**/**/*.qml' | wc -l) QML files present"
fi

echo ""
echo "== Launch demo scenes =="
for f in gallery/pages/scenes/LaunchListScene.qml gallery/pages/scenes/LaunchDetailScene.qml; do
    if git cat-file -e "origin/main:$f" 2>/dev/null; then
        echo "OK tracked on origin/main: $f"
    else
        echo "MISSING on origin/main: $f"
        MISS=1
    fi
done

echo ""
echo "== Build hint =="
echo "After pull, reconfigure and rebuild Gallery (stale build/ causes 'wrong' UI):"
echo "  rm -rf build && cmake -S . -B build -DMD3_BUILD_GALLERY=ON && cmake --build build -j\$(nproc)"
echo "Run:"
echo "  ./build/gallery/appQML_MD3"
echo "(not ./build/appQML_MD3)"

exit "$MISS"
