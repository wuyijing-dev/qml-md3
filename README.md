# QML MD3

Enterprise Material Design 3 component library for **Qt Quick / QML 6.8+**, visually and temporally aligned with **Flutter Material 3**.

## Goals

- Pixel- and motion-accurate MD3 controls matching Flutter Material defaults
- Design tokens first: color roles, typography, shape, elevation, state layers, motion
- Per-control API docs under `docs/api/` (regenerate with `tools/gen_api_docs.py`)
- Distributable QML module URI: `Md3`

## Requirements

- Qt **6.8+** recommended (developed against Qt 6.10+; 6.5 stage-1 — see [docs/qt-version-matrix.md](docs/topics/qt-version-matrix.md))
- CMake 3.16+
- C++17

## Support scope

| | Official focus | Notes |
|--|----------------|-------|
| **OS** | Windows desktop | Linux / macOS best-effort; **WASM experimental** ([docs/topics/wasm.md](docs/topics/wasm.md)) |
| **Qt** | 6.8+ full library | 5.15 = bootstrap only |
| **API** | Types in `docs/api/` (non-experimental) | See [docs/getting-started/api-stability.md](docs/getting-started/api-stability.md) |
| **Experimental** | No SemVer promise | [docs/topics/experimental.md](docs/topics/experimental.md) |
| **License** | LGPL-3.0 **or** Commercial (+ certification) | [docs/licensing.md](docs/licensing.md) · fonts/icons: [NOTICE](NOTICE) |

Status: **1.0.0** (Windows-focused production tag). P1 shell items (NavigationView / Flyout) and broader platform matrix remain in [docs/project/professional-todo.md](docs/project/professional-todo.md). Releases follow [docs/getting-started/release-checklist.md](docs/getting-started/release-checklist.md).

## Import

```qml
import Md3

Md3Button {
    text: "Filled"
    variant: Md3Button.Filled
    onClicked: console.log("clicked")
}
```

Theme singleton:

```qml
import Md3

Rectangle {
    color: Md3Theme.colorScheme.surface
    // ...
    Component.onCompleted: Md3Theme.dark = false
}
```

## Build

完整打包与「同目录 `./Md3`」约定见 **[docs/packaging.md](docs/getting-started/packaging.md)**。  
接入方式总览见 **[docs/integration.md](docs/getting-started/integration.md)**。

### Library only (no Gallery)

```powershell
cmake -S . -B build-lib -G Ninja `
  -DCMAKE_PREFIX_PATH="D:/Qt/6.10.2/mingw_64" `
  -DMD3_BUILD_GALLERY=OFF
cmake --build build-lib
cmake --install build-lib --prefix dist
```

Produces target **`Md3`** / **`Md3::Md3`** (static QML module `URI Md3`). Gallery is not built.

### Linux — one-click package (shared by default + system install)

```bash
python scripts/packaging/cli.py          # interactive TUI
./scripts/packaging/package-linux.sh     # same CLI
# static: SHARED=0 ./scripts/packaging/package-linux.sh
# stage only: SKIP_SYSTEM_INSTALL=1 ./scripts/packaging/package-linux.sh
CMAKE_PREFIX_PATH=$HOME/Qt/6.10.2/gcc_64 ./scripts/packaging/package-linux.sh
```

### Windows — one-click package (shared by default + user install)

```powershell
python scripts/packaging/cli.py
.\scripts\packaging\package-windows.ps1
.\scripts\packaging\package-windows.ps1 --qt-prefix "D:\Qt\6.10.2\mingw_64" -y
.\scripts\packaging\package-windows.ps1 --static -y
.\scripts\packaging\package-windows.ps1 --skip-install -y
.\scripts\packaging\package-windows.ps1 --bundle-dir "D:\path\to\Md3CreateDir" -y
```

Both write `dist/Md3/` (`lib/`, `include/`, `lib/cmake/Md3/`, and `bin/` for Windows DLLs) plus a zip/tarball. With Md3 Create, keep this layout:

