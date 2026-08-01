import QtQuick
import Md3

Md3AbstractButton {
    id: root

    property string avatarIcon: ""

    accessibleName: text
    pressRightMargin: 32
    cornerRadius: Md3Theme.shape.small
    containerColor: enabled ? Md3Theme.colorScheme.surfaceContainerLow
                            : Md3Theme.colorScheme.disabledContainer()
    contentColor: enabled ? Md3Theme.colorScheme.colorOnSurfaceVariant
                          : Md3Theme.colorScheme.disabledContent()

    pressTarget: bg
    onPressFeedback: function (x, y) { ripple.pulse(x, y) }

    signal removed()

    implicitHeight: Md3Theme.chipHeight
    implicitWidth: row.implicitWidth + 4
    height: implicitHeight
    width: implicitWidth

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: root.cornerRadius
        color: root.containerColor
        clip: true

        Md3Ripple { id: ripple; rippleColor: root.contentColor; clipRadius: bg.radius }
        Md3StateOverlay {
            overlayColor: root.contentColor
            hovered: root.hovered
            pressed: root.pressed
            focused: root.activeFocus && root.visualFocus
            controlEnabled: root.enabled
            radius: bg.radius
        }

        Row {
            id: row
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: root.avatarIcon.length > 0 ? 4 : 12
            spacing: 8

            Rectangle {
                visible: root.avatarIcon.length > 0
                width: 24
                height: 24
                radius: 12
                color: Md3Theme.colorScheme.primaryContainer
                anchors.verticalCenter: parent.verticalCenter
                Md3Icon {
                    anchors.centerIn: parent
                    icon: root.avatarIcon
                    size: 16
                    iconColor: Md3Theme.colorScheme.colorOnPrimaryContainer
                }
            }

            Md3Text {
                text: root.text
                role: Md3Text.LabelLarge
                tone: Md3Text.Custom
                customColor: root.contentColor
                anchors.verticalCenter: parent.verticalCenter
            }

            Item {
                width: 32
                height: 32
                anchors.verticalCenter: parent.verticalCenter
                Md3Icon {
                    anchors.centerIn: parent
                    icon: "close"
                    size: 18
                    iconColor: root.contentColor
                }
            }
        }
    }

    MouseArea {
        id: removeMouse
        width: 32
        height: parent.height
        anchors.right: parent.right
        z: 2
        enabled: root.enabled
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onClicked: root.removed()
    }
}
