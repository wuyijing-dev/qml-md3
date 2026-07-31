# Md3RadarChart

Radar / spider chart — categories around a polygon, one or more series.

- **Source:** `src/Md3/components/Md3RadarChart.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `categories` | `var` | `[]` | read/write | `Md3RadarChart` | Category labels around the axes |
| `values` | `var` | `[]` | read/write | `Md3RadarChart` | One series: number[] aligned with categories; or multiple: [number[], ...] |
| `maxValue` | `real` | `Number.NaN` | read/write | `Md3RadarChart` | — |
| `fillColor` | `color` | `Qt.rgba(Md3Theme.colorScheme.primary.r, Md3Theme.colorScheme.primary.g, Md3Th…` | read/write | `Md3RadarChart` | — |
| `strokeColor` | `color` | `Md3Theme.colorScheme.primary` | read/write | `Md3RadarChart` | — |
| `seriesColors` | `var` | `[]` | read/write | `Md3RadarChart` | — |
| `levels` | `int` | `4` | read/write | `Md3RadarChart` | — |
| `showLabels` | `bool` | `true` | read/write | `Md3RadarChart` | — |
| `showDots` | `bool` | `true` | read/write | `Md3RadarChart` | — |
| `strokeWidth` | `real` | `2` | read/write | `Md3RadarChart` | — |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `requestPaint()` | `Md3RadarChart` | — |

## Example

```qml
import Md3

Md3RadarChart {
    categories: []
    values: []
    maxValue: Number.NaN
    fillColor: Qt.rgba(Md3Theme.colorScheme.primary.r, Md3Theme.colorScheme.primary.g, Md3Th…
    strokeColor: Md3Theme.colorScheme.primary
}
```
