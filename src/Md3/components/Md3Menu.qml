import QtQuick
import QtQuick.Window

Item {
    id: root

    // Lightweight controller — overlay is hosted on the window
    width: 0
    height: 0

    property bool open: false
    property real menuX: 0
    property real menuY: 0
    property real menuWidth: 0 // 0 = content width
    property bool modal: true
    default property alias content: column.data

    readonly property real containerRadius: Md3Theme.shape.large

    function popup(x, y) {
        menuX = x
        menuY = y
        open = true
    }

    function dismiss() {
        open = false
    }

    // Map local (caller) coords into the overlay host
    function popupAtItem(item, x, y) {
        if (!item || !host)
            return
        const p = item.mapToItem(host, x, y)
        popup(p.x, p.y)
    }

    Item {
        id: host
        parent: Window.window ? Window.window.contentItem : root.parent
        anchors.fill: parent
        z: 5000
        // Hide when fully closed so we never steal clicks (opacity-0 Items still receive mouse)
        visible: root.open || panel.opacity > 0.01

        Rectangle {
            anchors.fill: parent
            color: Md3Theme.colorScheme.scrim
            opacity: root.open && root.modal ? 0.08 : 0
            visible: opacity > 0.001
            Behavior on opacity {
                NumberAnimation {
                    duration: Md3Motion.short2
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.standard
                }
            }
            MouseArea {
                anchors.fill: parent
                enabled: root.open && root.modal
                onClicked: root.dismiss()
            }
        }

        Md3Shadow {
            anchors.fill: panel
            elevation: root.open ? 2 : 0
            cornerRadius: root.containerRadius
            opacity: panel.opacity
        }

        Rectangle {
            id: panel
            x: root.menuX
            width: root.menuWidth > 0 ? root.menuWidth : Math.max(112, column.implicitWidth)
            height: column.implicitHeight + 16
            radius: root.containerRadius
            color: Md3Theme.colorScheme.surfaceContainer
            clip: true
            transformOrigin: Item.Top

            property real yOffset: root.open ? 0 : -6
            y: root.menuY + yOffset
            opacity: root.open ? 1 : 0
            scale: root.open ? 1 : 0.96

            // Closed panel must not eat input
            enabled: root.open || opacity > 0.01

            Behavior on opacity {
                NumberAnimation {
                    duration: Md3Motion.short3
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.standard
                }
            }
            Behavior on scale {
                NumberAnimation {
                    duration: Md3Motion.short3
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.emphasizedDecelerate
                }
            }
            Behavior on yOffset {
                NumberAnimation {
                    duration: Md3Motion.short3
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.emphasized
                }
            }

            Column {
                id: column
                anchors.top: parent.top
                anchors.topMargin: 8
                anchors.left: parent.left
                anchors.right: parent.right
                width: parent.width
            }
        }
    }
}
