import QtQuick
import Md3

Md3AbstractButton {
    id: root

    enum Size { Small, Regular, Large }
    enum ColorRole { Primary, Secondary, Tertiary, Surface }

    property int size: Md3Fab.Regular
    property int colorRole: Md3Fab.Primary
    property real iconRotation: 0
    property string tooltip: ""
    property real shadowPad: 28

    icon: "add"
    accessibleName: qsTr("Floating action button")

    readonly property real fabSize: {
        switch (size) {
        case Md3Fab.Small: return 40
        case Md3Fab.Large: return 96
        default: return 56
        }
    }
    cornerRadius: {
        switch (size) {
        case Md3Fab.Small: return Md3Theme.shape.medium
        case Md3Fab.Large: return Md3Theme.shape.extraLarge
        default: return Md3Theme.shape.large
        }
    }
    readonly property real iconSize: size === Md3Fab.Large ? 36 : 24
    readonly property real elev: {
        if (!enabled)
            return 0
        if (hovered && !pressed)
            return 8
        return 6
    }

    containerColor: {
        if (!enabled)
            return Md3Theme.colorScheme.disabledContainer()
        switch (colorRole) {
        case Md3Fab.Secondary: return Md3Theme.colorScheme.secondaryContainer
        case Md3Fab.Tertiary: return Md3Theme.colorScheme.tertiaryContainer
        case Md3Fab.Surface: return Md3Theme.colorScheme.surfaceContainerHigh
        default: return Md3Theme.colorScheme.primaryContainer
        }
    }
    contentColor: {
        if (!enabled)
            return Md3Theme.colorScheme.disabledContent()
        switch (colorRole) {
        case Md3Fab.Secondary: return Md3Theme.colorScheme.colorOnSecondaryContainer
        case Md3Fab.Tertiary: return Md3Theme.colorScheme.colorOnTertiaryContainer
        case Md3Fab.Surface: return Md3Theme.colorScheme.primary
        default: return Md3Theme.colorScheme.colorOnPrimaryContainer
        }
    }

    pressTarget: bg
    onPressFeedback: function (x, y) { ripple.pulse(x, y) }

    implicitWidth: Math.max(48, fabSize) + shadowPad * 2
    implicitHeight: Math.max(48, fabSize) + shadowPad * 2
    width: implicitWidth
    height: implicitHeight

    Md3Shadow {
        anchors.centerIn: parent
        width: fabSize
        height: fabSize
        elevation: root.elev
        cornerRadius: root.cornerRadius
    }

    Rectangle {
        id: bg
        anchors.centerIn: parent
        width: root.fabSize
        height: root.fabSize
        radius: root.cornerRadius
        color: root.containerColor
        clip: true
        scale: root.pressed ? 0.94 : 1.0
        Behavior on scale {
            enabled: !Md3Theme.reduceMotion
            NumberAnimation {
                duration: Md3Motion.short2
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.standard
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
            clipRadius: root.cornerRadius
        }

        Md3StateOverlay {
            overlayColor: root.contentColor
            hovered: root.hovered
            focused: root.activeFocus && root.visualFocus
            pressed: root.pressed
            controlEnabled: root.enabled
            radius: root.cornerRadius
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
        radius: root.cornerRadius + 3
        focused: root.activeFocus
        visualFocus: root.visualFocus
        controlEnabled: root.enabled
    }

    property bool _tipOpen: false

    HoverHandler {
        enabled: root.tooltip.length > 0
        onHoveredChanged: {
            if (hovered) {
                fabTipDelay.restart()
            } else {
                fabTipDelay.stop()
                root._tipOpen = false
            }
        }
    }

    Timer {
        id: fabTipDelay
        interval: 450
        onTriggered: root._tipOpen = root.tooltip.length > 0
    }

    Rectangle {
        visible: root._tipOpen && root.tooltip.length > 0
        anchors.horizontalCenter: bg.horizontalCenter
        anchors.bottom: bg.top
        anchors.bottomMargin: 8
        width: fabTipLabel.implicitWidth + 16
        height: fabTipLabel.implicitHeight + 8
        radius: Md3Theme.shape.extraSmall
        color: Md3Theme.colorScheme.inverseSurface
        z: 20
        opacity: visible ? 1 : 0
        Behavior on opacity {
            NumberAnimation {
                duration: Md3Motion.overlayDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.standard
            }
        }
        Text {
            id: fabTipLabel
            anchors.centerIn: parent
            text: root.tooltip
            color: Md3Theme.colorScheme.colorOnInverseSurface
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.bodySmall.size
        }
    }
}
