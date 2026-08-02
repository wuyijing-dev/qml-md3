# Md3SegmentedButton

- **Source:** `src/Md3/components/Md3SegmentedButton.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 6 | 1 | 2 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `model` | `var` | `[]` | read/write | `Md3SegmentedButton` | [{ text, icon?, enabled? }] |
| `currentIndex` | `int` | `0` | read/write | `Md3SegmentedButton` | Current index. |
| `multiSelect` | `bool` | `false` | read/write | `Md3SegmentedButton` | Multi Select. |
| `selectedIndices` | `var` | `[]` | read/write | `Md3SegmentedButton` | Multi-selection indices. |
| `segmentHeight` | `real` | `Md3Theme.controlHeight` | readonly | `Md3SegmentedButton` | Segment Height. |
| `outerRadius` | `real` | `segmentHeight / 2` | readonly | `Md3SegmentedButton` | Outer Radius. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `selectionChanged()` | `Md3SegmentedButton` | Emitted when selection Changed. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `isSelected(index)` | `—` | `Md3SegmentedButton` | Is Selected. |
| `toggle(index)` | `—` | `Md3SegmentedButton` | Toggle open / checked state. |

## Example

```qml
import Md3

Md3SegmentedButton {
    model: []
    currentIndex: 0
    multiSelect: false
    selectedIndices: []
}
```
