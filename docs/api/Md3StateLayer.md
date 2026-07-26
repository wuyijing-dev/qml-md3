# Md3StateLayer

- **Source:** `src/Md3/foundation/Md3StateLayer.qml`
- **Extends:** `QtObject`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `hover` | `real` | `0.08` | readonly | `Md3StateLayer` | — |
| `focus` | `real` | `0.12` | readonly | `Md3StateLayer` | — |
| `pressed` | `real` | `0.12` | readonly | `Md3StateLayer` | — |
| `dragged` | `real` | `0.16` | readonly | `Md3StateLayer` | — |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `opacityFor(isHovered, isFocused, isPressed, isDragged)` | `Md3StateLayer` | — |

## Example

```qml
import Md3

Md3StateLayer {
    // see properties above
}
```
