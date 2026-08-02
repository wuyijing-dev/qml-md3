# Md3_cpp

C++ bootstrap (`Md3::run` / `RunOptions`) and C ABI (`md3_capi.h`).

- **Source:** `src/Md3/md3.h`
- **Extends:** `—`
- **Kind:** C++ / QML_ELEMENT (generated from header)

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 10 | 0 | 6 | 0 |

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `organization` | `string` | `QStringLiteral("Md3")` | read/write | `Md3_cpp` | Organization. |
| `applicationName` | `string` | `QStringLiteral("Md3 App")` | read/write | `Md3_cpp` | Application Name. |
| `applicationVersion` | `string` | `QStringLiteral("1.1.1")` | read/write | `Md3_cpp` | Application Version. |
| `style` | `string` | `QStringLiteral("Basic")` | read/write | `Md3_cpp` | Style. |
| `loadFonts` | `bool` | `true` | read/write | `Md3_cpp` | Load Fonts. |
| `alphaBuffer` | `bool` | `true` | read/write | `Md3_cpp` | Alpha Buffer. |
| `printBanner` | `bool` | `false` | read/write | `Md3_cpp` | Print Banner. |
| `desktopFileName` | `string` | `—` | read/write | `Md3_cpp` | Desktop File Name. |
| `qmlImportPaths` | `var` | `—` | read/write | `Md3_cpp` | Qml Import Paths. |
| `appUserModelId` | `string` | `—` | read/write | `Md3_cpp` | App User Model Id. |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `Md3::run(…)` | `see header` | `Md3_cpp` | Run. |
| `Md3::loadFonts(…)` | `see header` | `Md3_cpp` | Load Fonts. |
| `Md3::initialize(…)` | `see header` | `Md3_cpp` | Initialize. |
| `md3_run_qml_file(…)` | `int/string` | `Md3_cpp` | Md3 run qml file. |
| `md3_run_qml_module(…)` | `int/string` | `Md3_cpp` | Md3 run qml module. |
| `md3_load_fonts(…)` | `int/string` | `Md3_cpp` | Md3 load fonts. |

## Example

```qml
import Md3

// C++ / host type — typically used from QML as `Md3_cpp { }`
Md3_cpp {
    // see properties / methods above
}
```
