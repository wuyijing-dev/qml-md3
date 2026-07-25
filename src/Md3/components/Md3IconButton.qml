import QtQuick
import QtQuick.Effects

Item {
    id: root
    enum Variant { Standard, Filled, FilledTonal, Outlined }
    property int variant: Md3IconButton.Standard
    property string icon: "favorite"
    property bool enabled: true
    property bool selected: false
    property string accessibleName: icon
    property bool visualFocus: false
    signal clicked()

    readonly property real circleSize: 40
    readonly property real circleRadius: circleSize / 2

    readonly property color containerColor: {
        if (!enabled && variant !== Md3IconButton.Standard)
            return Md3Theme.colorScheme.disabledContainer()
        switch (variant) {
        case Md3IconButton.Filled: return Md3Theme.colorScheme.primary
        case Md3IconButton.FilledTonal: return Md3Theme.colorScheme.secondaryContainer
        case Md3IconButton.Standard:
        case Md3IconButton.Outlined:
            return selected ? Md3Theme.colorScheme.secondaryContainer : "transparent"
        default: return "transparent"
        }
    }
    readonly property color contentColor: {
        if (!enabled) return Md3Theme.colorScheme.disabledContent()
        switch (variant) {
        case Md3IconButton.Filled: return Md3Theme.colorScheme.colorOnPrimary
        case Md3IconButton.FilledTonal: return Md3Theme.colorScheme.colorOnSecondaryContainer
        default: return selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                 : Md3Theme.colorScheme.colorOnSurfaceVariant
        }
    }

    width: 48
    height: 48
    activeFocusOnTab: enabled
    Accessible.name: accessibleName
    Accessible.role: Accessible.Button

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
            border.width: root.variant === Md3IconButton.Outlined ? 1 : 0
            border.color: Md3Theme.colorScheme.outline
            Behavior on color {
                ColorAnimation {
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
        onClicked: function (mouse) {
            root.visualFocus = false
            const local = mapToItem(bg, mouse.x, mouse.y)
            ripple.pulse(local.x, local.y)
            root.forceActiveFocus()
            root.clicked()
        }
    }
    Keys.onPressed: function (event) {
        if (event.key === Qt.Key_Tab || event.key === Qt.Key_Backtab
                || event.key === Qt.Key_Left || event.key === Qt.Key_Right
                || event.key === Qt.Key_Up || event.key === Qt.Key_Down)
            root.visualFocus = true
    }
    Keys.onReturnPressed: if (enabled) { visualFocus = true; clicked() }
    Keys.onSpacePressed: if (enabled) { visualFocus = true; clicked() }
}
