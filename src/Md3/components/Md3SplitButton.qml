import QtQuick
import QtQuick.Effects
import Md3

Md3AbstractButton {
    id: root

    enum Variant { Filled, FilledTonal, Outlined }

    property int variant: Md3SplitButton.Filled
    property var menuModel: []
    /// Optional explicit Window for menu overlay.
    property var overlayWindow: null

    signal menuItemClicked(int index)

    readonly property bool menuOpen: menu.open
    readonly property real h: 40
    readonly property real corner: h / 2
    readonly property real trailingWidth: 40

    readonly property color containerColor: {
        if (!enabled)
            return Md3Theme.colorScheme.disabledContainer()
        switch (variant) {
        case Md3SplitButton.FilledTonal: return Md3Theme.colorScheme.secondaryContainer
        case Md3SplitButton.Outlined: return "transparent"
        default: return Md3Theme.colorScheme.primary
        }
    }
    readonly property color contentColor: {
        if (!enabled)
            return Md3Theme.colorScheme.disabledContent()
        switch (variant) {
        case Md3SplitButton.FilledTonal: return Md3Theme.colorScheme.colorOnSecondaryContainer
        case Md3SplitButton.Outlined: return Md3Theme.colorScheme.primary
        default: return Md3Theme.colorScheme.colorOnPrimary
        }
    }

    implicitWidth: Math.max(64, mainRow.implicitWidth + 16 + trailingWidth)
    implicitHeight: Math.max(48, h)
    width: implicitWidth
    height: implicitHeight
    accessibleName: text
    pressTarget: mainSeg
    pressRightMargin: trailingWidth
    onPressFeedback: function (x, y) { mainRipple.pulse(x, y) }

    function openMenu() {
        if (!enabled || menuModel.length === 0)
            return
        const p = Md3OverlayHost.mapToOverlay(shell, 0, shell.height + 4, root.overlayWindow)
        menu.menuWidth = Math.max(shell.width, 168)
        if (menu.overlayWindow !== undefined)
            menu.overlayWindow = root.overlayWindow
        menu.popup(p.x, p.y)
    }

    function dismissMenu() {
        menu.dismiss()
    }

    Item {
        id: shell
        anchors.centerIn: parent
        width: parent.width
        height: root.h

        // Shared container chrome (no whole-shell mask — that broke per-segment ripples)
        Rectangle {
            anchors.fill: parent
            radius: root.corner
            color: root.containerColor
            border.width: root.variant === Md3SplitButton.Outlined ? 1 : 0
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

        // Leading action — mask: rounded start, flat end at divider
        Item {
            id: mainSeg
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: divider.left
            Accessible.name: root.accessibleName
            Accessible.role: Accessible.Button

            layer.enabled: true
            layer.smooth: true
            layer.effect: MultiEffect {
                maskEnabled: true
                maskSource: mainMask
            }

            Md3Ripple {
                id: mainRipple
                rippleColor: root.contentColor
                clipRadius: 0
            }
            Md3StateOverlay {
                overlayColor: root.contentColor
                hovered: root.hovered
                pressed: root.pressed
                focused: root.activeFocus && root.visualFocus
                controlEnabled: root.enabled
                topLeftRadius: root.corner
                bottomLeftRadius: root.corner
                topRightRadius: 0
                bottomRightRadius: 0
            }

            Row {
                id: mainRow
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
            id: mainMask
            width: mainSeg.width
            height: mainSeg.height
            layer.enabled: true
            visible: false
            Rectangle {
                anchors.fill: parent
                topLeftRadius: root.corner
                bottomLeftRadius: root.corner
                topRightRadius: 0
                bottomRightRadius: 0
                color: "#ffffff"
            }
        }

        Rectangle {
            id: divider
            anchors.right: trailing.left
            anchors.verticalCenter: parent.verticalCenter
            width: 1
            height: parent.height - 8
            z: 2
            color: {
                if (!root.enabled)
                    return Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.outline, 0.12)
                if (root.variant === Md3SplitButton.Filled)
                    return Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnPrimary, 0.2)
                if (root.variant === Md3SplitButton.FilledTonal)
                    return Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSecondaryContainer, 0.2)
                return Md3Theme.colorScheme.outline
            }
        }

        // Trailing chevron — mask: flat start, rounded end
        Item {
            id: trailing
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: root.trailingWidth
            Accessible.name: "More"
            Accessible.role: Accessible.Button

            layer.enabled: true
            layer.smooth: true
            layer.effect: MultiEffect {
                maskEnabled: true
                maskSource: trailMask
            }

            Md3Ripple {
                id: trailRipple
                rippleColor: root.contentColor
                clipRadius: 0
            }
            Md3StateOverlay {
                overlayColor: root.contentColor
                hovered: trailMouse.containsMouse
                pressed: trailMouse.pressed
                focused: root.activeFocus && root.visualFocus && root.menuOpen
                controlEnabled: root.enabled
                topLeftRadius: 0
                bottomLeftRadius: 0
                topRightRadius: root.corner
                bottomRightRadius: root.corner
            }

            Md3Icon {
                anchors.centerIn: parent
                icon: "arrow_drop_down"
                size: 24
                iconColor: root.contentColor
                rotation: root.menuOpen ? 180 : 0
                Behavior on rotation {
                    NumberAnimation {
                        duration: Md3Motion.short3
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.emphasized
                    }
                }
                Behavior on iconColor {
                    ColorAnimation {
                        duration: Md3Motion.short4
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.standard
                    }
                }
            }

            MouseArea {
                id: trailMouse
                anchors.fill: parent
                hoverEnabled: true
                enabled: root.enabled
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                onPressed: function (mouse) {
                    trailRipple.pulse(mouse.x, mouse.y)
                }
                onClicked: {
                    if (menu.open)
                        root.dismissMenu()
                    else
                        root.openMenu()
                }
            }
        }

        Item {
            id: trailMask
            width: trailing.width
            height: trailing.height
            layer.enabled: true
            visible: false
            Rectangle {
                anchors.fill: parent
                topLeftRadius: 0
                bottomLeftRadius: 0
                topRightRadius: root.corner
                bottomRightRadius: root.corner
                color: "#ffffff"
            }
        }
    }

    Md3FocusRing {
        anchors.centerIn: parent
        width: shell.width + 6
        height: shell.height + 6
        radius: root.corner + 3
        focused: root.activeFocus
        visualFocus: root.visualFocus
        controlEnabled: root.enabled
    }

    Keys.onPressed: function (event) {
        if (event.key === Qt.Key_Tab || event.key === Qt.Key_Backtab)
            root.visualFocus = true
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
