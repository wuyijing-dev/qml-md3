# Md3Notify

Singleton helpers for app-wide notifications.

- **Source:** `src/Md3/foundation/Md3Notify.qml`
- **Singleton:** yes

## Methods

| Method | Description |
|--------|-------------|
| `toast(message, options?)` | Multi-toast on `Md3ToastHost` — options: `{ severity, durationMs, position, id }` |
| `snackbar(message, options?)` | Enqueue on registered `Md3SnackbarHost` |
| `dismissAll()` | Clear snackbars + toast |
| `registerHost` / `unregisterHost` | Snackbar host (automatic) |
| `registerToastHost` / `unregisterToastHost` | Toast host (automatic) |

Snackbar `options`: `{ actionText, dualLine, durationMs, id, priority }`

Toast `options`: `{ severity, durationMs }` — severity `Md3Toast.Default|Success|Warning|Error`

## Example

```qml
Md3Notify.toast(qsTr("Copied"))
Md3Notify.snackbar(qsTr("Saved"), { actionText: qsTr("Undo") })
```

See [feedback.md](../feedback.md). `Md3ApplicationWindow` registers both hosts.
