# Md3Gauge

Classic horseshoe / arc KPI gauge (open bottom).

- **Source:** `src/Md3/components/Md3Gauge.qml`
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
| `value` | `real` | `0` | read/write | `Md3Gauge` | Current value. |
| `from` | `real` | `0` | read/write | `Md3Gauge` | Range lower bound. |
| `to` | `real` | `100` | read/write | `Md3Gauge` | Range upper bound. |
| `label` | `string` | `""` | read/write | `Md3Gauge` | Field / control label. |
| `unit` | `string` | `"%"` | read/write | `Md3Gauge` | Unit. |
| `decimals` | `int` | `0` | read/write | `Md3Gauge` | Decimals. |
| `strokeWidth` | `real` | `10` | read/write | `Md3Gauge` | Stroke Width. |
| `startAngle` | `real` | `-210` | read/write | `Md3Gauge` | Start Angle. |
| `sweepAngle` | `real` | `240` | read/write | `Md3Gauge` | Sweep Angle. |
| `trackColor` | `color` | `Md3Theme.colorScheme.gaugeTrack` | read/write | `Md3Gauge` | Track Color. |
| `valueColor` | `color` | `Md3Theme.colorScheme.primary` | read/write | `Md3Gauge` | Value Color. |
| `showValue` | `bool` | `true` | read/write | `Md3Gauge` | Show Value. |
| `size` | `real` | `140` | read/write | `Md3Gauge` | Control size token (see Enums). |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3Gauge` | Drop Shape geometry while page is off-display. |
| `progress` | `real` | `{…}` | readonly | `Md3Gauge` | Progress. |
| `valueText` | `string` | `Number(value).toFixed(decimals) + (unit.length ? unit : "")` | readonly | `Md3Gauge` | Value Text. |

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
    decimals: 0
}
```
