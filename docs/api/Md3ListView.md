# Md3ListView

WinUI-style list: virtualization, section headers, single/multi selection.

- **Source:** `src/Md3/components/Md3ListView.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 16 | 4 | 5 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Enums

### `Md3ListView.SelectionMode`

`Md3ListView.None`, `Md3ListView.Single`, `Md3ListView.Multiple`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `model` | `var` | `[]` | read/write | `Md3ListView` | JS array / QVariantList, `ListModel`, or `QAbstractListModel` (roles via delegate `model`). |
| `delegate` | `Component` | `null` | read/write | `Md3ListView` | Delegate. |
| `itemHeight` | `real` | `56` | read/write | `Md3ListView` | Item Height. |
| `sectionHeight` | `real` | `32` | read/write | `Md3ListView` | Section Height. |
| `sectionRole` | `string` | `""` | read/write | `Md3ListView` | Model object key for ListView.section (e.g. "group"). |
| `selectionMode` | `int (Md3ListView.SelectionMode)` | `Md3ListView.Single` | read/write | `Md3ListView` | Selection Mode. |
| `selectedIndices` | `var` | `[]` | read/write | `Md3ListView` | Multi-selection indices. |
| `currentIndex` | `int` | `-1` | read/write | `Md3ListView` | Current index. |
| `clipContent` | `bool` | `true` | read/write | `Md3ListView` | Clip Content. |
| `cacheBufferPx` | `int` | `800` | read/write | `Md3ListView` | Cache Buffer Px. |
| `interactive` | `bool` | `true` | read/write | `Md3ListView` | Gate activation without forcing `enabled: false`. |
| `emptyText` | `string` | `qsTr("No items")` | read/write | `Md3ListView` | Empty Text. |
| `emptyIcon` | `string` | `"inbox"` | read/write | `Md3ListView` | Empty-state icon name. |
| `accessibleName` | `string` | `""` | read/write | `Md3ListView` | Screen-reader / AT name (defaults to “List”; do not reuse emptyText). |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3ListView` | Drop ListView delegates while page is off-display (shell size stays). |
| `hasSections` | `bool` | `sectionRole.length > 0` | readonly | `Md3ListView` | Has Sections. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `itemActivated(int index, var item)` | `Md3ListView` | Emitted when item Activated. |
| `itemClicked(int index, var item)` | `Md3ListView` | Emitted when item Clicked. |
| `selectionChanged()` | `Md3ListView` | Emitted when selection Changed. |
| `currentIndexChangedByUser(int index, var item)` | `Md3ListView` | Emitted when current Index Changed By User. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `scrollToIndex(index)` | `—` | `Md3ListView` | Scroll To Index. |
| `clearSelection()` | `—` | `Md3ListView` | Clear Selection. |
| `selectAll()` | `—` | `Md3ListView` | Select All. |
| `isSelected(index)` | `—` | `Md3ListView` | Is Selected. |
| `toggleSelection(index)` | `—` | `Md3ListView` | Toggle Selection. |

## Example

```qml
import Md3

Md3ListView {
    model: []
    delegate: null
    itemHeight: 56
    sectionHeight: 32
    sectionRole: ""
    selectionMode: Md3ListView.Single
}
```

## WinUI 对照

| WinUI | Md3 |
|-------|-----|
| ListView | `Md3ListView` |
| ItemsRepeater（轻量） | `Md3VirtualList` |

## 要点

- `sectionRole`：模型字段名，生成分组头
- `selectionMode`：`None` / `Single` / `Multiple`
- Ctrl/Shift 点击、Ctrl+A、Space

详见 [collections.md](../guides/collections.md)。
