# Md3Control

- **Source:** `src/Md3/primitives/Md3Control.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 10 | 2 | 0 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `hovered` | `bool` | `mouse.containsMouse` | read/write | `Md3Control` | Hovered. |
| `pressed` | `bool` | `mouse.pressed` | read/write | `Md3Control` | Pressed. |
| `focused` | `bool` | `activeFocus` | read/write | `Md3Control` | Focused. |
| `controlEnabled` | `bool` | `enabled` | read/write | `Md3Control` | Control Enabled. |
| `accessibleName` | `string` | `""` | read/write | `Md3Control` | Accessible name override. |
| `accessibleRole` | `string` | `"button"` | read/write | `Md3Control` | Accessible Role. |
| `visualDensity` | `real` | `0` | read/write | `Md3Control` | Visual Density. |
| `stateColor` | `color` | `Md3Theme.colorScheme.colorOnSurface` | read/write | `Md3Control` | State Color. |
| `showRipple` | `bool` | `true` | read/write | `Md3Control` | Show Ripple. |
| `controlRadius` | `real` | `0` | read/write | `Md3Control` | Control Radius. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `clicked()` | `Md3Control` | Emitted when clicked. |
| `pressAndHold()` | `Md3Control` | Emitted when press And Hold. |

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
    accessibleRole: "button"
}
```
