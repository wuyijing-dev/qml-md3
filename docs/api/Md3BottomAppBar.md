# Md3BottomAppBar

- **Source:** `src/Md3/components/Md3BottomAppBar.qml`
- **Extends:** `Rectangle`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `actions` | `var` | `[] // icon names` | read/write | `Md3BottomAppBar` | — |
| `showFab` | `bool` | `false` | read/write | `Md3BottomAppBar` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `actionClicked(int index)` | `Md3BottomAppBar` | — |
| `fabClicked()` | `Md3BottomAppBar` | — |

## Methods

_None._

## Example

```qml
import Md3

Md3BottomAppBar {
    actions: [] // icon names
    showFab: false
}
```
