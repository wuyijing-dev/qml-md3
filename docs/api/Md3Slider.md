# Md3Slider

- **Source:** `src/Md3/components/Md3Slider.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 23 | 1 | 3 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `from` | `real` | `0` | read/write | `Md3Slider` | Range lower bound. |
| `to` | `real` | `1` | read/write | `Md3Slider` | Range upper bound. |
| `value` | `real` | `0.5` | read/write | `Md3Slider` | Current value. |
| `stepSize` | `real` | `0` | read/write | `Md3Slider` | Step Size. |
| `showLabel` | `bool` | `false` | read/write | `Md3Slider` | Show Label. |
| `label` | `string` | `""` | read/write | `Md3Slider` | Field label above the track (replaces Column { Text; Slider } glue). |
| `leadingIcon` | `string` | `""` | read/write | `Md3Slider` | Material icon left of `label` (Android volume-row pattern). |
| `showValue` | `bool` | `false` | read/write | `Md3Slider` | Show current value to the right of `label`. |
| `valueDecimals` | `int` | `2` | read/write | `Md3Slider` | Value Decimals. |
| `trackHeight` | `real` | `16` | read/write | `Md3Slider` | Thick capsule height (MD3 expressive ~16–20) |
| `handleWidth` | `real` | `4` | read/write | `Md3Slider` | Handle thickness (along track). Keep slim. |
| `handleHeight` | `real` | `trackHeight + 16` | read/write | `Md3Slider` | Handle length across track — must exceed trackHeight so thumb reads larger than the bar. |
| `segmentGap` | `real` | `6` | read/write | `Md3Slider` | Segment Gap. |
| `showStopIndicator` | `bool` | `true` | read/write | `Md3Slider` | Show end stop on continuous sliders (small terminal dot) |
| `discrete` | `bool` | `stepSize > 0` | read/write | `Md3Slider` | Force tick dots; default = stepSize > 0 |
| `maxTickCount` | `int` | `24` | read/write | `Md3Slider` | Max Tick Count. |
| `accessibleName` | `string` | `label.length ? label : qsTr("Slider")` | read/write | `Md3Slider` | Accessible name override. |
| `progress` | `real` | `Math.max(0, Math.min(1, (value - from) / Math.max(0.0001, to - from)))` | readonly | `Md3Slider` | Progress. |
| `activeColor` | `color` | `enabled ? Md3Theme.colorScheme.primary` | readonly | `Md3Slider` | Active Color. |
| `inactiveColor` | `color` | `enabled ? Md3Theme.colorScheme.secondaryContainer` | readonly | `Md3Slider` | Inactive Color. |
| `tickOnActive` | `color` | `Md3Theme.colorScheme.colorOnPrimary` | readonly | `Md3Slider` | Tick On Active. |
| `tickOnInactive` | `color` | `Md3Theme.colorScheme.primary` | readonly | `Md3Slider` | Tick On Inactive. |
| `tickCount` | `int` | `{…}` | readonly | `Md3Slider` | Tick Count. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `moved(real value)` | `Md3Slider` | Emitted when moved. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `setValue(v)` | `—` | `Md3Slider` | Set Value. |
| `nudge(dir)` | `—` | `Md3Slider` | Nudge. |
| `valueAt(px)` | `—` | `Md3Slider` | Value At. |

## Example

```qml
import Md3

Md3Slider {
    from: 0
    to: 1
    value: 0.5
    stepSize: 0
    showLabel: false
    label: ""
}
```
