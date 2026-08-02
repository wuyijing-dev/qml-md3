# IDE shell patterns

Recipes for **IDE-style** shells: toolbar + explorer split + tab workspace + optional detail sheet.
GitDesk-style apps should prefer these over Gallery destination-rail alone.

## Recommended chrome

| Role | Use |
|------|-----|
| Top commands | `toolBar` / `Md3AppToolBar` / `Md3DropDownButton` |
| Left explorer | `Md3SplitView` pane 1 — **no** `anchors.fill` on the pane itself |
| Main workspace | Tab strip + external page host (`fillHeight` or anchors) |
| Transient detail | `Md3SideSheet` (prefer over a third Split pane you cannot collapse) |
| Settings | `Md3FullscreenDialog` with `writeOpenOnClose: false` when `open` is bound |
| Status | `statusBar` — left path, center secondary, right busy |

## SplitView: never fill the pane

```qml
Md3SplitView {
    anchors.fill: parent
    splitRatio: 0.28
    // WRONG on a direct child: anchors.fill: parent
    Item { // pane 1 — geometry owned by SplitView
        Item {
            id: header
            anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right
            height: 40
        }
        Item {
            id: footer
            anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right
            height: 48
        }
        Md3ScrollView {
            anchors.top: header.bottom
            anchors.bottom: footer.top
            anchors.left: parent.left
            anchors.right: parent.right
            // do not use expand: true here
        }
    }
    Item { /* pane 2 workspace */ }
}
```

Collapse detail with `pane2Collapsed: true`, or use `Md3SideSheet` for dismissible panels.

## Tab bar + page host

**Strip only** (IDE usual):

```qml
Column {
    Md3TabBar { width: parent.width; model: tabs; /* no pages children */ }
    Item {
        width: parent.width
        height: parent.height - 48
        // Loader / StackLayout for current tab
    }
}
```

**Tabs with pages filling parent:**

```qml
Md3TabBar {
    anchors.fill: parent
    fillHeight: true
    model: tabs
    Item { /* page 0 */ }
    Item { /* page 1 */ }
}
```

## FullscreenDialog `open` binding

Internal `accept()`/`reject()` used to assign `open = false` and **break** `open: window.settingsOpen`.

```qml
property bool settingsOpen: false

Md3FullscreenDialog {
    open: window.settingsOpen
    writeOpenOnClose: false          // keep the binding
    onConfirmed: window.settingsOpen = false
    onDismissed: window.settingsOpen = false
}
```

Prefer bubbling `settingsRequested` from child pages; open/close only on the window.

## DropDown with default action

```qml
Md3DropDownButton {
    text: qsTr("Pull")
    split: true
    menuModel: [
        { text: qsTr("Pull (ff-only)") },
        { text: qsTr("Pull --rebase") }
    ]
    onPrimaryClicked: vm.pullFfOnly()
    onMenuItemClicked: function (i) { /* … */ }
}
```

## SideSheet long lists

Do **not** put thousands of `Repeater` + `Md3ListTile` rows in a SideSheet. Use `Md3ListView` / `Md3VirtualList` (or a Flickable ListView) inside the sheet body.

## Dangerous confirms

```qml
Md3Dialog {
    title: qsTr("Reset hard?")
    text: detail
    confirmTone: Md3Dialog.Error
    confirmText: qsTr("Reset")
}
```

## Naming aliases

| Prefer | Also accepted |
|--------|----------------|
| `Md3EmptyState.description` | `body` |
| `Md3Icon.color` / `iconColor` | either |
| `Md3TextArea` | `Md3TextField { multiline: true }` |

## Related

- [layout.md](layout.md) — stacks / expand / Fit·Scroll
- [dialogs-and-open.md](dialogs-and-open.md) — open binding rules
- [desktop-task-patterns.md](desktop-task-patterns.md) — scan / task chrome
- [feedback.md](feedback.md) — Dialog vs SideSheet vs Snackbar
