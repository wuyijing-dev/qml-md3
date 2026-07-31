# Md3NeedleGauge

Analog needle gauge with tick marks (speedometer-style).

- **Source:** `src/Md3/components/Md3NeedleGauge.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `value` | `real` | `0` | read/write | `Md3NeedleGauge` | — |
| `from` | `real` | `0` | read/write | `Md3NeedleGauge` | — |
| `to` | `real` | `100` | read/write | `Md3NeedleGauge` | — |
| `label` | `string` | `""` | read/write | `Md3NeedleGauge` | — |
| `unit` | `string` | `""` | read/write | `Md3NeedleGauge` | — |
| `decimals` | `int` | `0` | read/write | `Md3NeedleGauge` | — |
| `tickCount` | `int` | `11` | read/write | `Md3NeedleGauge` | — |
| `minorTicksPerMajor` | `int` | `4` | read/write | `Md3NeedleGauge` | — |
| `startAngle` | `real` | `-210` | read/write | `Md3NeedleGauge` | — |
| `sweepAngle` | `real` | `240` | read/write | `Md3NeedleGauge` | — |
| `strokeWidth` | `real` | `8` | read/write | `Md3NeedleGauge` | — |
| `trackColor` | `color` | `Md3Theme.colorScheme.gaugeTrack` | read/write | `Md3NeedleGauge` | — |
| `valueColor` | `color` | `Md3Theme.colorScheme.primary` | read/write | `Md3NeedleGauge` | — |
| `needleColor` | `color` | `Md3Theme.colorScheme.error` | read/write | `Md3NeedleGauge` | — |
| `tickColor` | `color` | `Md3Theme.colorScheme.colorOnSurfaceVariant` | read/write | `Md3NeedleGauge` | — |
| `showValue` | `bool` | `true` | read/write | `Md3NeedleGauge` | — |
| `showTicks` | `bool` | `true` | read/write | `Md3NeedleGauge` | — |
| `size` | `real` | `160` | read/write | `Md3NeedleGauge` | — |
| `progress` | `real` | `{…}` | readonly | `Md3NeedleGauge` | — |
| `valueText` | `string` | `Number(value).toFixed(decimals) + (unit.length ? unit : "")` | readonly | `Md3NeedleGauge` | — |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3NeedleGauge {
    value: 0
    from: 0
    to: 100
    label: ""
    unit: ""
}
```
