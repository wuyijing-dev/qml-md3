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
   (default **shared**; stages `dist/Md3` and installs to `/usr/local` or `%LOCALAPPDATA%\Md3`)
2. Copy `dist/Md3` beside your `CMakeLists.txt` as `./Md3`, **or** use the system install prefix
3. In CMake:

```cmake
list(APPEND CMAKE_PREFIX_PATH "${CMAKE_CURRENT_SOURCE_DIR}/Md3")
# or: list(APPEND CMAKE_PREFIX_PATH "/usr/local")
find_package(Md3 REQUIRED CONFIG)

target_link_libraries(yourApp PRIVATE Md3::Md3 Qt6::Quick)
# Shared: normal link. Static: whole-archive via helper.
if (TARGET Md3::QmlPlugin)
    target_link_libraries(yourApp PRIVATE Md3::QmlPlugin)
endif()
```

4. In `main.cpp` (required for **static** packages; recommended when linking the plugin):

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
cmake -S . -B build-lib -DMD3_BUILD_GALLERY=OFF -DMD3_BUILD_SHARED=ON
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
| `lib/libMd3.*` / `bin/*.dll` | Core library (shared default or static) |
| `lib/libMd3plugin.*` | QML plugin |
| `lib/Md3/stubs/` | Plugin / rcc init sources (static) |
| `lib/qml/Md3/` | `qmldir`, qmltypes |
| `lib/cmake/Md3/` | `find_package(Md3)` (`Md3_SHARED` set) |
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
Q_IMPORT_QML_PLUGIN(Md3Plugin)   // required for packaged static Md3; OK for shared

int main(int argc, char *argv[]) {
    return Md3::run(argc, argv, "MyApp"); // loads MyApp/Main.qml
}
```

Fonts, Basic style, DPI, and RHI early setup are handled inside `Md3::run`.

On Linux, if your app integrates with launcher/taskbar progress over D-Bus, set `Md3::RunOptions::desktopFileName` to a stable desktop id without spaces so Unity-style object paths remain valid.

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

By default Md3 bundles **HarmonyOS Sans SC Regular** + Material Icons. Medium/Bold are optional:

- CMake: `-DMD3_BUNDLE_EXTRA_UI_FONTS=ON` to pack Medium/Bold into the module qrc
- Or drop `HarmonyOS_SansSC_Medium.ttf` / `HarmonyOS_SansSC_Bold.ttf` next to the app under `fonts/` — `Md3::loadFonts()` picks them up if present
- Download: `scripts/download-fonts.ps1` (Regular only); add `-ExtraWeights` for Medium/Bold

Prefer **`Md3::run` / `Md3::initialize`**. Manual qrc path: `:/md3/fonts/resources/fonts/`.

## Progressive within-page content

`Md3Theme.progressiveContent` / `Md3ApplicationWindow.progressiveContent` (default **true**) gates `Md3DeferredSection`: first paint shows placeholders, then delayed sections create. Set `false` to load all sections immediately.

```qml
Md3ApplicationWindow {
    progressiveContent: true   // default
}
// or
Md3Theme.progressiveContent = false
```

## Performance overlay

Built into `Md3ApplicationWindow` (off by default — open from the title-bar speed button):

```qml
Md3ApplicationWindow {
    showPerformanceButton: true      // title-bar toggle
    showPerformanceOverlay: false    // floating panel + sampler
    // performanceDetached: false    // optional separate non-modal window
}
```

- Docked panel animates in/out (scale + fade + slide).
- Panel button **open_in_new** pops it into an optional `Md3DialogWindow`; **close_fullscreen** docks it back.
- Memory shows private bytes (closer to Task Manager); working set is listed separately.
- Element picker skips MouseArea/handlers and prefers `Md3*` components.

Types: `Md3PerformanceMonitor`, `Md3PerformancePanel`, `Md3ElementPicker`, `Md3Inspector`.

## Options

| Option | Default | Meaning |
|--------|---------|---------|
| `MD3_BUILD_GALLERY` | OFF when used as subdirectory | Build Gallery executable |
| `MD3_BUILD_SHARED` | OFF (CMake); packaging scripts default **ON** | Shared `Md3` instead of static |
| `MD3_BUNDLE_EXTRA_UI_FONTS` | OFF | Bundle HarmonyOS Medium/Bold faces |

## Linux notes

- After shared install to `/usr` or `/usr/local`, run `sudo ldconfig` (package script does this when possible).
- Package built with KF6 WindowSystem needs `libkf6windowsystem-dev` at **link** time of the app.
- System Qt may warn about missing `Qt6::qtquick2plugin` link targets; install `qml6-module-qtquick*` packages if QML fails at runtime for Qt modules.

## Versioning

Semantic versioning. See [CHANGELOG.md](../CHANGELOG.md). See [docs/api](api/README.md) for the full control surface.
