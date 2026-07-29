import QtQuick

Item {
    id: root

    property bool open: false
    property string title: ""
    property string text: ""
    property string confirmText: "OK"
    property string dismissText: "Cancel"
    property bool showDismiss: true
    /// Custom body between text and action buttons.
    default property alias content: bodySlot.data

    signal confirmed()
    signal dismissed()

    anchors.fill: parent
    visible: open || scrim.opacity > 0
    z: 1000
    focus: open

    function accept() {
        open = false
        confirmed()
    }

    function reject() {
        open = false
        dismissed()
    }

    onOpenChanged: {
        if (open) {
            forceActiveFocus()
            Qt.callLater(function () {
                if (confirmBtn.visible)
                    confirmBtn.forceActiveFocus()
                else if (dismissBtn.visible)
                    dismissBtn.forceActiveFocus()
            })
        }
    }

    Keys.onPressed: function (event) {
        if (!open)
            return
        if (event.key === Qt.Key_Escape) {
            reject()
            event.accepted = true
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            accept()
            event.accepted = true
        }
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
            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            anchors.fill: parent
            onClicked: root.reject()
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

        Md3FocusRing {
            anchors.fill: parent
            anchors.margins: -4
            radius: panel.radius + 4
            focused: root.activeFocus
            controlEnabled: true
            visualFocus: root.activeFocus
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

            Item {
                id: bodySlot
                width: parent.width
                height: childrenRect.height
                visible: children.length > 0
            }

            Row {
                anchors.right: parent.right
                spacing: 8
                Md3Button {
                    id: dismissBtn
                    visible: root.showDismiss
                    text: root.dismissText
                    variant: Md3Button.Text
                    onClicked: root.reject()
                }
                Md3Button {
                    id: confirmBtn
                    text: root.confirmText
                    variant: Md3Button.Text
                    onClicked: root.accept()
                }
            }
        }
    }
}
