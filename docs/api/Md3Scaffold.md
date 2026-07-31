# Md3Scaffold

App shell: optional built-in TopAppBar / NavigationBar / Drawer from props, or custom slots (`appBar:`, `navigationBar:`, `drawer:`, `fab:`).

- **Source:** `src/Md3/components/Md3Scaffold.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `title` | `string` | `""` | read/write | `Md3Scaffold` | Convenience: materialize Md3TopAppBar when set (and appBar slot empty). |
| `leadingIcon` | `string` | `"menu"` | read/write | `Md3Scaffold` | — |
| `showLeading` | `bool` | `true` | read/write | `Md3Scaffold` | — |
| `trailingIcons` | `var` | `[]` | read/write | `Md3Scaffold` | — |
| `navigationBarModel` | `var` | `[]` | read/write | `Md3Scaffold` | Convenience: materialize Md3NavigationBar when non-empty (and navigationBar slot empty). |
| `navModel` | `alias` | `root.navigationBarModel` | read/write | `Md3Scaffold` | Alias → `root.navigationBarModel` |
| `navigationBarIndex` | `int` | `0` | read/write | `Md3Scaffold` | — |
| `drawerModel` | `var` | `[]` | read/write | `Md3Scaffold` | Convenience: materialize Md3NavigationDrawer when non-empty (and drawer slot empty). |
| `drawerTitle` | `string` | `""` | read/write | `Md3Scaffold` | — |
| `drawerOpen` | `bool` | `false` | read/write | `Md3Scaffold` | — |
| `appBar` | `alias` | `appBarSlot.data` | read/write | `Md3Scaffold` | Alias → `appBarSlot.data` |
| `navigationBar` | `alias` | `navBarSlot.data` | read/write | `Md3Scaffold` | Alias → `navBarSlot.data` |
| `fab` | `alias` | `fabSlot.data` | read/write | `Md3Scaffold` | Alias → `fabSlot.data` |
| `drawer` | `alias` | `drawerSlot.data` | read/write | `Md3Scaffold` | Alias → `drawerSlot.data` |
| `layoutMode` | `int` | `Md3ContainerBody.Fit` | read/write | `Md3Scaffold` | — |
| `content` | `alias` | `body.content` | default read/write | `Md3Scaffold` | Default property → `body.content` |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `leadingClicked()` | `Md3Scaffold` | — |
| `trailingClicked(int index)` | `Md3Scaffold` | — |
| `navigationBarIndexChangedByUser(int index)` | `Md3Scaffold` | — |
| `drawerIndexChangedByUser(int index)` | `Md3Scaffold` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `openDrawer()` | `Md3Scaffold` | — |
| `closeDrawer()` | `Md3Scaffold` | — |

## Example

```qml
import Md3

Md3Scaffold {
    title: ""
    leadingIcon: "menu"
    showLeading: true
    trailingIcons: []
    navigationBarModel: []
}
```
