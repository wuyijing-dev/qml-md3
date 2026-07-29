import QtQuick
import QtQuick.Effects

Md3AbstractButton {
    id: root

    enum Variant { Filled, FilledTonal, Elevated, Outlined, Text }
    enum Size { ExtraSmall, Small, Medium, Large }

    property int variant: Md3Button.Filled
    property int size: Md3Button.Small

    accessibleName: text

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
    readonly property real elev: variant === Md3Button.Elevated ? (hovered || pressed ? 2 : 1) : 0

    containerColor: {
        if (!enabled) return Md3Theme.colorScheme.disabledContainer()
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
        if (!enabled) return Md3Theme.colorScheme.disabledContent()
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
    onPressFeedback: function (x, y) { ripple.pulse(x, y) }

    implicitWidth: Math.max(48, row.implicitWidth + padH * 2)
    implicitHeight: Math.max(48, h)
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
        id: bg
        anchors.centerIn: parent
        width: parent.width
        height: root.h

        layer.enabled: true
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
    }

    Item {
        id: btnMask
        width: bg.width
        height: bg.height
        layer.enabled: true
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
