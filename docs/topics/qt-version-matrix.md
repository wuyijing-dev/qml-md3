# Qt Version Matrix

Md3 targets **Qt 6.5+ only**. Qt 5.15 support has been removed. Kit differences (Effects/Shapes link targets, a few font APIs) are isolated in `cmake/Md3QtCompat.cmake` and the `Md3QtCompat` QML singleton so **6.5 / 6.8 / 6.10 execute the same product behavior**.

## Supported targets

| Qt | Status | Notes |
|----|--------|-------|
| **6.5.x** | Supported | Full library + Gallery. Links `QuickEffectsPrivate` / `QuickShapesPrivate` when public targets are absent. |
| **6.8.x** | **Recommended baseline** | Same Private Effects/Shapes pattern as 6.5 on many kits. |
| **6.10+ / 6.11** | Supported | Prefers public `Qt6::QuickEffects` / `Qt6::QuickShapes` when present. |
| **6.8+ WASM** | Experimental | See [wasm.md](wasm.md). |
| 5.15.x | **Removed** | Configure fails if `MD3_QT_VERSION=5`. |

## Isolation scheme (keep results consistent)

| Layer | What differs by kit | How Md3 unifies |
|-------|---------------------|-----------------|
| CMake link | Effects/Shapes **public** (6.10+) vs **Private** (6.5/6.8) | `md3_resolve_optional_qt_modules()` tries public then Private |
| C++ features | e.g. Han font fallback API (6.8+) | `MD3_QT_AT_LEAST_68` / `MD3_QT_AT_LEAST_610` from `md3_apply_qt_compat_definitions()` |
| QML layout | Column/Flickable height vs implicitHeight | Always **strict height sync** (`Md3VStack`/`Md3HStack`/`Md3Card` …); see `Md3QtCompat.strictColumnHeight` |
| DataTable sizing | height ↔ bodyHeight loops | Never bind `bodyHeight` to `height`; use `_resolvedBodyHeight` |

Do **not** write kit-specific Gallery pages. Prefer the strict path everywhere so 6.10 does not “accidentally” hide bugs that break 6.5/6.8.

## CMake switches

- `-DMD3_QT_MIN_VERSION=6.5.0` — minimum (default)
- `-DMD3_QT_VERSION=6` or `AUTO` — Qt6 only (`5` is rejected)
- `-DMD3_BUILD_GALLERY=ON|OFF`
- `-DMD3_QML_CACHEGEN=ON|OFF`

## Example configure

### Qt 6.10 / 6.11

```powershell
cmake -S . -B build-qt610 -G Ninja `
  -DCMAKE_PREFIX_PATH="D:/Qt/6.10.2/msvc2022_64" `
  -DMD3_BUILD_GALLERY=ON
cmake --build build-qt610
```

### Qt 6.8

```powershell
cmake -S . -B build-qt68 -G Ninja `
  -DCMAKE_PREFIX_PATH="D:/Qt/6.8.0/msvc2022_64" `
  -DMD3_BUILD_GALLERY=ON
cmake --build build-qt68
```

### Qt 6.5

```powershell
cmake -S . -B build-qt65 -G Ninja `
  -DCMAKE_PREFIX_PATH="D:/Qt/6.5.3/msvc2019_64" `
  -DMD3_BUILD_GALLERY=ON
cmake --build build-qt65
```

Or use the packaging TUI:

```powershell
python scripts/packaging/cli.py --list-qt
python scripts/packaging/cli.py
```

## Kit install tips (Windows)

If configure fails with missing `QuickEffects` on 6.5/6.8, install **Qt Quick Effects** for that kit. The CMake package name is often `QuickEffectsPrivate` even when `qml/QtQuick/Effects` exists — Md3 picks it up automatically.
