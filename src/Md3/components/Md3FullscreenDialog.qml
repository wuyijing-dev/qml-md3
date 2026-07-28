import QtQuick

Item {
    id: root

    property bool open: false
    property string title: ""
    property string confirmText: "Save"
    property int layoutMode: Md3ContainerBody.Fit
    default property alias content: body.content

    signal confirmed()
    signal dismissed()

    anchors.fill: parent
    visible: open || panel.y < height
    z: 1000

    Rectangle {
        anchors.fill: parent
        color: Md3Theme.colorScheme.surface
        opacity: root.open ? 1 : 0
        Behavior on opacity {
            NumberAnimation {
                    duration: Md3Motion.overlayDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.standard
                }
        }
    }

    Rectangle {
        id: panel
        width: parent.width
        height: parent.height
        y: root.open ? 0 : parent.height
        color: Md3Theme.colorScheme.surface

        Behavior on y {
            NumberAnimation {
                    duration: Md3Motion.spatialDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.emphasized
                }
        }

        Row {
            id: bar
            width: parent.width
            height: 64
            spacing: 8
            leftPadding: 8
            rightPadding: 8

            Md3IconButton {
                icon: "close"
                accessibleName: "Close"
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    root.open = false
                    root.dismissed()
                }
            }
            Text {
                text: root.title
                color: Md3Theme.colorScheme.colorOnSurface
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.typography.titleLarge.size
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 160
                elide: Text.ElideRight
            }
            Md3Button {
                text: root.confirmText
                variant: Md3Button.Text
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    root.open = false
                    root.confirmed()
                }
            }
        }

        Md3ContainerBody {
            id: body
            anchors.top: bar.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 24
            layoutMode: root.layoutMode
        }
    }
}
