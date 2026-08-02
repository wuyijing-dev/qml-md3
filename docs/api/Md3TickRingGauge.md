# Md3TickRingGauge

Tick-ring gauge — circular progress with radial tick marks (no needle).

- **Source:** `src/Md3/components/Md3TickRingGauge.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 18 | 0 | 0 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `value` | `real` | `0` | read/write | `Md3TickRingGauge` | Current value. |
| `from` | `real` | `0` | read/write | `Md3TickRingGauge` | Range lower bound. |
| `to` | `real` | `100` | read/write | `Md3TickRingGauge` | Range upper bound. |
| `label` | `string` | `""` | read/write | `Md3TickRingGauge` | Field / control label. |
| `unit` | `string` | `"%"` | read/write | `Md3TickRingGauge` | Unit. |
| `decimals` | `int` | `0` | read/write | `Md3TickRingGauge` | Decimals. |
| `tickCount` | `int` | `36` | read/write | `Md3TickRingGauge` | Tick Count. |
| `strokeWidth` | `real` | `8` | read/write | `Md3TickRingGauge` | Stroke Width. |
| `startAngle` | `real` | `-90` | read/write | `Md3TickRingGauge` | Start Angle. |
| `trackColor` | `color` | `Md3Theme.colorScheme.gaugeTrack` | read/write | `Md3TickRingGauge` | Track Color. |
| `valueColor` | `color` | `Md3Theme.colorScheme.primary` | read/write | `Md3TickRingGauge` | Value Color. |
| `tickColor` | `color` | `Md3Theme.colorScheme.outlineVariant` | read/write | `Md3TickRingGauge` | Tick Color. |
| `showValue` | `bool` | `true` | read/write | `Md3TickRingGauge` | Show Value. |
| `size` | `real` | `140` | read/write | `Md3TickRingGauge` | Control size token (see Enums). |
| `progress` | `real` | `{…}` | readonly | `Md3TickRingGauge` | Progress. |
| `valueText` | `string` | `Number(value).toFixed(decimals) + (unit.length ? unit : "")` | readonly | `Md3TickRingGauge` | Value Text. |
| `hostWindow` | `var` | `null` | read/write | `Md3TickRingGauge` | Host Window. |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3TickRingGauge` | Unload When Page Inactive. |

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
    decimals: 0
}
```
