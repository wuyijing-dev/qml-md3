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
| `layoutMode` | `int` | `Md3ContainerBody.Fit` | read/write | `Md3Menu` | — |
| `maxMenuHeight` | `real` | `480` | read/write | `Md3Menu` | — |
| `model` | `var` | `[]` | read/write | `Md3Menu` | Declarative menu from data: [{ text, icon?, divider?, items?, destructive?, enabled?, selected?, showCheck? }, ...] When non-empty, rebuilds children (replaces hand-written Md3MenuItem trees). |
| `isSubMenu` | `bool` | `parentMenu !== null` | readonly | `Md3Menu` | — |
| `content` | `alias` | `column.data` | default read/write | `Md3Menu` | Default property → `column.data` |
| `highlightedIndex` | `int` | `-1` | read/write | `Md3Menu` | — |
| `itemColumn` | `alias` | `column` | read/write | `Md3Menu` | Alias → `column` |
| `overlayWindow` | `var` | `null` | read/write | `Md3Menu` | Optional explicit Window for overlay reparent (else Window.window). |
| `containerRadius` | `real` | `Md3Theme.shape.large` | readonly | `Md3Menu` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `itemClicked(string path)` | `Md3Menu` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `rebuildFromModel()` | `Md3Menu` | — |
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
