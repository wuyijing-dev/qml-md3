import QtQuick

Item {
    id: root

    enum Size { Small, Regular, Large }
    enum ColorRole { Primary, Secondary, Tertiary, Surface }

    property int size: Md3Fab.Regular
    property int colorRole: Md3Fab.Primary
    property string icon: "add"
    /// Degrees applied to the glyph (FAB menu uses 45° when open).
    property real iconRotation: 0
    property bool enabled: true
    property string accessibleName: "Floating action button"
    property string tooltip: ""

    signal clicked()

    readonly property real fabSize: {
        switch (size) {
        case Md3Fab.Small: return 40
        case Md3Fab.Large: return 96
        default: return 56
        }
    }
    readonly property real corner: {
        switch (size) {
        case Md3Fab.Small: return Md3Theme.shape.medium
        case Md3Fab.Large: return Md3Theme.shape.extraLarge
        default: return Md3Theme.shape.large
        }
    }
    readonly property real iconSize: size === Md3Fab.Large ? 36 : 24
    property real shadowPad: 28 // set lower in dense layouts (e.g. FAB menu)

    readonly property color containerColor: {
        if (!enabled)
            return Md3Theme.colorScheme.disabledContainer()
        switch (colorRole) {
        case Md3Fab.Secondary: return Md3Theme.colorScheme.secondaryContainer
        case Md3Fab.Tertiary: return Md3Theme.colorScheme.tertiaryContainer
        case Md3Fab.Surface: return Md3Theme.colorScheme.surfaceContainerHigh
        default: return Md3Theme.colorScheme.primaryContainer
        }
    }
    readonly property color contentColor: {
        if (!enabled)
            return Md3Theme.colorScheme.disabledContent()
        switch (colorRole) {
        case Md3Fab.Secondary: return Md3Theme.colorScheme.colorOnSecondaryContainer
        case Md3Fab.Tertiary: return Md3Theme.colorScheme.colorOnTertiaryContainer
        case Md3Fab.Surface: return Md3Theme.colorScheme.primary
        default: return Md3Theme.colorScheme.colorOnPrimaryContainer
        }
    }

    readonly property bool hovered: mouse.containsMouse
    readonly property bool pressed: mouse.pressed
    readonly property bool focused: activeFocus
    readonly property real elev: {
        if (!enabled)
            return 0
        if (hovered && !pressed)
            return 8
        return 6
    }

    implicitWidth: Math.max(48, fabSize) + shadowPad * 2
    implicitHeight: Math.max(48, fabSize) + shadowPad * 2
    width: implicitWidth
    height: implicitHeight

    activeFocusOnTab: enabled
    Accessible.name: accessibleName
    Accessible.role: Accessible.Button
    Accessible.onPressAction: if (enabled) root.clicked()

    Keys.onReturnPressed: if (enabled) clicked()
    Keys.onEnterPressed: if (enabled) clicked()
    Keys.onSpacePressed: if (enabled) clicked()

    Md3Shadow {
        anchors.centerIn: parent
        width: fabSize
        height: fabSize
        elevation: root.elev
        cornerRadius: root.corner
    }

    Rectangle {
        id: bg
        anchors.centerIn: parent
        width: root.fabSize
        height: root.fabSize
        radius: root.corner
        color: root.containerColor
        clip: true

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: Md3Theme.colorScheme.surfaceTint
            opacity: Md3Theme.elevation.tintOpacity(root.elev)
            visible: root.enabled
        }

        Md3Ripple {
            id: ripple
            rippleColor: root.contentColor
            clipRadius: root.corner
        }

        Md3StateOverlay {
            overlayColor: root.contentColor
            hovered: root.hovered
            focused: root.focused
            pressed: root.pressed
            controlEnabled: root.enabled
            radius: root.corner
        }

        Md3Icon {
            anchors.centerIn: parent
            icon: root.icon
            size: root.iconSize
            iconColor: root.contentColor
            rotation: root.iconRotation
            Behavior on rotation {
                NumberAnimation {
                    duration: Md3Motion.spatialSnapDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.emphasized
                }
            }
        }
    }

    Md3FocusRing {
        anchors.centerIn: parent
        width: bg.width + 6
        height: bg.height + 6
        radius: root.corner + 3
        focused: root.focused
        controlEnabled: root.enabled
    }

    MouseArea {
        id: mouse
        anchors.centerIn: parent
        width: Math.max(48, root.fabSize)
        height: Math.max(48, root.fabSize)
        hoverEnabled: true
        enabled: root.enabled
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: function (mouse) {
            const ox = mouse.x - (width - bg.width) / 2
            const oy = mouse.y - (height - bg.height) / 2
            ripple.pulse(ox, oy)
            root.forceActiveFocus()
            root.clicked()
        }
    }
}
