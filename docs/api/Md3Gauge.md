# Md3Gauge

- **Source:** `src/Md3/components/Md3Gauge.qml`

Classic open-arc (horseshoe) KPI gauge.

## Related gauges (separate files)

| Component | File | Look |
|-----------|------|------|
| `Md3Gauge` | `Md3Gauge.qml` | Open arc |
| `Md3RingGauge` | `Md3RingGauge.qml` | Full 360° ring |
| `Md3NeedleGauge` | `Md3NeedleGauge.qml` | Needle + ticks |
| `Md3SegmentGauge` | `Md3SegmentGauge.qml` | Discrete segments |
| `Md3DotsGauge` | `Md3DotsGauge.qml` | Dots around ring |
| `Md3MultiRingGauge` | `Md3MultiRingGauge.qml` | Concentric rings |
| `Md3HalfGauge` | `Md3HalfGauge.qml` | Semicircle |
| `Md3WaveGauge` | `Md3WaveGauge.qml` | Liquid wave fill |
| `Md3TickRingGauge` | `Md3TickRingGauge.qml` | Ring + radial ticks |
| `Md3ArcBandGauge` | `Md3ArcBandGauge.qml` | Thick band + marker |
| `Md3KnobGauge` | `Md3KnobGauge.qml` | Rotary knob |
| `Md3CompassGauge` | `Md3CompassGauge.qml` | Compass heading |

## Properties

| Name | Type | Default |
|------|------|---------|
| `value` / `from` / `to` | `real` | `0` / `0` / `100` |
| `label` / `unit` | `string` | |
| `size` | `real` | `140` |
| `strokeWidth` | `real` | `10` |
| `startAngle` / `sweepAngle` | `real` | `-210` / `240` |
| `valueColor` / `trackColor` | `color` | theme |
| `showValue` | `bool` | `true` |
