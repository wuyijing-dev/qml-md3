# Md3Ripple

- **Source:** `src/Md3/primitives/Md3Ripple.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `rippleColor` | `color` | `Md3Theme.colorScheme.colorOnSurface` | read/write | `Md3Ripple` | — |
| `clipRadius` | `real` | `-1` | read/write | `Md3Ripple` | — |
| `topLeftRadius` | `real` | `-1` | read/write | `Md3Ripple` | Per-corner override (Connected button ends). <0 falls back to resolvedClipRadius. |
| `topRightRadius` | `real` | `-1` | read/write | `Md3Ripple` | — |
| `bottomLeftRadius` | `real` | `-1` | read/write | `Md3Ripple` | — |
| `bottomRightRadius` | `real` | `-1` | read/write | `Md3Ripple` | — |
| `active` | `bool` | `false` | read/write | `Md3Ripple` | — |
| `originX` | `real` | `width / 2` | read/write | `Md3Ripple` | — |
| `originY` | `real` | `height / 2` | read/write | `Md3Ripple` | — |
| `layersNeeded` | `bool` | `_layersArmed` | readonly | `Md3Ripple` | — |
| `resolvedClipRadius` | `real` | `{…}` | readonly | `Md3Ripple` | — |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `pulse(x, y)` | `Md3Ripple` | — |

## Example

```qml
import Md3

Md3Ripple {
    rippleColor: Md3Theme.colorScheme.colorOnSurface
    clipRadius: -1
    topLeftRadius: -1
    topRightRadius: -1
    bottomLeftRadius: -1
}
```
