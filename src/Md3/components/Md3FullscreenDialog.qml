import QtQuick
import Md3

Item {
    id: root

    property bool open: false
    property string title: ""
    property string confirmText: qsTr("Save")
    property int layoutMode: Md3ContainerBody.Fit
    default property alias content: body.content

    signal confirmed()
    signal dismissed()

    anchors.fill: parent
    visible: open || panel.y < height
    z: 1000
    focus: open
    Accessible.role: Accessible.Dialog
    Accessible.name: title.length ? title : qsTr("Fullscreen dialog")

    property var _restoreFocus: null

    function accept() {
        open = false
        confirmed()
        _restore()
    }

    function reject() {
        open = false
        dismissed()
        _restore()
    }

    function _restore() {
        const f = _restoreFocus
        _restoreFocus = null
        if (f && typeof f.forceActiveFocus === "function")
            Qt.callLater(function () {
                try { f.forceActiveFocus() } catch (e) { /* destroyed */ }
            })
    }

    onOpenChanged: {
        if (open) {
            const win = Md3OverlayHost.resolveWindow(null, root)
            if (win && win.activeFocusItem)
                _restoreFocus = win.activeFocusItem
            forceActiveFocus()
            Qt.callLater(function () {
                if (open)
                    closeBtn.forceActiveFocus()
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
            height: Md3Theme.appBarHeight
            spacing: 8
            leftPadding: 8
            rightPadding: 8

            Md3IconButton {
                id: closeBtn
                icon: "close"
                accessibleName: qsTr("Close")
                anchors.verticalCenter: parent.verticalCenter
                onClicked: root.reject()
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
                onClicked: root.accept()
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
