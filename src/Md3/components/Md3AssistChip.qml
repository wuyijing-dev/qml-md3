import QtQuick
import Md3

Md3AbstractButton {
    id: root

    property bool elevated: false

    accessibleName: text
    cornerRadius: Md3Theme.shape.small
    containerColor: {
        if (!enabled)
            return Md3Theme.colorScheme.disabledContainer()
        return elevated ? Md3Theme.colorScheme.surfaceContainerLow
                        : Md3Theme.colorScheme.surface
    }
    contentColor: enabled ? Md3Theme.colorScheme.colorOnSurface
                          : Md3Theme.colorScheme.disabledContent()

    pressTarget: bg
    onPressFeedback: function (x, y) { ripple.pulse(x, y) }

    implicitHeight: 32
    implicitWidth: row.implicitWidth + 16
    height: implicitHeight
    width: implicitWidth

    Md3Shadow {
        anchors.fill: bg
        elevation: root.elevated && root.enabled ? 1 : 0
        cornerRadius: root.cornerRadius
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: root.cornerRadius
        color: root.containerColor
        border.width: root.elevated ? 0 : 1
        border.color: root.enabled ? Md3Theme.colorScheme.outline
                                   : Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSurface, 0.12)
        clip: true

        Md3Ripple {
            id: ripple
            rippleColor: root.contentColor
            clipRadius: bg.radius
        }
        Md3StateOverlay {
            overlayColor: root.contentColor
            hovered: root.hovered
            focused: root.activeFocus && root.visualFocus
            pressed: root.pressed
            controlEnabled: root.enabled
            radius: bg.radius
        }

        Row {
            id: row
            anchors.centerIn: parent
            spacing: 8
            Md3Icon {
                visible: root.icon.length > 0
                icon: root.icon
                size: 18
                iconColor: root.enabled ? Md3Theme.colorScheme.primary : root.contentColor
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
}
