# Md3RingGauge

Full 360° ring / donut progress gauge.

- **Source:** `src/Md3/components/Md3RingGauge.qml`
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
| `value` | `real` | `0` | read/write | `Md3RingGauge` | Current value. |
| `from` | `real` | `0` | read/write | `Md3RingGauge` | Range lower bound. |
| `to` | `real` | `100` | read/write | `Md3RingGauge` | Range upper bound. |
| `label` | `string` | `""` | read/write | `Md3RingGauge` | Field / control label. |
| `unit` | `string` | `"%"` | read/write | `Md3RingGauge` | Unit. |
| `decimals` | `int` | `0` | read/write | `Md3RingGauge` | Decimals. |
| `strokeWidth` | `real` | `12` | read/write | `Md3RingGauge` | Stroke Width. |
| `startAngle` | `real` | `-90` | read/write | `Md3RingGauge` | Start Angle. |
| `trackColor` | `color` | `Md3Theme.colorScheme.gaugeTrack` | read/write | `Md3RingGauge` | Track Color. |
| `valueColor` | `color` | `Md3Theme.colorScheme.primary` | read/write | `Md3RingGauge` | Value Color. |
| `showValue` | `bool` | `true` | read/write | `Md3RingGauge` | Show Value. |
| `roundedCaps` | `bool` | `true` | read/write | `Md3RingGauge` | Rounded Caps. |
| `size` | `real` | `140` | read/write | `Md3RingGauge` | Control size token (see Enums). |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3RingGauge` | Drop Shape geometry while page is off-display. |
| `progress` | `real` | `{…}` | readonly | `Md3RingGauge` | Progress. |
| `valueText` | `string` | `Number(value).toFixed(decimals) + (unit.length ? unit : "")` | readonly | `Md3RingGauge` | Value Text. |

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
    decimals: 0
}
```
