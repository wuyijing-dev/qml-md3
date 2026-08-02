# Md3Sparkline

Lightweight sparkline for KPIs / lists — Canvas only (no Md3Chart overhead).

- **Source:** `src/Md3/components/Md3Sparkline.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 11 | 0 | 0 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `values` | `var` | `[]` | read/write | `Md3Sparkline` | Values. |
| `stroke` | `color` | `Md3Theme.colorScheme.primary` | read/write | `Md3Sparkline` | Stroke. |
| `fill` | `color` | `"transparent"` | read/write | `Md3Sparkline` | Fill. |
| `minY` | `real` | `Number.NaN` | read/write | `Md3Sparkline` | Min Y. |
| `maxY` | `real` | `Number.NaN` | read/write | `Md3Sparkline` | Max Y. |
| `lineWidth` | `real` | `1.5` | read/write | `Md3Sparkline` | Line Width. |
| `showArea` | `bool` | `true` | read/write | `Md3Sparkline` | Show Area. |
| `showLastDot` | `bool` | `false` | read/write | `Md3Sparkline` | Show Last Dot. |
| `areaOpacity` | `real` | `0.22` | read/write | `Md3Sparkline` | Area Opacity. |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3Sparkline` | Drop Canvas FBO while page is off-display (shell size stays). |
| `effectiveFill` | `color` | `fill.a > 0.01 ? fill` | readonly | `Md3Sparkline` | Effective Fill. |

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
    lineWidth: 1.5
}
```
