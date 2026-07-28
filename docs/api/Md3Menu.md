# Md3Menu

- **Source:** `src/Md3/components/Md3Menu.qml`

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `open` | bool | `false` | — |
| `menuX` / `menuY` / `menuWidth` | real | — | Popup geometry |
| `modal` | bool | `true` | Scrim for root menus |
| `layoutMode` | int | `Fit` | Fit / Scroll |
| `maxMenuHeight` | real | `480` | Scroll cap |
| `model` | var | `[]` | Data-driven items (see below) |
| `content` | alias | default | Hand-written MenuItems when model empty |

## Model entries

`{ text, icon?, trailingIcon?, divider?, items?, destructive?, enabled?, selected?, showCheck?, leadingCheck? }`

Use `items` for nested submenus (not `children`).

## Signals / methods

`itemClicked(string path)`, `popup(x,y)`, `popupAtItem(item,x,y)`, `dismiss()`, `dismissCascade()`, `clearItems()`, `rebuildFromModel()`, `addItemObject(comp, props)`

## Example

```qml
Md3Menu {
    model: [
        { text: "Cut", icon: "content_cut" },
        { divider: true },
        { text: "Share", items: [{ text: "Email", icon: "mail" }] }
    ]
    onItemClicked: (path) => console.log(path)
}
```
