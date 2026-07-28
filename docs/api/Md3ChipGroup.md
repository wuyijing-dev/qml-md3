# Md3ChipGroup

- **Source:** `src/Md3/components/Md3ChipGroup.qml`
- **Extends:** `Item`

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
| `model` | `var` | `[]` | read/write | `Md3ChipGroup` | — |
| `selectionMode` | `int` | `Md3ChipGroup.Single` | read/write | `Md3ChipGroup` | — |
| `currentIndex` | `int` | `-1` | read/write | `Md3ChipGroup` | — |
| `selectedIndices` | `var` | `[]` | read/write | `Md3ChipGroup` | — |
| `spacing` | `real` | `8` | read/write | `Md3ChipGroup` | — |
| `elevated` | `bool` | `false` | read/write | `Md3ChipGroup` | — |
| `enabled` | `bool` | `true` | read/write | `Md3ChipGroup` | — |
| `chipHeight` | `real` | `32` | read/write | `Md3ChipGroup` | — |
| `iconSize` | `real` | `18` | read/write | `Md3ChipGroup` | — |
| `fontSize` | `real` | `Md3Theme.scaled(Md3Theme.typography.labelLarge.size)` | read/write | `Md3ChipGroup` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `clicked(int index)` | `Md3ChipGroup` | — |
| `selectionChanged()` | `Md3ChipGroup` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `isSelected(index)` | `Md3ChipGroup` | — |
| `select(index)` | `Md3ChipGroup` | — |

## Example

```qml
import Md3

Md3ChipGroup {
    model: []
    selectionMode: Md3ChipGroup.Single
    currentIndex: -1
    selectedIndices: []
    spacing: 8
}
```
