import QtQuick

Item {
    id: root

    enum Variant { Elevated, Filled, Outlined }

    property int variant: Md3Card.Elevated
    property bool clickable: false
    // Use Item.enabled (do not redeclare — Qt 6.11 warns on override)
    property real padding: 16
    property int layoutMode: Md3ContainerBody.Fit
    /// Optional header — when set, users need not nest title Text manually.
    property string title: ""
    property string subtitle: ""
    default property alias content: bodySlot.data

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
            height: root.height >= root.padding * 2 + 1
                    ? root.height - root.padding * 2
                    : implicitHeight

            Md3VStack {
                width: parent.width
                spacing: 8
                fillWidth: true

                Md3Text {
                    visible: root.title.length > 0
                    width: parent.width
                    text: root.title
                    role: Md3Text.TitleMedium
                    wrapMode: Text.WordWrap
                }
                Md3Text {
                    visible: root.subtitle.length > 0
                    width: parent.width
                    text: root.subtitle
                    role: Md3Text.BodyMedium
                    tone: Md3Text.OnSurfaceVariant
                    wrapMode: Text.WordWrap
                }
                Item {
                    id: bodySlot
                    width: parent.width
                    height: childrenRect.height
                    implicitHeight: childrenRect.height
                    implicitWidth: childrenRect.width
                }
            }
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
