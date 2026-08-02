# Md3WaterfallChart

Waterfall chart — floating bars for stepwise +/− contributions to a total.

- **Source:** `src/Md3/components/Md3WaterfallChart.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `values` | `var` | `[]` | read/write | `Md3WaterfallChart` | [{ label, value, color? }] — positive = increase, negative = decrease |
| `upColor` | `color` | `Md3Theme.colorScheme.primary` | read/write | `Md3WaterfallChart` | — |
| `downColor` | `color` | `Md3Theme.colorScheme.error` | read/write | `Md3WaterfallChart` | — |
| `totalColor` | `color` | `Md3Theme.colorScheme.tertiary` | read/write | `Md3WaterfallChart` | — |
| `lastIsTotal` | `bool` | `true` | read/write | `Md3WaterfallChart` | — |
| `barGap` | `real` | `8` | read/write | `Md3WaterfallChart` | — |
| `showValues` | `bool` | `true` | read/write | `Md3WaterfallChart` | — |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3WaterfallChart` | Drop Canvas while page/window inactive (FBO free). |
| `steps` | `var` | `{…}` | readonly | `Md3WaterfallChart` | — |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `requestPaint()` | `Md3WaterfallChart` | — |

## Example

```qml
import Md3

Md3WaterfallChart {
    values: []
    upColor: Md3Theme.colorScheme.primary
    downColor: Md3Theme.colorScheme.error
    totalColor: Md3Theme.colorScheme.tertiary
    lastIsTotal: true
}
```
