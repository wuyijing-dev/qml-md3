# Md3ChipGroup

- **Source:** `src/Md3/components/Md3ChipGroup.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 10 | 2 | 2 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Enums

### `Md3ChipGroup.SelectionMode`

`Md3ChipGroup.Single`, `Md3ChipGroup.Multiple`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `model` | `var` | `[]` | read/write | `Md3ChipGroup` | Object rows `[{ text, icon?, enabled?, selected? }]`, or a string list / QStringList (each entry becomes `{ text: String(entry) }`). |
| `selectionMode` | `int (Md3ChipGroup.SelectionMode)` | `Md3ChipGroup.Single` | read/write | `Md3ChipGroup` | Selection Mode. |
| `currentIndex` | `int` | `-1` | read/write | `Md3ChipGroup` | Current index. |
| `selectedIndices` | `var` | `[]` | read/write | `Md3ChipGroup` | Multi-selection indices. |
| `spacing` | `real` | `8` | read/write | `Md3ChipGroup` | Child spacing. |
| `elevated` | `bool` | `false` | read/write | `Md3ChipGroup` | Elevated. |
| `chipHeight` | `real` | `32` | read/write | `Md3ChipGroup` | Chip Height. |
| `iconSize` | `real` | `18` | read/write | `Md3ChipGroup` | Icon Size. |
| `fontSize` | `real` | `Md3Theme.scaled(Md3Theme.typography.labelLarge.size)` | read/write | `Md3ChipGroup` | Font Size. |
| `normalizedModel` | `var` | `{…}` | readonly | `Md3ChipGroup` | Normalize `model` so Repeater always sees `{ text, … }` objects. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `clicked(int index)` | `Md3ChipGroup` | Emitted when clicked. |
| `selectionChanged()` | `Md3ChipGroup` | Emitted when selection Changed. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `isSelected(index)` | `—` | `Md3ChipGroup` | Is Selected. |
| `select(index)` | `—` | `Md3ChipGroup` | Select. |

## Example

```qml
import Md3

Md3ChipGroup {
    model: []
    selectionMode: Md3ChipGroup.Single
    currentIndex: -1
    selectedIndices: []
    spacing: 8
    elevated: false
}
```
