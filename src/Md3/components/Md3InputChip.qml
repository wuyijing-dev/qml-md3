import QtQuick

Item {
    id: root

    property string text: ""
    property string avatarIcon: ""
    property string accessibleName: text

    signal clicked()
    signal removed()

    implicitHeight: 32
    implicitWidth: row.implicitWidth + 4
    height: implicitHeight
    width: implicitWidth
    activeFocusOnTab: enabled
    Accessible.name: accessibleName
    Accessible.role: Accessible.Button

    readonly property color contentColor: enabled ? Md3Theme.colorScheme.colorOnSurfaceVariant
                                                  : Md3Theme.colorScheme.disabledContent()

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: Md3Theme.shape.small
        color: root.enabled ? Md3Theme.colorScheme.surfaceContainerLow
                            : Md3Theme.colorScheme.disabledContainer()
        clip: true

        Md3Ripple { id: ripple; rippleColor: root.contentColor; clipRadius: bg.radius }
        Md3StateOverlay {
            overlayColor: root.contentColor
            hovered: chipMouse.containsMouse
            pressed: chipMouse.pressed
            focused: root.activeFocus
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

            Text {
                text: root.text
                color: root.contentColor
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.scaled(Md3Theme.typography.labelLarge.size)
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
        id: chipMouse
        anchors.fill: parent
        anchors.rightMargin: 32
        hoverEnabled: true
        enabled: root.enabled
        z: 1
        onClicked: function (mouse) {
            ripple.pulse(mouse.x, mouse.y)
            root.forceActiveFocus()
            root.clicked()
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
