import QtQuick

Item {
    id: root

    enum Variant { Elevated, Filled, Outlined }

    property int variant: Md3Card.Elevated
    property bool clickable: false
    // Use Item.enabled (do not redeclare — Qt 6.11 warns on override)
    property real padding: 16
    property int layoutMode: Md3ContainerBody.Fit
    default property alias content: contentHost.content

    signal clicked()

    // Intrinsic only — never bind width/height to implicit* (Layout + fill children loop).
    implicitWidth: Math.max(280, contentHost.contentImplicitWidth + padding * 2)
    implicitHeight: contentHost.contentImplicitHeight + padding * 2

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

        Md3ContainerBody {
            id: contentHost
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: root.padding
            layoutMode: root.layoutMode
            // Explicit card height (Layouts) → fill; otherwise size to children only.
            height: root.height >= root.padding * 2 + 1
                    ? root.height - root.padding * 2
                    : implicitHeight
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
