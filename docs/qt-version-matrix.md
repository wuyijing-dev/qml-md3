# Qt Version Matrix (Stage 1)

This document defines the current multi-version support baseline for Md3.

## Supported Targets

| Qt | Status | Scope |
|---|---|---|
| 5.15.x | Stage 1 | **Core bootstrap library only** (`Md3::run`, fonts init, app setup). No Gallery / no `qt_add_qml_module` packaging. |
| 6.5.x | Stage 1 | Full Md3 library + Gallery build path (same CMake flow as 6.8). |
| 6.8.x | Stage 1 | Full Md3 library + Gallery build path (recommended baseline). |

## CMake Switches

- `-DMD3_QT_VERSION=AUTO|5|6`
  - `AUTO` picks Qt6 first, then Qt5.
- `-DMD3_BUILD_GALLERY=OFF`
  - Required on Qt5 stage 1.
- `-DMD3_QML_CACHEGEN=ON|OFF`
  - Meaningful for Qt6 QML module builds.

## Example Configure Commands

### Qt 6.8 / 6.5

```powershell
cmake -S . -B build-qt6 -DMD3_QT_VERSION=6 -DMD3_BUILD_GALLERY=ON
cmake --build build-qt6 --config Release
```

### Qt 5.15 (stage 1 minimal)

```powershell
cmake -S . -B build-qt515 -DMD3_QT_VERSION=5 -DMD3_BUILD_GALLERY=OFF
cmake --build build-qt515 --config Release
```

## Notes

- Qt5 path is intentionally minimal in stage 1 to establish CMake compatibility and a compilable baseline.
- Stage 2 expands Qt5 feature coverage (QML module packaging, component/runtime parity checks).
