# Md3SnackbarHost

Window-level snackbar queue: stacks up to maxVisible, then queues the rest.

- **Source:** `src/Md3/components/Md3SnackbarHost.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 6 | 2 | 2 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `maxVisible` | `int` | `3` | read/write | `Md3SnackbarHost` | Max Visible. |
| `spacing` | `int` | `10` | read/write | `Md3SnackbarHost` | Child spacing. |
| `defaultDurationMs` | `int` | `4000` | read/write | `Md3SnackbarHost` | Default Duration Ms. |
| `bottomMargin` | `real` | `16` | read/write | `Md3SnackbarHost` | Bottom Margin. |
| `sideMargin` | `real` | `16` | read/write | `Md3SnackbarHost` | Side Margin. |
| `dodgeBottom` | `real` | `0` | read/write | `Md3SnackbarHost` | Extra lift from bottom (e.g. dodge a performance dock). |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `actionTriggered(string snackId, string actionText)` | `Md3SnackbarHost` | Emitted when action Triggered. |
| `messageClosed(string snackId)` | `Md3SnackbarHost` | Emitted when message Closed. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `show(message, options)` | `—` | `Md3SnackbarHost` | Show. |
| `dismissAll()` | `—` | `Md3SnackbarHost` | Dismiss All. |

## Example

```qml
import Md3

Md3SnackbarHost {
    maxVisible: 3
    spacing: 10
    defaultDurationMs: 4000
    bottomMargin: 16
    sideMargin: 16
    dodgeBottom: 0
}
```
