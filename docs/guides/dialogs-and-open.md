# Dialog / Sheet `open` binding

## The trap

```qml
Md3FullscreenDialog {
    open: window.settingsOpen
    onConfirmed: window.settingsOpen = false
}
```

`accept()` / `reject()` / `dismiss()` historically did `open = false`, which **breaks** the binding to `settingsOpen`. The next `settingsOpen = true` no longer opens the overlay.

Same risk on `Md3Dialog`, `Md3SideSheet`, `Md3BottomSheet`, and `Md3Flyout`.

## Fix (1.1.3+ dialogs; 1.1.4+ sheets / flyout)

```qml
Md3FullscreenDialog {
    open: window.settingsOpen
    writeOpenOnClose: false
    onConfirmed: window.settingsOpen = false
    onDismissed: window.settingsOpen = false
}

Md3SideSheet {
    open: window.detailOpen
    writeOpenOnClose: false
    onDismissed: window.detailOpen = false
}
```

Or avoid binding: only assign both sides from functions (App-side sync):

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
