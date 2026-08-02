# Md3TreeView

Hierarchical tree: `{ title, icon?, children?, expanded?, checked?, data? }`.

- **Source:** `src/Md3/components/Md3TreeView.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 18 | 5 | 8 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `model` | `var` | `[]` | read/write | `Md3TreeView` | Data model. |
| `selectedIndex` | `int` | `-1` | read/write | `Md3TreeView` | Selected Index. |
| `rowHeight` | `real` | `Md3Theme.tableRowHeight` | read/write | `Md3TreeView` | Row height follows Theme density (override for custom trees). |
| `indent` | `real` | `20` | read/write | `Md3TreeView` | Indent. |
| `showConnectors` | `bool` | `false` | read/write | `Md3TreeView` | Show Connectors. |
| `checkEnabled` | `bool` | `false` | read/write | `Md3TreeView` | Check Enabled. |
| `triStateCheck` | `bool` | `true` | read/write | `Md3TreeView` | Tri State Check. |
| `filterText` | `string` | `""` | read/write | `Md3TreeView` | Global filter string. |
| `showFilter` | `bool` | `false` | read/write | `Md3TreeView` | Built-in filter field (no external TextField sync glue). |
| `filterPlaceholder` | `string` | `qsTr("Filter")` | read/write | `Md3TreeView` | Filter Placeholder. |
| `filterLabel` | `string` | `qsTr("Filter")` | read/write | `Md3TreeView` | Filter Label. |
| `showExpandControls` | `bool` | `false` | read/write | `Md3TreeView` | Expand all / Collapse all buttons beside the filter. |
| `lazyLoad` | `bool` | `false` | read/write | `Md3TreeView` | Lazy Load. |
| `contextMenu` | `var` | `null` | read/write | `Md3TreeView` | Context Menu. |
| `overlayWindow` | `var` | `null` | read/write | `Md3TreeView` | Optional explicit Window for context-menu overlay coords. |
| `preferredMaxHeight` | `real` | `0` | read/write | `Md3TreeView` | Cap scroll viewport in Column layouts (0 = natural full content height). |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3TreeView` | Drop ListView row delegates while page is off-display (chrome stays). |
| `flatRows` | `var` | `[]` | read/write | `Md3TreeView` | Flat Rows. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `activated(int flatIndex, var node)` | `Md3TreeView` | Emitted when activated. |
| `expandedChanged(int flatIndex, var node, bool expanded)` | `Md3TreeView` | Emitted when expanded Changed. |
| `checkedChanged()` | `Md3TreeView` | Emitted when checked Changed. |
| `fetchChildren(var node, var path)` | `Md3TreeView` | Emitted when fetch Children. |
| `contextMenuRequested(int flatIndex, var node, real globalX, real globalY)` | `Md3TreeView` | Emitted when context Menu Requested. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `isChecked(path)` | `—` | `Md3TreeView` | Is Checked. |
| `checkStateAt(path)` | `—` | `Md3TreeView` | Check State At. |
| `setChecked(path, on)` | `—` | `Md3TreeView` | Set Checked. |
| `setCheckState(path, state)` | `—` | `Md3TreeView` | Set Check State. |
| `toggleCheckAt(flatIndex)` | `—` | `Md3TreeView` | Toggle Check At. |
| `toggleAt(flatIndex)` | `—` | `Md3TreeView` | Toggle At. |
| `expandAll()` | `—` | `Md3TreeView` | Expand All. |
| `collapseAll()` | `—` | `Md3TreeView` | Collapse All. |

## Example

```qml
import Md3

Md3TreeView {
    model: []
    selectedIndex: -1
    rowHeight: Md3Theme.tableRowHeight
    indent: 20
    showConnectors: false
    checkEnabled: false
}
```
