import QtQuick

/// Window-level toast host (top-center). Registers with Md3Notify.
Item {
    id: root

    property int defaultDurationMs: 2200
    property real topMargin: 16

    anchors.left: parent ? parent.left : undefined
    anchors.right: parent ? parent.right : undefined
    anchors.top: parent ? parent.top : undefined
    anchors.topMargin: topMargin
    height: toast.height
    z: 1300

    function show(message, options) {
        const opts = options || {}
        toast.durationMs = opts.durationMs !== undefined ? Number(opts.durationMs) : defaultDurationMs
        toast.show(message, opts)
        return "toast"
    }

    function dismissAll() {
        toast.dismiss()
    }

    Md3Toast {
        id: toast
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: Math.min(420, parent.width - 48)
    }

    Component.onCompleted: Md3Notify.registerToastHost(root)
    Component.onDestruction: Md3Notify.unregisterToastHost(root)
}
