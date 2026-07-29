# Feedback surfaces

Choose the lightest surface that fits the message lifetime and actions.

| | **Toast** | **Snackbar** | **InfoBar** | **Banner** |
|---|-----------|--------------|-------------|------------|
| API | `Md3Notify.toast` / `Md3ToastHost` | `Md3Notify.snackbar` / `Md3SnackbarHost` | `Md3InfoBar` | `Md3Banner` |
| Lifetime | Short (~2s), auto | Timed / queued | Until dismissed | Until dismissed |
| Place | Top/bottom × left/center/right | Bottom stack | Inline in layout | Inline strip |
| Action | No | Optional | Optional | Primary/secondary |
| Queue | Multi-stack (`maxVisible`) then queue | Priority queue | N/A | N/A |

## Toast

```qml
Md3Notify.toast(qsTr("Copied"))
Md3Notify.toast(qsTr("Upload failed"), { severity: Md3Toast.Error, durationMs: 3000 })
Md3Notify.toast(qsTr("Saved"), { position: Md3ToastHost.TopRight, severity: Md3Toast.Success })
// Positions: TopCenter, TopRight, TopLeft, BottomRight, BottomLeft
```

## Snackbar

```qml
Md3Notify.snackbar(qsTr("Draft saved"), { actionText: qsTr("Undo"), priority: 0 })
```

## InfoBar

```qml
Md3InfoBar {
    severity: Md3InfoBar.Critical
    message: qsTr("Offline — changes will sync when connected.")
}
```

`Md3ApplicationWindow` registers snackbar + toast hosts automatically.
