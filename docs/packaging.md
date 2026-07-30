# Packaging Md3 (prebuilt library folder)

Ship Md3 as a **standalone folder** named `Md3` that sits next to an app’s `CMakeLists.txt` (or next to `Md3Create`). Consumers use `find_package(Md3)` — they do **not** need the full QML source tree.

Default packaging mode is **shared** (`.so` / `.dll`). Use `SHARED=0` / `-Shared:$false` for a static `.a` package.

## One-click scripts

| Platform | Script | Default |
|----------|--------|---------|
| All | [`scripts/packaging/cli.py`](https://github.com/wuyijing-dev/QML_MD3/blob/main/scripts/packaging/cli.py) | TUI/CLI package (shared → `dist/Md3/`) |
| Linux | [`scripts/packaging/package-linux.sh`](https://github.com/wuyijing-dev/QML_MD3/blob/main/scripts/packaging/package-linux.sh) | wrapper → `cli.py` + install `/usr/local` + tarball |
| Windows | [`scripts/packaging/package-windows.ps1`](https://github.com/wuyijing-dev/QML_MD3/blob/main/scripts/packaging/package-windows.ps1) | wrapper → `cli.py` + install `%LOCALAPPDATA%\Md3` + zip |

### Linux

```bash
cd /path/to/QML_MD3
python scripts/packaging/cli.py
./scripts/packaging/package-linux.sh
SHARED=0 ./scripts/packaging/package-linux.sh
SKIP_SYSTEM_INSTALL=1 ./scripts/packaging/package-linux.sh
CMAKE_PREFIX_PATH=$HOME/Qt/6.10.2/gcc_64 ./scripts/packaging/package-linux.sh
```

### Windows

```powershell
cd D:\path\to\QML_MD3
python scripts/packaging/cli.py
.\scripts\packaging\package-windows.ps1 --qt-prefix "D:\Qt\6.10.2\mingw_64" -y
.\scripts\packaging\package-windows.ps1 --static -y
.\scripts\packaging\package-windows.ps1 --skip-install -y
.\scripts\packaging\package-windows.ps1 --bundle-dir "D:\path\to\Md3CreateDir" -y
```

## Package layout

```text
Md3/
  lib/
    libMd3.so* / Md3.dll(+.lib) / libMd3.a   # shared (default) or static
    libMd3plugin.*
    qml/Md3/           # qmldir, qmltypes
    cmake/Md3/         # Md3Config.cmake (MD3_PACKAGE_SHARED recorded)
    Md3/stubs/         # static plugin / rcc *_init.cpp (static packages)
  bin/                 # Windows DLLs (shared)
  include/Md3/         # md3.h, …
  README.md
```

## Same-directory convention (fixed)

**Always** place the folder next to the project `CMakeLists.txt`, named exactly `Md3`:

```text
MyApp/
  CMakeLists.txt
  Main.qml
  main.cpp
  Md3/                 ← packaged library (same directory)
```

Md3 Create wizard source tree:

```text
QML_Md3_Generation/
  CMakeLists.txt
  Main.qml
  Md3/                 ← copy dist/Md3 here (NOT into build/)
  build/
    bin/Md3Create
```

## CMake consumer (same-dir package)

```cmake
set(MD3_DIR "${CMAKE_CURRENT_SOURCE_DIR}/Md3")
list(APPEND CMAKE_PREFIX_PATH "${MD3_DIR}")
find_package(Md3 REQUIRED CONFIG)

qt_add_executable(app main.cpp)
target_link_libraries(app PRIVATE Qt6::Quick Md3::Md3)

# Shared packages: Md3::QmlPlugin links normally (no whole-archive).
# Static packages: prefer the helper (whole-archive plugin + Md3).
if (TARGET Md3::QmlPlugin)
    target_link_libraries(app PRIVATE Md3::QmlPlugin)
endif()
```

System install after packaging:

```cmake
list(APPEND CMAKE_PREFIX_PATH "/usr/local")          # Linux default
# or: list(APPEND CMAKE_PREFIX_PATH "$ENV{LOCALAPPDATA}/Md3")  # Windows
find_package(Md3 REQUIRED)
```

On Linux, if the package was built with KDE WindowSystem:

```cmake
find_package(KF6WindowSystem REQUIRED)   # or KF5
target_link_libraries(app PRIVATE KF6::WindowSystem)
```

`find_package(Md3)` records this and will `FATAL_ERROR` if KF is required but missing.

## C++ — import the QML plugin

For **static** packages, without a reference `ld` may discard `libMd3plugin.a`, and at runtime you get `module "Md3" is not installed`. Add in **your app’s** `main.cpp`:

```cpp
#include <QtQml/qqmlextensionplugin.h>
Q_IMPORT_QML_PLUGIN(Md3Plugin)
```

For **shared** packages this is still safe and recommended when linking `Md3plugin` into the app; alternatively ensure `QML_IMPORT_PATH` points at `lib/qml` and the plugin loads from disk.

Then use `Md3::run` / `import Md3` as usual.

### Shared runtime

| Platform | Hint |
|----------|------|
| Linux | After `/usr` or `/usr/local` install, `sudo ldconfig`. Or set `LD_LIBRARY_PATH` to the package `lib/`. |
| Windows | Put `bin/` on `PATH`, or copy `Md3.dll` / `Md3plugin.dll` beside the executable. |

## Md3 Create workflow

1. Package this repo → `dist/Md3` (and optional system install)
2. `cp -a dist/Md3 /path/to/QML_Md3_Generation/Md3`
3. Build the wizard (no `-DMD3_ROOT` needed):

```bash
cd /path/to/QML_Md3_Generation
cmake -S . -B build -G Ninja
cmake --build build -j"$(nproc)"
./build/bin/Md3Create
```

4. Created apps receive a copy of `./Md3` beside their `CMakeLists.txt`.

Fallback (sources instead of package):

```bash
cmake -S . -B build -G Ninja -DMD3_ROOT=/path/to/QML_MD3
```

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| `qrc:/qt/qml/YourApp/qml/Main.qml: No such file or directory` | Consumer app QML alias/prefix wrong. Use `RESOURCE_PREFIX /qt/qml`, `QT_RESOURCE_ALIAS Main.qml`, `loadFromModule`. See [consumer-app-main-qml.md](consumer-app-main-qml.md) |
| App starts then exits immediately (Qt Creator: terminated abnormally) | Set `visible: true` on root `Md3ApplicationWindow`; deploy `Md3.dll` + `qml/Md3/` beside exe |
| `module "Md3" is not installed` | Static: `Q_IMPORT_QML_PLUGIN(Md3Plugin)` + whole-archive / `Md3::QmlPlugin`. Shared: DLLs on PATH / `ldconfig` / `QML_IMPORT_PATH` |
| `undefined reference` to `qml_register_types_Md3` / `qInitResources_*` | Static link order: plugin before Md3; use `WHOLE_ARCHIVE`. **Re-run** package script after pulling |
| `undefined reference` to `qInitResources_qmlcache_*` | Static package missing qmlcache objects. Rebuild package with current QML_MD3 (`MD3_QML_CACHEGEN=ON` default), or temporarily `-DMD3_QML_CACHEGEN=OFF` |
| `cannot open shared object file: libMd3.so.*` | `sudo ldconfig` or `LD_LIBRARY_PATH=…/lib` |
| Windows: missing `Md3.dll` at runtime | Add install `bin\` to PATH or copy DLL beside exe |
| `cannot open output file Md3Create: Is a directory` | Do not create a folder named `Md3Create` under `build/`. Exe is `build/bin/Md3Create` |
| `undefined reference` to `KWindowEffects` / `KX11Extras` | `sudo apt install libkf6windowsystem-dev`, reconfigure; or rebuild package after installing KF |
| CMake looks under `build/Md3` | Wrong — put `Md3/` next to **source** `CMakeLists.txt` |
| `cmake --build` → missing `CMakeCache.txt` | Run `cmake -S . -B build` first |

## Related

- [integration.md](integration.md) — subdirectory vs package
- [Md3 Create README](https://github.com/wuyijing-dev/QML_Md3_Generation) — wizard build steps
