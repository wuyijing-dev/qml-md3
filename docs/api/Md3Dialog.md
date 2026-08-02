# Md3Dialog

- **Source:** `src/Md3/components/Md3Dialog.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 7 | 2 | 2 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `open` | `bool` | `false` | read/write | `Md3Dialog` | Open the overlay / dialog. |
| `title` | `string` | `""` | read/write | `Md3Dialog` | Title text. |
| `text` | `string` | `""` | read/write | `Md3Dialog` | Primary label text. |
| `confirmText` | `string` | `qsTr("OK")` | read/write | `Md3Dialog` | Confirm Text. |
| `dismissText` | `string` | `qsTr("Cancel")` | read/write | `Md3Dialog` | Dismiss Text. |
| `showDismiss` | `bool` | `true` | read/write | `Md3Dialog` | Show Dismiss. |
| `content` | `alias` | `bodySlot.data` | default read/write | `Md3Dialog` | Custom body between text and action buttons. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `confirmed()` | `Md3Dialog` | Emitted when confirmed. |
| `dismissed()` | `Md3Dialog` | Emitted when dismissed. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `accept()` | `—` | `Md3Dialog` | Accept. |
| `reject()` | `—` | `Md3Dialog` | Reject. |

## Example

```qml
import Md3

Md3Dialog {
    open: false
    title: ""
    text: ""
    confirmText: qsTr("OK")
    dismissText: qsTr("Cancel")
    showDismiss: true
}
```
