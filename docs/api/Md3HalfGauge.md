# Md3HalfGauge

Semicircle / half-dial gauge (flat bottom).

- **Source:** `src/Md3/components/Md3HalfGauge.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 16 | 0 | 0 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `value` | `real` | `0` | read/write | `Md3HalfGauge` | Current value. |
| `from` | `real` | `0` | read/write | `Md3HalfGauge` | Range lower bound. |
| `to` | `real` | `100` | read/write | `Md3HalfGauge` | Range upper bound. |
| `label` | `string` | `""` | read/write | `Md3HalfGauge` | Field / control label. |
| `unit` | `string` | `"%"` | read/write | `Md3HalfGauge` | Unit. |
| `decimals` | `int` | `0` | read/write | `Md3HalfGauge` | Decimals. |
| `strokeWidth` | `real` | `12` | read/write | `Md3HalfGauge` | Stroke Width. |
| `startAngle` | `real` | `180` | read/write | `Md3HalfGauge` | Start Angle. |
| `sweepAngle` | `real` | `180` | read/write | `Md3HalfGauge` | Sweep Angle. |
| `trackColor` | `color` | `Md3Theme.colorScheme.gaugeTrack` | read/write | `Md3HalfGauge` | Track Color. |
| `valueColor` | `color` | `Md3Theme.colorScheme.primary` | read/write | `Md3HalfGauge` | Value Color. |
| `showValue` | `bool` | `true` | read/write | `Md3HalfGauge` | Show Value. |
| `size` | `real` | `140` | read/write | `Md3HalfGauge` | Control size token (see Enums). |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3HalfGauge` | Drop Shape geometry while page is off-display. |
| `progress` | `real` | `{…}` | readonly | `Md3HalfGauge` | Progress. |
| `valueText` | `string` | `Number(value).toFixed(decimals) + (unit.length ? unit : "")` | readonly | `Md3HalfGauge` | Value Text. |

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
    decimals: 0
}
```
