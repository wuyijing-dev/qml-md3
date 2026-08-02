# Md3RangeSlider

- **Source:** `src/Md3/components/Md3RangeSlider.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 15 | 1 | 5 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `from` | `real` | `0` | read/write | `Md3RangeSlider` | Range lower bound. |
| `to` | `real` | `1` | read/write | `Md3RangeSlider` | Range upper bound. |
| `firstValue` | `real` | `0.2` | read/write | `Md3RangeSlider` | First Value. |
| `secondValue` | `real` | `0.8` | read/write | `Md3RangeSlider` | Second Value. |
| `stepSize` | `real` | `0` | read/write | `Md3RangeSlider` | Step Size. |
| `label` | `string` | `""` | read/write | `Md3RangeSlider` | Field label above the track (peer of Md3Slider.label). |
| `showValue` | `bool` | `false` | read/write | `Md3RangeSlider` | Show "first – second" to the right of `label`. |
| `valueDecimals` | `int` | `0` | read/write | `Md3RangeSlider` | Value Decimals. |
| `trackHeight` | `real` | `16` | read/write | `Md3RangeSlider` | Track Height. |
| `handleWidth` | `real` | `4` | read/write | `Md3RangeSlider` | Slim handle thickness along the track |
| `handleHeight` | `real` | `trackHeight + 16` | read/write | `Md3RangeSlider` | Handle length across track — taller than track thickness |
| `accessibleName` | `string` | `label.length ? label : qsTr("Range slider")` | read/write | `Md3RangeSlider` | Accessible name override. |
| `span` | `real` | `Math.max(0.0001, to - from)` | readonly | `Md3RangeSlider` | Span. |
| `activeColor` | `color` | `enabled ? Md3Theme.colorScheme.primary` | readonly | `Md3RangeSlider` | Active Color. |
| `inactiveColor` | `color` | `enabled ? Md3Theme.colorScheme.secondaryContainer` | readonly | `Md3RangeSlider` | Inactive Color. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `rangeChanged(real first, real second)` | `Md3RangeSlider` | Emitted when range Changed. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `snap(v)` | `—` | `Md3RangeSlider` | Snap. |
| `setFirst(v)` | `—` | `Md3RangeSlider` | Set First. |
| `setSecond(v)` | `—` | `Md3RangeSlider` | Set Second. |
| `xFor(v)` | `—` | `Md3RangeSlider` | X For. |
| `valueFor(px)` | `—` | `Md3RangeSlider` | Value For. |

## Example

```qml
import Md3

Md3RangeSlider {
    from: 0
    to: 1
    firstValue: 0.2
    secondValue: 0.8
    stepSize: 0
    label: ""
}
```
