import QtQuick
import Md3

Md3AbstractButton {
    id: root

    property bool elevated: false

    accessibleName: text
    cornerRadius: Md3Theme.shape.small
    contentColor: enabled ? Md3Theme.colorScheme.colorOnSurfaceVariant
                          : Md3Theme.colorScheme.disabledContent()
    containerColor: elevated ? Md3Theme.colorScheme.surfaceContainerLow
                             : (enabled ? Md3Theme.colorScheme.surface : Md3Theme.colorScheme.disabledContainer())

    pressTarget: bg
    onPressFeedback: function (x, y) { ripple.pulse(x, y) }

    implicitHeight: Md3Theme.chipHeight
    implicitWidth: label.implicitWidth + 24
    height: implicitHeight
    width: implicitWidth

    Md3Shadow {
        anchors.fill: bgHost
        elevation: root.elevated && root.enabled ? 1 : 0
        cornerRadius: root.cornerRadius
    }

    Item {
        id: bgHost
        anchors.fill: parent
        scale: root.pressed ? 0.96 : 1.0
        Behavior on scale {
            enabled: !Md3Theme.reduceMotion
            NumberAnimation {
                duration: Md3Motion.short2
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.standard
            }
        }

        Rectangle {
            id: bg
            anchors.fill: parent
            radius: root.cornerRadius
            color: root.containerColor
            border.width: root.elevated ? 0 : 1
            border.color: Md3Theme.colorScheme.outline
            clip: true

            Md3Ripple { id: ripple; rippleColor: root.contentColor; clipRadius: bg.radius }
            Md3StateOverlay {
                overlayColor: root.contentColor
                hovered: root.hovered
                focused: root.activeFocus && root.visualFocus
                pressed: root.pressed
                controlEnabled: root.enabled
                radius: bg.radius
            }

            Md3Text {
                id: label
                anchors.centerIn: parent
                text: root.text
                role: Md3Text.LabelLarge
                tone: Md3Text.Custom
                customColor: root.contentColor
            }
        }
    }
}
