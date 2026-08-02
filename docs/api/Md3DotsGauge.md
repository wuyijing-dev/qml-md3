# Md3DotsGauge

Circular dots gauge — progress as filled dots around a ring.

- **Source:** `src/Md3/components/Md3DotsGauge.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `value` | `real` | `0` | read/write | `Md3DotsGauge` | — |
| `from` | `real` | `0` | read/write | `Md3DotsGauge` | — |
| `to` | `real` | `100` | read/write | `Md3DotsGauge` | — |
| `label` | `string` | `""` | read/write | `Md3DotsGauge` | — |
| `unit` | `string` | `""` | read/write | `Md3DotsGauge` | — |
| `decimals` | `int` | `0` | read/write | `Md3DotsGauge` | — |
| `dotCount` | `int` | `24` | read/write | `Md3DotsGauge` | — |
| `dotRadius` | `real` | `4` | read/write | `Md3DotsGauge` | — |
| `startAngle` | `real` | `-90` | read/write | `Md3DotsGauge` | — |
| `trackColor` | `color` | `Md3Theme.colorScheme.gaugeTrack` | read/write | `Md3DotsGauge` | — |
| `valueColor` | `color` | `Md3Theme.colorScheme.primary` | read/write | `Md3DotsGauge` | — |
| `showValue` | `bool` | `true` | read/write | `Md3DotsGauge` | — |
| `size` | `real` | `140` | read/write | `Md3DotsGauge` | — |
| `progress` | `real` | `{…}` | readonly | `Md3DotsGauge` | — |
| `filledDots` | `int` | `Math.round(progress * Math.max(1, dotCount))` | readonly | `Md3DotsGauge` | — |
| `valueText` | `string` | `Number(value).toFixed(decimals) + (unit.length ? unit : "")` | readonly | `Md3DotsGauge` | — |
| `hostWindow` | `var` | `null` | read/write | `Md3DotsGauge` | — |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3DotsGauge` | — |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3DotsGauge {
    value: 0
    from: 0
    to: 100
    label: ""
    unit: ""
}
```
