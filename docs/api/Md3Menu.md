# Md3Menu

- **Source:** `src/Md3/components/Md3Menu.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 16 | 1 | 9 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `open` | `bool` | `false` | read/write | `Md3Menu` | Open the overlay / dialog. |
| `menuX` | `real` | `0` | read/write | `Md3Menu` | Menu X. |
| `menuY` | `real` | `0` | read/write | `Md3Menu` | Menu Y. |
| `menuWidth` | `real` | `0` | read/write | `Md3Menu` | 0 = content width |
| `modal` | `bool` | `true` | read/write | `Md3Menu` | Modal. |
| `parentMenu` | `var` | `null` | read/write | `Md3Menu` | Cascading: parent of this submenu (null = root menu) |
| `childMenu` | `var` | `null` | read/write | `Md3Menu` | Currently open child submenu |
| `layoutMode` | `int` | `Md3ContainerBody.Fit` | read/write | `Md3Menu` | Layout Mode. |
| `maxMenuHeight` | `real` | `480` | read/write | `Md3Menu` | Max Menu Height. |
| `model` | `var` | `[]` | read/write | `Md3Menu` | Declarative menu from data: [{ text, icon?, divider?, items?, destructive?, enabled?, selected?, showCheck? }, ...] When non-empty, rebuilds children (replaces hand-written Md3MenuItem trees). |
| `isSubMenu` | `bool` | `parentMenu !== null` | readonly | `Md3Menu` | Is Sub Menu. |
| `content` | `alias` | `column.data` | default read/write | `Md3Menu` | Content. |
| `highlightedIndex` | `int` | `-1` | read/write | `Md3Menu` | Highlighted Index. |
| `itemColumn` | `alias` | `column` | read/write | `Md3Menu` | Item Column. |
| `overlayWindow` | `var` | `null` | read/write | `Md3Menu` | Optional explicit Window for overlay reparent (else Window.window). |
| `containerRadius` | `real` | `Md3Theme.shape.large` | readonly | `Md3Menu` | Container Radius. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `itemClicked(string path)` | `Md3Menu` | Emitted when item Clicked. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `rebuildFromModel()` | `—` | `Md3Menu` | Rebuild From Model. |
| `clearItems()` | `—` | `Md3Menu` | Clear Items. |
| `addItemObject(comp, props)` | `—` | `Md3Menu` | Add Item Object. |
| `hostEnsureParent(contentItem)` | `—` | `Md3Menu` | Host Ensure Parent. |
| `popup(x, y)` | `—` | `Md3Menu` | Popup. |
| `dismiss()` | `—` | `Md3Menu` | Dismiss. |
| `dismissCascade()` | `—` | `Md3Menu` | Dismiss Cascade. |
| `popupAtItem(item, x, y)` | `—` | `Md3Menu` | Popup At Item. |
| `openSubMenu(menu, anchorItem)` | `—` | `Md3Menu` | Open `menu` as a cascading submenu anchored to `anchorItem`. |

## Example

```qml
import Md3

Md3Menu {
    open: false
    menuX: 0
    menuY: 0
    menuWidth: 0
    modal: true
    parentMenu: null
}
```
