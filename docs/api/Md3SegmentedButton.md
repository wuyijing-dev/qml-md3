# Md3SegmentedButton

- **Source:** `src/Md3/components/Md3SegmentedButton.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `model` | `var` | `[] // [{ text, icon?, enabled? }]` | read/write | `Md3SegmentedButton` | — |
| `currentIndex` | `int` | `0` | read/write | `Md3SegmentedButton` | — |
| `multiSelect` | `bool` | `false` | read/write | `Md3SegmentedButton` | — |
| `selectedIndices` | `var` | `[]` | read/write | `Md3SegmentedButton` | — |
| `enabled` | `bool` | `true` | read/write | `Md3SegmentedButton` | — |
| `segmentHeight` | `real` | `40` | readonly | `Md3SegmentedButton` | — |
| `outerRadius` | `real` | `segmentHeight / 2` | readonly | `Md3SegmentedButton` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `selectionChanged()` | `Md3SegmentedButton` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `isSelected(index)` | `Md3SegmentedButton` | — |
| `toggle(index)` | `Md3SegmentedButton` | — |

## Example

```qml
import Md3

Md3SegmentedButton {
    model: [] // [{ text, icon?, enabled? }]
    currentIndex: 0
    multiSelect: false
    selectedIndices: []
}
```
