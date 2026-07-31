# Md3GridView

Data-driven virtualized grid with selection (WinUI GridView).

- **Source:** `src/Md3/components/Md3GridView.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Enums

### `Md3GridView.SelectionMode`

`Md3GridView.None`, `Md3GridView.Single`, `Md3GridView.Multiple`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `model` | `var` | `[]` | read/write | `Md3GridView` | — |
| `delegate` | `Component` | `null` | read/write | `Md3GridView` | — |
| `cellWidth` | `real` | `140` | read/write | `Md3GridView` | — |
| `cellHeight` | `real` | `140` | read/write | `Md3GridView` | — |
| `spacing` | `real` | `12` | read/write | `Md3GridView` | — |
| `selectionMode` | `int` | `Md3GridView.Single` | read/write | `Md3GridView` | — |
| `selectedIndices` | `var` | `[]` | read/write | `Md3GridView` | — |
| `currentIndex` | `int` | `-1` | read/write | `Md3GridView` | — |
| `clipContent` | `bool` | `true` | read/write | `Md3GridView` | — |
| `cacheBufferPx` | `int` | `800` | read/write | `Md3GridView` | — |
| `emptyText` | `string` | `qsTr("No items")` | read/write | `Md3GridView` | — |
| `emptyIcon` | `string` | `"grid_view"` | read/write | `Md3GridView` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `itemActivated(int index, var item)` | `Md3GridView` | — |
| `itemClicked(int index, var item)` | `Md3GridView` | — |
| `selectionChanged()` | `Md3GridView` | — |
| `currentIndexChangedByUser(int index, var item)` | `Md3GridView` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `clearSelection()` | `Md3GridView` | — |
| `isSelected(index)` | `Md3GridView` | — |
| `toggleSelection(index)` | `Md3GridView` | — |

## Example

```qml
import Md3

Md3GridView {
    model: []
    delegate: null
    cellWidth: 140
    cellHeight: 140
    spacing: 12
}
```

## WinUI 对照

| WinUI | Md3 |
|-------|-----|
| GridView | `Md3GridView` |

虚拟化 `GridView` + `selectionMode` / `selectedIndices`。详见 [collections.md](../guides/collections.md)。
