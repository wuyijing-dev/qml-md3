# Md3DynamicScheme

- **Source:** `src/Md3/foundation/Md3DynamicScheme.qml`
- **Extends:** `QtObject`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 0 | 0 | 6 | 0 |

_Also inherits Qt Quick `QtObject` members (not listed)._

## Import

```qml
import Md3
```

## Properties

_None._

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `clamp01(x)` | `—` | `Md3DynamicScheme` | Clamp01. |
| `hsl(h, s, l, a)` | `—` | `Md3DynamicScheme` | Hsl. |
| `wrapHue(h)` | `—` | `Md3DynamicScheme` | Wrap Hue. |
| `luminance(c)` | `—` | `Md3DynamicScheme` | Relative luminance helper for contrast picks |
| `onColorFor(bg)` | `—` | `Md3DynamicScheme` | On Color For. |
| `applyTo(scheme, seedColor, isDark)` | `—` | `Md3DynamicScheme` | Apply To. |

## Example

```qml
import Md3

Md3DynamicScheme {
    // see properties above
}
```
