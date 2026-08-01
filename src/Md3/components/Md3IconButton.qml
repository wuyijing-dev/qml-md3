import QtQuick
import QtQuick.Effects
import Md3

Md3AbstractButton {
    id: root

    enum Variant { Standard, Filled, FilledTonal, Outlined }

    property int variant: Md3IconButton.Standard
    property bool selected: false
    property string badgeText: ""
    property bool badgeDot: false
    property int badgeMax: 99
    property int badgeSizePreset: Md3Badge.Medium
    property color badgeColor: Md3Theme.colorScheme.error
    property color badgeLabelColor: Md3Theme.colorScheme.colorOnError

    icon: "favorite"
    accessibleName: text.length ? text : (icon.length ? icon : qsTr("Icon button"))

    readonly property real circleSize: Md3Theme.iconCircleSize
    readonly property real circleRadius: circleSize / 2
    cornerRadius: circleRadius

    containerColor: {
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
    contentColor: {
        if (!enabled) return Md3Theme.colorScheme.disabledContent()
        switch (variant) {
        case Md3IconButton.Filled: return Md3Theme.colorScheme.colorOnPrimary
        case Md3IconButton.FilledTonal: return Md3Theme.colorScheme.colorOnSecondaryContainer
        default: return selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                 : Md3Theme.colorScheme.colorOnSurfaceVariant
        }
    }

    pressTarget: bg
    onPressFeedback: function (x, y) { ripple.pulse(x, y) }

    width: Md3Theme.iconButtonSize
    height: Md3Theme.iconButtonSize

    Item {
        id: bg
        anchors.centerIn: parent
        width: root.circleSize
        height: root.circleSize
        transform: Scale {
            origin.x: bg.width / 2
            origin.y: bg.height / 2
            xScale: root.pressed ? 0.96 : (root.hovered ? 1.04 : 1)
            yScale: xScale
            Behavior on xScale {
                NumberAnimation {
                    duration: Md3Motion.spatialSnapDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.emphasized
                }
            }
            Behavior on yScale {
                NumberAnimation {
                    duration: Md3Motion.spatialSnapDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.emphasized
                }
            }
        }

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
            hovered: root.hovered
            focused: root.activeFocus && root.visualFocus
            pressed: root.pressed
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

    Md3Badge {
        anchors.right: bg.right
        anchors.top: bg.top
        anchors.rightMargin: -2
        anchors.topMargin: -2
        z: 10
        visible: root.badgeDot || root.badgeText.length > 0
        text: root.badgeText
        dot: root.badgeDot
        max: root.badgeMax
        sizePreset: root.badgeSizePreset
        badgeColor: root.badgeColor
        labelColor: root.badgeLabelColor
    }
}
