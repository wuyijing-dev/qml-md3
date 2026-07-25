import QtQuick
import QtQuick.Layouts
import Md3

Flickable {
    id: root
    contentWidth: width
    contentHeight: column.height
    clip: true

    ColumnLayout {
        id: column
        width: root.width
        spacing: 24

        Text {
            text: "Floating action buttons"
            color: Md3Theme.colorScheme.colorOnSurface
            font.pixelSize: Md3Theme.typography.headlineMedium.size
            font.family: Md3Theme.typography.fontFamily
        }

        Text {
            text: "Sizes × colors"
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.titleSmall.size
        }

        Flow {
            Layout.fillWidth: true
            spacing: 8
            Md3Fab { size: Md3Fab.Small; colorRole: Md3Fab.Primary; icon: "add" }
            Md3Fab { size: Md3Fab.Regular; colorRole: Md3Fab.Primary; icon: "edit" }
            Md3Fab { size: Md3Fab.Large; colorRole: Md3Fab.Primary; icon: "favorite" }
            Md3Fab { size: Md3Fab.Regular; colorRole: Md3Fab.Secondary; icon: "add" }
            Md3Fab { size: Md3Fab.Regular; colorRole: Md3Fab.Tertiary; icon: "add" }
            Md3Fab { size: Md3Fab.Regular; colorRole: Md3Fab.Surface; icon: "add" }
            Md3Fab { enabled: false; icon: "add" }
        }

        Text {
            text: "FAB menu"
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.titleSmall.size
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 260
            clip: false
            Md3FabMenu {
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.rightMargin: 4
                anchors.bottomMargin: 4
                actionGap: 4
                model: [
                    { icon: "image", text: "Image" },
                    { icon: "mic", text: "Audio" },
                    { icon: "videocam", text: "Video" }
                ]
            }
        }

        Text {
            text: "Extended FAB"
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.titleSmall.size
        }

        Row {
            spacing: 16
            Md3ExtendedFab {
                id: ext
                text: "Create"
                icon: "add"
                extended: true
            }
            Md3Button {
                text: ext.extended ? "Collapse" : "Expand"
                variant: Md3Button.Outlined
                onClicked: ext.extended = !ext.extended
            }
        }
    }
}
