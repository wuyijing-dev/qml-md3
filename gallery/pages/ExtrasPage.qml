import QtQuick
import QtQuick.Layouts
import Md3

Flickable {
    contentWidth: width
    contentHeight: column.height
    clip: true
    ColumnLayout {
        id: column
        width: parent.width
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
        Md3DataTable {
            Layout.fillWidth: true
            columns: [
                { title: "Name", role: "name", width: 140 },
                { title: "Role", role: "role", width: 120 },
                { title: "Status", role: "status", width: 100 }
            ]
            rows: [
                { name: "Ada", role: "Admin", status: "Active" },
                { name: "Alan", role: "Editor", status: "Away" },
                { name: "Grace", role: "Viewer", status: "Active" }
            ]
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
    }
}
