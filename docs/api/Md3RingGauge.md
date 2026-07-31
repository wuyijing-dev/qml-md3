# Md3RingGauge

Full 360° ring / donut progress gauge.

- **Source:** `src/Md3/components/Md3RingGauge.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `value` | `real` | `0` | read/write | `Md3RingGauge` | — |
| `from` | `real` | `0` | read/write | `Md3RingGauge` | — |
| `to` | `real` | `100` | read/write | `Md3RingGauge` | — |
| `label` | `string` | `""` | read/write | `Md3RingGauge` | — |
| `unit` | `string` | `"%"` | read/write | `Md3RingGauge` | — |
| `decimals` | `int` | `0` | read/write | `Md3RingGauge` | — |
| `strokeWidth` | `real` | `12` | read/write | `Md3RingGauge` | — |
| `startAngle` | `real` | `-90` | read/write | `Md3RingGauge` | — |
| `trackColor` | `color` | `Md3Theme.colorScheme.gaugeTrack` | read/write | `Md3RingGauge` | — |
| `valueColor` | `color` | `Md3Theme.colorScheme.primary` | read/write | `Md3RingGauge` | — |
| `showValue` | `bool` | `true` | read/write | `Md3RingGauge` | — |
| `roundedCaps` | `bool` | `true` | read/write | `Md3RingGauge` | — |
| `size` | `real` | `140` | read/write | `Md3RingGauge` | — |
| `progress` | `real` | `{…}` | readonly | `Md3RingGauge` | — |
| `valueText` | `string` | `Number(value).toFixed(decimals) + (unit.length ? unit : "")` | readonly | `Md3RingGauge` | — |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3RingGauge {
    value: 0
    from: 0
    to: 100
    label: ""
    unit: "%"
}
```
