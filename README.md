# QML MD3

Enterprise Material Design 3 component library for **Qt Quick / QML 6.8+**, visually and temporally aligned with **Flutter Material 3**.

## Goals

- Pixel- and motion-accurate MD3 controls matching Flutter Material defaults
- Design tokens first: color roles, typography, shape, elevation, state layers, motion
- Docs-first workflow: research → `docs/md3/*.md` → implement → Gallery page
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

Configure with your Qt kit (example MinGW path):

```powershell
cmake -S . -B build -G Ninja -DCMAKE_PREFIX_PATH="D:/Qt/6.10.2/mingw_64"
cmake --build build
```

Run the Gallery executable from the build tree.

## Layout

| Path | Role |
|------|------|
| `src/Md3/` | Library module (`URI Md3`) |
| `gallery/` | Component browser + scenes |
| `docs/` | Architecture, tokens, per-component specs, a11y, integration |
| `resources/fonts/` | Local Roboto + Material Icons / Outlined (see `scripts/download-fonts.ps1`) |

## Docs

- [docs/architecture.md](docs/architecture.md)
- [docs/workflow.md](docs/workflow.md) — docs-first (mandatory)
- [docs/tokens.md](docs/tokens.md)
- [docs/integration.md](docs/integration.md)
- [docs/a11y.md](docs/a11y.md)
- [docs/visual-regression.md](docs/visual-regression.md)
- [docs/md3/application-window.md](docs/md3/application-window.md) — cross-platform app window chrome (WinUI-like)
- [CHANGELOG.md](CHANGELOG.md)

## Version

`0.1.0` — full component surface (controls remain **experimental** until visual regression audit).
