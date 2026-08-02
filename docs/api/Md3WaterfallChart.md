# Md3WaterfallChart

Waterfall chart — floating bars for stepwise +/− contributions to a total.

- **Source:** `src/Md3/components/Md3WaterfallChart.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 9 | 0 | 1 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `values` | `var` | `[]` | read/write | `Md3WaterfallChart` | [{ label, value, color? }] — positive = increase, negative = decrease |
| `upColor` | `color` | `Md3Theme.colorScheme.primary` | read/write | `Md3WaterfallChart` | Up Color. |
| `downColor` | `color` | `Md3Theme.colorScheme.error` | read/write | `Md3WaterfallChart` | Down Color. |
| `totalColor` | `color` | `Md3Theme.colorScheme.tertiary` | read/write | `Md3WaterfallChart` | Total Color. |
| `lastIsTotal` | `bool` | `true` | read/write | `Md3WaterfallChart` | Last Is Total. |
| `barGap` | `real` | `8` | read/write | `Md3WaterfallChart` | Bar Gap. |
| `showValues` | `bool` | `true` | read/write | `Md3WaterfallChart` | Show Values. |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3WaterfallChart` | Drop Canvas while page/window inactive (FBO free). |
| `steps` | `var` | `{…}` | readonly | `Md3WaterfallChart` | Steps. |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `requestPaint()` | `—` | `Md3WaterfallChart` | Request Paint. |

## Example

```qml
import Md3

Md3WaterfallChart {
    values: []
    upColor: Md3Theme.colorScheme.primary
    downColor: Md3Theme.colorScheme.error
    totalColor: Md3Theme.colorScheme.tertiary
    lastIsTotal: true
    barGap: 8
}
```
