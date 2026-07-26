# Integrating Md3

Md3 is a **standalone QML library** (`URI Md3`). The Gallery demo is optional and is **not** required to use the components.

For **prebuilt folder + same-directory layout**, see **[packaging.md](packaging.md)** first.

## CMake — subdirectory (dev / from sources)

```cmake
set(MD3_BUILD_GALLERY OFF CACHE BOOL "" FORCE)  # skip demo app
add_subdirectory(path/to/QML_MD3)

qt_add_executable(yourApp main.cpp)
target_link_libraries(yourApp PRIVATE Md3 Qt6::Quick)
if (TARGET Md3plugin)
    target_link_libraries(yourApp PRIVATE Md3plugin)
endif()
```

When this repo is added via `add_subdirectory` from another project, `MD3_BUILD_GALLERY` defaults to **OFF**.

## CMake — packaged `./Md3` (recommended for apps)

1. Run `scripts/package-linux.sh` or `scripts/package-windows.ps1`
2. Copy `dist/Md3` beside your `CMakeLists.txt` as `./Md3`
3. In CMake:

```cmake
list(APPEND CMAKE_PREFIX_PATH "${CMAKE_CURRENT_SOURCE_DIR}/Md3")
find_package(Md3 REQUIRED CONFIG)

target_link_libraries(yourApp PRIVATE Md3::Md3 Qt6::Quick)
# Prefer helper (whole-archive static plugin):
if (TARGET Md3::QmlPlugin)
    target_link_libraries(yourApp PRIVATE Md3::QmlPlugin)
endif()
```

4. In `main.cpp`:

```cpp
#include <QtQml/qqmlextensionplugin.h>
Q_IMPORT_QML_PLUGIN(Md3Plugin)

#include "md3.h"
int main(int argc, char *argv[]) {
    return Md3::run(argc, argv, "MyApp");
}
```

### Manual install prefix

```bash
cmake -S . -B build-lib -DMD3_BUILD_GALLERY=OFF
cmake --build build-lib
cmake --install build-lib --prefix /opt/md3
```

```cmake
list(APPEND CMAKE_PREFIX_PATH "/opt/md3")
find_package(Md3 REQUIRED)
```

Installed / packaged layout:

| Path | Content |
|------|---------|
| `lib/libMd3.*` | Core library |
| `lib/libMd3plugin.*` | Static QML plugin |
| `lib/Md3/stubs/` | Plugin / rcc init sources |
| `lib/qml/Md3/` | `qmldir`, qmltypes |
| `lib/cmake/Md3/` | `find_package(Md3)` |
| `include/Md3/` | C++ headers |

## QML

```qml
import Md3

Md3ApplicationWindow {
    color: Md3Theme.colorScheme.surface
    Md3Button {
        text: "OK"
        onClicked: { }
    }
}
```

## C++ — one-liner

```cpp
#include "md3.h"
#include <QtQml/qqmlextensionplugin.h>
Q_IMPORT_QML_PLUGIN(Md3Plugin)   // required when linking packaged static Md3

int main(int argc, char *argv[]) {
    return Md3::run(argc, argv, "MyApp"); // loads MyApp/Main.qml
}
```

Fonts, Basic style, DPI, and RHI early setup are handled inside `Md3::run`.

Manual split:

```cpp
Md3::applyEarly(argc, argv);          // before QGuiApplication
QGuiApplication app(argc, argv);
Md3::initialize(app);                 // fonts + style
```

## Runtime import path

When the static plugin is linked and imported (`Q_IMPORT_QML_PLUGIN`), types register at startup — no extra import path is usually needed.

If you load QML modules from the filesystem instead:

```bash
export QML_IMPORT_PATH=/path/to/Md3/lib/qml
```

## Theme

```qml
Md3Theme.dark = true
Md3Theme.applySeed("#006A6A")
Md3Theme.textScale = 1.25
```

## Fonts

Roboto + Material Icons ship in the Md3 module qrc. Prefer **`Md3::run` / `Md3::initialize`**. Manual path: `:/qt/qml/Md3/resources/fonts/`.

## Options

| Option | Default | Meaning |
|--------|---------|---------|
| `MD3_BUILD_GALLERY` | OFF when used as subdirectory | Build Gallery executable |
| `MD3_BUILD_SHARED` | OFF | Shared `Md3` instead of static |

## Linux notes

- Package built with KF6 WindowSystem needs `libkf6windowsystem-dev` at **link** time of the app.
- System Qt may warn about missing `Qt6::qtquick2plugin` link targets; install `qml6-module-qtquick*` packages if QML fails at runtime for Qt modules.

## Versioning

Semantic versioning. See [CHANGELOG.md](../CHANGELOG.md). See [docs/api](api/README.md) for the full control surface.
