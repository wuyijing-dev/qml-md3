# Md3TreeView

Hierarchical tree: model nodes `{ title, icon?, children?, expanded?, data? }`.

- **Source:** `src/Md3/components/Md3TreeView.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `model` | `var` | `[]` | read/write | `Md3TreeView` | — |
| `selectedIndex` | `int` | `-1` | read/write | `Md3TreeView` | — |
| `rowHeight` | `real` | `40` | read/write | `Md3TreeView` | — |
| `indent` | `real` | `20` | read/write | `Md3TreeView` | — |
| `showConnectors` | `bool` | `false` | read/write | `Md3TreeView` | — |
| `flatRows` | `var` | `{…}` | readonly | `Md3TreeView` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `activated(int flatIndex, var node)` | `Md3TreeView` | — |
| `expandedChanged(int flatIndex, var node, bool expanded)` | `Md3TreeView` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `toggleAt(flatIndex)` | `Md3TreeView` | — |
| `expandAll()` | `Md3TreeView` | — |
| `collapseAll()` | `Md3TreeView` | — |

## Example

```qml
import Md3

Md3TreeView {
    model: []
    selectedIndex: -1
    rowHeight: 40
    indent: 20
    showConnectors: false
}
```
