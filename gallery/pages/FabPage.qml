import QtQuick
import Md3

Flickable {
    id: root
    contentWidth: width
    contentHeight: column.implicitHeight
    clip: true

    Md3VStack {
        id: column
        width: root.width
        spacing: 24

        Md3Text {
            text: "Floating action buttons"
            role: Md3Text.HeadlineMedium
        }

        Md3Text {
            text: "Sizes × colors"
            role: Md3Text.TitleSmall
            tone: Md3Text.OnSurfaceVariant
        }

        Md3FlowLayout {
            width: parent.width
            spacing: 8
            Md3Fab { size: Md3Fab.Small; colorRole: Md3Fab.Primary; icon: "add" }
            Md3Fab { size: Md3Fab.Regular; colorRole: Md3Fab.Primary; icon: "edit" }
            Md3Fab { size: Md3Fab.Large; colorRole: Md3Fab.Primary; icon: "favorite" }
            Md3Fab { size: Md3Fab.Regular; colorRole: Md3Fab.Secondary; icon: "add" }
            Md3Fab { size: Md3Fab.Regular; colorRole: Md3Fab.Tertiary; icon: "add" }
            Md3Fab { size: Md3Fab.Regular; colorRole: Md3Fab.Surface; icon: "add" }
            Md3Fab { enabled: false; icon: "add" }
        }

        Md3Text {
            text: "FAB menu"
            role: Md3Text.TitleSmall
            tone: Md3Text.OnSurfaceVariant
        }

        Item {
            width: parent.width
            height: 260
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

        Md3Text {
            text: "Extended FAB"
            role: Md3Text.TitleSmall
            tone: Md3Text.OnSurfaceVariant
        }

        Md3HStack {
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
