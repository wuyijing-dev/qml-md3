# Reducing glue code

Prefer these component APIs over hand-rolled `Row`/`Column`/`Text` wrappers.

See also [layout.md](layout.md).

## Selection controls

```qml
Md3Switch { text: qsTr("Dark theme"); checked: true }
Md3Checkbox { text: qsTr("Remember me") }
Md3Radio { text: qsTr("Option A"); value: "a"; group: g }
```

## Slider / range

```qml
Md3Slider {
    leadingIcon: "volume_up"
    label: qsTr("Media volume")
    showValue: true
    from: 0; to: 100; value: 42
}

Md3RangeSlider {
    label: qsTr("Price range")
    showValue: true
    from: 0; to: 100; firstValue: 20; secondValue: 70
}
```

`showLabel` on Slider still shows the floating bubble while dragging; `showValue` is the inline header value.

## Radio group

```qml
Md3RadioGroup {
    value: "a"
    model: [
        { text: qsTr("Option A"), value: "a" },
        { text: qsTr("Option B"), value: "b" },
        { text: qsTr("Option C"), value: "c", enabled: false }
    ]
}
```

## Button group

```qml
Md3ButtonGroup {
    layout: Md3ButtonGroup.Connected
    currentIndex: 0
    model: [
        { text: "Left", icon: "format_align_left" },
        { text: "Center", icon: "format_align_center" }
    ]
    // clicks update currentIndex automatically (autoSelect: true)
}
```

## Icon button badge

```qml
Md3IconButton { icon: "notifications"; badgeText: "3" }
Md3IconButton { icon: "favorite"; badgeDot: true }
```

Use `Md3Badged` only when wrapping non-icon content (e.g. a text button).

Nav destinations and TopAppBar trailing icons accept the same fields on model objects:

```qml
Md3NavigationBar {
    model: [
        { icon: "home", label: "Home", badgeDot: true },
        { icon: "mail", label: "Mail", badge: "3" }  // or badgeText / badgeMax
    ]
}
Md3TopAppBar {
    trailingIcons: [
        { icon: "notifications", badgeText: "12" },
        { icon: "more_vert", badgeDot: true }
    ]
}
```

## TabBar pages

```qml
Md3TabBar {
    model: [{ text: "One" }, { text: "Two" }]
    Item { /* page 0 */ }
    Item { /* page 1 */ }
}
```

## Scaffold shell

```qml
Md3Scaffold {
    title: qsTr("Inbox")
    trailingIcons: ["search", "more_vert"]
    navModel: [
        { icon: "mail", label: qsTr("Mail"), badge: "2" },
        { icon: "chat", label: qsTr("Chat") }
    ]
    drawerModel: [ { icon: "inbox", label: qsTr("Inbox") } ]
    /* content */
}
```

Custom `appBar:` / `navigationBar:` / `drawer:` slots still override the built-ins.

## Stepper wizard

```qml
Md3Stepper {
    model: [{ title: "Details" }, { title: "Confirm" }]
    onFinished: Md3Notify.snackbar(qsTr("Done"))
    Item { /* step 0 */ }
    Item { /* step 1 */ }
}
```

## DataTable cell types

```qml
columns: [
    { title: "Name", role: "name", type: "avatar" },
    { title: "Status", role: "status", type: "chip",
      chipIconMap: { "Active": "check_circle", "Away": "schedule" } },
    { title: "OK", role: "ok", type: "check" }
]
```

Types: `text` (default), `chip`, `avatar`, `check`. Use `cellDelegate` only for custom cells.

## List tile

```qml
Md3ListTile {
    title: qsTr("Notifications")
    leadingIcon: "notifications"
    showDivider: true
    trailing: Md3Switch { checked: true }
}

Md3ListTile {
    title: qsTr("Alex Chen")
    subtitle: qsTr("Design lead")
    leadingAvatar: "AC"          // or leadingAvatarSource: "…"
    // leading: Md3Avatar { … }  // custom leading slot
}
```

## Cards & sections

```qml
Md3Card {
    title: qsTr("Storage")
    subtitle: qsTr("Local cache")
    actions: [{ text: qsTr("Reset"), variant: "outlined" }]
    onActionClicked: (i) => console.log(i)
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
    // Built-in vertical stack — no Md3VStack / width: parent.width glue
    Md3TextField { name: "email"; label: qsTr("Email") }
    Md3Button {
        text: qsTr("Save")
        onClicked: form.validate()  // sets errorText on named fields
    }
}
```

## Search

```qml
Md3SearchBar { searchView: fullScreenSearch }
Md3SearchView {
    id: fullScreenSearch
    suggestions: ["Material Design", "QML tokens"]
}
```

## Tree view filter

```qml
Md3TreeView {
    showFilter: true
    showExpandControls: true
    filterPlaceholder: qsTr("Search nodes")
    model: [ /* … */ ]
}
```

## Date / time fields

```qml
Md3DateField { label: qsTr("Due date"); selectedDate: new Date() }
Md3TimeField { label: qsTr("Start"); hour: 10; minute: 30 }
```

## Tag / password fields

```qml
Md3TagField {
    label: qsTr("Recipients")
    tags: ["ada@example.com"]
    // Enter / comma commits; Backspace removes last
}

Md3PasswordField {
    label: qsTr("Password")
    showStrength: true
}
```

## Feedback: Toast vs InfoBar vs Snackbar

| | **Toast** | **InfoBar** | **Snackbar** |
|--|-----------|-------------|--------------|
| Placement | Top-center | In-page flow | Bottom queue |
| Lifetime | Short (~2s) | Until dismissed | Timed + queue |
| Actions | No | Optional action | Optional action |
| Use for | Quick confirm (“Copied”) | Persistent status | Undo / recoverable ops |

```qml
Md3Notify.toast(qsTr("Copied"), { severity: Md3Toast.Success })
Md3InfoBar {
    severity: Md3InfoBar.Warning
    title: qsTr("Storage low")
    message: qsTr("Free up space…")
    actionText: qsTr("Manage")
}
Md3Notify.snackbar(qsTr("Saved"), { actionText: qsTr("Undo") })
Md3Notify.snackbar(qsTr("Urgent"), { priority: 10 })
```

Requires `Md3ApplicationWindow` (hosts auto-register) or place `Md3ToastHost` / `Md3SnackbarHost`.

## ScrollView

```qml
Md3ScrollView {
    Layout.fillWidth: true
    Layout.preferredHeight: 200
    Column {
        width: parent.width
        spacing: 8
        Repeater {
            model: 20
            Text { text: "Row " + (index + 1); color: Md3Theme.colorScheme.colorOnSurface }
        }
    }
}
```

## Gauge / sparkline / heatmap

```qml
Md3Gauge { value: 72; label: qsTr("CPU"); unit: "%" }
Md3Sparkline { values: [12, 18, 22, 31]; showArea: true; showLastDot: true }
Md3HeatmapChart {
    rowLabels: ["Mon", "Tue"]
    columnLabels: ["AM", "PM"]
    values: [[2, 8], [4, 12]]
}
Md3LineChart { showArea: true; areaEmphasis: true; areaOpacity: 0.35 }
```

## Snackbar (no Window.host glue)

```qml
Md3Notify.snackbar(qsTr("Saved"), { actionText: qsTr("Undo") })
Md3Notify.snackbar(qsTr("Urgent"), { priority: 10 })  // jumps ahead in the queue
```

Requires `Md3ApplicationWindow` or any `Md3SnackbarHost` in the tree (auto-registers).
