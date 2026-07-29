import QtQuick

// Compact title-bar action — fixed hit size aligned with caption buttons
Item {
    id: root

    property string icon: "contrast"
    property string accessibleName: icon
    property bool checked: false
    property bool destructive: false
    property real buttonWidth: 40
    property real buttonHeight: 28
    property real iconSize: 14

    signal clicked()

    width: buttonWidth
    height: buttonHeight
    implicitWidth: buttonWidth
    implicitHeight: buttonHeight
    Accessible.name: accessibleName
    Accessible.role: Accessible.Button
    Accessible.onPressAction: root.clicked()

    Rectangle {
        anchors.fill: parent
        color: {
            if (!mouse.containsMouse && !mouse.pressed && !root.checked)
                return "transparent"
            if (root.destructive && mouse.containsMouse)
                return mouse.pressed ? Md3Theme.colorScheme.error
                                     : Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.error, 0.9)
            const base = root.checked ? 0.12 : (mouse.pressed ? 0.12 : 0.08)
            return Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSurface, base)
        }
        Behavior on color {
            ColorAnimation {
                duration: Md3Motion.short2
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.standard
            }
        }
    }

    Md3Icon {
        anchors.centerIn: parent
        icon: root.icon
        size: root.iconSize
        iconColor: {
            if (root.destructive && mouse.containsMouse)
                return Md3Theme.colorScheme.colorOnError
            return Md3Theme.colorScheme.colorOnSurfaceVariant
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
