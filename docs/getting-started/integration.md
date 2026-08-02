# Integrating Md3

Md3 is a **standalone QML library** (`URI Md3`). The Gallery demo is optional and is **not** required to use the components.

For **prebuilt folder + same-directory layout**, see **[packaging.md](packaging.md)** first.

## Lock a version for your product (recommended)

Do **not** track floating `main` in a shipping app. Pin to the tagged release:

| Method | How |
|--------|-----|
| **Git tag / submodule** | `git checkout v1.1.1` or submodule at `v1.1.1` |
| **FetchContent** | `GIT_TAG v1.1.1` (annotated tag) |
| **add_subdirectory** | Clone/copy the tree at `v1.1.1`, then `add_subdirectory(...)` |
| **Packaged `./Md3`** | Build/install from that tag; keep the prefix in VCS or CI cache |
| **Python** | `pip install "git+…@v1.1.1#subdirectory=python[pyside6]"` then `md3qml install --version 1.1.1` when using Release zips |
| **Rust** | Depend on `rust/md3qml` from a checkout at `v1.1.1`; set `MD3_PREFIX` to a shared build from the same tag |

Current lock tag: **`v1.1.1`** (see [CHANGELOG](../../CHANGELOG.md)). Upgrade only when you choose a newer tag.

## Host stacks — what each layer provides

| Capability | **C++** (`Md3::run`) | **PySide** (`md3qml`) | **Rust / C ABI** | **QML** (`import Md3`) |
|------------|----------------------|------------------------|------------------|-------------------------|
| Bootstrap / fonts / style | Full `RunOptions` | `RunOptions.load_fonts` → `md3_load_fonts` | `load_fonts` in `Md3RunConfig` + `md3qml::load_fonts` | — |
| Clipboard | `window.copyToClipboard` | `app.native.copy_to_clipboard` | — (use QML) | `Md3Notify.copy` |
| Toast / Snackbar / Undo dwell | — | — (call QML / `invoke`) | — | `Md3Notify.*` |
| Shell InfoBar | — | `app.invoke("showShellInfoBar", …)` | — | `showShellInfoBar` on `Md3ApplicationWindow` |
| Form `focusFirstError` / Button `busy` | — | — | — | Component API |
| Window chrome / taskbar / tray | `Md3WindowHelper` | `app.native` (desktop subset) | — | Gallery / window APIs |

**Product contract:** pin **`v1.1.1`**, build/install shared Md3 from that tag, put UX in QML. Hosts only bootstrap + optional system helpers. Do not expect Rust C ABI to grow WindowHelper parity.

For **writing less layout glue** (stacks, flow, grid, Card.title, layoutMode), see **[layout.md](../guides/layout.md)**.

For **selection / list / sheet / dialog shortcuts**, see **[glue-less-api.md](../guides/glue-less-api.md)**.  
For **first paint / page cache / memory tradeoffs**, see **[performance.md](../topics/performance.md)**.

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

### Qt version

Md3 is **Qt 6.5+ only** (recommended 6.8 / 6.10). Kit differences are isolated in `cmake/Md3QtCompat.cmake`:

```cmake
# Optional; defaults are fine for most apps
set(MD3_QT_MIN_VERSION "6.5.0" CACHE STRING "")
set(MD3_QT_VERSION "6" CACHE STRING "")  # AUTO or 6 — Qt5 rejected
```

See [qt-version-matrix.md](../topics/qt-version-matrix.md).

## CMake — packaged `./Md3` (recommended for apps)

1. Run `python scripts/packaging/cli.py` (or `scripts/packaging/package-linux.sh` / `package-windows.ps1`)  
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

For shared-package consumer apps on Windows, also add the executable directory and deploy `qml/Md3` beside the exe (see [consumer-app-main-qml.md](../topics/consumer-app-main-qml.md)).

---

## Consumer app: `Main.qml` fails to load

Symptom:

```text
qrc:/qt/qml/YourApp/qml/Main.qml: No such file or directory
```

Fix (summary):

1. In `qt_add_qml_module`, set `RESOURCE_PREFIX /qt/qml`
2. Set `QT_RESOURCE_ALIAS Main.qml` on your entry QML file
3. Load with `engine.loadFromModule("YourApp", "Main")` (not a hard-coded `qml/Main.qml` URL)
4. Deploy shared `Md3.dll` + `qml/Md3/` next to the executable
5. Set `visible: true` on `Md3ApplicationWindow`

Full walkthrough and copy-paste templates: **[consumer-app-main-qml.md](../topics/consumer-app-main-qml.md)**.  
Reference implementation: sibling project `auto_deploy_Qt`.

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
- Download: `scripts/assets/download-fonts.ps1` (Regular only); add `-ExtraWeights` for Medium/Bold

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

### Gallery: keep Linux in sync with Windows

Gallery QML **is in git** (`gallery/Main.qml`, `gallery/pages/**`, including `LaunchListScene.qml`).  
Default app icons ship **inside the Md3 module** (`qrc:/md3/icons/…`, singleton `Md3AppIcons`).  
Canonical PNGs live in `resources/icons/`; CMake stages copies under `src/Md3/icons/` (gitignored).  
`Md3ApplicationWindow.windowIcon` defaults to `Md3AppIcons.window` — apps need not set an icon unless they want a custom one.

If the Linux app looks older than Windows after `git pull`:

1. Confirm commit: `git fetch origin && git rev-parse HEAD origin/main` (should match).
2. **Clean rebuild** (incremental builds can keep stale QML):  
   `rm -rf build && cmake -S . -B build -DMD3_BUILD_GALLERY=ON && cmake --build build -j$(nproc)`
3. Run the Gallery binary at **`./build/gallery/appQML_MD3`** (not `./build/appQML_MD3`).
4. Optional check: `bash scripts/verify-gallery-sync.sh`

`Authorization required, but no authorization protocol specified` means the process has no X11/Wayland display (SSH without `-X`, wrong `DISPLAY`, etc.). Run from a desktop session or `export DISPLAY=:0` / use `ssh -X`.

## Versioning

Semantic versioning. See [CHANGELOG.md](https://github.com/wuyijing-dev/QML_MD3/blob/main/CHANGELOG.md). See [docs/api](api/README.md) for the full control surface.
