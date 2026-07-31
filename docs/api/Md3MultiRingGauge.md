# Md3MultiRingGauge

Concentric multi-ring gauge — each ring is `{ value, from?, to?, color?, label? }`.

- **Source:** `src/Md3/components/Md3MultiRingGauge.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `rings` | `var` | `[]` | read/write | `Md3MultiRingGauge` | [{ value, from, to, color, label, unit }] |
| `strokeWidth` | `real` | `10` | read/write | `Md3MultiRingGauge` | — |
| `ringGap` | `real` | `6` | read/write | `Md3MultiRingGauge` | — |
| `startAngle` | `real` | `-90` | read/write | `Md3MultiRingGauge` | — |
| `trackColor` | `color` | `Md3Theme.colorScheme.gaugeTrack` | read/write | `Md3MultiRingGauge` | — |
| `showCenterLabel` | `bool` | `true` | read/write | `Md3MultiRingGauge` | — |
| `centerLabel` | `string` | `""` | read/write | `Md3MultiRingGauge` | — |
| `centerValue` | `string` | `""` | read/write | `Md3MultiRingGauge` | — |
| `size` | `real` | `160` | read/write | `Md3MultiRingGauge` | — |
| `minCenterRatio` | `real` | `0.40` | read/write | `Md3MultiRingGauge` | Minimum center hole as a fraction of diameter (keeps text readable). |
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
}
```