```text
SomeFolder\
  Md3Create.exe
  Md3\              # fixed name — same directory as the wizard
```

Generated apps get `./Md3` in the project root (same directory as `CMakeLists.txt`).

```cmake
list(APPEND CMAKE_PREFIX_PATH "${CMAKE_CURRENT_SOURCE_DIR}/Md3")
find_package(Md3 REQUIRED)
target_link_libraries(app PRIVATE Md3::Md3)
```


### Library + Gallery (default for this repo)

```powershell
cmake -S . -B build -G Ninja -DCMAKE_PREFIX_PATH="D:/Qt/6.10.2/mingw_64"
cmake --build build
```

Run the Gallery executable from the build tree.

### Use from another CMake project

```cmake
# Prefer: add as subdirectory (Gallery auto-disabled)
set(MD3_BUILD_GALLERY OFF CACHE BOOL "" FORCE)
add_subdirectory(3rdparty/QML_MD3)

# Or after cmake --install:
# find_package(Md3 REQUIRED)

qt_add_executable(myApp main.cpp)
target_link_libraries(myApp PRIVATE Md3 Qt6::Quick)
if (TARGET Md3plugin)
    target_link_libraries(myApp PRIVATE Md3plugin)
endif()
```

```qml
import Md3
Md3Button { text: "OK" }
```

```cpp
#include "md3.h"
int main(int argc, char *argv[]) {
    return Md3::run(argc, argv, "MyApp"); // loads MyApp/Main.qml
}
```

## Layout

| Path | Role |
|------|------|
| `src/Md3/` | Library module (`URI Md3`) — `CMakeLists.txt` is self-contained |
| `gallery/` | Optional component browser (`MD3_BUILD_GALLERY`) |
| `examples/hello-md3/` | Minimal consumer (`MD3_BUILD_EXAMPLES`) |
| `tests/smoke/` | qmltestrunner smoke (`MD3_BUILD_TESTS`) |
| `cmake/` | `Md3Config.cmake` for `find_package` after install |
| `docs/` | Guides + generated API |
| `src/Md3/resources/fonts/` | HarmonyOS Sans SC + Material Icons |

## CMake options

| Option | Default | Meaning |
|--------|---------|---------|
| `MD3_BUILD_GALLERY` | ON if top-level, **OFF** if `add_subdirectory` | Build Gallery app |
| `MD3_BUILD_EXAMPLES` | OFF | Build `examples/hello-md3` |
| `MD3_BUILD_TESTS` | OFF | Register qml smoke tests |
| `MD3_BUILD_SHARED` | OFF (scripts default ON) | Shared instead of static `Md3` |
| `MD3_QML_CACHEGEN` | **ON** | qmlcachegen; `-DOFF` when iterating QML without clean rebuild |
| `MD3_QT_VERSION` | `AUTO` | Qt major: `AUTO` / `5` / `6` |

## Docs

- [docs/getting-started/quickstart.md](docs/getting-started/quickstart.md) — **≤10 min**
- [docs/project/professional-todo.md](docs/project/professional-todo.md) — production TODO
- [docs/getting-started/api-stability.md](docs/getting-started/api-stability.md) — SemVer / public API
- [docs/getting-started/release-checklist.md](docs/getting-started/release-checklist.md)
- [docs/api/README.md](docs/api/README.md) — control API index
- [docs/packaging.md](docs/getting-started/packaging.md) · [docs/integration.md](docs/getting-started/integration.md)
- [docs/index.md](docs/index.md) — full guide map
- [LICENSE](LICENSE) · [NOTICE](NOTICE) · [CHANGELOG.md](CHANGELOG.md)

Sibling: [QML_Md3_Generation](https://github.com/wuyijing-dev/QML_Md3_Generation) — project wizard.

Regenerate API property tables **locally** after editing controls (do not auto-push Document repo):

```powershell
python tools/gen_api_docs.py
# Commit docs/api only when intentionally shipping API docs.
```

## Version

`1.0.0` — desktop-focused production release (see CHANGELOG).
