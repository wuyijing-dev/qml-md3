# Reducing glue code

Prefer these component APIs over hand-rolled `Row`/`Column`/`Text` wrappers.

See also [layout.md](layout.md).

## Selection controls

```qml
Md3Switch { text: qsTr("Dark theme"); checked: true }
Md3Checkbox { text: qsTr("Remember me") }
Md3Radio { text: qsTr("Option A"); value: "a"; group: g }
```

## Slider

```qml
Md3Slider {
    label: qsTr("Frost / blur")
    showValue: true
    from: 0; to: 1; value: 0.45
}
```

`showLabel` still shows the floating bubble while dragging; `showValue` is the inline header value.

## List tile

```qml
Md3ListTile {
    title: qsTr("Notifications")
    leadingIcon: "notifications"
    showDivider: true
    // fillWidth defaults to true — no width: parent.width
    trailing: Md3Switch { checked: true }
}
```

## Cards & sections

```qml
Md3Card {
    title: qsTr("Storage")
    subtitle: qsTr("Local cache")
    layoutMode: Md3ContainerBody.Scroll
    /* body */
}

Md3PageSection {
    title: qsTr("Appearance")
    subtitle: qsTr("Theme and density")
    Md3Switch { text: qsTr("Dark theme") }
}
```

## Sheets & dialogs

```qml
Md3BottomSheet {
    title: qsTr("Options")
    text: qsTr("Pick an action")
    confirmText: qsTr("Done")
}

Md3SideSheet {
    title: qsTr("Details")
    text: qsTr("Secondary content…")
    Md3Button { text: qsTr("Close"); onClicked: dismiss() }
}

Md3Dialog {
    title: qsTr("Edit")
    text: qsTr("Update profile")
    Md3TextField { label: qsTr("Name") }  // content slot above actions
}
```

## Menu model

```qml
Md3Menu {
    model: [
        { text: "Cut", icon: "content_cut" },
        { divider: true },
        { text: "Create", icon: "add", items: [
            { text: "Document", icon: "description" },
            { text: "Folder", icon: "folder" }
        ]}
    ]
    onItemClicked: (path) => console.log(path)
}
```

## Form field names

```qml
Md3Form {
    id: form
    requiredFields: ["email"]
    Md3TextField { name: "email"; label: qsTr("Email") }
    Md3Button {
        text: qsTr("Save")
        onClicked: form.validate()  // sets errorText on named fields
    }
}
```

## Snackbar (no Window.host glue)

```qml
Md3Notify.snackbar(qsTr("Saved"), { actionText: qsTr("Undo") })
```

Requires `Md3ApplicationWindow` or any `Md3SnackbarHost` in the tree (auto-registers).
