# Md3HeatmapChart

Heatmap — matrix style or GitHub contribution calendar.

- **Source:** `src/Md3/components/Md3HeatmapChart.qml`
- **Extends:** `Item`

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
| `style` | `int` | `Md3HeatmapChart.Contribution` | read/write | `Md3HeatmapChart` | — |
| `values` | `var` | `[]` | read/write | `Md3HeatmapChart` | Matrix: [[n,...],...] or flat number[] + `columns` Contribution: number[] (day-major, oldest→newest) or [{ date, count }] |
| `columns` | `int` | `0` | read/write | `Md3HeatmapChart` | — |
| `rowLabels` | `var` | `[]` | read/write | `Md3HeatmapChart` | — |
| `columnLabels` | `var` | `[]` | read/write | `Md3HeatmapChart` | — |
| `minValue` | `real` | `Number.NaN` | read/write | `Md3HeatmapChart` | — |
| `maxValue` | `real` | `Number.NaN` | read/write | `Md3HeatmapChart` | — |
| `lowColor` | `color` | `Md3Theme.colorScheme.surfaceContainerHighest` | read/write | `Md3HeatmapChart` | — |
| `highColor` | `color` | `Md3Theme.colorScheme.primary` | read/write | `Md3HeatmapChart` | — |
| `weeks` | `int` | `53` | read/write | `Md3HeatmapChart` | — |
| `levels` | `int` | `5` | read/write | `Md3HeatmapChart` | — |
| `levelColors` | `var` | `[]` | read/write | `Md3HeatmapChart` | Empty → theme-aware greens similar to GitHub |
| `weekStartsOnMonday` | `bool` | `true` | read/write | `Md3HeatmapChart` | — |
| `showMonthLabels` | `bool` | `true` | read/write | `Md3HeatmapChart` | — |
| `showWeekdayLabels` | `bool` | `true` | read/write | `Md3HeatmapChart` | — |
| `cellSize` | `real` | `11` | read/write | `Md3HeatmapChart` | — |
| `cellGap` | `real` | `3` | read/write | `Md3HeatmapChart` | — |
| `cellRadius` | `real` | `2` | read/write | `Md3HeatmapChart` | — |
| `showLegend` | `bool` | `true` | read/write | `Md3HeatmapChart` | — |
| `legendHeight` | `real` | `18` | read/write | `Md3HeatmapChart` | — |
| `matrix` | `var` | `{…}` | readonly | `Md3HeatmapChart` | — |
| `valueRange` | `var` | `{…}` | readonly | `Md3HeatmapChart` | — |
| `effectiveLevelColors` | `var` | `{…}` | readonly | `Md3HeatmapChart` | — |
| `monthLabels` | `var` | `style === Md3HeatmapChart.Contribution` | readonly | `Md3HeatmapChart` | — |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3HeatmapChart` | Drop Canvas FBOs while page/window inactive. |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `levelFor(v)` | `Md3HeatmapChart` | — |
| `cellColor(v)` | `Md3HeatmapChart` | — |
| `requestPaint()` | `Md3HeatmapChart` | — |

## Example

```qml
import Md3

Md3HeatmapChart {
    style: Md3HeatmapChart.Contribution
    values: []
    columns: 0
    rowLabels: []
    columnLabels: []
}
```
