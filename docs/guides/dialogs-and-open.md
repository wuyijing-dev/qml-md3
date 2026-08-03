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

## Imperative confirm / prompt

`Md3ApplicationWindow` registers a dialog service. From anywhere:

```qml
Md3DialogHost.confirm({
    title: qsTr("Delete?"),
    text: qsTr("This cannot be undone."),
    confirmTone: Md3Dialog.Error,
    confirmText: qsTr("Delete"),
    onConfirmed: function () { /* … */ }
})

Md3DialogHost.prompt({
    title: qsTr("Rename"),
    label: qsTr("Name"),
    value: currentName,
    onConfirmed: function (value) { /* … */ }
})
```

Prefer signals up to the window when possible; use DialogHost to avoid `Window.window.confirmX` glue.

## Dialog form width

```qml
Md3Dialog {
    preferredWidth: 480
    Md3TextField {
        width: parent ? parent.width : 280  // or bind to dialog.contentWidth from outside
    }
}
```

Child fields inside the dialog body already get `parent.width` from the column.
