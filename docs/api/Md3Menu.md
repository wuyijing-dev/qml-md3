# Md3Menu

- **Source:** `src/Md3/components/Md3Menu.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `open` | `bool` | `false` | read/write | `Md3Menu` | — |
| `menuX` | `real` | `0` | read/write | `Md3Menu` | — |
| `menuY` | `real` | `0` | read/write | `Md3Menu` | — |
| `menuWidth` | `real` | `0` | read/write | `Md3Menu` | — |
| `modal` | `bool` | `true` | read/write | `Md3Menu` | — |
| `parentMenu` | `var` | `null` | read/write | `Md3Menu` | Cascading: parent of this submenu (null = root menu) |
| `childMenu` | `var` | `null` | read/write | `Md3Menu` | Currently open child submenu |
| `isSubMenu` | `bool` | `parentMenu !== null` | readonly | `Md3Menu` | — |
| `content` | `alias` | `column.data` | default read/write | `Md3Menu` | Default property → `column.data` |
| `itemColumn` | `alias` | `column` | read/write | `Md3Menu` | Alias → `column` |
| `containerRadius` | `real` | `Md3Theme.shape.large` | readonly | `Md3Menu` | — |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `clearItems()` | `Md3Menu` | — |
| `addItemObject(comp, props)` | `Md3Menu` | — |
| `hostEnsureParent(contentItem)` | `Md3Menu` | — |
| `popup(x, y)` | `Md3Menu` | — |
| `dismiss()` | `Md3Menu` | — |
| `dismissCascade()` | `Md3Menu` | — |
| `popupAtItem(item, x, y)` | `Md3Menu` | — |
| `openSubMenu(menu, anchorItem)` | `Md3Menu` | Open `menu` as a cascading submenu anchored to `anchorItem`. |

## Example

```qml
import Md3

Md3Menu {
    open: false
    menuX: 0
    menuY: 0
    menuWidth: 0
    modal: true
}
```
