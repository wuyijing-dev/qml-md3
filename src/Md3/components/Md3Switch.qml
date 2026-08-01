import QtQuick
import Md3

Md3SelectionControl {
    id: root

    // Use Item.enabled (do not redeclare)
    property bool showIcon: false
    /// Visible label beside the switch — replaces Row { Switch; Text } glue.
    chromeWidth: 52
    accessibleName: text.length ? text : qsTr("Switch")
    accessibleRole: Accessible.CheckBox
    labelRole: Md3Text.BodyLarge
    onActivated: toggle()

    signal toggled(bool checked)

    function toggle() {
        if (!enabled)
            return
        checked = !checked
        toggled(checked)
    }

    readonly property color trackColor: {
        if (!enabled)
            return checked ? Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSurface, 0.12)
                           : Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.surfaceContainerHighest, 0.12)
        return checked ? Md3Theme.colorScheme.primary
                       : Md3Theme.colorScheme.surfaceContainerHighest
    }
    readonly property color thumbColor: {
        if (!enabled)
            return checked ? Md3Theme.colorScheme.surface
                           : Md3Theme.colorScheme.disabledContent()
        return checked ? Md3Theme.colorScheme.colorOnPrimary
                       : Md3Theme.colorScheme.outline
    }
    readonly property real thumbSize: checked ? 24 : 16

    Item {
        id: switchChrome
        width: 52
        height: 48
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
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
            id: track
            anchors.centerIn: parent
            width: 52
            height: 32
            radius: Md3Theme.shape.full
            color: root.trackColor
            border.width: root.checked || !root.enabled ? 0 : 2
            border.color: root.enabled ? Md3Theme.colorScheme.outline
                                       : "transparent"

            Behavior on color {
                ColorAnimation {
                    duration: Md3Motion.short4
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.standard
                }
            }

            Md3StateOverlay {
                overlayColor: root.checked ? Md3Theme.colorScheme.colorOnPrimary
                                           : Md3Theme.colorScheme.colorOnSurface
                hovered: root.hovered
                focused: root.activeFocus
                pressed: root.pressed
                controlEnabled: root.enabled
                radius: track.radius
            }

            Rectangle {
                id: thumb
                width: root.thumbSize
                height: root.thumbSize
                radius: width / 2
                color: root.thumbColor
                anchors.verticalCenter: parent.verticalCenter
                x: root.checked ? parent.width - width - 4 : 4

                Behavior on x {
                    NumberAnimation {
                        duration: Md3Motion.short4
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.emphasized
                    }
                }
                Behavior on width {
                    NumberAnimation {
                        duration: Md3Motion.short3
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.standard
                    }
                }
                Behavior on height {
                    NumberAnimation {
                        duration: Md3Motion.short3
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.standard
                    }
                }
                Behavior on color {
                    ColorAnimation {
                        duration: Md3Motion.short4
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.standard
                    }
                }

                Md3Icon {
                    anchors.centerIn: parent
                    visible: root.showIcon
                    icon: root.checked ? "check" : "close"
                    size: 16
                    iconColor: root.checked ? Md3Theme.colorScheme.primary
                                            : Md3Theme.colorScheme.surfaceContainerHighest
                }
            }
        }

        Md3FocusRing {
            anchors.centerIn: track
            width: track.width + 6
            height: track.height + 6
            radius: Md3Theme.shape.full
            focused: root.activeFocus
            controlEnabled: root.enabled
        }
    }
}
