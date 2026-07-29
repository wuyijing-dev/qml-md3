import QtQuick

Item {
    id: root

    property string text: ""
    property string icon: ""
    property bool selected: false
    property bool elevated: false
    property string accessibleName: text
    /// Compact density for title bars (e.g. 24)
    property real chipHeight: 32
    property real iconSize: 18
    property real fontSize: Md3Theme.scaled(Md3Theme.typography.labelLarge.size)

    signal clicked()

    implicitHeight: chipHeight
    implicitWidth: row.implicitWidth + Math.max(12, chipHeight * 0.5)
    height: implicitHeight
    width: implicitWidth
    activeFocusOnTab: enabled
    Accessible.name: accessibleName
    Accessible.role: Accessible.Button
    Accessible.checkable: true
    Accessible.checked: selected

    readonly property color containerColor: {
        if (!enabled)
            return selected ? Md3Theme.colorScheme.disabledContainer() : "transparent"
        if (selected)
            return Md3Theme.colorScheme.secondaryContainer
        return elevated ? Md3Theme.colorScheme.surfaceContainerLow : Md3Theme.colorScheme.surface
    }
    readonly property color contentColor: {
        if (!enabled)
            return Md3Theme.colorScheme.disabledContent()
        return selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                        : Md3Theme.colorScheme.colorOnSurfaceVariant
    }

    Md3Shadow {
        anchors.fill: bg
        elevation: root.elevated && root.enabled && !root.selected ? 1 : 0
        cornerRadius: Md3Theme.shape.small
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: Md3Theme.shape.small
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
            hovered: mouse.containsMouse
            focused: root.activeFocus
            pressed: mouse.pressed
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
            Text {
                text: root.text
                color: root.contentColor
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: root.fontSize
                font.weight: Md3Theme.typography.labelLarge.weight
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        enabled: root.enabled
        onClicked: function (mouse) {
            ripple.pulse(mouse.x, mouse.y)
            root.selected = !root.selected
            root.forceActiveFocus()
            root.clicked()
        }
    }
}
