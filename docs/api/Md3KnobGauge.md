# Md3KnobGauge

Rotary knob-style gauge (value as dial rotation with notch).

- **Source:** `src/Md3/components/Md3KnobGauge.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `value` | `real` | `0` | read/write | `Md3KnobGauge` | — |
| `from` | `real` | `0` | read/write | `Md3KnobGauge` | — |
| `to` | `real` | `100` | read/write | `Md3KnobGauge` | — |
| `label` | `string` | `""` | read/write | `Md3KnobGauge` | — |
| `unit` | `string` | `""` | read/write | `Md3KnobGauge` | — |
| `decimals` | `int` | `0` | read/write | `Md3KnobGauge` | — |
| `startAngle` | `real` | `-135` | read/write | `Md3KnobGauge` | — |
| `sweepAngle` | `real` | `270` | read/write | `Md3KnobGauge` | — |
| `trackColor` | `color` | `Md3Theme.colorScheme.gaugeTrack` | read/write | `Md3KnobGauge` | — |
| `valueColor` | `color` | `Md3Theme.colorScheme.primary` | read/write | `Md3KnobGauge` | — |
| `knobColor` | `color` | `Md3Theme.colorScheme.gaugeDial` | read/write | `Md3KnobGauge` | — |
| `showValue` | `bool` | `true` | read/write | `Md3KnobGauge` | — |
| `size` | `real` | `140` | read/write | `Md3KnobGauge` | — |
| `progress` | `real` | `{…}` | readonly | `Md3KnobGauge` | — |
| `valueText` | `string` | `Number(value).toFixed(decimals) + (unit.length ? unit : "")` | readonly | `Md3KnobGauge` | — |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3KnobGauge {
    value: 0
    from: 0
    to: 100
    label: ""
    unit: ""
}
```
