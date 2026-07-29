import QtQuick
import QtQuick.Effects

Item {
    id: root

    enum Variant { Standard, Filled, FilledTonal, Outlined }

    property int variant: Md3ToggleIconButton.Standard
    property string icon: "favorite"
    property bool checked: false
    property string accessibleName: icon
    property bool visualFocus: false

    signal clicked()
    signal toggled(bool checked)

    readonly property real circleSize: 40
    readonly property real circleRadius: circleSize / 2

    readonly property color containerColor: {
        if (!enabled) {
            if (variant === Md3ToggleIconButton.Standard && !checked)
                return "transparent"
            return Md3Theme.colorScheme.disabledContainer()
        }
        switch (variant) {
        case Md3ToggleIconButton.Filled:
            return checked ? Md3Theme.colorScheme.primary
                           : Md3Theme.colorScheme.surfaceContainerHighest
        case Md3ToggleIconButton.FilledTonal:
            return checked ? Md3Theme.colorScheme.secondaryContainer
                           : Md3Theme.colorScheme.surfaceContainerHighest
        case Md3ToggleIconButton.Outlined:
            return checked ? Md3Theme.colorScheme.inverseSurface : "transparent"
        default:
            return checked ? Md3Theme.colorScheme.secondaryContainer : "transparent"
        }
    }

    readonly property color contentColor: {
        if (!enabled)
            return Md3Theme.colorScheme.disabledContent()
        switch (variant) {
        case Md3ToggleIconButton.Filled:
            return checked ? Md3Theme.colorScheme.colorOnPrimary
                           : Md3Theme.colorScheme.primary
        case Md3ToggleIconButton.FilledTonal:
            return checked ? Md3Theme.colorScheme.colorOnSecondaryContainer
                           : Md3Theme.colorScheme.colorOnSurfaceVariant
        case Md3ToggleIconButton.Outlined:
            return checked ? Md3Theme.colorScheme.colorOnInverseSurface
                           : Md3Theme.colorScheme.colorOnSurfaceVariant
        default:
            return checked ? Md3Theme.colorScheme.colorOnSecondaryContainer
                           : Md3Theme.colorScheme.colorOnSurfaceVariant
        }
    }

    width: 48
    height: 48
    activeFocusOnTab: enabled
    Accessible.name: accessibleName
    Accessible.role: Accessible.Button
    Accessible.checkable: true
    Accessible.checked: checked
    Accessible.onPressAction: if (enabled) root.toggle()

    function toggle() {
        if (!enabled)
            return
        checked = !checked
        toggled(checked)
        clicked()
    }

    Item {
        id: bg
        anchors.centerIn: parent
        width: root.circleSize
        height: root.circleSize

        layer.enabled: true
        layer.smooth: true
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: circleMask
        }

        Rectangle {
            anchors.fill: parent
            radius: root.circleRadius
            color: root.containerColor
            border.width: root.variant === Md3ToggleIconButton.Outlined && !root.checked ? 1 : 0
            border.color: root.enabled ? Md3Theme.colorScheme.outline
                                       : Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.outline, 0.12)

            Behavior on color {
                ColorAnimation {
                    duration: Md3Motion.short4
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.standard
                }
            }
            Behavior on border.width {
                NumberAnimation {
                    duration: Md3Motion.short4
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.standard
                }
            }
        }

        Md3Ripple {
            id: ripple
            rippleColor: root.contentColor
            clipRadius: root.circleRadius
        }
        Md3StateOverlay {
            overlayColor: root.contentColor
            hovered: mouse.containsMouse
            focused: root.activeFocus && root.visualFocus
            pressed: mouse.pressed
            controlEnabled: root.enabled
            radius: root.circleRadius
        }
        Md3Icon {
            anchors.centerIn: parent
            icon: root.icon
            size: 24
            iconColor: root.contentColor
            Behavior on iconColor {
                ColorAnimation {
                    duration: Md3Motion.short4
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.standard
                }
            }
        }
    }

    Item {
        id: circleMask
        width: bg.width
        height: bg.height
        layer.enabled: true
        visible: false
        Rectangle {
            anchors.fill: parent
            radius: root.circleRadius
            color: "#ffffff"
        }
    }

    Md3FocusRing {
        anchors.centerIn: parent
        width: bg.width + 6
        height: bg.height + 6
        radius: (bg.width + 6) / 2
        focused: root.activeFocus
        visualFocus: root.visualFocus
        controlEnabled: root.enabled
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        enabled: root.enabled
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: function (mouse) {
            root.visualFocus = false
            const local = mapToItem(bg, mouse.x, mouse.y)
            ripple.pulse(local.x, local.y)
            root.forceActiveFocus()
            root.toggle()
        }
    }
    Keys.onPressed: function (event) {
        if (event.key === Qt.Key_Tab || event.key === Qt.Key_Backtab
                || event.key === Qt.Key_Left || event.key === Qt.Key_Right
                || event.key === Qt.Key_Up || event.key === Qt.Key_Down)
            root.visualFocus = true
    }
    Keys.onReturnPressed: if (enabled) { visualFocus = true; toggle() }
    Keys.onSpacePressed: if (enabled) { visualFocus = true; toggle() }
}
