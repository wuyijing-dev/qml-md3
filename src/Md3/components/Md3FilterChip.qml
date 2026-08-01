import QtQuick
import Md3

/// Filter chip — selection is usually owned by the host (`selected:` binding).
/// Does not auto-toggle; emit `clicked` and let the parent update `selected`.
Md3AbstractButton {
    id: root

    property bool elevated: false
    property bool selected: false
    property real chipHeight: Md3Theme.chipHeight
    property real iconSize: 18
    property real fontSize: Md3Theme.scaled(Md3Theme.typography.labelLarge.size)

    checkable: false
    accessibleName: text
    cornerRadius: Md3Theme.shape.small
    containerColor: {
        if (!enabled)
            return selected ? Md3Theme.colorScheme.disabledContainer() : "transparent"
        if (selected)
            return Md3Theme.colorScheme.secondaryContainer
        return elevated ? Md3Theme.colorScheme.surfaceContainerLow : Md3Theme.colorScheme.surface
    }
    contentColor: {
        if (!enabled)
            return Md3Theme.colorScheme.disabledContent()
        return selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                        : Md3Theme.colorScheme.colorOnSurfaceVariant
    }

    pressTarget: bg
    onPressFeedback: function (x, y) { ripple.pulse(x, y) }

    implicitHeight: chipHeight
    implicitWidth: row.implicitWidth + Math.max(12, chipHeight * 0.5)
    height: implicitHeight
    width: implicitWidth

    Md3Shadow {
        anchors.fill: bg
        elevation: root.elevated && root.enabled && !root.selected ? 1 : 0
        cornerRadius: root.cornerRadius
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: root.cornerRadius
        color: root.containerColor
        border.width: (!root.selected && !root.elevated) ? 1 : 0
        border.color: Md3Theme.colorScheme.outline
        clip: true

        Behavior on color {
            ColorAnimation {
                duration: Md3Motion.short4
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.uiSpatial
            }
        }

        Md3Ripple { id: ripple; rippleColor: root.contentColor; clipRadius: bg.radius }
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
                visible: root.selected
                icon: "check"
                size: root.iconSize
                iconColor: root.contentColor
                anchors.verticalCenter: parent.verticalCenter
            }
            Md3Icon {
                visible: !root.selected && root.icon.length > 0
                icon: root.icon
                size: root.iconSize
                iconColor: root.contentColor
                anchors.verticalCenter: parent.verticalCenter
            }
            Md3Text {
                text: root.text
                role: Md3Text.LabelLarge
                tone: Md3Text.Custom
                customColor: root.contentColor
                font.pixelSize: root.fontSize
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
