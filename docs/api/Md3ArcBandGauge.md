# Md3ArcBandGauge

Thick arc-band gauge with an end cap marker (dashboard KPI band).

- **Source:** `src/Md3/components/Md3ArcBandGauge.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `value` | `real` | `0` | read/write | `Md3ArcBandGauge` | — |
| `from` | `real` | `0` | read/write | `Md3ArcBandGauge` | — |
| `to` | `real` | `100` | read/write | `Md3ArcBandGauge` | — |
| `label` | `string` | `""` | read/write | `Md3ArcBandGauge` | — |
| `unit` | `string` | `"%"` | read/write | `Md3ArcBandGauge` | — |
| `decimals` | `int` | `0` | read/write | `Md3ArcBandGauge` | — |
| `strokeWidth` | `real` | `16` | read/write | `Md3ArcBandGauge` | — |
| `startAngle` | `real` | `-210` | read/write | `Md3ArcBandGauge` | — |
| `sweepAngle` | `real` | `240` | read/write | `Md3ArcBandGauge` | — |
| `trackColor` | `color` | `Md3Theme.colorScheme.gaugeTrack` | read/write | `Md3ArcBandGauge` | — |
| `valueColor` | `color` | `Md3Theme.colorScheme.primary` | read/write | `Md3ArcBandGauge` | — |
| `markerColor` | `color` | `Md3Theme.colorScheme.colorOnPrimary` | read/write | `Md3ArcBandGauge` | — |
| `showValue` | `bool` | `true` | read/write | `Md3ArcBandGauge` | — |
| `showMarker` | `bool` | `true` | read/write | `Md3ArcBandGauge` | — |
| `size` | `real` | `140` | read/write | `Md3ArcBandGauge` | — |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3ArcBandGauge` | Drop Shape geometry while page is off-display. |
| `progress` | `real` | `{…}` | readonly | `Md3ArcBandGauge` | — |
| `valueText` | `string` | `Number(value).toFixed(decimals) + (unit.length ? unit : "")` | readonly | `Md3ArcBandGauge` | — |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3ArcBandGauge {
    value: 0
    from: 0
    to: 100
    label: ""
    unit: "%"
}
```
