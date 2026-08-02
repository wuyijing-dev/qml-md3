# Md3CompassGauge

Compass-style circular dial with heading needle (0–360°).

- **Source:** `src/Md3/components/Md3CompassGauge.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `value` | `real` | `0` | read/write | `Md3CompassGauge` | — |
| `from` | `real` | `0` | read/write | `Md3CompassGauge` | — |
| `to` | `real` | `360` | read/write | `Md3CompassGauge` | — |
| `label` | `string` | `""` | read/write | `Md3CompassGauge` | — |
| `unit` | `string` | `"°"` | read/write | `Md3CompassGauge` | — |
| `decimals` | `int` | `0` | read/write | `Md3CompassGauge` | — |
| `trackColor` | `color` | `Md3Theme.colorScheme.gaugeTrack` | read/write | `Md3CompassGauge` | — |
| `dialColor` | `color` | `Md3Theme.colorScheme.gaugeDial` | read/write | `Md3CompassGauge` | — |
| `valueColor` | `color` | `Md3Theme.colorScheme.error` | read/write | `Md3CompassGauge` | — |
| `tickColor` | `color` | `Md3Theme.colorScheme.colorOnSurfaceVariant` | read/write | `Md3CompassGauge` | — |
| `showCardinals` | `bool` | `true` | read/write | `Md3CompassGauge` | — |
| `showValue` | `bool` | `true` | read/write | `Md3CompassGauge` | — |
| `size` | `real` | `140` | read/write | `Md3CompassGauge` | — |
| `progress` | `real` | `{…}` | readonly | `Md3CompassGauge` | — |
| `valueText` | `string` | `Number(value).toFixed(decimals) + (unit.length ? unit : "")` | readonly | `Md3CompassGauge` | — |
| `hostWindow` | `var` | `null` | read/write | `Md3CompassGauge` | — |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3CompassGauge` | — |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3CompassGauge {
    value: 0
    from: 0
    to: 360
    label: ""
    unit: "°"
}
```
