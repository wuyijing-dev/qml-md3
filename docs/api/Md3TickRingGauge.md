# Md3TickRingGauge

Tick-ring gauge — circular progress with radial tick marks (no needle).

- **Source:** `src/Md3/components/Md3TickRingGauge.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `value` | `real` | `0` | read/write | `Md3TickRingGauge` | — |
| `from` | `real` | `0` | read/write | `Md3TickRingGauge` | — |
| `to` | `real` | `100` | read/write | `Md3TickRingGauge` | — |
| `label` | `string` | `""` | read/write | `Md3TickRingGauge` | — |
| `unit` | `string` | `"%"` | read/write | `Md3TickRingGauge` | — |
| `decimals` | `int` | `0` | read/write | `Md3TickRingGauge` | — |
| `tickCount` | `int` | `36` | read/write | `Md3TickRingGauge` | — |
| `strokeWidth` | `real` | `8` | read/write | `Md3TickRingGauge` | — |
| `startAngle` | `real` | `-90` | read/write | `Md3TickRingGauge` | — |
| `trackColor` | `color` | `Md3Theme.colorScheme.gaugeTrack` | read/write | `Md3TickRingGauge` | — |
| `valueColor` | `color` | `Md3Theme.colorScheme.primary` | read/write | `Md3TickRingGauge` | — |
| `tickColor` | `color` | `Md3Theme.colorScheme.outlineVariant` | read/write | `Md3TickRingGauge` | — |
| `showValue` | `bool` | `true` | read/write | `Md3TickRingGauge` | — |
| `size` | `real` | `140` | read/write | `Md3TickRingGauge` | — |
| `progress` | `real` | `{…}` | readonly | `Md3TickRingGauge` | — |
| `valueText` | `string` | `Number(value).toFixed(decimals) + (unit.length ? unit : "")` | readonly | `Md3TickRingGauge` | — |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3TickRingGauge {
    value: 0
    from: 0
    to: 100
    label: ""
    unit: "%"
}
```
