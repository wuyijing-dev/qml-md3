import QtQuick

Item {
    id: root

    enum Variant { Elevated, Filled, Outlined }

    property int variant: Md3Card.Elevated
    property bool clickable: false
    property bool enabled: true
    default property alias content: contentHost.data

    signal clicked()

    implicitWidth: 280
    implicitHeight: contentHost.implicitHeight + 32
    width: implicitWidth
    height: implicitHeight

    readonly property real elev: variant === Md3Card.Elevated ? 1 : 0
    readonly property color containerColor: {
        switch (variant) {
        case Md3Card.Filled: return Md3Theme.colorScheme.surfaceContainerHighest
        case Md3Card.Outlined: return Md3Theme.colorScheme.surface
        default: return Md3Theme.colorScheme.surfaceContainerLow
        }
    }

    Md3Shadow {
        anchors.fill: bg
        elevation: root.elev
        cornerRadius: Md3Theme.shape.medium
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: Md3Theme.shape.medium
        color: root.containerColor
        border.width: root.variant === Md3Card.Outlined ? 1 : 0
        border.color: Md3Theme.colorScheme.outlineVariant
        clip: true

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: Md3Theme.colorScheme.surfaceTint
            opacity: Md3Theme.elevation.tintOpacity(root.elev)
            visible: root.elev > 0
        }

        Md3StateOverlay {
            visible: root.clickable
            overlayColor: Md3Theme.colorScheme.colorOnSurface
            hovered: mouse.containsMouse
            pressed: mouse.pressed
            controlEnabled: root.enabled && root.clickable
            radius: bg.radius
        }

        Item {
            id: contentHost
            anchors.fill: parent
            anchors.margins: 16
            implicitHeight: childrenRect.height
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        enabled: root.clickable && root.enabled
        hoverEnabled: true
        onClicked: root.clicked()
    }
}
