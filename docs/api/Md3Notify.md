# Md3Notify

Singleton helpers for app-wide notifications.

- **Source:** `src/Md3/foundation/Md3Notify.qml`
- **Singleton:** yes

## Methods

| Method | Description |
|--------|-------------|
| `snackbar(message, options?)` | Enqueue on registered `Md3SnackbarHost` |
| `dismissAll()` | Clear queue + visible snacks |
| `registerHost(host)` | Usually automatic |
| `unregisterHost(host)` | Usually automatic |

`options`: `{ actionText, dualLine, durationMs, id, priority }` — higher `priority` is shown before lower ones still waiting in the queue.

## Example

```qml
Md3Notify.snackbar(qsTr("Saved"), { actionText: qsTr("Undo") })
```

`Md3ApplicationWindow` includes a host; bare windows need `Md3SnackbarHost { anchors... }`.
