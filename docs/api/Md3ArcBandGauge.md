# Md3ArcBandGauge

Thick arc-band gauge with an end cap marker (dashboard KPI band).

- **Source:** `src/Md3/components/Md3ArcBandGauge.qml`
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
| `value` | `real` | `0` | read/write | `Md3ArcBandGauge` | Current value. |
| `from` | `real` | `0` | read/write | `Md3ArcBandGauge` | Range lower bound. |
| `to` | `real` | `100` | read/write | `Md3ArcBandGauge` | Range upper bound. |
| `label` | `string` | `""` | read/write | `Md3ArcBandGauge` | Field / control label. |
| `unit` | `string` | `"%"` | read/write | `Md3ArcBandGauge` | Unit. |
| `decimals` | `int` | `0` | read/write | `Md3ArcBandGauge` | Decimals. |
| `strokeWidth` | `real` | `16` | read/write | `Md3ArcBandGauge` | Stroke Width. |
| `startAngle` | `real` | `-210` | read/write | `Md3ArcBandGauge` | Start Angle. |
| `sweepAngle` | `real` | `240` | read/write | `Md3ArcBandGauge` | Sweep Angle. |
| `trackColor` | `color` | `Md3Theme.colorScheme.gaugeTrack` | read/write | `Md3ArcBandGauge` | Track Color. |
| `valueColor` | `color` | `Md3Theme.colorScheme.primary` | read/write | `Md3ArcBandGauge` | Value Color. |
| `markerColor` | `color` | `Md3Theme.colorScheme.colorOnPrimary` | read/write | `Md3ArcBandGauge` | Marker Color. |
| `showValue` | `bool` | `true` | read/write | `Md3ArcBandGauge` | Show Value. |
| `showMarker` | `bool` | `true` | read/write | `Md3ArcBandGauge` | Show Marker. |
| `size` | `real` | `140` | read/write | `Md3ArcBandGauge` | Control size token (see Enums). |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3ArcBandGauge` | Drop Shape geometry while page is off-display. |
| `progress` | `real` | `{…}` | readonly | `Md3ArcBandGauge` | Progress. |
| `valueText` | `string` | `Number(value).toFixed(decimals) + (unit.length ? unit : "")` | readonly | `Md3ArcBandGauge` | Value Text. |

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
    decimals: 0
}
```
