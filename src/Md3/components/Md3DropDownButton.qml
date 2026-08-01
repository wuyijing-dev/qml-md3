import QtQuick
import QtQuick.Effects
import Md3

/// Single-piece button that opens a menu (WinUI DropDownButton).
/// Unlike Md3SplitButton, the whole control opens the menu — no primary action.
Md3AbstractButton {
    id: root

    enum Variant { Filled, FilledTonal, Outlined, Text }

    property int variant: Md3DropDownButton.Filled
    property var menuModel: []
    /// Optional explicit Window for menu overlay.
    property var overlayWindow: null

    signal menuItemClicked(int index)

    readonly property bool menuOpen: menu.open
    readonly property real h: 40
    readonly property real padH: 16

    cornerRadius: h / 2

    containerColor: {
        if (!enabled)
            return variant === Md3DropDownButton.Text || variant === Md3DropDownButton.Outlined
                   ? "transparent"
                   : Md3Theme.colorScheme.disabledContainer()
        switch (variant) {
        case Md3DropDownButton.FilledTonal: return Md3Theme.colorScheme.secondaryContainer
        case Md3DropDownButton.Outlined:
        case Md3DropDownButton.Text: return "transparent"
        default: return Md3Theme.colorScheme.primary
        }
    }
    contentColor: {
        if (!enabled)
            return Md3Theme.colorScheme.disabledContent()
        switch (variant) {
        case Md3DropDownButton.FilledTonal: return Md3Theme.colorScheme.colorOnSecondaryContainer
        case Md3DropDownButton.Outlined:
        case Md3DropDownButton.Text: return Md3Theme.colorScheme.primary
        default: return Md3Theme.colorScheme.colorOnPrimary
        }
    }

    accessibleName: text
    pressTarget: bg
    onPressFeedback: function (x, y) { ripple.pulse(x, y) }
    onClicked: toggleMenu()

    implicitWidth: Math.max(48, row.implicitWidth + padH * 2)
    implicitHeight: Math.max(48, h)
    width: implicitWidth
    height: implicitHeight

    function toggleMenu() {
        if (!enabled || menuModel.length === 0)
            return
        if (menu.open)
            dismissMenu()
        else
            openMenu()
    }

    function openMenu() {
        if (!enabled || menuModel.length === 0)
            return
        const p = Md3OverlayHost.mapToOverlay(bg, 0, bg.height + 4, root.overlayWindow)
        menu.menuWidth = Math.max(bg.width, 168)
        if (menu.overlayWindow !== undefined)
            menu.overlayWindow = root.overlayWindow
        menu.popup(p.x, p.y)
    }

    function dismissMenu() {
        menu.dismiss()
    }

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
            border.width: root.variant === Md3DropDownButton.Outlined ? 1 : 0
            border.color: root.enabled ? Md3Theme.colorScheme.outline
                                       : Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.outline, 0.12)

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
            Md3Icon {
                icon: "arrow_drop_down"
                size: 24
                iconColor: root.contentColor
                anchors.verticalCenter: parent.verticalCenter
                rotation: root.menuOpen ? 180 : 0
                Behavior on rotation {
                    NumberAnimation {
                        duration: Md3Motion.short3
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.emphasized
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

    Keys.onDownPressed: if (enabled) openMenu()

    Md3Menu {
        id: menu
        modal: true

        Repeater {
            model: root.menuModel
            Md3MenuItem {
                required property int index
                required property var modelData
                width: Math.max(menu.menuWidth, 168)
                text: modelData.text !== undefined ? modelData.text : String(modelData)
                icon: modelData.icon !== undefined ? modelData.icon : ""
                enabled: modelData.enabled !== false
                onClicked: {
                    root.menuItemClicked(index)
                    menu.dismiss()
                }
            }
        }
    }
}
