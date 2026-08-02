# Md3Ripple

- **Source:** `src/Md3/primitives/Md3Ripple.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 13 | 0 | 1 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `rippleColor` | `color` | `Md3Theme.colorScheme.colorOnSurface` | read/write | `Md3Ripple` | Ripple Color. |
| `clipRadius` | `real` | `-1` | read/write | `Md3Ripple` | Clip Radius. |
| `topLeftRadius` | `real` | `-1` | read/write | `Md3Ripple` | Per-corner override (Connected button ends). <0 falls back to resolvedClipRadius. |
| `topRightRadius` | `real` | `-1` | read/write | `Md3Ripple` | Top Right Radius. |
| `bottomLeftRadius` | `real` | `-1` | read/write | `Md3Ripple` | Bottom Left Radius. |
| `bottomRightRadius` | `real` | `-1` | read/write | `Md3Ripple` | Bottom Right Radius. |
| `active` | `bool` | `false` | read/write | `Md3Ripple` | Active. |
| `originX` | `real` | `width / 2` | read/write | `Md3Ripple` | Origin X. |
| `originY` | `real` | `height / 2` | read/write | `Md3Ripple` | Origin Y. |
| `useInkRipple` | `bool` | `Md3Theme.effectsRipple` | readonly | `Md3Ripple` | Use Ink Ripple. |
| `useMaskedRipple` | `bool` | `Md3Theme.effectsRippleMasked` | readonly | `Md3Ripple` | Use Masked Ripple. |
| `layersNeeded` | `bool` | `useMaskedRipple && (_layersArmed \|\| ripple.running \|\| interruptFade.running \|…` | readonly | `Md3Ripple` | Layers Needed. |
| `resolvedClipRadius` | `real` | `{…}` | readonly | `Md3Ripple` | Resolved Clip Radius. |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `pulse(x, y)` | `—` | `Md3Ripple` | Pulse. |

## Example

```qml
import Md3

Md3Ripple {
    rippleColor: Md3Theme.colorScheme.colorOnSurface
    clipRadius: -1
    topLeftRadius: -1
    topRightRadius: -1
    bottomLeftRadius: -1
    bottomRightRadius: -1
}
```
