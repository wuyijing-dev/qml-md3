# Md3SegmentGauge

Segmented arc gauge — discrete wedges (battery / steps style).

- **Source:** `src/Md3/components/Md3SegmentGauge.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 20 | 0 | 0 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `value` | `real` | `0` | read/write | `Md3SegmentGauge` | Current value. |
| `from` | `real` | `0` | read/write | `Md3SegmentGauge` | Range lower bound. |
| `to` | `real` | `100` | read/write | `Md3SegmentGauge` | Range upper bound. |
| `label` | `string` | `""` | read/write | `Md3SegmentGauge` | Field / control label. |
| `unit` | `string` | `""` | read/write | `Md3SegmentGauge` | Unit. |
| `decimals` | `int` | `0` | read/write | `Md3SegmentGauge` | Decimals. |
| `segments` | `int` | `12` | read/write | `Md3SegmentGauge` | Segments. |
| `segmentGapDeg` | `real` | `4` | read/write | `Md3SegmentGauge` | Segment Gap Deg. |
| `startAngle` | `real` | `-210` | read/write | `Md3SegmentGauge` | Start Angle. |
| `sweepAngle` | `real` | `240` | read/write | `Md3SegmentGauge` | Sweep Angle. |
| `strokeWidth` | `real` | `12` | read/write | `Md3SegmentGauge` | Stroke Width. |
| `trackColor` | `color` | `Md3Theme.colorScheme.gaugeTrack` | read/write | `Md3SegmentGauge` | Track Color. |
| `valueColor` | `color` | `Md3Theme.colorScheme.primary` | read/write | `Md3SegmentGauge` | Value Color. |
| `showValue` | `bool` | `true` | read/write | `Md3SegmentGauge` | Show Value. |
| `size` | `real` | `140` | read/write | `Md3SegmentGauge` | Control size token (see Enums). |
| `progress` | `real` | `{…}` | readonly | `Md3SegmentGauge` | Progress. |
| `filledSegments` | `int` | `Math.round(progress * Math.max(1, segments))` | readonly | `Md3SegmentGauge` | Filled Segments. |
| `valueText` | `string` | `Number(value).toFixed(decimals) + (unit.length ? unit : "")` | readonly | `Md3SegmentGauge` | Value Text. |
| `hostWindow` | `var` | `null` | read/write | `Md3SegmentGauge` | Host Window. |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3SegmentGauge` | Unload When Page Inactive. |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3SegmentGauge {
    value: 0
    from: 0
    to: 100
    label: ""
    unit: ""
    decimals: 0
}
```
