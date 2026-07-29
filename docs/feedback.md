# Feedback surfaces

Choose the lightest surface that fits the message lifetime and actions.

| | **Toast** | **Snackbar** | **InfoBar** | **Banner** |
|---|-----------|--------------|-------------|------------|
| API | `Md3Notify.toast` / `Md3ToastHost` | `Md3Notify.snackbar` / `Md3SnackbarHost` | `Md3InfoBar` | `Md3Banner` |
| Lifetime | Short (~2s), auto | Timed / queued | Until dismissed | Until dismissed |
| Place | Top-center | Bottom stack | Inline in layout | Inline strip |
| Action | No | Optional | Optional | Primary/secondary |
| Queue | Replaces current | Priority queue | N/A | N/A |

## Toast

```qml
Md3Notify.toast(qsTr("Copied"))
Md3Notify.toast(qsTr("Upload failed"), { severity: Md3Toast.Error, durationMs: 3000 })
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
