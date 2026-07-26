# QML MD3

Enterprise Material Design 3 component library for **Qt Quick / QML 6.8+**, visually and temporally aligned with **Flutter Material 3**.

## Goals

- Pixel- and motion-accurate MD3 controls matching Flutter Material defaults
- Design tokens first: color roles, typography, shape, elevation, state layers, motion
- Per-control API docs under `docs/api/` (regenerate with `scripts/gen_api_docs.py`)
- Distributable QML module URI: `Md3`

## Requirements

- Qt **6.8+** (developed against Qt 6.10.2)
- CMake 3.16+
- C++17

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

### Library only (no Gallery)

```powershell
cmake -S . -B build-lib -G Ninja `
  -DCMAKE_PREFIX_PATH="D:/Qt/6.10.2/mingw_64" `
  -DMD3_BUILD_GALLERY=OFF
cmake --build build-lib
cmake --install build-lib --prefix dist
```

Produces target **`Md3`** / **`Md3::Md3`** (static QML module `URI Md3`). Gallery is not built.

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
| `gallery/` | Optional component browser (gated by `MD3_BUILD_GALLERY`) |
| `cmake/` | `Md3Config.cmake` for `find_package` after install |
| `docs/` | Architecture, tokens, per-component specs |
| `resources/fonts/` | Roboto + Material Icons |

## CMake options

| Option | Default | Meaning |
|--------|---------|---------|
| `MD3_BUILD_GALLERY` | ON if top-level, **OFF** if `add_subdirectory` | Build Gallery app |
| `MD3_BUILD_SHARED` | OFF | Shared instead of static `Md3` |

## Docs

- [docs/api/README.md](docs/api/README.md) — **完整控件 API**（一控件一文档，含全部属性/信号/方法）
- [docs/integration.md](docs/integration.md) — CMake + `Md3::run`
- [docs/tokens.md](docs/tokens.md) — 主题令牌
- [CHANGELOG.md](CHANGELOG.md)

Sibling tools (repo parent `QML_MD3/`):

- [`../md3-create`](../md3-create) — **QML 新建工程向导**（选 Qt 版本 / 模板，生成接入本库的应用）

Regenerate QML API pages after editing controls:

```powershell
python scripts/gen_api_docs.py
```

## Version

`0.1.0` — full component surface (controls remain **experimental** until visual regression audit).
