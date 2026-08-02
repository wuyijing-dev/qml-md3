# Md3GridView

Data-driven virtualized grid with selection (WinUI GridView).

- **Source:** `src/Md3/components/Md3GridView.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 13 | 4 | 3 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

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
| `model` | `var` | `[]` | read/write | `Md3GridView` | Data model. |
| `delegate` | `Component` | `null` | read/write | `Md3GridView` | Delegate. |
| `cellWidth` | `real` | `140` | read/write | `Md3GridView` | Cell Width. |
| `cellHeight` | `real` | `140` | read/write | `Md3GridView` | Cell Height. |
| `spacing` | `real` | `12` | read/write | `Md3GridView` | Child spacing. |
| `selectionMode` | `int (Md3GridView.SelectionMode)` | `Md3GridView.Single` | read/write | `Md3GridView` | Selection Mode. |
| `selectedIndices` | `var` | `[]` | read/write | `Md3GridView` | Multi-selection indices. |
| `currentIndex` | `int` | `-1` | read/write | `Md3GridView` | Current index. |
| `clipContent` | `bool` | `true` | read/write | `Md3GridView` | Clip Content. |
| `cacheBufferPx` | `int` | `800` | read/write | `Md3GridView` | Cache Buffer Px. |
| `emptyText` | `string` | `qsTr("No items")` | read/write | `Md3GridView` | Empty Text. |
| `emptyIcon` | `string` | `"grid_view"` | read/write | `Md3GridView` | Empty-state icon name. |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3GridView` | Drop GridView delegates while page is off-display (shell size stays). |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `itemActivated(int index, var item)` | `Md3GridView` | Emitted when item Activated. |
| `itemClicked(int index, var item)` | `Md3GridView` | Emitted when item Clicked. |
| `selectionChanged()` | `Md3GridView` | Emitted when selection Changed. |
| `currentIndexChangedByUser(int index, var item)` | `Md3GridView` | Emitted when current Index Changed By User. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `clearSelection()` | `—` | `Md3GridView` | Clear Selection. |
| `isSelected(index)` | `—` | `Md3GridView` | Is Selected. |
| `toggleSelection(index)` | `—` | `Md3GridView` | Toggle Selection. |

## Example

```qml
import Md3

Md3GridView {
    model: []
    delegate: null
    cellWidth: 140
    cellHeight: 140
    spacing: 12
    selectionMode: Md3GridView.Single
}
```

## WinUI 对照

| WinUI | Md3 |
|-------|-----|
| GridView | `Md3GridView` |

虚拟化 `GridView` + `selectionMode` / `selectedIndices`。详见 [collections.md](../guides/collections.md)。
