# Md3HalfGauge

Semicircle / half-dial gauge (flat bottom).

- **Source:** `src/Md3/components/Md3HalfGauge.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `value` | `real` | `0` | read/write | `Md3HalfGauge` | — |
| `from` | `real` | `0` | read/write | `Md3HalfGauge` | — |
| `to` | `real` | `100` | read/write | `Md3HalfGauge` | — |
| `label` | `string` | `""` | read/write | `Md3HalfGauge` | — |
| `unit` | `string` | `"%"` | read/write | `Md3HalfGauge` | — |
| `decimals` | `int` | `0` | read/write | `Md3HalfGauge` | — |
| `strokeWidth` | `real` | `12` | read/write | `Md3HalfGauge` | — |
| `startAngle` | `real` | `180` | read/write | `Md3HalfGauge` | — |
| `sweepAngle` | `real` | `180` | read/write | `Md3HalfGauge` | — |
| `trackColor` | `color` | `Md3Theme.colorScheme.gaugeTrack` | read/write | `Md3HalfGauge` | — |
| `valueColor` | `color` | `Md3Theme.colorScheme.primary` | read/write | `Md3HalfGauge` | — |
| `showValue` | `bool` | `true` | read/write | `Md3HalfGauge` | — |
| `size` | `real` | `140` | read/write | `Md3HalfGauge` | — |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3HalfGauge` | Drop Shape geometry while page is off-display. |
| `progress` | `real` | `{…}` | readonly | `Md3HalfGauge` | — |
| `valueText` | `string` | `Number(value).toFixed(decimals) + (unit.length ? unit : "")` | readonly | `Md3HalfGauge` | — |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3HalfGauge {
    value: 0
    from: 0
    to: 100
    label: ""
    unit: "%"
}
```
