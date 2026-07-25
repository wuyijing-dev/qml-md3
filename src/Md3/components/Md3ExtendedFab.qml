import QtQuick

Item {
    id: root

    enum ColorRole { Primary, Secondary, Tertiary, Surface }

    property int colorRole: Md3ExtendedFab.Primary
    property string icon: "add"
    property string text: "Create"
    property bool extended: true
    property bool enabled: true
    property string accessibleName: text

    signal clicked()

    readonly property real fabHeight: 56
    readonly property real corner: Md3Theme.shape.large
    readonly property real iconSize: 24
    readonly property real padStart: icon.length > 0 ? 16 : 20
    readonly property real padEnd: 20

    readonly property color containerColor: {
        if (!enabled)
            return Md3Theme.colorScheme.disabledContainer()
        switch (colorRole) {
        case Md3ExtendedFab.Secondary: return Md3Theme.colorScheme.secondaryContainer
        case Md3ExtendedFab.Tertiary: return Md3Theme.colorScheme.tertiaryContainer
        case Md3ExtendedFab.Surface: return Md3Theme.colorScheme.surfaceContainerHigh
        default: return Md3Theme.colorScheme.primaryContainer
        }
    }
    readonly property color contentColor: {
        if (!enabled)
            return Md3Theme.colorScheme.disabledContent()
        switch (colorRole) {
        case Md3ExtendedFab.Secondary: return Md3Theme.colorScheme.colorOnSecondaryContainer
        case Md3ExtendedFab.Tertiary: return Md3Theme.colorScheme.colorOnTertiaryContainer
        case Md3ExtendedFab.Surface: return Md3Theme.colorScheme.primary
        default: return Md3Theme.colorScheme.colorOnPrimaryContainer
        }
    }

    readonly property bool hovered: mouse.containsMouse
    readonly property bool pressed: mouse.pressed
    readonly property bool focused: activeFocus
    readonly property real elev: enabled ? (hovered && !pressed ? 8 : 6) : 0
    readonly property real shadowPad: 28

    readonly property real collapsedWidth: fabHeight
    readonly property real expandedWidth: padStart + (icon.length > 0 ? iconSize + 8 : 0)
                                          + label.implicitWidth + padEnd

    implicitWidth: (extended ? expandedWidth : collapsedWidth) + shadowPad * 2
    implicitHeight: fabHeight + shadowPad * 2
    width: implicitWidth
    height: implicitHeight

    activeFocusOnTab: enabled
    Accessible.name: accessibleName
    Accessible.role: Accessible.Button
    Accessible.onPressAction: if (enabled) root.clicked()

    Keys.onReturnPressed: if (enabled) clicked()
    Keys.onSpacePressed: if (enabled) clicked()

    Behavior on width {
        NumberAnimation {
            duration: Md3Motion.spatialDuration
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Md3Motion.emphasized
        }
    }

    Md3Shadow {
        anchors.centerIn: parent
        width: bg.width
        height: bg.height
        elevation: root.elev
        cornerRadius: root.corner
    }

    Rectangle {
        id: bg
        anchors.centerIn: parent
        width: root.extended ? root.expandedWidth : root.collapsedWidth
        height: root.fabHeight
        radius: root.corner
        color: root.containerColor
        clip: true

        Behavior on width {
            NumberAnimation {
                duration: Md3Motion.spatialDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.emphasized
            }
        }

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

        Row {
            id: row
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: root.extended ? root.padStart : (parent.width - root.iconSize) / 2
            spacing: 8

            Behavior on anchors.leftMargin {
                NumberAnimation {
                    duration: Md3Motion.spatialDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.emphasized
                }
            }

            Md3Icon {
                visible: root.icon.length > 0
                icon: root.icon
                size: root.iconSize
                iconColor: root.contentColor
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: label
                text: root.text
                color: root.contentColor
                visible: root.extended
                opacity: root.extended ? 1 : 0
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.scaled(Md3Theme.typography.labelLarge.size)
                font.weight: Md3Theme.typography.labelLarge.weight
                font.letterSpacing: Md3Theme.typography.labelLarge.letterSpacing
                anchors.verticalCenter: parent.verticalCenter

                Behavior on opacity {
                    NumberAnimation {
                        duration: Md3Motion.short3
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.standard
                    }
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
        width: bg.width
        height: bg.height
        hoverEnabled: true
        enabled: root.enabled
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: function (mouse) {
            ripple.pulse(mouse.x, mouse.y)
            root.forceActiveFocus()
            root.clicked()
        }
    }
}
