# Md3StateLayer

- **Source:** `src/Md3/foundation/Md3StateLayer.qml`
- **Extends:** `QtObject`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 4 | 0 | 1 | 0 |

_Also inherits Qt Quick `QtObject` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `hover` | `real` | `0.08` | readonly | `Md3StateLayer` | Hover. |
| `focus` | `real` | `0.12` | readonly | `Md3StateLayer` | Focus. |
| `pressed` | `real` | `0.12` | readonly | `Md3StateLayer` | Pressed. |
| `dragged` | `real` | `0.16` | readonly | `Md3StateLayer` | Dragged. |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `opacityFor(isHovered, isFocused, isPressed, isDragged)` | `—` | `Md3StateLayer` | Opacity For. |

## Example

```qml
import Md3

Md3StateLayer {
    // see properties above
}
```
