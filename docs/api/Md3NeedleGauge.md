# Md3NeedleGauge

Analog needle gauge with tick marks (speedometer-style).

- **Source:** `src/Md3/components/Md3NeedleGauge.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 22 | 0 | 0 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `value` | `real` | `0` | read/write | `Md3NeedleGauge` | Current value. |
| `from` | `real` | `0` | read/write | `Md3NeedleGauge` | Range lower bound. |
| `to` | `real` | `100` | read/write | `Md3NeedleGauge` | Range upper bound. |
| `label` | `string` | `""` | read/write | `Md3NeedleGauge` | Field / control label. |
| `unit` | `string` | `""` | read/write | `Md3NeedleGauge` | Unit. |
| `decimals` | `int` | `0` | read/write | `Md3NeedleGauge` | Decimals. |
| `tickCount` | `int` | `11` | read/write | `Md3NeedleGauge` | Tick Count. |
| `minorTicksPerMajor` | `int` | `4` | read/write | `Md3NeedleGauge` | Minor Ticks Per Major. |
| `startAngle` | `real` | `-210` | read/write | `Md3NeedleGauge` | Start Angle. |
| `sweepAngle` | `real` | `240` | read/write | `Md3NeedleGauge` | Sweep Angle. |
| `strokeWidth` | `real` | `8` | read/write | `Md3NeedleGauge` | Stroke Width. |
| `trackColor` | `color` | `Md3Theme.colorScheme.gaugeTrack` | read/write | `Md3NeedleGauge` | Track Color. |
| `valueColor` | `color` | `Md3Theme.colorScheme.primary` | read/write | `Md3NeedleGauge` | Value Color. |
| `needleColor` | `color` | `Md3Theme.colorScheme.error` | read/write | `Md3NeedleGauge` | Needle Color. |
| `tickColor` | `color` | `Md3Theme.colorScheme.colorOnSurfaceVariant` | read/write | `Md3NeedleGauge` | Tick Color. |
| `showValue` | `bool` | `true` | read/write | `Md3NeedleGauge` | Show Value. |
| `showTicks` | `bool` | `true` | read/write | `Md3NeedleGauge` | Show Ticks. |
| `size` | `real` | `160` | read/write | `Md3NeedleGauge` | Control size token (see Enums). |
| `progress` | `real` | `{…}` | readonly | `Md3NeedleGauge` | Progress. |
| `valueText` | `string` | `Number(value).toFixed(decimals) + (unit.length ? unit : "")` | readonly | `Md3NeedleGauge` | Value Text. |
| `hostWindow` | `var` | `null` | read/write | `Md3NeedleGauge` | Host Window. |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3NeedleGauge` | Unload When Page Inactive. |

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
    decimals: 0
}
```
