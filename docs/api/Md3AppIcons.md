# Md3AppIcons

Default app / window icons shipped inside the Md3 module (resources/icons). Paths: qrc:/md3/icons/app-icon.png … — used when windowIcon is left empty.

- **Source:** `src/Md3/foundation/Md3AppIcons.qml`
- **Extends:** `QtObject`
- **Singleton:** `true` (`pragma Singleton`)

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 6 | 0 | 0 | 0 |

_Also inherits Qt Quick `QtObject` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `app` | `url` | `"qrc:/md3/icons/app-icon.png"` | readonly | `Md3AppIcons` | App. |
| `app16` | `url` | `"qrc:/md3/icons/app-icon-16.png"` | readonly | `Md3AppIcons` | App16. |
| `app32` | `url` | `"qrc:/md3/icons/app-icon-32.png"` | readonly | `Md3AppIcons` | App32. |
| `app48` | `url` | `"qrc:/md3/icons/app-icon-48.png"` | readonly | `Md3AppIcons` | App48. |
| `app256` | `url` | `"qrc:/md3/icons/app-icon-256.png"` | readonly | `Md3AppIcons` | App256. |
| `window` | `url` | `app` | readonly | `Md3AppIcons` | Alias for title bar / About / taskbar primary icon. |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

// Singleton — use as `Md3AppIcons.…`
console.log(Md3AppIcons)
```
