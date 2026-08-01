import QtQuick
import Md3

Md3Page {
    id: page

    function _galleryWindow() {
        const w = hostWindow()
        return (w && w.galleryTableSelection !== undefined) ? w : null
    }

    function _syncGalleryStatus() {
        const w = _galleryWindow()
        if (!w)
            return
        w.galleryTableSelection = tableDemo.selectedIndices.length
        w.galleryTableLoading = tableDemo.loading
        if (treeDemo.selectedIndex >= 0 && treeDemo.flatRows[treeDemo.selectedIndex]) {
            const n = treeDemo.flatRows[treeDemo.selectedIndex].node
            w.galleryTreeSelection = n && n.title ? qsTr("Tree: %1").arg(n.title) : ""
        } else {
            w.galleryTreeSelection = ""
        }
    }

    Component.onCompleted: _syncGalleryStatus()

    Flickable {
        id: flick
        anchors.fill: parent
        contentWidth: width
        contentHeight: column.implicitHeight
        clip: true

        Md3VStack {
            id: column
            width: flick.width
            spacing: 16
            Md3Text {
                text: "Enterprise extras"
                role: Md3Text.HeadlineMedium
            }
            Md3Banner {
                width: parent.width
                text: "Your password expires in 3 days."
                primaryAction: "Update"
                secondaryAction: "Dismiss"
            }

            Md3Text {
                text: qsTr("Avatar")
                role: Md3Text.LabelLarge
                tone: Md3Text.OnSurfaceVariant
            }
            Md3HStack {
                spacing: 12
                Md3Avatar { initials: "AD"; sizePreset: Md3Avatar.Small }
                Md3Avatar { initials: "ML"; sizePreset: Md3Avatar.Medium }
                Md3Avatar { icon: "person"; sizePreset: Md3Avatar.Large }
                Md3AvatarGroup {
                    maxVisible: 3
                    model: [
                        { initials: "A" },
                        { initials: "B" },
                        { initials: "C" },
                        { initials: "D" },
                        { initials: "E" }
                    ]
                }
            }

            Md3Text {
                text: qsTr("Empty state")
                role: Md3Text.LabelLarge
                tone: Md3Text.OnSurfaceVariant
            }
            Md3EmptyState {
                width: parent.width
                height: 220
                icon: "search_off"
                title: qsTr("No results")
                body: qsTr("Try a different filter or clear your search.")
                actionText: qsTr("Clear filters")
                onActionClicked: console.log("empty-state CTA")
            }

            Md3Tooltip {
                text: "Tooltip label"
                Md3Button { text: "Hover me" }
            }
            Md3ExpansionTile {
                width: parent.width
                title: "Advanced"
                subtitle: "More options"
                Md3Text {
                    text: "Expanded content"
                    tone: Md3Text.OnSurfaceVariant
                    leftPadding: 16
                }
            }
            Md3Stepper {
                id: stepperDemo
                width: parent.width
                height: 220
                currentStep: 0
                model: [
                    { title: "Details" },
                    { title: "Review" },
                    { title: "Confirm" }
                ]
                onFinished: Md3Notify.snackbar(qsTr("Stepper finished"))
                Item {
                    Md3VStack {
                        anchors.centerIn: parent
                        spacing: 8
                        Md3Text {
                            text: qsTr("Enter details")
                            role: Md3Text.BodyMedium
                        }
                        Md3TextField {
                            width: 240
                            label: qsTr("Name")
                            placeholderText: qsTr("Ada Lovelace")
                        }
                    }
                }
                Item {
                    Md3Text {
                        anchors.centerIn: parent
                        text: qsTr("Review your choices")
                        role: Md3Text.BodyMedium
                        tone: Md3Text.OnSurfaceVariant
                    }
                }
                Item {
                    Md3Text {
                        anchors.centerIn: parent
                        text: qsTr("Confirm and finish")
                        role: Md3Text.BodyMedium
                        tone: Md3Text.OnSurfaceVariant
                    }
                }
            }

            Md3Text {
                text: qsTr("Tree view")
                role: Md3Text.LabelLarge
                tone: Md3Text.OnSurfaceVariant
            }
            Md3Card {
                variant: Md3Card.Outlined
                width: parent.width
                height: 480
                Md3TreeView {
                    id: treeDemo
                    anchors.fill: parent
                    anchors.margins: 8
                    showConnectors: true
                    checkEnabled: true
                    showFilter: true
                    showExpandControls: true
                    filterLabel: qsTr("Filter tree")
                    filterPlaceholder: qsTr("Type to search nodes")
                    onActivated: function (idx, node) {
                        _syncGalleryStatus()
                        const w = _galleryWindow()
                        if (w)
                            w.showStatusMessage(qsTr("Activated %1").arg(node.title))
                    }
                    onCheckedChanged: _syncGalleryStatus()
                    model: [
                        {
                            title: qsTr("Workspace"),
                            icon: "folder",
                            expanded: true,
                            children: [
                                { title: qsTr("src"), icon: "folder", expanded: true, children: [
                                    { title: "main.cpp", icon: "description" },
                                    { title: "app.cpp", icon: "description" },
                                    { title: "window.cpp", icon: "description" },
                                    { title: "CMakeLists.txt", icon: "description" }
                                ]},
                                { title: qsTr("resources"), icon: "folder", expanded: true, children: [
                                    { title: "icons", icon: "image" },
                                    { title: "fonts", icon: "font_download" },
                                    { title: "i18n", icon: "translate" }
                                ]},
                                { title: qsTr("tests"), icon: "folder", children: [
                                    { title: "smoke", icon: "science" },
                                    { title: "baselines", icon: "photo" }
                                ]}
                            ]
                        },
                        {
                            title: qsTr("Settings"),
                            icon: "settings",
                            expanded: true,
                            children: [
                                { title: qsTr("Theme"), icon: "palette" },
                                { title: qsTr("Keyboard"), icon: "keyboard" },
                                { title: qsTr("Accessibility"), icon: "accessibility" }
                            ]
                        }
                    ]
                }
            }

            Md3Text {
                text: qsTr("Path field")
                role: Md3Text.LabelLarge
                tone: Md3Text.OnSurfaceVariant
            }
            Md3PathField {
                id: pathOpenDemo
                width: parent.width
                label: qsTr("Open file")
                mode: Md3PathField.OpenFile
                showBreadcrumb: true
                allowedExtensions: [".qml", ".json", ".md"]
                recentPaths: [
                    "D:/QML_MD3/QML_MD3/gallery/Main.qml",
                    "D:/QML_MD3/QML_MD3/src/Md3/components/Md3DataTable.qml"
                ]
                nameFilters: ["QML files (*.qml)", "All files (*)"]
                dialogTitle: qsTr("Choose a file")
                onAccepted: function (p) {
                    const w = _galleryWindow()
                    if (w)
                        w.showStatusMessage(qsTr("Path: %1").arg(p))
                }
            }
            Md3PathField {
                width: parent.width
                label: qsTr("Open multiple files")
                mode: Md3PathField.OpenFiles
                dialogTitle: qsTr("Choose files")
            }
            Md3PathField {
                width: parent.width
                label: qsTr("Output folder")
                mode: Md3PathField.Folder
                showBreadcrumb: true
                dialogTitle: qsTr("Choose a folder")
            }

            Md3Text {
                text: qsTr("File drop zone")
                role: Md3Text.LabelLarge
                tone: Md3Text.OnSurfaceVariant
            }
            Md3FileDropZone {
                id: dropDemo
                width: parent.width
                height: 280
                tableBodyHeight: 180
                acceptedExtensions: [".qml", ".json", ".md", ".txt", ".png", ".jpg", ".zip"]
                onFilesDropped: function (items) {
                    Md3Notify.toast(qsTr("Added %1 file(s)").arg(items.length), {
                        severity: Md3Toast.Success,
                        position: Md3ToastHost.TopRight
                    })
                }
            }

            Md3Text {
                text: qsTr("Virtual list")
                role: Md3Text.LabelLarge
                tone: Md3Text.OnSurfaceVariant
            }
            Md3Card {
                variant: Md3Card.Outlined
                width: parent.width
                height: 260
                padding: 8
                Md3VirtualList {
                    id: virtualDemo
                    anchors.fill: parent
                    itemHeight: 40
                    model: {
                        const rows = []
                        for (let i = 0; i < 5000; ++i)
                            rows.push({ title: qsTr("Log row %1").arg(i + 1) })
                        return rows
                    }
                    onCurrentIndexChangedByUser: function (index, item) {
                        const w = _galleryWindow()
                        if (w)
                            w.showStatusMessage(qsTr("Focused item %1").arg(index + 1))
                    }
                }
            }

            Md3Text {
                text: qsTr("ListView — groups + multi-select")
                role: Md3Text.LabelLarge
                tone: Md3Text.OnSurfaceVariant
            }
            Md3Card {
                variant: Md3Card.Outlined
                width: parent.width
                height: 280
                padding: 0
                Md3ListView {
                    anchors.fill: parent
                    anchors.margins: 4
                    itemHeight: 52
                    sectionRole: "group"
                    selectionMode: Md3ListView.Multiple
                    model: [
                        { title: "Ada", subtitle: "Admin", group: "A" },
                        { title: "Alan", subtitle: "Editor", group: "A" },
                        { title: "Barbara", subtitle: "Editor", group: "B" },
                        { title: "Grace", subtitle: "Viewer", group: "G" },
                        { title: "Linus", subtitle: "Admin", group: "L" },
                        { title: "Margaret", subtitle: "Lead", group: "M" }
                    ]
                    onSelectionChanged: {
                        const w = _galleryWindow()
                        if (w)
                            w.showStatusMessage(qsTr("%1 selected").arg(selectedIndices.length))
                    }
                }
            }

            Md3Text {
                text: qsTr("GridView + ItemsView")
                role: Md3Text.LabelLarge
                tone: Md3Text.OnSurfaceVariant
            }
            Md3SegmentedButton {
                id: itemsLayout
                model: [{ text: qsTr("Stack") }, { text: qsTr("Grid") }]
                currentIndex: 1
            }
            Md3Card {
                variant: Md3Card.Outlined
                width: parent.width
                height: 260
                padding: 8
                Md3ItemsView {
                    anchors.fill: parent
                    layout: itemsLayout.currentIndex === 0 ? Md3ItemsView.Stack : Md3ItemsView.Grid
                    cellWidth: 120
                    cellHeight: 110
                    selectionMode: Md3ListView.Single
                    model: [
                        { title: "Photos", icon: "photo" },
                        { title: "Music", icon: "music_note" },
                        { title: "Files", icon: "folder" },
                        { title: "Mail", icon: "mail" },
                        { title: "Maps", icon: "map" },
                        { title: "Settings", icon: "settings" }
                    ]
                }
            }

            Md3Text {
                text: qsTr("Swipe actions (leading + trailing · ←/→ keyboard · exclusive)")
                role: Md3Text.LabelLarge
                tone: Md3Text.OnSurfaceVariant
            }
            Md3Card {
                variant: Md3Card.Outlined
                width: parent.width
                padding: 0
                Md3VStack {
                    width: parent.width
                    spacing: 0
                    Md3SwipeReveal {
                        width: parent.width
                        height: 72
                        panelColor: Md3Theme.colorScheme.surfaceContainerLow
                        leadingActions: [
                            { icon: "mark_email_read", label: qsTr("Read") }
                        ]
                        trailingActions: [
                            { icon: "archive", label: qsTr("Archive") },
                            { icon: "delete", label: qsTr("Delete"), destructive: true }
                        ]
                        onActionTriggered: function (i, leading) {
                            const w = _galleryWindow()
                            if (w)
                                w.showStatusMessage(qsTr("%1 action %2")
                                                    .arg(leading ? qsTr("Leading") : qsTr("Trailing"))
                                                    .arg(i))
                        }
                        Md3ListTile {
                            anchors.fill: parent
                            title: qsTr("Inbox message")
                            subtitle: qsTr("Swipe either way · Tab then ←/→")
                            leadingIcon: "mail"
                            showDivider: true
                        }
                    }
                    Md3SwipeReveal {
                        width: parent.width
                        height: 72
                        panelColor: Md3Theme.colorScheme.surface
                        leadingActions: [
                            { icon: "push_pin", label: qsTr("Pin") }
                        ]
                        trailingActions: [
                            { icon: "flag", label: qsTr("Flag") }
                        ]
                        onActionTriggered: function (i, leading) {
                            const w = _galleryWindow()
                            if (w)
                                w.showStatusMessage(qsTr("%1 #%2")
                                                    .arg(leading ? qsTr("Pin/Read side") : qsTr("Flag side"))
                                                    .arg(i))
                        }
                        Md3ListTile {
                            anchors.fill: parent
                            title: qsTr("Another item")
                            subtitle: qsTr("Opening one closes the other")
                            leadingIcon: "inbox"
                        }
                    }
                }
            }

            Md3Text {
                text: qsTr("Data table")
                role: Md3Text.LabelLarge
                tone: Md3Text.OnSurfaceVariant
            }
            Md3HStack {
                width: parent.width
                spacing: 8
                Md3Button {
                    text: tableDemo.loading ? qsTr("Stop loading") : qsTr("Loading")
                    variant: Md3Button.Outlined
                    onClicked: {
                        tableDemo.loading = !tableDemo.loading
                        _syncGalleryStatus()
                    }
                }
                Md3Button {
                    text: tableDemo.density === Md3DataTable.Compact ? qsTr("Comfortable") : qsTr("Compact")
                    variant: Md3Button.Text
                    onClicked: tableDemo.density = tableDemo.density === Md3DataTable.Compact
                            ? Md3DataTable.Comfortable : Md3DataTable.Compact
                }
                Md3Button {
                    text: qsTr("Clear selection")
                    variant: Md3Button.Text
                    enabled: tableDemo.selectedIndices.length > 0
                    onClicked: tableDemo.clearSelection()
                }
                Md3Spacer { expand: true }
                Md3Text {
                    text: qsTr("Frozen · filter · F2 / double-click edit Notes")
                    role: Md3Text.BodySmall
                    tone: Md3Text.OnSurfaceVariant
                    elide: Text.ElideRight
                }
            }
            Md3DataTable {
                id: tableDemo
                width: parent.width
                height: 460
                selectionEnabled: true
                pagination: true
                pageSize: 5
                bodyHeight: 300
                columnResizeEnabled: true
                frozenColumnCount: 1
                showFilterBar: true
                keyboardNavigationEnabled: true
                columnFilters: ({ status: statusFilter.text })
                columns: [
                    { title: "Name", role: "name", width: 140, type: "avatar" },
                    { title: "Role", role: "role", width: 120, editable: true },
                    {
                        title: "Status", role: "status", width: 120, type: "chip",
                        chipIconMap: { "Active": "check_circle", "Away": "schedule" }
                    },
                    { title: "OK", role: "ok", width: 64, type: "check" },
                    { title: "Score", role: "score", width: 80 },
                    { title: "Team", role: "team", width: 120 },
                    { title: "Notes", role: "notes", width: 160, editable: true }
                ]
                rows: [
                    { name: "Ada", role: "Admin", status: "Active", ok: true, score: 98, team: "Platform", notes: "Core owner" },
                    { name: "Alan", role: "Editor", status: "Away", ok: false, score: 72, team: "Docs", notes: "Review queue" },
                    { name: "Grace", role: "Viewer", status: "Active", ok: true, score: 88, team: "Design", notes: "" },
                    { name: "Linus", role: "Admin", status: "Active", ok: true, score: 91, team: "Kernel", notes: "On-call" },
                    { name: "Barbara", role: "Editor", status: "Away", ok: false, score: 65, team: "Docs", notes: "" },
                    { name: "Dennis", role: "Viewer", status: "Active", ok: true, score: 77, team: "Tools", notes: "" },
                    { name: "Ken", role: "Admin", status: "Away", ok: false, score: 84, team: "Platform", notes: "" },
                    { name: "Margaret", role: "Editor", status: "Active", ok: true, score: 95, team: "Design", notes: "Lead" },
                    { name: "Donald", role: "Viewer", status: "Away", ok: false, score: 58, team: "Research", notes: "" },
                    { name: "Edsger", role: "Admin", status: "Active", ok: true, score: 89, team: "Research", notes: "" },
                    { name: "Tony", role: "Editor", status: "Active", ok: true, score: 81, team: "Tools", notes: "" },
                    { name: "Niklaus", role: "Viewer", status: "Away", ok: false, score: 70, team: "Platform", notes: "" }
                ]
                rowActions: [
                    { id: "edit", text: qsTr("Edit"), icon: "edit" },
                    { id: "duplicate", text: qsTr("Duplicate"), icon: "content_copy" },
                    { id: "delete", text: qsTr("Delete"), icon: "delete" }
                ]
                emptyTitle: qsTr("No people")
                emptyBody: qsTr("Add a row to get started.")
                emptyActionText: qsTr("Reload sample")
                onEmptyActionClicked: console.log("reload")
                onSelectionChanged: _syncGalleryStatus()
                onCellEdited: function (sourceIndex, role, newValue) {
                    const w = _galleryWindow()
                    if (w)
                        w.showStatusMessage(qsTr("Edited %1 → %2").arg(role).arg(newValue))
                }
                onRowDoubleClicked: function (sourceIndex) {
                    const w = _galleryWindow()
                    if (w)
                        w.showStatusMessage(qsTr("Opened row %1").arg(sourceIndex))
                }
                onRowActionTriggered: function (sourceIndex, action) {
                    console.log("row action", sourceIndex, action.id || action.text)
                }
            }
            Md3TextField {
                id: statusFilter
                width: parent.width
                label: qsTr("Status column filter")
                placeholderText: qsTr("e.g. Active")
                onTextChanged: tableDemo.columnFilters = ({ status: text })
            }

            Md3Text {
                text: qsTr("Carousel")
                role: Md3Text.TitleMedium
            }
            Md3Carousel {
                width: parent.width
                itemHeight: 180
                peekRatio: 0.14
                autoPlay: true
                autoPlayInterval: 4500
                model: [
                    {
                        title: qsTr("主推"),
                        subtitle: qsTr("左右滑动，可预览下一页"),
                        color: Md3Theme.colorScheme.primary
                    },
                    {
                        title: qsTr("次要"),
                        subtitle: qsTr("指示点可跳转"),
                        color: Md3Theme.colorScheme.secondary
                    },
                    {
                        title: qsTr("强调"),
                        subtitle: qsTr("支持自动轮播"),
                        color: Md3Theme.colorScheme.tertiary
                    }
                ]
            }

            Md3Text {
                text: qsTr("FlipView + PipsPager")
                role: Md3Text.LabelLarge
                tone: Md3Text.OnSurfaceVariant
            }
            Md3Carousel {
                width: parent.width
                mode: Md3Carousel.Flip
                itemHeight: 160
                autoPlay: false
                model: [
                    { title: qsTr("Page 1"), subtitle: qsTr("Full-bleed flip"), color: Md3Theme.colorScheme.primaryContainer },
                    { title: qsTr("Page 2"), subtitle: qsTr("Snap one item"), color: Md3Theme.colorScheme.secondaryContainer },
                    { title: qsTr("Page 3"), subtitle: qsTr("Pips below"), color: Md3Theme.colorScheme.tertiaryContainer }
                ]
            }
            Md3PipsPager {
                anchors.horizontalCenter: parent.horizontalCenter
                count: 5
                currentIndex: 2
                style: Md3PipsPager.Dot
            }

            Md3Text {
                text: qsTr("Skeleton")
                role: Md3Text.TitleMedium
            }
            Md3Card {
                variant: Md3Card.Outlined
                width: parent.width
                height: 220
                Md3SkeletonPane {
                    anchors.fill: parent
                    anchors.margins: 16
                    layout: "page"
                }
            }
            Md3HStack {
                id: skeletonRow
                width: parent.width
                spacing: 12
                Md3Skeleton { variant: Md3Skeleton.Circular; width: 48; height: 48 }
                Md3Skeleton {
                    variant: Md3Skeleton.Text
                    width: Math.max(0, skeletonRow.width - 48 - 72 - skeletonRow.spacing * 2)
                    height: 14
                }
                Md3Skeleton { variant: Md3Skeleton.Rounded; width: 72; height: 32 }
            }

            Item { width: parent.width; height: 24 }
        }
    }

    Md3ContextMenuArea {
        anchors.fill: parent
        menuWidth: 220
        contextMenu: pageCtxMenu
    }

    Md3Menu {
        id: pageCtxMenu
        menuWidth: 220

        Md3MenuItem {
            text: qsTr("Refresh table")
            icon: "refresh"
            onClicked: {
                tableDemo.loading = true
                refreshTimer.start()
            }
        }
        Md3MenuItem {
            text: qsTr("Clear selection")
            icon: "deselect"
            enabled: tableDemo.selectedIndices.length > 0
            onClicked: tableDemo.clearSelection()
        }
        Md3MenuDivider {}
        Md3MenuItem {
            text: qsTr("Copy selection count")
            icon: "content_copy"
            onClicked: console.log("selected", tableDemo.selectedIndices.length)
        }
    }

    Timer {
        id: refreshTimer
        interval: 900
        onTriggered: tableDemo.loading = false
    }
}
