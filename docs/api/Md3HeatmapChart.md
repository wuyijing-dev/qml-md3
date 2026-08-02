# Md3HeatmapChart

Heatmap — matrix style or GitHub contribution calendar.

- **Source:** `src/Md3/components/Md3HeatmapChart.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 25 | 0 | 3 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Enums

### `Md3HeatmapChart.Style`

`Md3HeatmapChart.Matrix`, `Md3HeatmapChart.Contribution`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `style` | `int (Md3HeatmapChart.Style)` | `Md3HeatmapChart.Contribution` | read/write | `Md3HeatmapChart` | Style. |
| `values` | `var` | `[]` | read/write | `Md3HeatmapChart` | Matrix: [[n,...],...] or flat number[] + `columns` Contribution: number[] (day-major, oldest→newest) or [{ date, count }] |
| `columns` | `int` | `0` | read/write | `Md3HeatmapChart` | Column definitions or count. |
| `rowLabels` | `var` | `[]` | read/write | `Md3HeatmapChart` | Row Labels. |
| `columnLabels` | `var` | `[]` | read/write | `Md3HeatmapChart` | Column Labels. |
| `minValue` | `real` | `Number.NaN` | read/write | `Md3HeatmapChart` | Min Value. |
| `maxValue` | `real` | `Number.NaN` | read/write | `Md3HeatmapChart` | Max Value. |
| `lowColor` | `color` | `Md3Theme.colorScheme.surfaceContainerHighest` | read/write | `Md3HeatmapChart` | Low Color. |
| `highColor` | `color` | `Md3Theme.colorScheme.primary` | read/write | `Md3HeatmapChart` | High Color. |
| `weeks` | `int` | `53` | read/write | `Md3HeatmapChart` | Weeks. |
| `levels` | `int` | `5` | read/write | `Md3HeatmapChart` | Levels. |
| `levelColors` | `var` | `[]` | read/write | `Md3HeatmapChart` | Empty → theme-aware greens similar to GitHub |
| `weekStartsOnMonday` | `bool` | `true` | read/write | `Md3HeatmapChart` | Week Starts On Monday. |
| `showMonthLabels` | `bool` | `true` | read/write | `Md3HeatmapChart` | Show Month Labels. |
| `showWeekdayLabels` | `bool` | `true` | read/write | `Md3HeatmapChart` | Show Weekday Labels. |
| `cellSize` | `real` | `11` | read/write | `Md3HeatmapChart` | Cell Size. |
| `cellGap` | `real` | `3` | read/write | `Md3HeatmapChart` | Cell Gap. |
| `cellRadius` | `real` | `2` | read/write | `Md3HeatmapChart` | Cell Radius. |
| `showLegend` | `bool` | `true` | read/write | `Md3HeatmapChart` | Show Legend. |
| `legendHeight` | `real` | `18` | read/write | `Md3HeatmapChart` | Legend Height. |
| `matrix` | `var` | `{…}` | readonly | `Md3HeatmapChart` | Matrix. |
| `valueRange` | `var` | `{…}` | readonly | `Md3HeatmapChart` | Value Range. |
| `effectiveLevelColors` | `var` | `{…}` | readonly | `Md3HeatmapChart` | Effective Level Colors. |
| `monthLabels` | `var` | `style === Md3HeatmapChart.Contribution` | readonly | `Md3HeatmapChart` | Month Labels. |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3HeatmapChart` | Drop Canvas FBOs while page/window inactive. |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `levelFor(v)` | `—` | `Md3HeatmapChart` | Level For. |
| `cellColor(v)` | `—` | `Md3HeatmapChart` | Cell Color. |
| `requestPaint()` | `—` | `Md3HeatmapChart` | Request Paint. |

## Example

```qml
import Md3

Md3HeatmapChart {
    style: Md3HeatmapChart.Contribution
    values: []
    columns: 0
    rowLabels: []
    columnLabels: []
    minValue: Number.NaN
}
```
