# Md3HeatmapChart

- **Source:** `src/Md3/components/Md3HeatmapChart.qml`

Heatmap with two styles: classic **Matrix** and **GitHub Contribution** calendar.

## Style

| Enum | Description |
|------|-------------|
| `Md3HeatmapChart.Matrix` | Continuous 2D matrix with `lowColor`→`highColor` |
| `Md3HeatmapChart.Contribution` | GitHub-like weeks×weekdays, discrete levels, Less/More legend |

## Contribution (GitHub) properties

| Name | Type | Default |
|------|------|---------|
| `values` | `var` | day-major counts oldest→newest (length ≈ `weeks*7`) |
| `weeks` | `int` | `53` |
| `levels` | `int` | `5` |
| `levelColors` | `var` | theme greens (light/dark) |
| `cellSize` / `cellGap` / `cellRadius` | `real` | `11` / `3` / `2` |
| `showMonthLabels` / `showWeekdayLabels` | `bool` | `true` |
| `weekStartsOnMonday` | `bool` | `true` |

```qml
Md3HeatmapChart {
    style: Md3HeatmapChart.Contribution
    weeks: 53
    values: contributionCounts // 371 numbers
}
```

## Matrix properties

`values` (2D or flat+`columns`), `rowLabels`, `columnLabels`, `lowColor`, `highColor`, `cellGap`, `showLegend`.
