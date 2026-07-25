import QtQuick

Item {
    id: root

    property bool open: false
    property bool modal: true
    default property alias content: sheetContent.data

    signal dismissed()

    anchors.fill: parent
    visible: open || sheet.y < height - 0.5 || scrim.opacity > 0.01
    z: 900

    Rectangle {
        id: scrim
        anchors.fill: parent
        visible: root.modal
        color: Md3Theme.colorScheme.scrim
        opacity: root.open ? 0.32 : 0
        Behavior on opacity {
            NumberAnimation {
                    duration: Md3Motion.overlayDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.standard
                }
        }
        MouseArea {
            anchors.fill: parent
            enabled: root.open && root.modal
            onClicked: {
                root.open = false
                root.dismissed()
            }
        }
    }

    Rectangle {
        id: sheet
        anchors.left: parent.left
        anchors.right: parent.right
        height: Math.min(parent.height * 0.6, sheetContent.implicitHeight + 48)
        y: root.open ? parent.height - height : parent.height
        radius: 0
        topLeftRadius: Md3Theme.shape.extraLarge
        topRightRadius: Md3Theme.shape.extraLarge
        color: Md3Theme.colorScheme.surfaceContainerLow

        Behavior on y {
            NumberAnimation {
                    duration: Md3Motion.spatialDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.emphasized
                }
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 16
            width: 32
            height: 4
            radius: 2
            color: Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSurfaceVariant, 0.4)
        }

        Item {
            id: sheetContent
            anchors.top: parent.top
            anchors.topMargin: 36
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 16
            implicitHeight: childrenRect.height
        }
    }
}
