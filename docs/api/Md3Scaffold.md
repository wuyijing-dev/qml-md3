# Md3Scaffold

App shell: optional built-in TopAppBar / NavigationBar / Drawer from props, or custom slots (`appBar:`, `navigationBar:`, `drawer:`, `fab:`).

- **Source:** `src/Md3/components/Md3Scaffold.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 16 | 4 | 2 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `title` | `string` | `""` | read/write | `Md3Scaffold` | Convenience: materialize Md3TopAppBar when set (and appBar slot empty). |
| `leadingIcon` | `string` | `"menu"` | read/write | `Md3Scaffold` | Leading Icon. |
| `showLeading` | `bool` | `true` | read/write | `Md3Scaffold` | Show Leading. |
| `trailingIcons` | `var` | `[]` | read/write | `Md3Scaffold` | Trailing Icons. |
| `navigationBarModel` | `var` | `[]` | read/write | `Md3Scaffold` | Convenience: materialize Md3NavigationBar when non-empty (and navigationBar slot empty). |
| `navModel` | `alias` | `root.navigationBarModel` | read/write | `Md3Scaffold` | Nav Model. |
| `navigationBarIndex` | `int` | `0` | read/write | `Md3Scaffold` | Navigation Bar Index. |
| `drawerModel` | `var` | `[]` | read/write | `Md3Scaffold` | Convenience: materialize Md3NavigationDrawer when non-empty (and drawer slot empty). |
| `drawerTitle` | `string` | `""` | read/write | `Md3Scaffold` | Drawer Title. |
| `drawerOpen` | `bool` | `false` | read/write | `Md3Scaffold` | Drawer Open. |
| `appBar` | `alias` | `appBarSlot.data` | read/write | `Md3Scaffold` | App Bar. |
| `navigationBar` | `alias` | `navBarSlot.data` | read/write | `Md3Scaffold` | Navigation Bar. |
| `fab` | `alias` | `fabSlot.data` | read/write | `Md3Scaffold` | Fab. |
| `drawer` | `alias` | `drawerSlot.data` | read/write | `Md3Scaffold` | Drawer. |
| `layoutMode` | `int` | `Md3ContainerBody.Fit` | read/write | `Md3Scaffold` | Layout Mode. |
| `content` | `alias` | `body.content` | default read/write | `Md3Scaffold` | Content. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `leadingClicked()` | `Md3Scaffold` | Emitted when leading Clicked. |
| `trailingClicked(int index)` | `Md3Scaffold` | Emitted when trailing Clicked. |
| `navigationBarIndexChangedByUser(int index)` | `Md3Scaffold` | Emitted when navigation Bar Index Changed By User. |
| `drawerIndexChangedByUser(int index)` | `Md3Scaffold` | Emitted when drawer Index Changed By User. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `openDrawer()` | `—` | `Md3Scaffold` | Open Drawer. |
| `closeDrawer()` | `—` | `Md3Scaffold` | Close Drawer. |

## Example

```qml
import Md3

Md3Scaffold {
    title: ""
    leadingIcon: "menu"
    showLeading: true
    trailingIcons: []
    navigationBarModel: []
    navigationBarIndex: 0
}
```
