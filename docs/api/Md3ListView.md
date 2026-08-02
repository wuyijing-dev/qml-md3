# Md3ListView

WinUI-style list: virtualization, section headers, single/multi selection.

- **Source:** `src/Md3/components/Md3ListView.qml`
- **Extends:** `Item`

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
| `model` | `var` | `[]` | read/write | `Md3ListView` | — |
| `delegate` | `Component` | `null` | read/write | `Md3ListView` | — |
| `itemHeight` | `real` | `56` | read/write | `Md3ListView` | — |
| `sectionHeight` | `real` | `32` | read/write | `Md3ListView` | — |
| `sectionRole` | `string` | `""` | read/write | `Md3ListView` | Model object key for ListView.section (e.g. "group"). |
| `selectionMode` | `int` | `Md3ListView.Single` | read/write | `Md3ListView` | — |
| `selectedIndices` | `var` | `[]` | read/write | `Md3ListView` | — |
| `currentIndex` | `int` | `-1` | read/write | `Md3ListView` | — |
| `clipContent` | `bool` | `true` | read/write | `Md3ListView` | — |
| `cacheBufferPx` | `int` | `800` | read/write | `Md3ListView` | — |
| `interactive` | `bool` | `true` | read/write | `Md3ListView` | — |
| `emptyText` | `string` | `qsTr("No items")` | read/write | `Md3ListView` | — |
| `emptyIcon` | `string` | `"inbox"` | read/write | `Md3ListView` | — |
| `accessibleName` | `string` | `""` | read/write | `Md3ListView` | Screen-reader / AT name (defaults to “List”; do not reuse emptyText). |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3ListView` | Drop ListView delegates while page is off-display (shell size stays). |
| `hasSections` | `bool` | `sectionRole.length > 0` | readonly | `Md3ListView` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `itemActivated(int index, var item)` | `Md3ListView` | — |
| `itemClicked(int index, var item)` | `Md3ListView` | — |
| `selectionChanged()` | `Md3ListView` | — |
| `currentIndexChangedByUser(int index, var item)` | `Md3ListView` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `scrollToIndex(index)` | `Md3ListView` | — |
| `clearSelection()` | `Md3ListView` | — |
| `selectAll()` | `Md3ListView` | — |
| `isSelected(index)` | `Md3ListView` | — |
| `toggleSelection(index)` | `Md3ListView` | — |

## Example

```qml
import Md3

Md3ListView {
    model: []
    delegate: null
    itemHeight: 56
    sectionHeight: 32
    sectionRole: ""
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
