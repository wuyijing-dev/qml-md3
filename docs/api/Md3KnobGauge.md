# Md3KnobGauge

Rotary knob-style gauge — drag or arrow keys to change value.

- **Source:** `src/Md3/components/Md3KnobGauge.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 19 | 1 | 0 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `value` | `real` | `0` | read/write | `Md3KnobGauge` | Current value. |
| `from` | `real` | `0` | read/write | `Md3KnobGauge` | Range lower bound. |
| `to` | `real` | `100` | read/write | `Md3KnobGauge` | Range upper bound. |
| `step` | `real` | `1` | read/write | `Md3KnobGauge` | Step. |
| `label` | `string` | `""` | read/write | `Md3KnobGauge` | Field / control label. |
| `unit` | `string` | `""` | read/write | `Md3KnobGauge` | Unit. |
| `decimals` | `int` | `0` | read/write | `Md3KnobGauge` | Decimals. |
| `startAngle` | `real` | `-135` | read/write | `Md3KnobGauge` | Start Angle. |
| `sweepAngle` | `real` | `270` | read/write | `Md3KnobGauge` | Sweep Angle. |
| `trackColor` | `color` | `Md3Theme.colorScheme.gaugeTrack` | read/write | `Md3KnobGauge` | Track Color. |
| `valueColor` | `color` | `Md3Theme.colorScheme.primary` | read/write | `Md3KnobGauge` | Value Color. |
| `knobColor` | `color` | `Md3Theme.colorScheme.gaugeDial` | read/write | `Md3KnobGauge` | Knob Color. |
| `showValue` | `bool` | `true` | read/write | `Md3KnobGauge` | Show Value. |
| `interactive` | `bool` | `true` | read/write | `Md3KnobGauge` | Gate activation without forcing `enabled: false`. |
| `size` | `real` | `140` | read/write | `Md3KnobGauge` | Control size token (see Enums). |
| `progress` | `real` | `{…}` | readonly | `Md3KnobGauge` | Progress. |
| `valueText` | `string` | `Number(value).toFixed(decimals) + (unit.length ? unit : "")` | readonly | `Md3KnobGauge` | Value Text. |
| `hostWindow` | `var` | `null` | read/write | `Md3KnobGauge` | Host Window. |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3KnobGauge` | Unload When Page Inactive. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `valueEdited(real value)` | `Md3KnobGauge` | Emitted when value Edited. |

## Methods

_None._

## Example

```qml
import Md3

Md3KnobGauge {
    value: 0
    from: 0
    to: 100
    step: 1
    label: ""
    unit: ""
}
```
