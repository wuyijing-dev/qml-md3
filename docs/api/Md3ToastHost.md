# Md3ToastHost

- **Source:** `src/Md3/components/Md3ToastHost.qml`

Window-level multi-toast host. Registers with `Md3Notify`. Supports stacking (up to `maxVisible`) with enter/move animation and five screen positions.

## Position

| Enum | Also as string |
|------|----------------|
| `Md3ToastHost.TopCenter` | `"topCenter"` |
| `Md3ToastHost.TopRight` | `"topRight"` |
| `Md3ToastHost.TopLeft` | `"topLeft"` |
| `Md3ToastHost.BottomRight` | `"bottomRight"` |
| `Md3ToastHost.BottomLeft` | `"bottomLeft"` |

## Properties

`position`, `maxVisible` (default 4), `spacing`, `defaultDurationMs`, `edgeMargin`, `sideMargin`, `dodgeTop`, `dodgeBottom`

## Usage

```qml
Md3Notify.toast(qsTr("Saved"), {
    severity: Md3Toast.Success,
    position: Md3ToastHost.TopRight,
    durationMs: 2500
})

// Queue several — they stack until maxVisible, then wait
Md3Notify.toast(qsTr("One"))
Md3Notify.toast(qsTr("Two"))
Md3Notify.toast(qsTr("Three"))
```

`show(message, options)` returns a toast id. `dismissAll()` clears the stack and queue.
