import QtQuick
import QtQuick.Layouts
import Md3

Item {
    id: page

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
                Text {
                    Layout.fillWidth: true
                    text: treeDemo.selectedIndex >= 0
                          ? qsTr("Selected: %1").arg(treeDemo.flatRows[treeDemo.selectedIndex].node.title)
                          : qsTr("Click a node")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.bodySmall.size
                    elide: Text.ElideRight
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
                Layout.fillWidth: true
                label: qsTr("Open file")
                mode: Md3PathField.OpenFile
                nameFilters: ["QML files (*.qml)", "All files (*)"]
                dialogTitle: qsTr("Choose a file")
            }
            Md3PathField {
                Layout.fillWidth: true
                label: qsTr("Output folder")
                mode: Md3PathField.Folder
                dialogTitle: qsTr("Choose a folder")
            }

            Text {
                text: qsTr("Status bar")
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.labelLarge.size
            }
            Md3Card {
                variant: Md3Card.Outlined
                Layout.fillWidth: true
                Layout.preferredHeight: 36
                clip: true
                Md3StatusBar {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    text: qsTr("Ready — 12 files indexed")
                    leadingIcon: "info"
                    progress: 0.42
                    Text {
                        text: qsTr("Ln 42, Col 8")
                        color: Md3Theme.colorScheme.colorOnSurfaceVariant
                        font.pixelSize: Md3Theme.typography.labelSmall.size
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        text: "UTF-8"
                        color: Md3Theme.colorScheme.colorOnSurfaceVariant
                        font.pixelSize: Md3Theme.typography.labelSmall.size
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
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
                    onClicked: tableDemo.loading = !tableDemo.loading
                }
                Md3Button {
                    text: qsTr("Clear selection")
                    variant: Md3Button.Text
                    enabled: tableDemo.selectedIndices.length > 0
                    onClicked: tableDemo.clearSelection()
                }
                Text {
                    Layout.fillWidth: true
                    text: tableDemo.selectedIndices.length
                          ? qsTr("%1 selected").arg(tableDemo.selectedIndices.length)
                          : qsTr("Drag column edges to resize · row ⋮ for actions")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.bodySmall.size
                    elide: Text.ElideRight
                }
            }
            Md3DataTable {
                id: tableDemo
                Layout.fillWidth: true
                Layout.preferredHeight: 420
                selectionEnabled: true
                pagination: true
                pageSize: 5
                bodyHeight: 260
                columnResizeEnabled: true
                columns: [
                    { title: "Name", role: "name", width: 140 },
                    { title: "Role", role: "role", width: 120 },
                    { title: "Status", role: "status", width: 100 },
                    { title: "Score", role: "score", width: 80 },
                    { title: "Team", role: "team", width: 120 },
                    { title: "Notes", role: "notes", width: 160 }
                ]
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
                onRowActionTriggered: function (sourceIndex, action) {
                    console.log("row action", sourceIndex, action.id || action.text)
                }
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
