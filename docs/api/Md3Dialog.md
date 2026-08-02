# Md3Dialog

Modal dialog with optional scrollable body and confirm tone.

- **Source:** `src/Md3/components/Md3Dialog.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 10 | 2 | 2 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Enums

### `Md3Dialog.ConfirmTone`

`Md3Dialog.Primary`, `Md3Dialog.Error`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `open` | `bool` | `false` | read/write | `Md3Dialog` | Open the overlay / dialog. |
| `title` | `string` | `""` | read/write | `Md3Dialog` | Title text. |
| `text` | `string` | `""` | read/write | `Md3Dialog` | Primary label text. |
| `confirmText` | `string` | `qsTr("OK")` | read/write | `Md3Dialog` | Confirm Text. |
| `dismissText` | `string` | `qsTr("Cancel")` | read/write | `Md3Dialog` | Dismiss Text. |
| `showDismiss` | `bool` | `true` | read/write | `Md3Dialog` | Show Dismiss. |
| `bodyMaxHeight` | `real` | `280` | read/write | `Md3Dialog` | Cap body height; content scrolls when taller. |
| `confirmTone` | `int (Md3Dialog.ConfirmTone)` | `Md3Dialog.Primary` | read/write | `Md3Dialog` | Primary (default) or Error/destructive confirm button. |
| `writeOpenOnClose` | `bool` | `true` | read/write | `Md3Dialog` | When true (default), close writes ``open = false``. Set false if ``open`` is bound externally. |
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
