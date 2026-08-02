# Desktop task / scan patterns

Recipes for long-running desktop tools (index, scan, clean) that outgrow Gallery chrome demos.

## Page chrome: `Md3PageHeader`

Prefer this over hand-rolled `Row` + title. **Children are actions** (default property → actions row). Never wrap with `default property alias x: header.data`.

```qml
Md3PageHeader {
    width: parent.width
    title: qsTr("Find duplicates")
    subtitle: qsTr("Local index · SQL pages the table")
    Md3Button { text: qsTr("Scan"); onClicked: vm.startScan() }
    Md3Button { text: qsTr("Stop"); variant: Md3Button.Outlined; onClicked: vm.stop() }
    Md3Button { text: qsTr("Rebuild index"); variant: Md3Button.Text }
}
```

Narrow widths fold trailing actions into `Md3Menu` overflow.

## Stacks: `content`, never `data`

```qml
// WRONG — children park on the stack root and do not lay out
Item {
    default property alias content: hstack.data
    Md3HStack { id: hstack }
}

// RIGHT
Item {
    default property alias content: hstack.content
    Md3HStack { id: hstack }
}
```

## Cancellable work: `Md3TaskProgress`

```qml
Md3TaskProgress {
    width: parent.width
    active: vm.indexing
    label: qsTr("Indexing…")
    secondaryLabel: vm.indexPath
    indeterminate: true
    cancelable: true
    onCanceled: vm.cancelIndex()
}
```

Use InfoBar/Toast for short status; use TaskProgress for **cancelable** long jobs.

## Selection bar + status line

```qml
Md3SelectionToolbar {
    width: parent.width
    selectedCount: table.selectedIndices.length
    Md3Button { text: qsTr("Clean selected"); onClicked: vm.cleanSelected() }
}

Md3StatusLine {
    icon: "database"
    text: qsTr("Index %1 rows").arg(vm.indexCount)
    secondaryText: qsTr("Built %1").arg(vm.indexBuiltAt)
    actionText: qsTr("Rebuild")
    onActionClicked: vm.rebuildIndex()
}
```

## Destructive confirm (scrollable body)

```qml
Md3Dialog {
    title: qsTr("Delete forever?")
    text: qsTr("Selected files cannot be restored from the Recycle Bin.")
    bodyMaxHeight: 280
    confirmText: qsTr("Delete forever")
    confirmTone: Md3Dialog.Error
    // default content: checklist / Md3ListTile rows
}
```

## Table vs list vs tile

| Need | Use |
|------|-----|
| Multi-column, filter, page, row menu | `Md3DataTable` — bind **current page** rows (SQL `LIMIT`), not the whole index |
| Point-and-fill / simple activate | `Md3ListView` or `Md3ListTile` |
| Growing scan results as AIM | `Md3ListView` with `QAbstractListModel` / `ListModel`, or native `ListView` |

## Signal handler style (Qt 6)

```qml
Md3Switch {
    onToggled: function (checked) { settings.dark = checked }
}
Md3Checkbox {
    onToggled: function (state) { excluded = state !== Qt.Checked }
    // or: onCheckedToggled: function (checked) { … }
}
```

Do **not** write `onToggled: foo = checked` (parameter injection is deprecated).

## Focus rings (mouse-first apps)

```qml
Md3ApplicationWindow {
    defaultShowFocusRings: false   // QSettings miss → start off
}
// Runtime: Md3Accessibility.showFocusRings
```

`Md3FocusRing` is gated by `Md3Accessibility.showFocusRings`. Keyboard focus still works when rings are hidden.

## ChipGroup strings

```qml
Md3ChipGroup {
    model: recentQueries  // QStringList / string[] → { text } automatically
}
```

## Page scroll vs list scroll

- **Form / short page**: outer `Md3ScrollView` / Flickable + `Md3VStack`.
- **Primary results list**: `Md3ListView` / DataTable as the scrolling surface; put chrome (`Md3PageHeader`, TaskProgress) **above** the list, not inside a nested Flickable header that fights height measurement.
