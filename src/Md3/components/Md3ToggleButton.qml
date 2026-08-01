import QtQuick
import QtQuick.Effects
import Md3

/// Text toggle button (WinUI ToggleButton / MD3 toggle). Prefer
/// Md3ToggleIconButton for icon-only.
Md3AbstractButton {
    id: root

    enum Variant { Filled, Outlined }

    property int variant: Md3ToggleButton.Filled
    property int size: Md3Button.Small

    checkable: true
    accessibleName: text
    accessibleRole: Accessible.CheckBox

    readonly property real h: {
        switch (size) {
        case Md3Button.ExtraSmall: return 32
        case Md3Button.Medium: return 56
        case Md3Button.Large: return 96
        default: return 40
        }
    }
    readonly property real padH: size === Md3Button.ExtraSmall ? 12 : (size === Md3Button.Large ? 24 : 16)
    cornerRadius: {
        switch (size) {
        case Md3Button.ExtraSmall: return Md3Theme.shape.small
        case Md3Button.Large: return Md3Theme.shape.large
        default: return h / 2
        }
    }

    containerColor: {
        if (!enabled) {
            if (variant === Md3ToggleButton.Outlined && !checked)
                return "transparent"
            return Md3Theme.colorScheme.disabledContainer()
        }
        if (variant === Md3ToggleButton.Outlined)
            return checked ? Md3Theme.colorScheme.inverseSurface : "transparent"
        return checked ? Md3Theme.colorScheme.primary
                       : Md3Theme.colorScheme.surfaceContainerHighest
    }
    contentColor: {
        if (!enabled)
            return Md3Theme.colorScheme.disabledContent()
        if (variant === Md3ToggleButton.Outlined)
            return checked ? Md3Theme.colorScheme.colorOnInverseSurface
                           : Md3Theme.colorScheme.colorOnSurfaceVariant
        return checked ? Md3Theme.colorScheme.colorOnPrimary
                       : Md3Theme.colorScheme.primary
    }

    pressTarget: bg
    onPressFeedback: function (x, y) { ripple.pulse(x, y) }

    implicitWidth: Math.max(48, row.implicitWidth + padH * 2)
    implicitHeight: Math.max(48, h)
    width: implicitWidth
    height: implicitHeight

    function toggle() { activate(true) }

    Item {
        id: bg
        anchors.centerIn: parent
        width: parent.width
        height: root.h

        layer.enabled: Md3Theme.effectsRippleMasked && ripple.layersNeeded
        layer.smooth: true
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: btnMask
        }

        Rectangle {
            anchors.fill: parent
            radius: root.cornerRadius
            color: root.containerColor
            border.width: root.variant === Md3ToggleButton.Outlined && !root.checked ? 1 : 0
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

        Row {
            id: row
            anchors.centerIn: parent
            spacing: 8
            Md3Icon {
                visible: root.icon.length > 0
                icon: root.icon
                size: 18
                iconColor: root.contentColor
                anchors.verticalCenter: parent.verticalCenter
                Behavior on iconColor {
                    ColorAnimation {
                        duration: Md3Motion.short4
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.standard
                    }
                }
            }
            Md3Text {
                text: root.text
                role: Md3Text.LabelLarge
                tone: Md3Text.Custom
                customColor: root.contentColor
                anchors.verticalCenter: parent.verticalCenter
                Behavior on color {
                    ColorAnimation {
                        duration: Md3Motion.short4
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.standard
                    }
                }
            }
        }
    }

    Item {
        id: btnMask
        width: bg.width
        height: bg.height
        layer.enabled: bg.layer.enabled
        visible: false
        Rectangle {
            anchors.fill: parent
            radius: root.cornerRadius
            color: "#ffffff"
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
}
