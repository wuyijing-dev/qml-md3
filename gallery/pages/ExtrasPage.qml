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
                          : qsTr("Right-click page for context menu")
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
                columns: [
                    { title: "Name", role: "name", width: 140 },
                    { title: "Role", role: "role", width: 120 },
                    { title: "Status", role: "status", width: 100 },
                    { title: "Score", role: "score", width: 80 }
                ]
                rows: [
                    { name: "Ada", role: "Admin", status: "Active", score: 98 },
                    { name: "Alan", role: "Editor", status: "Away", score: 72 },
                    { name: "Grace", role: "Viewer", status: "Active", score: 88 },
                    { name: "Linus", role: "Admin", status: "Active", score: 91 },
                    { name: "Barbara", role: "Editor", status: "Away", score: 65 },
                    { name: "Dennis", role: "Viewer", status: "Active", score: 77 },
                    { name: "Ken", role: "Admin", status: "Away", score: 84 },
                    { name: "Margaret", role: "Editor", status: "Active", score: 95 },
                    { name: "Donald", role: "Viewer", status: "Away", score: 58 },
                    { name: "Edsger", role: "Admin", status: "Active", score: 89 },
                    { name: "Tony", role: "Editor", status: "Active", score: 81 },
                    { name: "Niklaus", role: "Viewer", status: "Away", score: 70 }
                ]
                emptyTitle: qsTr("No people")
                emptyBody: qsTr("Add a row to get started.")
                emptyActionText: qsTr("Reload sample")
                onEmptyActionClicked: console.log("reload")
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
