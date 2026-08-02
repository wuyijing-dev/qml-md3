# Md3SegmentGauge

Segmented arc gauge — discrete wedges (battery / steps style).

- **Source:** `src/Md3/components/Md3SegmentGauge.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `value` | `real` | `0` | read/write | `Md3SegmentGauge` | — |
| `from` | `real` | `0` | read/write | `Md3SegmentGauge` | — |
| `to` | `real` | `100` | read/write | `Md3SegmentGauge` | — |
| `label` | `string` | `""` | read/write | `Md3SegmentGauge` | — |
| `unit` | `string` | `""` | read/write | `Md3SegmentGauge` | — |
| `decimals` | `int` | `0` | read/write | `Md3SegmentGauge` | — |
| `segments` | `int` | `12` | read/write | `Md3SegmentGauge` | — |
| `segmentGapDeg` | `real` | `4` | read/write | `Md3SegmentGauge` | — |
| `startAngle` | `real` | `-210` | read/write | `Md3SegmentGauge` | — |
| `sweepAngle` | `real` | `240` | read/write | `Md3SegmentGauge` | — |
| `strokeWidth` | `real` | `12` | read/write | `Md3SegmentGauge` | — |
| `trackColor` | `color` | `Md3Theme.colorScheme.gaugeTrack` | read/write | `Md3SegmentGauge` | — |
| `valueColor` | `color` | `Md3Theme.colorScheme.primary` | read/write | `Md3SegmentGauge` | — |
| `showValue` | `bool` | `true` | read/write | `Md3SegmentGauge` | — |
| `size` | `real` | `140` | read/write | `Md3SegmentGauge` | — |
| `progress` | `real` | `{…}` | readonly | `Md3SegmentGauge` | — |
| `filledSegments` | `int` | `Math.round(progress * Math.max(1, segments))` | readonly | `Md3SegmentGauge` | — |
| `valueText` | `string` | `Number(value).toFixed(decimals) + (unit.length ? unit : "")` | readonly | `Md3SegmentGauge` | — |
| `hostWindow` | `var` | `null` | read/write | `Md3SegmentGauge` | — |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3SegmentGauge` | — |

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
}
```
