# QML MD3

Enterprise Material Design 3 component library for **Qt Quick / QML 6.8+**, visually and temporally aligned with **Flutter Material 3**.

## Goals

- Pixel- and motion-accurate MD3 controls matching Flutter Material defaults
- Design tokens first: color roles, typography, shape, elevation, state layers, motion
- Per-control API docs under `docs/api/` (regenerate with `scripts/docs/gen_api_docs.py`)
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

完整打包与「同目录 `./Md3`」约定见 **[docs/packaging.md](docs/packaging.md)**。  
接入方式总览见 **[docs/integration.md](docs/integration.md)**。

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
| `gallery/` | Optional component browser (gated by `MD3_BUILD_GALLERY`) |
| `cmake/` | `Md3Config.cmake` for `find_package` after install |
| `docs/` | Architecture, tokens, per-component specs |
| `resources/fonts/` | HarmonyOS Sans SC Regular (+ optional Medium/Bold) + Material Icons |

## CMake options

| Option | Default | Meaning |
|--------|---------|---------|
| `MD3_BUILD_GALLERY` | ON if top-level, **OFF** if `add_subdirectory` | Build Gallery app |
| `MD3_BUILD_SHARED` | OFF (scripts default ON) | Shared instead of static `Md3` |
| `MD3_QML_CACHEGEN` | **ON** | qmlcachegen for faster cold open; `-DOFF` only when iterating QML without clean rebuild |
| `MD3_QT_VERSION` | `AUTO` | Qt major selector: `AUTO` / `5` / `6` |

## Docs

- [docs/professional-todo.md](docs/professional-todo.md) — **专业组件库完整 TODO**（治理 / CI / 测试 / a11y / 发版）
- [docs/a11y.md](docs/a11y.md) — 无障碍约定、键盘操作、验收与扫描脚本
- [docs/i18n.md](docs/i18n.md) — `qsTr` / `Md3I18n` / `.ts`→`.qm` 工作流
- [docs/api/README.md](docs/api/README.md) — **完整控件 API**（一控件一文档，含全部属性/信号/方法）
- [docs/packaging.md](docs/packaging.md) — **预编译包（默认 shared）/ 系统安装 / 同目录 `Md3/`**
- [docs/integration.md](docs/integration.md) — CMake + `Md3::run`
- [docs/qt-version-matrix.md](docs/qt-version-matrix.md) — Qt 5.15 / 6.5 / 6.8 stage matrix
- [docs/design-guidelines.md](docs/design-guidelines.md) — 变体 / 密度 / Sheet·Dialog / 表单与空态
- [docs/buttons-commands.md](docs/buttons-commands.md) — Toggle / DropDown / Hyperlink / CommandBar（WinUI 对照）
- [docs/performance.md](docs/performance.md) — first paint / page cache / memory tradeoffs
- [docs/mkdocs-hosting.md](docs/mkdocs-hosting.md) — MkDocs → 专用仓 [QML_MD3_Document](https://github.com/wuyijing-dev/QML_MD3_Document) / Pages
- [docs/consumer-app-main-qml.md](docs/consumer-app-main-qml.md) — fix consumer app `Main.qml` / qrc load failures
- [docs/tokens.md](docs/tokens.md) — 主题令牌
- [CHANGELOG.md](CHANGELOG.md)

Sibling tools:

- [QML_Md3_Generation](https://github.com/wuyijing-dev/QML_Md3_Generation) — **QML 新建工程向导**（同目录 `Md3/` 包）

Regenerate QML API pages after editing controls:

```powershell
python scripts/docs/gen_api_docs.py
```

## Version

`1.0.0` — first stable desktop-focused Md3 component library release.
