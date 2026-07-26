# Md3Control

- **Source:** `src/Md3/primitives/Md3Control.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `hovered` | `bool` | `mouse.containsMouse` | read/write | `Md3Control` | — |
| `pressed` | `bool` | `mouse.pressed` | read/write | `Md3Control` | — |
| `focused` | `bool` | `activeFocus` | read/write | `Md3Control` | — |
| `controlEnabled` | `bool` | `enabled` | read/write | `Md3Control` | — |
| `accessibleName` | `string` | `""` | read/write | `Md3Control` | — |
| `accessibleRole` | `string` | `"button"` | read/write | `Md3Control` | — |
| `visualDensity` | `real` | `0` | read/write | `Md3Control` | — |
| `stateColor` | `color` | `Md3Theme.colorScheme.colorOnSurface` | read/write | `Md3Control` | — |
| `showRipple` | `bool` | `true` | read/write | `Md3Control` | — |
| `controlRadius` | `real` | `0` | read/write | `Md3Control` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `clicked()` | `Md3Control` | — |
| `pressAndHold()` | `Md3Control` | — |

## Methods

_None._

## Example

```qml
import Md3

Md3Control {
    hovered: mouse.containsMouse
    pressed: mouse.pressed
    focused: activeFocus
    controlEnabled: enabled
    accessibleName: ""
}
```
