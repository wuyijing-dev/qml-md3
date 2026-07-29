import QtQuick

Item {
    id: root

    property string text: ""
    property string icon: ""
    property bool elevated: false
    property string accessibleName: text

    signal clicked()

    implicitHeight: 32
    implicitWidth: row.implicitWidth + 16
    height: implicitHeight
    width: implicitWidth
    activeFocusOnTab: enabled
    Accessible.name: accessibleName
    Accessible.role: Accessible.Button

    readonly property color containerColor: {
        if (!enabled)
            return Md3Theme.colorScheme.disabledContainer()
        return elevated ? Md3Theme.colorScheme.surfaceContainerLow
                        : Md3Theme.colorScheme.surface
    }
    readonly property color contentColor: enabled ? Md3Theme.colorScheme.colorOnSurface
                                                  : Md3Theme.colorScheme.disabledContent()

    Md3Shadow {
        anchors.fill: bg
        elevation: root.elevated && root.enabled ? 1 : 0
        cornerRadius: Md3Theme.shape.small
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: Md3Theme.shape.small
        color: root.containerColor
        border.width: root.elevated ? 0 : 1
        border.color: root.enabled ? Md3Theme.colorScheme.outline
                                   : Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSurface, 0.12)
        clip: true

        Md3Ripple {
            id: ripple
            rippleColor: root.contentColor
            clipRadius: bg.radius
        }
        Md3StateOverlay {
            overlayColor: root.contentColor
            hovered: mouse.containsMouse
            focused: root.activeFocus
            pressed: mouse.pressed
            controlEnabled: root.enabled
            radius: bg.radius
        }

        Row {
            id: row
            anchors.centerIn: parent
            spacing: 8
            Md3Icon {
                visible: root.icon.length > 0
                icon: root.icon
                size: 18
                iconColor: root.enabled ? Md3Theme.colorScheme.primary : root.contentColor
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                text: root.text
                color: root.contentColor
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.scaled(Md3Theme.typography.labelLarge.size)
                font.weight: Md3Theme.typography.labelLarge.weight
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        enabled: root.enabled
        onClicked: function (mouse) {
            ripple.pulse(mouse.x, mouse.y)
            root.forceActiveFocus()
            root.clicked()
        }
    }
    Keys.onReturnPressed: if (enabled) clicked()
    Keys.onSpacePressed: if (enabled) clicked()
}
