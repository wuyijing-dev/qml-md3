# Md3BulletChart

Bullet chart — qualitative ranges + measure + comparative marker.

- **Source:** `src/Md3/components/Md3BulletChart.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 12 | 0 | 0 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `value` | `real` | `0` | read/write | `Md3BulletChart` | Current value. |
| `comparative` | `real` | `Number.NaN` | read/write | `Md3BulletChart` | Comparative. |
| `from` | `real` | `0` | read/write | `Md3BulletChart` | Range lower bound. |
| `to` | `real` | `100` | read/write | `Md3BulletChart` | Range upper bound. |
| `label` | `string` | `""` | read/write | `Md3BulletChart` | Field / control label. |
| `unit` | `string` | `""` | read/write | `Md3BulletChart` | Unit. |
| `ranges` | `var` | `[50, 75, 100]` | read/write | `Md3BulletChart` | Sorted ascending qualitative thresholds, e.g. [50, 75, 100] |
| `rangeColors` | `var` | `[]` | read/write | `Md3BulletChart` | Range Colors. |
| `barHeight` | `real` | `18` | read/write | `Md3BulletChart` | Bar Height. |
| `trackHeight` | `real` | `28` | read/write | `Md3BulletChart` | Track Height. |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3BulletChart` | Drop qualitative bands while page is off-display. |
| `progress` | `real` | `{…}` | readonly | `Md3BulletChart` | Progress. |

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
    unit: ""
}
```
