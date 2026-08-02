# Md3FullscreenDialog

- **Source:** `src/Md3/components/Md3FullscreenDialog.qml`
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
| `open` | `bool` | `false` | read/write | `Md3FullscreenDialog` | Open the overlay / dialog. |
| `title` | `string` | `""` | read/write | `Md3FullscreenDialog` | Title text. |
| `confirmText` | `string` | `qsTr("Save")` | read/write | `Md3FullscreenDialog` | Confirm Text. |
| `layoutMode` | `int` | `Md3ContainerBody.Fit` | read/write | `Md3FullscreenDialog` | Layout Mode. |
| `contentMargins` | `real` | `24` | read/write | `Md3FullscreenDialog` | Body margins (was hard-coded 24). |
| `writeOpenOnClose` | `bool` | `true` | read/write | `Md3FullscreenDialog` | When true (default), ``accept``/``reject`` assign ``open = false``. Set false when ``open`` is bound to an external property so the binding is not broken. |
| `content` | `alias` | `body.content` | default read/write | `Md3FullscreenDialog` | Content. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `confirmed()` | `Md3FullscreenDialog` | Emitted when confirmed. |
| `dismissed()` | `Md3FullscreenDialog` | Emitted when dismissed. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `accept()` | `—` | `Md3FullscreenDialog` | Accept. |
| `reject()` | `—` | `Md3FullscreenDialog` | Reject. |

## Example

```qml
import Md3

Md3FullscreenDialog {
    open: false
    title: ""
    confirmText: qsTr("Save")
    layoutMode: Md3ContainerBody.Fit
    contentMargins: 24
    writeOpenOnClose: true
}
```
