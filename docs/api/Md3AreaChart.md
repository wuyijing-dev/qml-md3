# Md3AreaChart

Stacked / single area chart (filled series under a line).

- **Source:** `src/Md3/components/Md3AreaChart.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `values` | `var` | `[]` | read/write | `Md3AreaChart` | number[] or [number[], ...] for stacked areas |
| `labels` | `var` | `[]` | read/write | `Md3AreaChart` | — |
| `seriesColors` | `var` | `[]` | read/write | `Md3AreaChart` | — |
| `minY` | `real` | `Number.NaN` | read/write | `Md3AreaChart` | — |
| `maxY` | `real` | `Number.NaN` | read/write | `Md3AreaChart` | — |
| `stacked` | `bool` | `false` | read/write | `Md3AreaChart` | — |
| `showLine` | `bool` | `true` | read/write | `Md3AreaChart` | — |
| `showGrid` | `bool` | `true` | read/write | `Md3AreaChart` | — |
| `lineWidth` | `real` | `2` | read/write | `Md3AreaChart` | — |
| `areaOpacity` | `real` | `0.35` | read/write | `Md3AreaChart` | — |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `requestPaint()` | `Md3AreaChart` | — |

## Example

```qml
import Md3

Md3AreaChart {
    values: []
    labels: []
    seriesColors: []
    minY: Number.NaN
    maxY: Number.NaN
}
```
