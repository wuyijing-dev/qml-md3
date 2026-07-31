# Md3Surface

- **Source:** `src/Md3/primitives/Md3Surface.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `color` | `color` | `Md3Theme.colorScheme.surface` | read/write | `Md3Surface` | — |
| `elevation` | `real` | `0` | read/write | `Md3Surface` | — |
| `radius` | `real` | `Md3Theme.shape.medium` | read/write | `Md3Surface` | — |
| `clipContent` | `bool` | `true` | read/write | `Md3Surface` | — |
| `tintColor` | `color` | `Md3Theme.colorScheme.surfaceTint` | read/write | `Md3Surface` | — |
| `layoutMode` | `int` | `Md3ContainerBody.Fit` | read/write | `Md3Surface` | — |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3Surface {
    color: Md3Theme.colorScheme.surface
    elevation: 0
    radius: Md3Theme.shape.medium
    clipContent: true
    tintColor: Md3Theme.colorScheme.surfaceTint
}
```
