import QtQuick

Item {
    id: root

    property bool open: false
    property string title: ""
    property string text: ""
    property string confirmText: "OK"
    property string dismissText: "Cancel"
    property bool showDismiss: true

    signal confirmed()
    signal dismissed()

    anchors.fill: parent
    visible: open || scrim.opacity > 0
    z: 1000

    onOpenChanged: {
        if (open)
            forceActiveFocus()
    }

    Rectangle {
        id: scrim
        anchors.fill: parent
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
            onClicked: {
                root.open = false
                root.dismissed()
            }
        }
    }

    Rectangle {
        id: panel
        anchors.centerIn: parent
        width: Math.min(parent.width - 48, 560)
        implicitHeight: col.implicitHeight + 24
        height: implicitHeight
        radius: Md3Theme.shape.extraLarge
        color: Md3Theme.colorScheme.surfaceContainerHigh
        scale: root.open ? 1 : 0.9
        opacity: root.open ? 1 : 0

        Behavior on scale {
            NumberAnimation {
                    duration: Md3Motion.menuDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.emphasizedDecelerate
                }
        }
        Behavior on opacity {
            NumberAnimation {
                    duration: Md3Motion.overlayDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.standard
                }
        }

        Column {
            id: col
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 24
            spacing: 16

            Text {
                width: parent.width
                text: root.title
                visible: root.title.length > 0
                color: Md3Theme.colorScheme.colorOnSurface
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.typography.headlineSmall.size
                wrapMode: Text.Wrap
            }
            Text {
                width: parent.width
                text: root.text
                visible: root.text.length > 0
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.typography.bodyMedium.size
                wrapMode: Text.Wrap
            }

            Row {
                anchors.right: parent.right
                spacing: 8
                Md3Button {
                    visible: root.showDismiss
                    text: root.dismissText
                    variant: Md3Button.Text
                    onClicked: {
                        root.open = false
                        root.dismissed()
                    }
                }
                Md3Button {
                    text: root.confirmText
                    variant: Md3Button.Text
                    onClicked: {
                        root.open = false
                        root.confirmed()
                    }
                }
            }
        }
    }
}
