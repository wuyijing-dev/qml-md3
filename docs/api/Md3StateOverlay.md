# Md3StateOverlay

- **Source:** `src/Md3/primitives/Md3StateOverlay.qml`
- **Extends:** `Rectangle`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `overlayColor` | `color` | `Md3Theme.colorScheme.colorOnSurface` | read/write | `Md3StateOverlay` | — |
| `hovered` | `bool` | `false` | read/write | `Md3StateOverlay` | — |
| `focused` | `bool` | `false` | read/write | `Md3StateOverlay` | — |
| `pressed` | `bool` | `false` | read/write | `Md3StateOverlay` | — |
| `dragged` | `bool` | `false` | read/write | `Md3StateOverlay` | — |
| `controlEnabled` | `bool` | `true` | read/write | `Md3StateOverlay` | — |
| `layerOpacity` | `real` | `{…}` | readonly | `Md3StateOverlay` | — |

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
}
```
