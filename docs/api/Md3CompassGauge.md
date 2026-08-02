# Md3CompassGauge

Compass-style circular dial with heading needle (0–360°).

- **Source:** `src/Md3/components/Md3CompassGauge.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 17 | 0 | 0 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `value` | `real` | `0` | read/write | `Md3CompassGauge` | Current value. |
| `from` | `real` | `0` | read/write | `Md3CompassGauge` | Range lower bound. |
| `to` | `real` | `360` | read/write | `Md3CompassGauge` | Range upper bound. |
| `label` | `string` | `""` | read/write | `Md3CompassGauge` | Field / control label. |
| `unit` | `string` | `"°"` | read/write | `Md3CompassGauge` | Unit. |
| `decimals` | `int` | `0` | read/write | `Md3CompassGauge` | Decimals. |
| `trackColor` | `color` | `Md3Theme.colorScheme.gaugeTrack` | read/write | `Md3CompassGauge` | Track Color. |
| `dialColor` | `color` | `Md3Theme.colorScheme.gaugeDial` | read/write | `Md3CompassGauge` | Dial Color. |
| `valueColor` | `color` | `Md3Theme.colorScheme.error` | read/write | `Md3CompassGauge` | Value Color. |
| `tickColor` | `color` | `Md3Theme.colorScheme.colorOnSurfaceVariant` | read/write | `Md3CompassGauge` | Tick Color. |
| `showCardinals` | `bool` | `true` | read/write | `Md3CompassGauge` | Show Cardinals. |
| `showValue` | `bool` | `true` | read/write | `Md3CompassGauge` | Show Value. |
| `size` | `real` | `140` | read/write | `Md3CompassGauge` | Control size token (see Enums). |
| `progress` | `real` | `{…}` | readonly | `Md3CompassGauge` | Progress. |
| `valueText` | `string` | `Number(value).toFixed(decimals) + (unit.length ? unit : "")` | readonly | `Md3CompassGauge` | Value Text. |
| `hostWindow` | `var` | `null` | read/write | `Md3CompassGauge` | Host Window. |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3CompassGauge` | Unload When Page Inactive. |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3CompassGauge {
    value: 0
    from: 0
    to: 360
    label: ""
    unit: "°"
    decimals: 0
}
```
