# Md3RadialBarChart

Radial bar chart — each category as an arc bar on concentric tracks.

- **Source:** `src/Md3/components/Md3RadialBarChart.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 11 | 0 | 1 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `values` | `var` | `[]` | read/write | `Md3RadialBarChart` | [{ label, value, color? }] or number[] + labels |
| `labels` | `var` | `[]` | read/write | `Md3RadialBarChart` | Labels. |
| `maxValue` | `real` | `Number.NaN` | read/write | `Md3RadialBarChart` | Max Value. |
| `barWidth` | `real` | `10` | read/write | `Md3RadialBarChart` | Bar Width. |
| `barGap` | `real` | `6` | read/write | `Md3RadialBarChart` | Bar Gap. |
| `startAngle` | `real` | `-90` | read/write | `Md3RadialBarChart` | Start Angle. |
| `sweepAngle` | `real` | `270` | read/write | `Md3RadialBarChart` | Sweep Angle. |
| `trackColor` | `color` | `Md3Theme.colorScheme.gaugeTrack` | read/write | `Md3RadialBarChart` | Track Color. |
| `showLabels` | `bool` | `true` | read/write | `Md3RadialBarChart` | Show Labels. |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3RadialBarChart` | Drop Canvas while page/window inactive (FBO free). |
| `bars` | `var` | `{…}` | readonly | `Md3RadialBarChart` | Bars. |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `requestPaint()` | `—` | `Md3RadialBarChart` | Request Paint. |

## Example

```qml
import Md3

Md3RadialBarChart {
    values: []
    labels: []
    maxValue: Number.NaN
    barWidth: 10
    barGap: 6
    startAngle: -90
}
```
