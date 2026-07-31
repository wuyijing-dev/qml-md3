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
| `confirmText` | `string` | `qsTr("OK")` | read/write | `Md3Dialog` | — |
| `dismissText` | `string` | `qsTr("Cancel")` | read/write | `Md3Dialog` | — |
| `showDismiss` | `bool` | `true` | read/write | `Md3Dialog` | — |
| `content` | `alias` | `bodySlot.data` | default read/write | `Md3Dialog` | Custom body between text and action buttons. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `confirmed()` | `Md3Dialog` | — |
| `dismissed()` | `Md3Dialog` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `accept()` | `Md3Dialog` | — |
| `reject()` | `Md3Dialog` | — |

## Example

```qml
import Md3

Md3Dialog {
    open: false
    title: ""
    text: ""
    confirmText: qsTr("OK")
    dismissText: qsTr("Cancel")
}
```
