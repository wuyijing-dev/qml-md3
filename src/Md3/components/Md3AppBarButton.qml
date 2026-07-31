import QtQuick
import QtQuick.Effects
import Md3

/// Compact command-bar action (WinUI AppBarButton / AppBarToggleButton).
/// Set `checkable: true` for toggle behavior.
Md3AbstractButton {
    id: root

    enum Layout { IconOnly, IconAndLabel }

    property int layout: Md3AppBarButton.IconAndLabel
    /// Shown under/beside the icon when layout is IconAndLabel.
    property string label: text

    icon: "more_horiz"
    accessibleName: label.length ? label : (text.length ? text : icon)

    readonly property real tileSize: 40
    cornerRadius: Md3Theme.shape.extraSmall

    containerColor: {
        if (!enabled)
            return "transparent"
        if (checkable && checked)
            return Md3Theme.colorScheme.secondaryContainer
        return "transparent"
    }
    contentColor: {
        if (!enabled)
            return Md3Theme.colorScheme.disabledContent()
        if (checkable && checked)
            return Md3Theme.colorScheme.colorOnSecondaryContainer
        return Md3Theme.colorScheme.colorOnSurfaceVariant
    }

    pressTarget: bg
    onPressFeedback: function (x, y) { ripple.pulse(x, y) }

    implicitWidth: layout === Md3AppBarButton.IconOnly
                   ? Math.max(48, tileSize)
                   : Math.max(64, col.implicitWidth + 8)
    implicitHeight: layout === Md3AppBarButton.IconOnly
                    ? Math.max(48, tileSize)
                    : Math.max(48, col.implicitHeight + 4)
    width: implicitWidth
    height: implicitHeight

    Item {
        id: bg
        anchors.centerIn: parent
        width: parent.width - 4
        height: parent.height - 4

        layer.enabled: true
        layer.smooth: true
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: mask
        }

        Rectangle {
            anchors.fill: parent
            radius: root.cornerRadius
            color: root.containerColor
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

        Column {
            id: col
            anchors.centerIn: parent
            spacing: 2
            Md3Icon {
                anchors.horizontalCenter: parent.horizontalCenter
                icon: root.icon
                size: 20
                iconColor: root.contentColor
                Behavior on iconColor {
                    ColorAnimation {
                        duration: Md3Motion.short4
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.standard
                    }
                }
            }
            Md3Text {
                visible: root.layout === Md3AppBarButton.IconAndLabel
                         && root.label.length > 0
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.label
                role: Md3Text.LabelSmall
                tone: Md3Text.Custom
                customColor: root.contentColor
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
        id: mask
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
        width: bg.width + 4
        height: bg.height + 4
        radius: root.cornerRadius + 2
        focused: root.activeFocus
        visualFocus: root.visualFocus
        controlEnabled: root.enabled
    }
}
