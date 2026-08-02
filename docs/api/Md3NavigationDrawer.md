# Md3NavigationDrawer

- **Source:** `src/Md3/components/Md3NavigationDrawer.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 10 | 2 | 2 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `open` | `bool` | `false` | read/write | `Md3NavigationDrawer` | Open the overlay / dialog. |
| `modal` | `bool` | `true` | read/write | `Md3NavigationDrawer` | Modal. |
| `model` | `var` | `[]` | read/write | `Md3NavigationDrawer` | Data model. |
| `currentIndex` | `int` | `0` | read/write | `Md3NavigationDrawer` | Current index. |
| `title` | `string` | `""` | read/write | `Md3NavigationDrawer` | Title text. |
| `drawerWidth` | `real` | `360` | read/write | `Md3NavigationDrawer` | Drawer Width. |
| `startMargin` | `real` | `0` | read/write | `Md3NavigationDrawer` | Start Margin. |
| `destinationHeight` | `real` | `Md3Theme.navDestinationHeight` | readonly | `Md3NavigationDrawer` | Destination Height. |
| `destinationSpacing` | `real` | `0` | readonly | `Md3NavigationDrawer` | Destination Spacing. |
| `panelWidth` | `real` | `Math.min(drawerWidth, Math.max(0, width - startMargin))` | readonly | `Md3NavigationDrawer` | Panel Width. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `currentIndexChangedByUser(int index)` | `Md3NavigationDrawer` | Emitted when current Index Changed By User. |
| `dismissed()` | `Md3NavigationDrawer` | Emitted when dismissed. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `destinationY(index)` | `—` | `Md3NavigationDrawer` | Destination Y. |
| `dismiss()` | `—` | `Md3NavigationDrawer` | Dismiss. |

## Example

```qml
import Md3

Md3NavigationDrawer {
    open: false
    modal: true
    model: []
    currentIndex: 0
    title: ""
    drawerWidth: 360
}
```
