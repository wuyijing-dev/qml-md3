# Md3FabMenu

- **Source:** `src/Md3/components/Md3FabMenu.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `model` | `var` | `[]` | read/write | `Md3FabMenu` | — |
| `open` | `bool` | `false` | read/write | `Md3FabMenu` | — |
| `colorRole` | `int` | `Md3Fab.Primary` | read/write | `Md3FabMenu` | — |
| `icon` | `string` | `"add"` | read/write | `Md3FabMenu` | — |
| `closeIcon` | `string` | `"close"` | read/write | `Md3FabMenu` | — |
| `actionGap` | `real` | `4` | read/write | `Md3FabMenu` | — |
| `stackedModel` | `var` | `{…}` | readonly | `Md3FabMenu` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `clicked()` | `Md3FabMenu` | — |
| `actionClicked(int index)` | `Md3FabMenu` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `toggle()` | `Md3FabMenu` | — |

## Example

```qml
import Md3

Md3FabMenu {
    model: []
    open: false
    colorRole: Md3Fab.Primary
    icon: "add"
    closeIcon: "close"
}
```
