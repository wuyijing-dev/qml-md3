# Md3Gauge

Classic horseshoe / arc KPI gauge (open bottom).

- **Source:** `src/Md3/components/Md3Gauge.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `value` | `real` | `0` | read/write | `Md3Gauge` | — |
| `from` | `real` | `0` | read/write | `Md3Gauge` | — |
| `to` | `real` | `100` | read/write | `Md3Gauge` | — |
| `label` | `string` | `""` | read/write | `Md3Gauge` | — |
| `unit` | `string` | `"%"` | read/write | `Md3Gauge` | — |
| `decimals` | `int` | `0` | read/write | `Md3Gauge` | — |
| `strokeWidth` | `real` | `10` | read/write | `Md3Gauge` | — |
| `startAngle` | `real` | `-210` | read/write | `Md3Gauge` | — |
| `sweepAngle` | `real` | `240` | read/write | `Md3Gauge` | — |
| `trackColor` | `color` | `Md3Theme.colorScheme.gaugeTrack` | read/write | `Md3Gauge` | — |
| `valueColor` | `color` | `Md3Theme.colorScheme.primary` | read/write | `Md3Gauge` | — |
| `showValue` | `bool` | `true` | read/write | `Md3Gauge` | — |
| `size` | `real` | `140` | read/write | `Md3Gauge` | — |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3Gauge` | Drop Shape geometry while page is off-display. |
| `progress` | `real` | `{…}` | readonly | `Md3Gauge` | — |
| `valueText` | `string` | `Number(value).toFixed(decimals) + (unit.length ? unit : "")` | readonly | `Md3Gauge` | — |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3Gauge {
    value: 0
    from: 0
    to: 100
    label: ""
    unit: "%"
}
```
