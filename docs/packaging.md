# Packaging Md3 (prebuilt library folder)

Ship Md3 as a **standalone folder** named `Md3` that sits next to an app’s `CMakeLists.txt` (or next to `Md3Create`). Consumers use `find_package(Md3)` — they do **not** need the full QML source tree.

## One-click scripts

| Platform | Script | Default output |
|----------|--------|----------------|
| Linux | [`scripts/package-linux.sh`](../scripts/package-linux.sh) | `dist/Md3/` + `dist/Md3-linux-*.tar.gz` |
| Windows | [`scripts/package-windows.ps1`](../scripts/package-windows.ps1) | `dist/Md3/` + `dist/Md3-windows-*.zip` |

### Linux

```bash
cd /path/to/QML_MD3
./scripts/package-linux.sh
# optional:
PREFIX=$HOME/opt/Md3 CMAKE_PREFIX_PATH=$HOME/Qt/6.10.2/gcc_64 ./scripts/package-linux.sh
```

### Windows

```powershell
cd D:\path\to\QML_MD3
.\scripts\package-windows.ps1 -CmakePrefixPath "D:\Qt\6.10.2\mingw_64"
# Copy next to Md3Create as fixed sibling name:
.\scripts\package-windows.ps1 -CreateBundleDir "D:\path\to\Md3CreateDir"
```

## Package layout

```text
Md3/
  lib/
    libMd3.a / Md3.lib
    libMd3plugin.a
    qml/Md3/           # qmldir, qmltypes
    cmake/Md3/         # Md3Config.cmake
    Md3/stubs/         # static plugin / rcc *_init.cpp
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

# Static QML plugin — must not be dropped by the linker
if (CMAKE_VERSION VERSION_GREATER_EQUAL "3.24")
    if (TARGET Md3plugin)
        target_link_libraries(app PRIVATE "$<LINK_LIBRARY:WHOLE_ARCHIVE,Md3plugin>")
    endif()
    if (TARGET Md3plugin_init)
        target_link_libraries(app PRIVATE "$<LINK_LIBRARY:WHOLE_ARCHIVE,Md3plugin_init>")
    endif()
elseif (TARGET Md3::QmlPlugin)
    target_link_libraries(app PRIVATE Md3::QmlPlugin)
endif()
```

On Linux, if the package was built with KDE WindowSystem:

```cmake
find_package(KF6WindowSystem REQUIRED)   # or KF5
target_link_libraries(app PRIVATE KF6::WindowSystem)
```

`find_package(Md3)` records this and will `FATAL_ERROR` if KF is required but missing.

## C++ — import the static QML plugin

Without a reference, `ld` may discard `libMd3plugin.a`, and at runtime you get:

```text
module "Md3" is not installed
```

Add in **your app’s** `main.cpp` (required for packaged static Md3):

```cpp
#include <QtQml/qqmlextensionplugin.h>
Q_IMPORT_QML_PLUGIN(Md3Plugin)
```

Then use `Md3::run` / `import Md3` as usual.

## Md3 Create workflow

1. Package this repo → `dist/Md3`
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
| `module "Md3" is not installed` | Add `Q_IMPORT_QML_PLUGIN(Md3Plugin)`; link plugin with `WHOLE_ARCHIVE` / `Md3::QmlPlugin` |
| `cannot open output file Md3Create: Is a directory` | Do not create a folder named `Md3Create` under `build/`. Exe is `build/bin/Md3Create` |
| `undefined reference` to `KWindowEffects` / `KX11Extras` | `sudo apt install libkf6windowsystem-dev`, reconfigure; or rebuild package after installing KF |
| CMake looks under `build/Md3` | Wrong — put `Md3/` next to **source** `CMakeLists.txt` |
| `cmake --build` → missing `CMakeCache.txt` | Run `cmake -S . -B build` first |

## Related

- [integration.md](integration.md) — subdirectory vs package
- [Md3 Create README](https://github.com/wuyijing-dev/QML_Md3_Generation) — wizard build steps
