# Md3BulletChart

Bullet chart — qualitative ranges + measure + comparative marker.

- **Source:** `src/Md3/components/Md3BulletChart.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `value` | `real` | `0` | read/write | `Md3BulletChart` | — |
| `comparative` | `real` | `Number.NaN` | read/write | `Md3BulletChart` | — |
| `from` | `real` | `0` | read/write | `Md3BulletChart` | — |
| `to` | `real` | `100` | read/write | `Md3BulletChart` | — |
| `label` | `string` | `""` | read/write | `Md3BulletChart` | — |
| `unit` | `string` | `""` | read/write | `Md3BulletChart` | — |
| `ranges` | `var` | `[50, 75, 100]` | read/write | `Md3BulletChart` | Sorted ascending qualitative thresholds, e.g. [50, 75, 100] |
| `rangeColors` | `var` | `[]` | read/write | `Md3BulletChart` | — |
| `barHeight` | `real` | `18` | read/write | `Md3BulletChart` | — |
| `trackHeight` | `real` | `28` | read/write | `Md3BulletChart` | — |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3BulletChart` | Drop qualitative bands while page is off-display. |
| `progress` | `real` | `{…}` | readonly | `Md3BulletChart` | — |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3BulletChart {
    value: 0
    comparative: Number.NaN
    from: 0
    to: 100
    label: ""
}
```
