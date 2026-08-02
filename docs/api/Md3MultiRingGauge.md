# Md3MultiRingGauge

Concentric multi-ring gauge — each ring is `{ value, from?, to?, color?, label? }`.

- **Source:** `src/Md3/components/Md3MultiRingGauge.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 13 | 0 | 0 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `rings` | `var` | `[]` | read/write | `Md3MultiRingGauge` | [{ value, from, to, color, label, unit }] |
| `strokeWidth` | `real` | `10` | read/write | `Md3MultiRingGauge` | Stroke Width. |
| `ringGap` | `real` | `6` | read/write | `Md3MultiRingGauge` | Ring Gap. |
| `startAngle` | `real` | `-90` | read/write | `Md3MultiRingGauge` | Start Angle. |
| `trackColor` | `color` | `Md3Theme.colorScheme.gaugeTrack` | read/write | `Md3MultiRingGauge` | Track Color. |
| `showCenterLabel` | `bool` | `true` | read/write | `Md3MultiRingGauge` | Show Center Label. |
| `centerLabel` | `string` | `""` | read/write | `Md3MultiRingGauge` | Center Label. |
| `centerValue` | `string` | `""` | read/write | `Md3MultiRingGauge` | Center Value. |
| `size` | `real` | `160` | read/write | `Md3MultiRingGauge` | Control size token (see Enums). |
| `minCenterRatio` | `real` | `0.40` | read/write | `Md3MultiRingGauge` | Minimum center hole as a fraction of diameter (keeps text readable). |
| `hostWindow` | `var` | `null` | read/write | `Md3MultiRingGauge` | Host Window. |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3MultiRingGauge` | Unload When Page Inactive. |
| `innerHoleRadius` | `real` | `Math.max(22, _dialR * minCenterRatio)` | readonly | `Md3MultiRingGauge` | Guaranteed readable hole; rings auto-thin to leave this clear. |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3MultiRingGauge {
    rings: []
    strokeWidth: 10
    ringGap: 6
    startAngle: -90
    trackColor: Md3Theme.colorScheme.gaugeTrack
    showCenterLabel: true
}
```
