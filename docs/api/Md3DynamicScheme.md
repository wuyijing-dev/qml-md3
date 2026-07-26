# Md3DynamicScheme

- **Source:** `src/Md3/foundation/Md3DynamicScheme.qml`
- **Extends:** `QtObject`

## Import

```qml
import Md3
```

## Properties

_None._

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `clamp01(x)` | `Md3DynamicScheme` | — |
| `hsl(h, s, l, a)` | `Md3DynamicScheme` | — |
| `wrapHue(h)` | `Md3DynamicScheme` | — |
| `luminance(c)` | `Md3DynamicScheme` | Relative luminance helper for contrast picks |
| `onColorFor(bg)` | `Md3DynamicScheme` | — |
| `applyTo(scheme, seedColor, isDark)` | `Md3DynamicScheme` | — |

## Example

```qml
import Md3

Md3DynamicScheme {
    // see properties above
}
```
