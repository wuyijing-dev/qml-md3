# Md3ItemsView

Unified items host with stack or grid layout strategy (WinUI ItemsView-lite).

- **Source:** `src/Md3/components/Md3ItemsView.qml`
- **Extends:** `Item`

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
| `layout` | `int` | `Md3ItemsView.Stack` | read/write | `Md3ItemsView` | — |
| `model` | `var` | `[]` | read/write | `Md3ItemsView` | — |
| `delegate` | `Component` | `null` | read/write | `Md3ItemsView` | — |
| `itemHeight` | `real` | `56` | read/write | `Md3ItemsView` | — |
| `cellWidth` | `real` | `140` | read/write | `Md3ItemsView` | — |
| `cellHeight` | `real` | `140` | read/write | `Md3ItemsView` | — |
| `spacing` | `real` | `8` | read/write | `Md3ItemsView` | — |
| `selectionMode` | `int` | `Md3ListView.Single` | read/write | `Md3ItemsView` | — |
| `selectedIndices` | `var` | `[]` | read/write | `Md3ItemsView` | — |
| `currentIndex` | `int` | `-1` | read/write | `Md3ItemsView` | — |
| `sectionRole` | `string` | `""` | read/write | `Md3ItemsView` | — |
| `emptyText` | `string` | `qsTr("No items")` | read/write | `Md3ItemsView` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `itemActivated(int index, var item)` | `Md3ItemsView` | — |
| `itemClicked(int index, var item)` | `Md3ItemsView` | — |
| `selectionChanged()` | `Md3ItemsView` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `clearSelection()` | `Md3ItemsView` | — |

## Example

```qml
import Md3

Md3ItemsView {
    layout: Md3ItemsView.Stack
    model: []
    delegate: null
    itemHeight: 56
    cellWidth: 140
}
```

## WinUI 对照

| WinUI | Md3 |
|-------|-----|
| ItemsView | `Md3ItemsView` |

`layout: Stack | Grid` 切换同一 `model`。Waterfall 未做。详见 [collections.md](../collections.md)。
