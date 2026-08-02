import QtQuick
import Md3

/// Compact persistent status line (index health, cache, non-alert state).
Item {
    id: root

    property string icon: ""
    property string text: ""
    property string secondaryText: ""
    property string actionText: ""

    signal actionClicked()

    implicitHeight: row.implicitHeight
    implicitWidth: row.implicitWidth
    height: implicitHeight

    Row {
        id: row
        spacing: 8

        Md3Icon {
            visible: root.icon.length > 0
            icon: root.icon
            size: 18
            iconColor: Md3Theme.colorScheme.colorOnSurfaceVariant
            anchors.verticalCenter: parent.verticalCenter
        }

        Column {
            spacing: 0
            anchors.verticalCenter: parent.verticalCenter
            Md3Text {
                text: root.text
                role: Md3Text.BodyMedium
                visible: root.text.length > 0
            }
            Md3Text {
                text: root.secondaryText
                role: Md3Text.BodySmall
                tone: Md3Text.OnSurfaceVariant
                visible: root.secondaryText.length > 0
            }
        }

        Md3Button {
            visible: root.actionText.length > 0
            text: root.actionText
            variant: Md3Button.Text
            anchors.verticalCenter: parent.verticalCenter
            onClicked: root.actionClicked()
        }
    }
}
