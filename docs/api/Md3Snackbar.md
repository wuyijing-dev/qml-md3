# Md3Snackbar

- **Source:** `src/Md3/components/Md3Snackbar.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 8 | 2 | 2 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `text` | `string` | `""` | read/write | `Md3Snackbar` | Primary label text. |
| `actionText` | `string` | `""` | read/write | `Md3Snackbar` | Action Text. |
| `dualLine` | `bool` | `false` | read/write | `Md3Snackbar` | Dual Line. |
| `open` | `bool` | `false` | read/write | `Md3Snackbar` | Open the overlay / dialog. |
| `durationMs` | `int` | `4000` | read/write | `Md3Snackbar` | Duration Ms. |
| `actionDurationMs` | `int` | `6500` | read/write | `Md3Snackbar` | Extra dwell when an action is present (Undo / View). |
| `politeAnnouncements` | `bool` | `true` | read/write | `Md3Snackbar` | When true, snackbar is not an assertive live region (avoids stealing AT focus). |
| `slideY` | `real` | `open ? 0 : height + 8` | read/write | `Md3Snackbar` | Slide Y. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `actionClicked()` | `Md3Snackbar` | Emitted when action Clicked. |
| `closed()` | `Md3Snackbar` | Emitted when closed. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `show(message)` | `—` | `Md3Snackbar` | Show. |
| `dismiss()` | `—` | `Md3Snackbar` | Dismiss. |

## Example

```qml
import Md3

Md3Snackbar {
    text: ""
    actionText: ""
    dualLine: false
    open: false
    durationMs: 4000
    actionDurationMs: 6500
}
```
