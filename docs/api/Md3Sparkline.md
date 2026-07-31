# Md3Sparkline

Lightweight sparkline for KPIs / lists — Canvas only (no Md3Chart overhead).

- **Source:** `src/Md3/components/Md3Sparkline.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `values` | `var` | `[]` | read/write | `Md3Sparkline` | — |
| `stroke` | `color` | `Md3Theme.colorScheme.primary` | read/write | `Md3Sparkline` | — |
| `fill` | `color` | `"transparent"` | read/write | `Md3Sparkline` | — |
| `minY` | `real` | `Number.NaN` | read/write | `Md3Sparkline` | — |
| `maxY` | `real` | `Number.NaN` | read/write | `Md3Sparkline` | — |
| `lineWidth` | `real` | `1.5` | read/write | `Md3Sparkline` | — |
| `showArea` | `bool` | `true` | read/write | `Md3Sparkline` | — |
| `showLastDot` | `bool` | `false` | read/write | `Md3Sparkline` | — |
| `areaOpacity` | `real` | `0.22` | read/write | `Md3Sparkline` | — |
| `effectiveFill` | `color` | `fill.a > 0.01 ? fill` | readonly | `Md3Sparkline` | — |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3Sparkline {
    values: []
    stroke: Md3Theme.colorScheme.primary
    fill: "transparent"
    minY: Number.NaN
    maxY: Number.NaN
}
```
