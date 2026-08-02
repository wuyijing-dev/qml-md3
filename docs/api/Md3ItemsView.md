# Md3ItemsView

Unified items host with stack or grid layout strategy (WinUI ItemsView-lite).

- **Source:** `src/Md3/components/Md3ItemsView.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 13 | 3 | 1 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Enums

### `Md3ItemsView.Layout`

`Md3ItemsView.Stack`, `Md3ItemsView.Grid`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `layout` | `int (Md3ItemsView.Layout)` | `Md3ItemsView.Stack` | read/write | `Md3ItemsView` | Layout. |
| `model` | `var` | `[]` | read/write | `Md3ItemsView` | Data model. |
| `delegate` | `Component` | `null` | read/write | `Md3ItemsView` | Delegate. |
| `itemHeight` | `real` | `56` | read/write | `Md3ItemsView` | Item Height. |
| `cellWidth` | `real` | `140` | read/write | `Md3ItemsView` | Cell Width. |
| `cellHeight` | `real` | `140` | read/write | `Md3ItemsView` | Cell Height. |
| `spacing` | `real` | `8` | read/write | `Md3ItemsView` | Child spacing. |
| `selectionMode` | `int` | `Md3ListView.Single` | read/write | `Md3ItemsView` | Selection Mode. |
| `selectedIndices` | `var` | `[]` | read/write | `Md3ItemsView` | Multi-selection indices. |
| `currentIndex` | `int` | `-1` | read/write | `Md3ItemsView` | Current index. |
| `sectionRole` | `string` | `""` | read/write | `Md3ItemsView` | Section Role. |
| `emptyText` | `string` | `qsTr("No items")` | read/write | `Md3ItemsView` | Empty Text. |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3ItemsView` | Drop Stack/Grid hosts while page is off-display (shell size stays). |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `itemActivated(int index, var item)` | `Md3ItemsView` | Emitted when item Activated. |
| `itemClicked(int index, var item)` | `Md3ItemsView` | Emitted when item Clicked. |
| `selectionChanged()` | `Md3ItemsView` | Emitted when selection Changed. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `clearSelection()` | `—` | `Md3ItemsView` | Clear Selection. |

## Example

```qml
import Md3

Md3ItemsView {
    layout: Md3ItemsView.Stack
    model: []
    delegate: null
    itemHeight: 56
    cellWidth: 140
    cellHeight: 140
}
```

## WinUI 对照

| WinUI | Md3 |
|-------|-----|
| ItemsView | `Md3ItemsView` |

`layout: Stack | Grid` 切换同一 `model`。Waterfall 未做。详见 [collections.md](../guides/collections.md)。
