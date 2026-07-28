# Md3VirtualList

Thin virtualized list wrapper for large models with jump/scroll helpers.

- **Source:** `src/Md3/components/Md3VirtualList.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `model` | `var` | `[]` | read/write | `Md3VirtualList` | — |
| `delegate` | `Component` | `null` | read/write | `Md3VirtualList` | — |
| `itemHeight` | `real` | `40` | read/write | `Md3VirtualList` | — |
| `clipContent` | `bool` | `true` | read/write | `Md3VirtualList` | — |
| `cacheBufferPx` | `int` | `800` | read/write | `Md3VirtualList` | — |
| `currentIndex` | `int` | `-1` | read/write | `Md3VirtualList` | — |
| `interactive` | `bool` | `true` | read/write | `Md3VirtualList` | — |
| `emptyText` | `string` | `qsTr("No items")` | read/write | `Md3VirtualList` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `itemActivated(int index, var item)` | `Md3VirtualList` | — |
| `currentIndexChangedByUser(int index, var item)` | `Md3VirtualList` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `scrollToIndex(index)` | `Md3VirtualList` | — |
| `revealIndex(index)` | `Md3VirtualList` | — |

## Example

```qml
import Md3

Md3VirtualList {
    model: []
    delegate: null
    itemHeight: 40
    clipContent: true
    cacheBufferPx: 800
}
```
