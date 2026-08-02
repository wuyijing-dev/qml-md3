# Md3DotsGauge

Circular dots gauge — progress as filled dots around a ring.

- **Source:** `src/Md3/components/Md3DotsGauge.qml`
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
| `value` | `real` | `0` | read/write | `Md3DotsGauge` | Current value. |
| `from` | `real` | `0` | read/write | `Md3DotsGauge` | Range lower bound. |
| `to` | `real` | `100` | read/write | `Md3DotsGauge` | Range upper bound. |
| `label` | `string` | `""` | read/write | `Md3DotsGauge` | Field / control label. |
| `unit` | `string` | `""` | read/write | `Md3DotsGauge` | Unit. |
| `decimals` | `int` | `0` | read/write | `Md3DotsGauge` | Decimals. |
| `dotCount` | `int` | `24` | read/write | `Md3DotsGauge` | Dot Count. |
| `dotRadius` | `real` | `4` | read/write | `Md3DotsGauge` | Dot Radius. |
| `startAngle` | `real` | `-90` | read/write | `Md3DotsGauge` | Start Angle. |
| `trackColor` | `color` | `Md3Theme.colorScheme.gaugeTrack` | read/write | `Md3DotsGauge` | Track Color. |
| `valueColor` | `color` | `Md3Theme.colorScheme.primary` | read/write | `Md3DotsGauge` | Value Color. |
| `showValue` | `bool` | `true` | read/write | `Md3DotsGauge` | Show Value. |
| `size` | `real` | `140` | read/write | `Md3DotsGauge` | Control size token (see Enums). |
| `progress` | `real` | `{…}` | readonly | `Md3DotsGauge` | Progress. |
| `filledDots` | `int` | `Math.round(progress * Math.max(1, dotCount))` | readonly | `Md3DotsGauge` | Filled Dots. |
| `valueText` | `string` | `Number(value).toFixed(decimals) + (unit.length ? unit : "")` | readonly | `Md3DotsGauge` | Value Text. |
| `hostWindow` | `var` | `null` | read/write | `Md3DotsGauge` | Host Window. |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3DotsGauge` | Unload When Page Inactive. |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3DotsGauge {
    value: 0
    from: 0
    to: 100
    label: ""
    unit: ""
    decimals: 0
}
```
