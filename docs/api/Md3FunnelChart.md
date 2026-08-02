# Md3FunnelChart

Funnel chart — stages as stacked trapezoids (conversion / pipeline).

- **Source:** `src/Md3/components/Md3FunnelChart.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 8 | 0 | 1 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `values` | `var` | `[]` | read/write | `Md3FunnelChart` | [{ label, value, color? }] or number[] with `labels` |
| `labels` | `var` | `[]` | read/write | `Md3FunnelChart` | Labels. |
| `gap` | `real` | `4` | read/write | `Md3FunnelChart` | Gap. |
| `minWidthRatio` | `real` | `0.18` | read/write | `Md3FunnelChart` | Min Width Ratio. |
| `showLabels` | `bool` | `true` | read/write | `Md3FunnelChart` | Show Labels. |
| `showValues` | `bool` | `true` | read/write | `Md3FunnelChart` | Show Values. |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3FunnelChart` | Drop Canvas while page/window inactive (FBO free). |
| `stages` | `var` | `{…}` | readonly | `Md3FunnelChart` | Stages. |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `requestPaint()` | `—` | `Md3FunnelChart` | Request Paint. |

## Example

```qml
import Md3

Md3FunnelChart {
    values: []
    labels: []
    gap: 4
    minWidthRatio: 0.18
    showLabels: true
    showValues: true
}
```
