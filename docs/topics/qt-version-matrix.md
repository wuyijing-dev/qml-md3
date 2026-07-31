# Qt Version Matrix (Stage 1+)

Multi-version support for Md3 across Qt kits on the same machine.

## Supported Targets

| Qt | Status | Scope |
|---|---|---|
| 5.15.x | Stage 1 | **Core bootstrap library only** (`Md3::run`, fonts init). No Gallery / no `qt_add_qml_module`. |
| 6.5.x | Stage 1 | Full library + Gallery. Links `QuickEffectsPrivate` / `QuickShapesPrivate` (no public Effects CMake target). |
| 6.8.x | Stage 1 | Full library + Gallery. Same Private Effects/Shapes as 6.5. **Recommended baseline.** Layout: `Md3HStack` must drive `height` from `implicitHeight` (Column ignores implicit-only on 6.8); avoid `Md3DataTable` `bodyHeight: f(height)` with `height: implicitHeight` (binding loop). |
| 6.10+ / 6.11 | Stage 1 | Full library + Gallery. Prefers public `Qt6::QuickEffects` / `Qt6::QuickShapes` when present. Column stacking more forgiving of implicit-only heights. |
| 6.8+ **WASM** | Experimental | Library + hello via Qt for WebAssembly. See [wasm.md](wasm.md). Gallery opt-in. |

## CMake Compatibility Notes

- `md3_find_qt` is a **macro** (not a function) so `QT_KNOWN_POLICY_QTP000*` from `Qt6Qml` stay visible. Using a function caused `QTP0005 is not a known Qt policy` under Qt Creator.
- Optional modules are resolved with fallbacks:
  - Effects: `QuickEffects` → `QuickEffectsPrivate`
  - Shapes: `QuickShapes` → `QuickShapesPrivate`
  - Gallery Multimedia: optional (kit may omit it)
- Policies `QTP0001` / `QTP0004` / `QTP0005` are set to **NEW** via `md3_setup_qt_qml_policies()`.
- Private-module header warning is suppressed with `QT_NO_PRIVATE_MODULE_WARNING`.

## CMake Switches

- `-DMD3_QT_VERSION=AUTO|5|6` — `AUTO` picks Qt6 first, then Qt5
- `-DMD3_BUILD_GALLERY=ON|OFF` — OFF required on Qt5 stage 1
- `-DMD3_QML_CACHEGEN=ON|OFF` — Qt6 QML module bytecode

## Example Configure Commands

### Qt 6.11 / 6.10 (public Effects)

```powershell
cmake -S . -B build-qt611 -G Ninja `
  -DCMAKE_PREFIX_PATH="D:/Qt/6.11.0/msvc2022_64" `
  -DMD3_QT_VERSION=6 -DMD3_BUILD_GALLERY=ON
cmake --build build-qt611
```

### Qt 6.8 (EffectsPrivate)

```powershell
cmake -S . -B build-qt68 -G Ninja `
  -DCMAKE_PREFIX_PATH="D:/Qt/6.8.0/msvc2022_64" `
  -DMD3_QT_VERSION=6 -DMD3_BUILD_GALLERY=ON
cmake --build build-qt68
```

### Qt 5.15 (stage 1 minimal)

```powershell
cmake -S . -B build-qt515 -G Ninja `
  -DCMAKE_PREFIX_PATH="D:/Qt/5.15.2/msvc2019_64" `
  -DMD3_QT_VERSION=5 -DMD3_BUILD_GALLERY=OFF
cmake --build build-qt515
```

Or use the packaging TUI (auto-detect kits):

```powershell
python scripts/packaging/cli.py --list-qt
python scripts/packaging/cli.py
```

## Kit install tips (Windows)

If configure fails with missing `QuickEffects` on 6.8/6.5, open Qt Maintenance Tool and ensure **Qt Quick Effects** / declarative extras are installed for that kit. On 6.5/6.8 the CMake package name is often `QuickEffectsPrivate` even when `qml/QtQuick/Effects` exists — Md3 handles that automatically.

`Error reading …/modules/Core.json: Could not determine target architecture` from Qt Creator is a kit metadata warning (e.g. mixing 6.5 kits in the IDE); it does not block a correctly-prefixed CMake configure.
