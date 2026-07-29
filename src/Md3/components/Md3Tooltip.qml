import QtQuick

Item {
    id: root

    property string text: ""
    property bool open: false
    property int showDelay: 500
    default property alias content: host.data

    width: host.childrenRect.width
    height: host.childrenRect.height

    Item {
        id: host
        anchors.fill: parent
    }

    Timer {
        id: delay
        interval: root.showDelay
        onTriggered: root.open = true
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        acceptedButtons: Qt.NoButton
        onEntered: delay.start()
        onExited: {
            delay.stop()
            root.open = false
        }
    }

    Rectangle {
        visible: root.open && root.text.length > 0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.top
        anchors.bottomMargin: 4
        z: 2000
        width: tip.implicitWidth + 16
        height: tip.implicitHeight + 8
        radius: Md3Theme.shape.extraSmall
        color: Md3Theme.colorScheme.inverseSurface
        opacity: visible ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                    duration: Md3Motion.overlayDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.standard
                }
        }

        Text {
            id: tip
            anchors.centerIn: parent
            text: root.text
            color: Md3Theme.colorScheme.colorOnInverseSurface
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.bodySmall.size
        }
    }
}
