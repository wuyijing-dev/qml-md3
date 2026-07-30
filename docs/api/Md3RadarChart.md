# Md3RadarChart

- **Source:** `src/Md3/components/Md3RadarChart.qml`

Radar / spider chart.

```qml
Md3RadarChart {
    categories: ["Speed", "UX", "Docs", "Perf"]
    values: [80, 75, 68, 90]
    // or multi-series:
    // values: [[80, 75, 68, 90], [60, 85, 70, 55]]
}
```

## Properties

`categories`, `values`, `maxValue`, `levels`, `fillColor`, `strokeColor`, `seriesColors`, `showLabels`, `showDots`
