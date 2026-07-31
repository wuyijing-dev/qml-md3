# Md3Slider

- **Source:** `src/Md3/components/Md3Slider.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `from` | `real` | `0` | read/write | `Md3Slider` | — |
| `to` | `real` | `1` | read/write | `Md3Slider` | — |
| `value` | `real` | `0.5` | read/write | `Md3Slider` | — |
| `stepSize` | `real` | `0` | read/write | `Md3Slider` | — |
| `showLabel` | `bool` | `false` | read/write | `Md3Slider` | — |
| `label` | `string` | `""` | read/write | `Md3Slider` | Field label above the track (replaces Column { Text; Slider } glue). |
| `leadingIcon` | `string` | `""` | read/write | `Md3Slider` | Material icon left of `label` (Android volume-row pattern). |
| `showValue` | `bool` | `false` | read/write | `Md3Slider` | Show current value to the right of `label`. |
| `valueDecimals` | `int` | `2` | read/write | `Md3Slider` | — |
| `trackHeight` | `real` | `16` | read/write | `Md3Slider` | Thick capsule height (MD3 expressive ~16–20) |
| `handleWidth` | `real` | `4` | read/write | `Md3Slider` | Handle thickness (along track). Keep slim. |
| `handleHeight` | `real` | `trackHeight + 16` | read/write | `Md3Slider` | Handle length across track — must exceed trackHeight so thumb reads larger than the bar. |
| `segmentGap` | `real` | `6` | read/write | `Md3Slider` | — |
| `showStopIndicator` | `bool` | `true` | read/write | `Md3Slider` | Show end stop on continuous sliders (small terminal dot) |
| `discrete` | `bool` | `stepSize > 0` | read/write | `Md3Slider` | Force tick dots; default = stepSize > 0 |
| `maxTickCount` | `int` | `24` | read/write | `Md3Slider` | — |
| `accessibleName` | `string` | `label.length ? label : qsTr("Slider")` | read/write | `Md3Slider` | — |
| `progress` | `real` | `Math.max(0, Math.min(1, (value - from) / Math.max(0.0001, to - from)))` | readonly | `Md3Slider` | — |
| `activeColor` | `color` | `enabled ? Md3Theme.colorScheme.primary` | readonly | `Md3Slider` | — |
| `inactiveColor` | `color` | `enabled ? Md3Theme.colorScheme.secondaryContainer` | readonly | `Md3Slider` | — |
| `tickOnActive` | `color` | `Md3Theme.colorScheme.colorOnPrimary` | readonly | `Md3Slider` | — |
| `tickOnInactive` | `color` | `Md3Theme.colorScheme.primary` | readonly | `Md3Slider` | — |
| `tickCount` | `int` | `{…}` | readonly | `Md3Slider` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `moved(real value)` | `Md3Slider` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `setValue(v)` | `Md3Slider` | — |
| `nudge(dir)` | `Md3Slider` | — |
| `valueAt(px)` | `Md3Slider` | — |

## Example

```qml
import Md3

Md3Slider {
    from: 0
    to: 1
    value: 0.5
    stepSize: 0
    showLabel: false
}
```
