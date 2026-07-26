# Integrating Md3

Md3 is a **standalone QML library** (`URI Md3`). The Gallery demo is optional and is **not** required to use the components.

## CMake — subdirectory (recommended)

```cmake
set(MD3_BUILD_GALLERY OFF CACHE BOOL "" FORCE)  # skip demo app
add_subdirectory(path/to/QML_MD3)               # or path/to/QML_MD3/src/Md3

qt_add_executable(yourApp main.cpp)
# Link the QML module (pulls in plugin registration for static builds)
target_link_libraries(yourApp PRIVATE Md3 Qt6::Quick)
if (TARGET Md3plugin)
    target_link_libraries(yourApp PRIVATE Md3plugin)
endif()
# Equivalent alias: Md3::Md3
```

When this repo is added via `add_subdirectory` from another project, `MD3_BUILD_GALLERY` defaults to **OFF**.

## CMake — install + find_package

```bash
# One-click on Linux (recommended)
./scripts/package-linux.sh
# → dist/Md3/  (lib + include + cmake) and dist/Md3-linux-*.tar.gz

# Or manually
cmake -S QML_MD3 -B build-lib -DMD3_BUILD_GALLERY=OFF -DCMAKE_PREFIX_PATH=…
cmake --build build-lib
cmake --install build-lib --prefix /opt/md3   # or ./dist/Md3
```

```cmake
list(APPEND CMAKE_PREFIX_PATH "/path/to/dist/Md3")  # or /opt/md3
find_package(Md3 REQUIRED)
target_link_libraries(yourApp PRIVATE Md3::Md3 Qt6::Quick)
if (TARGET Md3plugin)
    target_link_libraries(yourApp PRIVATE Md3plugin)
endif()
if (TARGET Md3plugin_init)
    target_link_libraries(yourApp PRIVATE Md3plugin_init)
endif()
```

Installed layout:

- `lib/libMd3.a` (+ `libMd3plugin.a`)
- `lib/Md3/stubs/` — static QML/plugin init `.cpp`
- `lib/qml/Md3/` — `qmldir`, qmltypes
- `lib/cmake/Md3/` — `Md3Config.cmake` (`find_package(Md3)`)
- `include/Md3/` — C++ headers (`md3.h`, `md3graphics.h`, …)

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

When linking `Md3` into the executable (static module), types register at startup — no extra import path is usually needed.

If you load the module from the filesystem instead:

```
QML_IMPORT_PATH=<prefix>/lib/qml
```

## Theme

```qml
Md3Theme.dark = true
Md3Theme.applySeed("#006A6A")
Md3Theme.textScale = 1.25
```

## Fonts

Roboto + Material Icons ship in the Md3 module qrc. Prefer **`Md3::run` / `Md3::initialize`** (loads them automatically). Manual path: `:/qt/qml/Md3/resources/fonts/`.

## Options

| Option | Default | Meaning |
|--------|---------|---------|
| `MD3_BUILD_GALLERY` | OFF when used as subdirectory | Build Gallery executable |
| `MD3_BUILD_SHARED` | OFF | Shared `Md3` instead of static |

## Versioning

Semantic versioning. See [CHANGELOG.md](../CHANGELOG.md). See [docs/api](api/README.md) for the full control surface.
