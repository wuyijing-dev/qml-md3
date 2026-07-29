# Md3Scaffold

- **Source:** `src/Md3/components/Md3Scaffold.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `title` | `string` | `""` | read/write | `Md3Scaffold` | Built-in TopAppBar title when `appBar` slot empty |
| `leadingIcon` | `string` | `"menu"` | read/write | `Md3Scaffold` | — |
| `showLeading` | `bool` | `true` | read/write | `Md3Scaffold` | — |
| `trailingIcons` | `var` | `[]` | read/write | `Md3Scaffold` | Built-in TopAppBar trailing icons |
| `navigationBarModel` / `navModel` | `var` | `[]` | read/write | `Md3Scaffold` | Built-in NavigationBar model |
| `navigationBarIndex` | `int` | `0` | read/write | `Md3Scaffold` | — |
| `drawerModel` | `var` | `[]` | read/write | `Md3Scaffold` | Built-in NavigationDrawer model |
| `drawerTitle` | `string` | `""` | read/write | `Md3Scaffold` | — |
| `drawerOpen` | `bool` | `false` | read/write | `Md3Scaffold` | — |
| `layoutMode` | `int` | `Md3ContainerBody.Fit` | read/write | `Md3Scaffold` | — |
| `appBar` | `alias` | `appBarSlot.data` | read/write | `Md3Scaffold` | Custom app bar (overrides built-in) |
| `navigationBar` | `alias` | `navBarSlot.data` | read/write | `Md3Scaffold` | Custom nav bar |
| `fab` | `alias` | `fabSlot.data` | read/write | `Md3Scaffold` | — |
| `drawer` | `alias` | `drawerSlot.data` | read/write | `Md3Scaffold` | Custom drawer |
| `content` | `alias` | `body.content` | default read/write | `Md3Scaffold` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `leadingClicked()` | `Md3Scaffold` | — |
| `trailingClicked(int index)` | `Md3Scaffold` | — |
| `navigationBarIndexChangedByUser(int index)` | `Md3Scaffold` | — |
| `drawerIndexChangedByUser(int index)` | `Md3Scaffold` | — |

## Methods

| Method | Description |
|--------|-------------|
| `openDrawer()` / `closeDrawer()` | Toggle built-in drawer |

## Example

```qml
import Md3

Md3Scaffold {
    title: qsTr("Inbox")
    navModel: [
        { icon: "mail", label: qsTr("Mail") },
        { icon: "chat", label: qsTr("Chat") }
    ]
}
```
