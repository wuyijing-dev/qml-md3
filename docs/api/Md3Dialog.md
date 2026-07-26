# Md3Dialog

- **Source:** `src/Md3/components/Md3Dialog.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `open` | `bool` | `false` | read/write | `Md3Dialog` | — |
| `title` | `string` | `""` | read/write | `Md3Dialog` | — |
| `text` | `string` | `""` | read/write | `Md3Dialog` | — |
| `confirmText` | `string` | `"OK"` | read/write | `Md3Dialog` | — |
| `dismissText` | `string` | `"Cancel"` | read/write | `Md3Dialog` | — |
| `showDismiss` | `bool` | `true` | read/write | `Md3Dialog` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `confirmed()` | `Md3Dialog` | — |
| `dismissed()` | `Md3Dialog` | — |

## Methods

_None._

## Example

```qml
import Md3

Md3Dialog {
    open: false
    title: ""
    text: ""
    confirmText: "OK"
    dismissText: "Cancel"
}
```
