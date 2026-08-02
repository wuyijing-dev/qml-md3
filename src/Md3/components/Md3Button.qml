import QtQuick
import QtQuick.Effects
import Md3

Md3AbstractButton {
    id: root

    enum Variant { Filled, FilledTonal, Elevated, Outlined, Text }
    enum Size { ExtraSmall, Small, Medium, Large }

    property int variant: Md3Button.Filled
    property int size: Md3Button.Small
    /// Show spinner and block clicks while keeping the laid-out width.
    property bool busy: false
    /// Destructive / error emphasis (Filled uses error container).
    property bool danger: false

    accessibleName: text
    interactive: enabled && !busy

    /// Visual enabled (colors). Busy keeps brand colors and shows a spinner instead.
    readonly property bool effectivelyEnabled: enabled
    readonly property real h: {
        switch (size) {
        case Md3Button.ExtraSmall: return Md3Theme.densityCompact ? 28 : 32
        case Md3Button.Medium: return Md3Theme.fieldHeight
        case Md3Button.Large: return Md3Theme.densityCompact ? 80 : 96
        default: return Md3Theme.controlHeight
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
    readonly property real elev: variant === Md3Button.Elevated ? (hovered || pressed ? 2 : 1) : 0

    containerColor: {
        if (!effectivelyEnabled) return Md3Theme.colorScheme.disabledContainer()
        if (danger) {
            switch (variant) {
            case Md3Button.Text:
            case Md3Button.Outlined: return "transparent"
            default: return Md3Theme.colorScheme.error
            }
        }
        switch (variant) {
        case Md3Button.Filled: return Md3Theme.colorScheme.primary
        case Md3Button.FilledTonal: return Md3Theme.colorScheme.secondaryContainer
        case Md3Button.Elevated: return Md3Theme.colorScheme.surfaceContainerLow
        case Md3Button.Outlined:
        case Md3Button.Text: return "transparent"
        default: return Md3Theme.colorScheme.primary
        }
    }
    contentColor: {
        if (!effectivelyEnabled) return Md3Theme.colorScheme.disabledContent()
        if (danger) {
            switch (variant) {
            case Md3Button.Text:
            case Md3Button.Outlined: return Md3Theme.colorScheme.error
            default: return Md3Theme.colorScheme.colorOnError
            }
        }
        switch (variant) {
        case Md3Button.Filled: return Md3Theme.colorScheme.colorOnPrimary
        case Md3Button.FilledTonal: return Md3Theme.colorScheme.colorOnSecondaryContainer
        case Md3Button.Elevated: return Md3Theme.colorScheme.primary
        case Md3Button.Outlined:
        case Md3Button.Text: return Md3Theme.colorScheme.primary
        default: return Md3Theme.colorScheme.colorOnPrimary
        }
    }

    pressTarget: bg
    onPressFeedback: function (x, y) { if (!busy) ripple.pulse(x, y) }

    implicitWidth: Math.max(Md3Theme.iconButtonSize, row.implicitWidth + padH * 2)
    implicitHeight: Math.max(Md3Theme.iconButtonSize, h)
    width: implicitWidth
    height: implicitHeight

    Md3Shadow {
        anchors.centerIn: parent
        width: bg.width
        height: bg.height
        elevation: root.elev
        cornerRadius: root.cornerRadius
    }

    Item {
        id: bgHost
        anchors.centerIn: parent
        width: parent.width
        height: root.h
        scale: root.pressed ? 0.97 : 1.0
        Behavior on scale {
            enabled: !Md3Theme.reduceMotion
            NumberAnimation {
                duration: Md3Motion.short2
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.standard
            }
        }

        Item {
            id: bg
            anchors.fill: parent

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
                border.width: root.variant === Md3Button.Outlined ? 1 : 0
                border.color: root.enabled ? Md3Theme.colorScheme.outline : Md3Theme.colorScheme.disabledContent()
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
                opacity: root.busy ? 0 : 1
                Md3Icon {
                    visible: root.icon.length > 0
                    icon: root.icon
                    size: 18
                    iconColor: root.contentColor
                    anchors.verticalCenter: parent.verticalCenter
                }
                Md3Text {
                    text: root.text
                    role: Md3Text.LabelLarge
                    tone: Md3Text.Custom
                    customColor: root.contentColor
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Md3CircularProgressIndicator {
                anchors.centerIn: parent
                visible: root.busy
                indeterminate: true
                size: Math.min(22, root.h - 10)
                strokeWidth: 2.5
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
        width: bgHost.width + 6
        height: bgHost.height + 6
        radius: root.cornerRadius + 3
        focused: root.activeFocus
        visualFocus: root.visualFocus
        controlEnabled: root.enabled
    }
}
