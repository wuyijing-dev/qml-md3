import QtQuick

Item {
    id: root

    property string text: ""
    property bool elevated: false
    property bool enabled: true
    property string accessibleName: text

    signal clicked()

    implicitHeight: 32
    implicitWidth: label.implicitWidth + 24
    height: implicitHeight
    width: implicitWidth
    activeFocusOnTab: enabled
    Accessible.name: accessibleName
    Accessible.role: Accessible.Button

    readonly property color contentColor: enabled ? Md3Theme.colorScheme.colorOnSurfaceVariant
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
        color: root.elevated ? Md3Theme.colorScheme.surfaceContainerLow
                             : (root.enabled ? Md3Theme.colorScheme.surface : Md3Theme.colorScheme.disabledContainer())
        border.width: root.elevated ? 0 : 1
        border.color: Md3Theme.colorScheme.outline
        clip: true

        Md3Ripple { id: ripple; rippleColor: root.contentColor; clipRadius: bg.radius }
        Md3StateOverlay {
            overlayColor: root.contentColor
            hovered: mouse.containsMouse
            focused: root.activeFocus
            pressed: mouse.pressed
            controlEnabled: root.enabled
            radius: bg.radius
        }

        Text {
            id: label
            anchors.centerIn: parent
            text: root.text
            color: root.contentColor
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.scaled(Md3Theme.typography.labelLarge.size)
            font.weight: Md3Theme.typography.labelLarge.weight
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
}
