# Md3AreaChart

Stacked / single area chart (filled series under a line).

- **Source:** `src/Md3/components/Md3AreaChart.qml`
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
| `values` | `var` | `[]` | read/write | `Md3AreaChart` | number[] or [number[], ...] for stacked areas |
| `labels` | `var` | `[]` | read/write | `Md3AreaChart` | Labels. |
| `seriesColors` | `var` | `[]` | read/write | `Md3AreaChart` | Series Colors. |
| `minY` | `real` | `Number.NaN` | read/write | `Md3AreaChart` | Min Y. |
| `maxY` | `real` | `Number.NaN` | read/write | `Md3AreaChart` | Max Y. |
| `stacked` | `bool` | `false` | read/write | `Md3AreaChart` | Stacked. |
| `showLine` | `bool` | `true` | read/write | `Md3AreaChart` | Show Line. |
| `showGrid` | `bool` | `true` | read/write | `Md3AreaChart` | Show Grid. |
| `lineWidth` | `real` | `2` | read/write | `Md3AreaChart` | Line Width. |
| `areaOpacity` | `real` | `0.35` | read/write | `Md3AreaChart` | Area Opacity. |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3AreaChart` | Drop Canvas while page/window inactive (FBO free). |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `requestPaint()` | `—` | `Md3AreaChart` | Request Paint. |

## Example

```qml
import Md3

Md3AreaChart {
    values: []
    labels: []
    seriesColors: []
    minY: Number.NaN
    maxY: Number.NaN
    stacked: false
}
```
