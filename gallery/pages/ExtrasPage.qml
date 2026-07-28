import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import Md3

Item {
    id: page

    function _galleryWindow() {
        const w = Window.window
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
        contentHeight: column.height
        clip: true

        ColumnLayout {
            id: column
            width: flick.width
            spacing: 16
            Text {
                text: "Enterprise extras"
                color: Md3Theme.colorScheme.colorOnSurface
                font.pixelSize: Md3Theme.typography.headlineMedium.size
            }
            Md3Banner {
                Layout.fillWidth: true
                text: "Your password expires in 3 days."
                primaryAction: "Update"
                secondaryAction: "Dismiss"
            }

            Text {
                text: qsTr("Avatar")
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.labelLarge.size
            }
            Row {
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

            Text {
                text: qsTr("Empty state")
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.labelLarge.size
            }
            Md3EmptyState {
                Layout.fillWidth: true
                Layout.preferredHeight: 220
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
                Layout.fillWidth: true
                title: "Advanced"
                subtitle: "More options"
                Text {
                    text: "Expanded content"
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    leftPadding: 16
                }
            }
            Md3Stepper {
                Layout.fillWidth: true
                currentStep: 1
                model: [
                    { title: "Details" },
                    { title: "Review" },
                    { title: "Confirm" }
                ]
            }

            Text {
                text: qsTr("Tree view")
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.labelLarge.size
            }
            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                Md3TextField {
                    Layout.fillWidth: true
                    label: qsTr("Filter tree")
                    placeholderText: qsTr("Type to search nodes")
                    text: treeDemo.filterText
                    onTextChanged: treeDemo.filterText = text
                }
                Md3Button {
                    text: qsTr("Expand all")
                    variant: Md3Button.Text
                    onClicked: treeDemo.expandAll()
                }
                Md3Button {
                    text: qsTr("Collapse all")
                    variant: Md3Button.Text
                    onClicked: treeDemo.collapseAll()
                }
            }
            Md3Card {
                variant: Md3Card.Outlined
                Layout.fillWidth: true
                Layout.preferredHeight: 280
                Md3TreeView {
                    id: treeDemo
                    anchors.fill: parent
                    anchors.margins: 8
                    showConnectors: true
                    checkEnabled: true
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
                                    { title: "CMakeLists.txt", icon: "description" }
                                ]},
                                { title: qsTr("resources"), icon: "folder", children: [
                                    { title: "icons", icon: "image" }
                                ]}
                            ]
                        },
                        {
                            title: qsTr("Settings"),
                            icon: "settings",
                            children: [
                                { title: qsTr("Theme"), icon: "palette" },
                                { title: qsTr("Keyboard"), icon: "keyboard" }
                            ]
                        }
                    ]
                }
            }

            Text {
                text: qsTr("Path field")
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.labelLarge.size
            }
            Md3PathField {
                id: pathOpenDemo
                Layout.fillWidth: true
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
                Layout.fillWidth: true
                label: qsTr("Open multiple files")
                mode: Md3PathField.OpenFiles
                dialogTitle: qsTr("Choose files")
            }
            Md3PathField {
                Layout.fillWidth: true
                label: qsTr("Output folder")
                mode: Md3PathField.Folder
                showBreadcrumb: true
                dialogTitle: qsTr("Choose a folder")
            }

            Text {
                text: qsTr("Data table")
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.labelLarge.size
            }
            RowLayout {
                Layout.fillWidth: true
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
                Text {
                    Layout.fillWidth: true
                    text: qsTr("Frozen col · filter · ↑↓ Enter · double-click row")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.bodySmall.size
                    elide: Text.ElideRight
                }
            }
            Md3DataTable {
                id: tableDemo
                Layout.fillWidth: true
                Layout.preferredHeight: 460
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
                    { title: "Name", role: "name", width: 140 },
                    { title: "Role", role: "role", width: 120 },
                    { title: "Status", role: "status", width: 100 },
                    { title: "Score", role: "score", width: 80 },
                    { title: "Team", role: "team", width: 120 },
                    { title: "Notes", role: "notes", width: 160 }
                ]
                cellDelegate: Component {
                    Item {
                        property var rowData
                        property var columnDef
                        property int columnIndex
                        property string displayText
                        property int sourceIndex
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            leftPadding: 8
                            visible: !columnDef || columnDef.role !== "status"
                            text: displayText
                            color: Md3Theme.colorScheme.colorOnSurface
                            font.pixelSize: Md3Theme.typography.bodyMedium.size
                            elide: Text.ElideRight
                        }
                        Md3AssistChip {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: 8
                            visible: columnDef && columnDef.role === "status"
                            text: displayText
                            icon: displayText === "Active" ? "check_circle" : "schedule"
                        }
                    }
                }
                rows: [
                    { name: "Ada", role: "Admin", status: "Active", score: 98, team: "Platform", notes: "Core owner" },
                    { name: "Alan", role: "Editor", status: "Away", score: 72, team: "Docs", notes: "Review queue" },
                    { name: "Grace", role: "Viewer", status: "Active", score: 88, team: "Design", notes: "" },
                    { name: "Linus", role: "Admin", status: "Active", score: 91, team: "Kernel", notes: "On-call" },
                    { name: "Barbara", role: "Editor", status: "Away", score: 65, team: "Docs", notes: "" },
                    { name: "Dennis", role: "Viewer", status: "Active", score: 77, team: "Tools", notes: "" },
                    { name: "Ken", role: "Admin", status: "Away", score: 84, team: "Platform", notes: "" },
                    { name: "Margaret", role: "Editor", status: "Active", score: 95, team: "Design", notes: "Lead" },
                    { name: "Donald", role: "Viewer", status: "Away", score: 58, team: "Research", notes: "" },
                    { name: "Edsger", role: "Admin", status: "Active", score: 89, team: "Research", notes: "" },
                    { name: "Tony", role: "Editor", status: "Active", score: 81, team: "Tools", notes: "" },
                    { name: "Niklaus", role: "Viewer", status: "Away", score: 70, team: "Platform", notes: "" }
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
                Layout.fillWidth: true
                label: qsTr("Status column filter")
                placeholderText: qsTr("e.g. Active")
                onTextChanged: tableDemo.columnFilters = ({ status: text })
            }

            Text {
                text: qsTr("Carousel")
                color: Md3Theme.colorScheme.colorOnSurface
                font.pixelSize: Md3Theme.typography.titleMedium.size
            }
            Md3Carousel {
                Layout.fillWidth: true
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

            Text {
                text: qsTr("Skeleton")
                color: Md3Theme.colorScheme.colorOnSurface
                font.pixelSize: Md3Theme.typography.titleMedium.size
            }
            Md3Card {
                variant: Md3Card.Outlined
                Layout.fillWidth: true
                Layout.preferredHeight: 220
                Md3SkeletonPane {
                    anchors.fill: parent
                    anchors.margins: 16
                    layout: "page"
                }
            }
            RowLayout {
                Layout.fillWidth: true
                spacing: 12
                Md3Skeleton { variant: Md3Skeleton.Circular; width: 48; height: 48 }
                Md3Skeleton { variant: Md3Skeleton.Text; Layout.fillWidth: true; height: 14 }
                Md3Skeleton { variant: Md3Skeleton.Rounded; width: 72; height: 32 }
            }

            Item { Layout.preferredHeight: 24; Layout.fillWidth: true }
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
