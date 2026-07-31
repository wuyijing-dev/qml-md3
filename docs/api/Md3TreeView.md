# Md3TreeView

Hierarchical tree: `{ title, icon?, children?, expanded?, checked?, data? }`.

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
| `checkEnabled` | `bool` | `false` | read/write | `Md3TreeView` | — |
| `triStateCheck` | `bool` | `true` | read/write | `Md3TreeView` | — |
| `filterText` | `string` | `""` | read/write | `Md3TreeView` | — |
| `showFilter` | `bool` | `false` | read/write | `Md3TreeView` | Built-in filter field (no external TextField sync glue). |
| `filterPlaceholder` | `string` | `qsTr("Filter")` | read/write | `Md3TreeView` | — |
| `filterLabel` | `string` | `qsTr("Filter")` | read/write | `Md3TreeView` | — |
| `showExpandControls` | `bool` | `false` | read/write | `Md3TreeView` | Expand all / Collapse all buttons beside the filter. |
| `lazyLoad` | `bool` | `false` | read/write | `Md3TreeView` | — |
| `contextMenu` | `var` | `null` | read/write | `Md3TreeView` | — |
| `overlayWindow` | `var` | `null` | read/write | `Md3TreeView` | Optional explicit Window for context-menu overlay coords. |
| `flatRows` | `var` | `{…}` | readonly | `Md3TreeView` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `activated(int flatIndex, var node)` | `Md3TreeView` | — |
| `expandedChanged(int flatIndex, var node, bool expanded)` | `Md3TreeView` | — |
| `checkedChanged()` | `Md3TreeView` | — |
| `fetchChildren(var node, var path)` | `Md3TreeView` | — |
| `contextMenuRequested(int flatIndex, var node, real globalX, real globalY)` | `Md3TreeView` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `isChecked(path)` | `Md3TreeView` | — |
| `checkStateAt(path)` | `Md3TreeView` | — |
| `setChecked(path, on)` | `Md3TreeView` | — |
| `setCheckState(path, state)` | `Md3TreeView` | — |
| `toggleCheckAt(flatIndex)` | `Md3TreeView` | — |
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
