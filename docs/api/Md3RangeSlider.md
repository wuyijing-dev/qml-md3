# Md3RangeSlider

- **Source:** `src/Md3/components/Md3RangeSlider.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `from` | `real` | `0` | read/write | `Md3RangeSlider` | — |
| `to` | `real` | `1` | read/write | `Md3RangeSlider` | — |
| `firstValue` | `real` | `0.2` | read/write | `Md3RangeSlider` | — |
| `secondValue` | `real` | `0.8` | read/write | `Md3RangeSlider` | — |
| `stepSize` | `real` | `0` | read/write | `Md3RangeSlider` | — |
| `label` | `string` | `""` | read/write | `Md3RangeSlider` | Header label |
| `showValue` | `bool` | `false` | read/write | `Md3RangeSlider` | Show `first – second` |
| `valueDecimals` | `int` | `0` | read/write | `Md3RangeSlider` | — |
| `trackHeight` | `real` | `16` | read/write | `Md3RangeSlider` | — |
| `handleWidth` | `real` | `4` | read/write | `Md3RangeSlider` | Slim handle thickness along the track |
| `handleHeight` | `real` | `trackHeight + 16` | read/write | `Md3RangeSlider` | Handle length across track — taller than track thickness |
| `accessibleName` | `string` | `"Range slider"` | read/write | `Md3RangeSlider` | — |
| `span` | `real` | `Math.max(0.0001, to - from)` | readonly | `Md3RangeSlider` | — |
| `activeColor` | `color` | `enabled ? Md3Theme.colorScheme.primary` | readonly | `Md3RangeSlider` | — |
| `inactiveColor` | `color` | `enabled ? Md3Theme.colorScheme.secondaryContainer` | readonly | `Md3RangeSlider` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `rangeChanged(real first, real second)` | `Md3RangeSlider` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `snap(v)` | `Md3RangeSlider` | — |
| `setFirst(v)` | `Md3RangeSlider` | — |
| `setSecond(v)` | `Md3RangeSlider` | — |
| `xFor(v)` | `Md3RangeSlider` | — |
| `valueFor(px)` | `Md3RangeSlider` | — |

## Example

```qml
import Md3

Md3RangeSlider {
    label: qsTr("Price range")
    showValue: true
    from: 0
    to: 100
    firstValue: 20
    secondValue: 70
}
```
