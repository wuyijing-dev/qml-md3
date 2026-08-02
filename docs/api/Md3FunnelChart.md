# Md3FunnelChart

Funnel chart — stages as stacked trapezoids (conversion / pipeline).

- **Source:** `src/Md3/components/Md3FunnelChart.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `values` | `var` | `[]` | read/write | `Md3FunnelChart` | [{ label, value, color? }] or number[] with `labels` |
| `labels` | `var` | `[]` | read/write | `Md3FunnelChart` | — |
| `gap` | `real` | `4` | read/write | `Md3FunnelChart` | — |
| `minWidthRatio` | `real` | `0.18` | read/write | `Md3FunnelChart` | — |
| `showLabels` | `bool` | `true` | read/write | `Md3FunnelChart` | — |
| `showValues` | `bool` | `true` | read/write | `Md3FunnelChart` | — |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3FunnelChart` | Drop Canvas while page/window inactive (FBO free). |
| `stages` | `var` | `{…}` | readonly | `Md3FunnelChart` | — |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `requestPaint()` | `Md3FunnelChart` | — |

## Example

```qml
import Md3

Md3FunnelChart {
    values: []
    labels: []
    gap: 4
    minWidthRatio: 0.18
    showLabels: true
}
```
