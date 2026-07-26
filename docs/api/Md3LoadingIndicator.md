# Md3LoadingIndicator

Material 3 Loading indicator — Shape PathAngleArc (GPU), optional caption.

- **Source:** `src/Md3/components/Md3LoadingIndicator.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Enums

### `Md3LoadingIndicator.Size`

`Md3LoadingIndicator.Small`, `Md3LoadingIndicator.Medium`, `Md3LoadingIndicator.Large`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `sizePreset` | `int` | `Md3LoadingIndicator.Medium` | read/write | `Md3LoadingIndicator` | — |
| `value` | `real` | `0` | read/write | `Md3LoadingIndicator` | — |
| `indeterminate` | `bool` | `true` | read/write | `Md3LoadingIndicator` | — |
| `label` | `string` | `""` | read/write | `Md3LoadingIndicator` | — |
| `indicatorColor` | `color` | `Md3Theme.colorScheme.primary` | read/write | `Md3LoadingIndicator` | — |
| `trackColor` | `color` | `Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.primary, 0.2)` | read/write | `Md3LoadingIndicator` | — |
| `strokeWidth` | `real` | `{…}` | read/write | `Md3LoadingIndicator` | — |
| `indicatorSize` | `real` | `{…}` | read/write | `Md3LoadingIndicator` | — |
| `_treeShown` | `bool` | `true` | read/write | `Md3LoadingIndicator` | — |
| `sceneActive` | `bool` | `enabled && _treeShown` | readonly | `Md3LoadingIndicator` | — |
| `radius` | `real` | `indicatorSize / 2 - strokeWidth` | readonly | `Md3LoadingIndicator` | — |
| `rotation` | `real` | `-Math.PI / 2` | read/write | `Md3LoadingIndicator` | — |
| `sweep` | `real` | `Math.PI * 0.65` | read/write | `Md3LoadingIndicator` | — |
| `sweepDir` | `real` | `1` | read/write | `Md3LoadingIndicator` | — |
| `spinSpeed` | `real` | `Math.PI * 2 / (Md3Motion.progressSpin / 1000)` | read/write | `Md3LoadingIndicator` | — |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `radToDeg(r)` | `Md3LoadingIndicator` | — |
| `rebuild()` | `Md3LoadingIndicator` | — |

## Example

```qml
import Md3

Md3LoadingIndicator {
    sizePreset: Md3LoadingIndicator.Medium
    value: 0
    indeterminate: true
    label: ""
    indicatorColor: Md3Theme.colorScheme.primary
}
```
