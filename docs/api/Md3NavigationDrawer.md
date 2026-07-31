# Md3NavigationDrawer

- **Source:** `src/Md3/components/Md3NavigationDrawer.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `open` | `bool` | `false` | read/write | `Md3NavigationDrawer` | — |
| `modal` | `bool` | `true` | read/write | `Md3NavigationDrawer` | — |
| `model` | `var` | `[]` | read/write | `Md3NavigationDrawer` | — |
| `currentIndex` | `int` | `0` | read/write | `Md3NavigationDrawer` | — |
| `title` | `string` | `""` | read/write | `Md3NavigationDrawer` | — |
| `drawerWidth` | `real` | `360` | read/write | `Md3NavigationDrawer` | — |
| `startMargin` | `real` | `0` | read/write | `Md3NavigationDrawer` | — |
| `destinationHeight` | `real` | `56` | readonly | `Md3NavigationDrawer` | — |
| `destinationSpacing` | `real` | `0` | readonly | `Md3NavigationDrawer` | — |
| `panelWidth` | `real` | `Math.min(drawerWidth, Math.max(0, width - startMargin))` | readonly | `Md3NavigationDrawer` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `currentIndexChangedByUser(int index)` | `Md3NavigationDrawer` | — |
| `dismissed()` | `Md3NavigationDrawer` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `destinationY(index)` | `Md3NavigationDrawer` | — |
| `dismiss()` | `Md3NavigationDrawer` | — |

## Example

```qml
import Md3

Md3NavigationDrawer {
    open: false
    modal: true
    model: []
    currentIndex: 0
    title: ""
}
```
