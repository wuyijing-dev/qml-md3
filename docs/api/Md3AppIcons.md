# Md3AppIcons

Default app / window icons shipped inside the Md3 module (resources/icons). Paths: qrc:/md3/icons/app-icon.png … — used when windowIcon is left empty.

- **Source:** `src/Md3/foundation/Md3AppIcons.qml`
- **Extends:** `QtObject`
- **Singleton:** `true` (`pragma Singleton`)

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `app` | `url` | `"qrc:/md3/icons/app-icon.png"` | readonly | `Md3AppIcons` | — |
| `app16` | `url` | `"qrc:/md3/icons/app-icon-16.png"` | readonly | `Md3AppIcons` | — |
| `app32` | `url` | `"qrc:/md3/icons/app-icon-32.png"` | readonly | `Md3AppIcons` | — |
| `app48` | `url` | `"qrc:/md3/icons/app-icon-48.png"` | readonly | `Md3AppIcons` | — |
| `app256` | `url` | `"qrc:/md3/icons/app-icon-256.png"` | readonly | `Md3AppIcons` | — |
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
