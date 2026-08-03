# Md3VirtualList

Thin virtualized list wrapper for large models with jump/scroll helpers. Prefer Md3ListView when you need section headers or multi-select; this type remains the lightweight ItemsRepeater-style primitive.

- **Source:** `src/Md3/components/Md3VirtualList.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 14 | 2 | 2 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `model` | `var` | `[]` | read/write | `Md3VirtualList` | Data model. |
| `delegate` | `Component` | `null` | read/write | `Md3VirtualList` | Delegate. |
| `itemHeight` | `real` | `Md3Theme.tableRowHeight` | read/write | `Md3VirtualList` | Item Height. |
| `clipContent` | `bool` | `true` | read/write | `Md3VirtualList` | Clip Content. |
| `cacheBufferPx` | `int` | `800` | read/write | `Md3VirtualList` | Cache Buffer Px. |
| `currentIndex` | `int` | `-1` | read/write | `Md3VirtualList` | Current index. |
| `interactive` | `bool` | `true` | read/write | `Md3VirtualList` | Gate activation without forcing `enabled: false`. |
| `emptyText` | `string` | `qsTr("No items")` | read/write | `Md3VirtualList` | Empty Text. |
| `accessibleName` | `string` | `""` | read/write | `Md3VirtualList` | Screen-reader label (defaults to “Virtual list”). |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3VirtualList` | Drop ListView delegates while page is off-display (shell size stays). |
| `preferredMaxHeight` | `real` | `0` | read/write | `Md3VirtualList` | Preferred Max Height. |
| `preferredHeightFraction` | `real` | `0` | read/write | `Md3VirtualList` | Preferred Height Fraction. |
| `preferredMinHeight` | `real` | `120` | read/write | `Md3VirtualList` | Preferred Min Height. |
| `fillAvailableHeight` | `bool` | `false` | read/write | `Md3VirtualList` | Fill Available Height. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `itemActivated(int index, var item)` | `Md3VirtualList` | Emitted when item Activated. |
| `currentIndexChangedByUser(int index, var item)` | `Md3VirtualList` | Emitted when current Index Changed By User. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `scrollToIndex(index)` | `—` | `Md3VirtualList` | Scroll To Index. |
| `revealIndex(index)` | `—` | `Md3VirtualList` | Reveal Index. |

## Example

```qml
import Md3

Md3VirtualList {
    model: []
    delegate: null
    itemHeight: Md3Theme.tableRowHeight
    clipContent: true
    cacheBufferPx: 800
    currentIndex: -1
}
```
