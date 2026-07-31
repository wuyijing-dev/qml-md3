# Md3RadialBarChart

Radial bar chart — each category as an arc bar on concentric tracks.

- **Source:** `src/Md3/components/Md3RadialBarChart.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `values` | `var` | `[]` | read/write | `Md3RadialBarChart` | [{ label, value, color? }] or number[] + labels |
| `labels` | `var` | `[]` | read/write | `Md3RadialBarChart` | — |
| `maxValue` | `real` | `Number.NaN` | read/write | `Md3RadialBarChart` | — |
| `barWidth` | `real` | `10` | read/write | `Md3RadialBarChart` | — |
| `barGap` | `real` | `6` | read/write | `Md3RadialBarChart` | — |
| `startAngle` | `real` | `-90` | read/write | `Md3RadialBarChart` | — |
| `sweepAngle` | `real` | `270` | read/write | `Md3RadialBarChart` | — |
| `trackColor` | `color` | `Md3Theme.colorScheme.gaugeTrack` | read/write | `Md3RadialBarChart` | — |
| `showLabels` | `bool` | `true` | read/write | `Md3RadialBarChart` | — |
| `bars` | `var` | `{…}` | readonly | `Md3RadialBarChart` | — |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `requestPaint()` | `Md3RadialBarChart` | — |

## Example

```qml
import Md3

Md3RadialBarChart {
    values: []
    labels: []
    maxValue: Number.NaN
    barWidth: 10
    barGap: 6
}
```
