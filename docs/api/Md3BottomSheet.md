# Md3BottomSheet

- **Source:** `src/Md3/components/Md3BottomSheet.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 11 | 2 | 2 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `open` | `bool` | `false` | read/write | `Md3BottomSheet` | Open the overlay / dialog. |
| `modal` | `bool` | `true` | read/write | `Md3BottomSheet` | Modal. |
| `layoutMode` | `int` | `Md3ContainerBody.Fit` | read/write | `Md3BottomSheet` | Layout Mode. |
| `title` | `string` | `""` | read/write | `Md3BottomSheet` | Title text. |
| `text` | `string` | `""` | read/write | `Md3BottomSheet` | Primary label text. |
| `confirmText` | `string` | `""` | read/write | `Md3BottomSheet` | Confirm Text. |
| `dismissText` | `string` | `""` | read/write | `Md3BottomSheet` | Dismiss Text. |
| `dismissDragThreshold` | `real` | `96` | read/write | `Md3BottomSheet` | Drag distance (px) before release dismisses the sheet. |
| `writeOpenOnClose` | `bool` | `true` | read/write | `Md3BottomSheet` | When true (default), accept/reject writes ``open = false``. Set false if ``open`` is bound externally. |
| `content` | `alias` | `bodySlot.data` | default read/write | `Md3BottomSheet` | Content. |
| `maxSheetHeight` | `real` | `parent ? parent.height * 0.6 : 480` | readonly | `Md3BottomSheet` | Max Sheet Height. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `dismissed()` | `Md3BottomSheet` | Emitted when dismissed. |
| `confirmed()` | `Md3BottomSheet` | Emitted when confirmed. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `accept()` | `—` | `Md3BottomSheet` | Accept. |
| `reject()` | `—` | `Md3BottomSheet` | Reject. |

## Example

```qml
import Md3

Md3BottomSheet {
    open: false
    modal: true
    layoutMode: Md3ContainerBody.Fit
    title: ""
    text: ""
    confirmText: ""
}
```
