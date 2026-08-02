# Md3WaveGauge

Circular gauge with animated liquid / wave fill level (seamless loop).

- **Source:** `src/Md3/components/Md3WaveGauge.qml`
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
| `value` | `real` | `0` | read/write | `Md3WaveGauge` | Current value. |
| `from` | `real` | `0` | read/write | `Md3WaveGauge` | Range lower bound. |
| `to` | `real` | `100` | read/write | `Md3WaveGauge` | Range upper bound. |
| `label` | `string` | `""` | read/write | `Md3WaveGauge` | Field / control label. |
| `unit` | `string` | `"%"` | read/write | `Md3WaveGauge` | Unit. |
| `decimals` | `int` | `0` | read/write | `Md3WaveGauge` | Decimals. |
| `trackColor` | `color` | `Md3Theme.colorScheme.gaugeTrack` | read/write | `Md3WaveGauge` | Track Color. |
| `dialColor` | `color` | `Md3Theme.colorScheme.gaugeDial` | read/write | `Md3WaveGauge` | Dial Color. |
| `valueColor` | `color` | `Md3Theme.colorScheme.primary` | read/write | `Md3WaveGauge` | Value Color. |
| `waveColor` | `color` | `Qt.rgba(valueColor.r, valueColor.g, valueColor.b, 0.55)` | read/write | `Md3WaveGauge` | Wave Color. |
| `showValue` | `bool` | `true` | read/write | `Md3WaveGauge` | Show Value. |
| `animated` | `bool` | `true` | read/write | `Md3WaveGauge` | Animated. |
| `animationFps` | `int` | `0` | read/write | `Md3WaveGauge` | 0 = display refresh (full quality). >0 only if you explicitly want a cap. |
| `size` | `real` | `140` | read/write | `Md3WaveGauge` | Control size token (see Enums). |
| `strokeWidth` | `real` | `3` | read/write | `Md3WaveGauge` | Stroke Width. |
| `waveSpeed` | `real` | `2.2` | read/write | `Md3WaveGauge` | Radians advanced per second (wave travel speed). |
| `hostWindow` | `var` | `null` | read/write | `Md3WaveGauge` | Optional Window for live-motion checks (else OverlayHost). |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3WaveGauge` | Unload When Page Inactive. |
| `progress` | `real` | `{…}` | readonly | `Md3WaveGauge` | Progress. |
| `valueText` | `string` | `Number(value).toFixed(decimals) + (unit.length ? unit : "")` | readonly | `Md3WaveGauge` | Value Text. |
| `effectivelyShown` | `bool` | `_treeShown` | readonly | `Md3WaveGauge` | Effectively Shown. |
| `wavePhase` | `real` | `0` | read/write | `Md3WaveGauge` | Wave Phase. |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3WaveGauge {
    value: 0
    from: 0
    to: 100
    label: ""
    unit: "%"
    decimals: 0
}
```
