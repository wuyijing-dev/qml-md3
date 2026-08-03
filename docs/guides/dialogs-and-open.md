# Dialog `open` binding

## The trap

```qml
Md3FullscreenDialog {
    open: window.settingsOpen
    onConfirmed: window.settingsOpen = false
}
```

`accept()` / `reject()` historically did `open = false`, which **breaks** the binding to `settingsOpen`. The next `settingsOpen = true` no longer opens the dialog.

Same risk on `Md3Dialog`.

## Fix (1.1.3+)

```qml
Md3FullscreenDialog {
    open: window.settingsOpen
    writeOpenOnClose: false
    onConfirmed: window.settingsOpen = false
    onDismissed: window.settingsOpen = false
}
```

Or avoid binding: only assign both sides from functions:

```qml
function openSettings() {
    settingsOpen = true
    settingsDialog.open = true
}
function closeSettings() {
    settingsOpen = false
    settingsDialog.open = false
}
```

## Child pages

Prefer `signal settingsRequested` → window handler, not `Window.window.settingsOpen = true` buried in a page.

## Destructive tone

```qml
Md3Dialog {
    confirmTone: Md3Dialog.Error
    confirmText: qsTr("Delete forever")
    bodyMaxHeight: 280
}
```

See [feedback.md](feedback.md).
