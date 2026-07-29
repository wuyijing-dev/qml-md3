# Md3SnackbarHost

Window-level snackbar queue: stacks up to maxVisible, then queues the rest.

- **Source:** `src/Md3/components/Md3SnackbarHost.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `maxVisible` | `int` | `3` | read/write | `Md3SnackbarHost` | — |
| `spacing` | `int` | `10` | read/write | `Md3SnackbarHost` | — |
| `defaultDurationMs` | `int` | `4000` | read/write | `Md3SnackbarHost` | — |
| `bottomMargin` | `real` | `16` | read/write | `Md3SnackbarHost` | — |
| `sideMargin` | `real` | `16` | read/write | `Md3SnackbarHost` | — |
| `dodgeBottom` | `real` | `0` | read/write | `Md3SnackbarHost` | Extra lift from bottom (e.g. dodge a performance dock). |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `actionTriggered(string snackId, string actionText)` | `Md3SnackbarHost` | — |
| `messageClosed(string snackId)` | `Md3SnackbarHost` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `show(message, options)` | `Md3SnackbarHost` | options: `{ actionText, dualLine, durationMs, id, priority }` — higher priority is dequeued first |
| `dismissAll()` | `Md3SnackbarHost` | — |

## Example

```qml
import Md3

Md3SnackbarHost {
    maxVisible: 3
    spacing: 10
    defaultDurationMs: 4000
    bottomMargin: 16
    sideMargin: 16
}
```
