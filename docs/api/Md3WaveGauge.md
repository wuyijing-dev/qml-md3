# Md3WaveGauge

Circular gauge with animated liquid / wave fill level (seamless loop).

- **Source:** `src/Md3/components/Md3WaveGauge.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `value` | `real` | `0` | read/write | `Md3WaveGauge` | — |
| `from` | `real` | `0` | read/write | `Md3WaveGauge` | — |
| `to` | `real` | `100` | read/write | `Md3WaveGauge` | — |
| `label` | `string` | `""` | read/write | `Md3WaveGauge` | — |
| `unit` | `string` | `"%"` | read/write | `Md3WaveGauge` | — |
| `decimals` | `int` | `0` | read/write | `Md3WaveGauge` | — |
| `trackColor` | `color` | `Md3Theme.colorScheme.gaugeTrack` | read/write | `Md3WaveGauge` | — |
| `dialColor` | `color` | `Md3Theme.colorScheme.gaugeDial` | read/write | `Md3WaveGauge` | — |
| `valueColor` | `color` | `Md3Theme.colorScheme.primary` | read/write | `Md3WaveGauge` | — |
| `waveColor` | `color` | `Qt.rgba(valueColor.r, valueColor.g, valueColor.b, 0.55)` | read/write | `Md3WaveGauge` | — |
| `showValue` | `bool` | `true` | read/write | `Md3WaveGauge` | — |
| `animated` | `bool` | `true` | read/write | `Md3WaveGauge` | — |
| `animationFps` | `int` | `0` | read/write | `Md3WaveGauge` | 0 = display refresh (full quality). >0 only if you explicitly want a cap. |
| `size` | `real` | `140` | read/write | `Md3WaveGauge` | — |
| `strokeWidth` | `real` | `3` | read/write | `Md3WaveGauge` | — |
| `waveSpeed` | `real` | `2.2` | read/write | `Md3WaveGauge` | Radians advanced per second (wave travel speed). |
| `hostWindow` | `var` | `null` | read/write | `Md3WaveGauge` | Optional Window for live-motion checks (else OverlayHost). |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3WaveGauge` | — |
| `progress` | `real` | `{…}` | readonly | `Md3WaveGauge` | — |
| `valueText` | `string` | `Number(value).toFixed(decimals) + (unit.length ? unit : "")` | readonly | `Md3WaveGauge` | — |
| `effectivelyShown` | `bool` | `_treeShown` | readonly | `Md3WaveGauge` | — |
| `wavePhase` | `real` | `0` | read/write | `Md3WaveGauge` | — |

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
}
```
