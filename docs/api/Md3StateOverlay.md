# Md3StateOverlay

- **Source:** `src/Md3/primitives/Md3StateOverlay.qml`
- **Extends:** `Rectangle`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 7 | 0 | 0 | 0 |

_Also inherits Qt Quick `Rectangle` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `overlayColor` | `color` | `Md3Theme.colorScheme.colorOnSurface` | read/write | `Md3StateOverlay` | Overlay Color. |
| `hovered` | `bool` | `false` | read/write | `Md3StateOverlay` | Hovered. |
| `focused` | `bool` | `false` | read/write | `Md3StateOverlay` | Focused. |
| `pressed` | `bool` | `false` | read/write | `Md3StateOverlay` | Pressed. |
| `dragged` | `bool` | `false` | read/write | `Md3StateOverlay` | Dragged. |
| `controlEnabled` | `bool` | `true` | read/write | `Md3StateOverlay` | Control Enabled. |
| `layerOpacity` | `real` | `{…}` | readonly | `Md3StateOverlay` | Layer Opacity. |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3StateOverlay {
    overlayColor: Md3Theme.colorScheme.colorOnSurface
    hovered: false
    focused: false
    pressed: false
    dragged: false
    controlEnabled: true
}
```
