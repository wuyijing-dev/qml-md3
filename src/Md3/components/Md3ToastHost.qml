import QtQuick
import Md3

/// Window-level toast host: stacked multi-toast with position + enter/exit animation.
Item {
    id: root

    enum Position {
        TopCenter,
        TopRight,
        TopLeft,
        BottomRight,
        BottomLeft
    }

    property int position: Md3ToastHost.TopCenter
    property int maxVisible: 4
    property int spacing: 8
    property int defaultDurationMs: 2200
    property real edgeMargin: 16
    property real sideMargin: 16
    property real dodgeBottom: 0
    property real dodgeTop: 0

    readonly property bool _isTop: position === Md3ToastHost.TopCenter
                                   || position === Md3ToastHost.TopRight
                                   || position === Md3ToastHost.TopLeft
    readonly property bool _isCenter: position === Md3ToastHost.TopCenter
    readonly property bool _isLeft: position === Md3ToastHost.TopLeft
                                    || position === Md3ToastHost.BottomLeft
    readonly property bool _isRight: position === Md3ToastHost.TopRight
                                     || position === Md3ToastHost.BottomRight

    anchors.fill: parent ? parent : undefined
    z: 1300
    // Pass-through — only toast chips intercept input.
    enabled: true

    property var _queue: []
    property int _serial: 0

    ListModel {
        id: activeModel
    }

    function show(message, options) {
        const opts = options || {}
        if (opts.position !== undefined)
            root.position = _resolvePosition(opts.position)
        const toastId = opts.id !== undefined ? String(opts.id) : ("toast-" + (++_serial))
        const entry = {
            toastId: toastId,
            text: String(message || ""),
            severity: opts.severity !== undefined ? Number(opts.severity) : 0,
            durationMs: opts.durationMs !== undefined ? Number(opts.durationMs) : defaultDurationMs
        }
        _queue = _queue.concat([entry])
        _pump()
        return toastId
    }

    function dismissAll() {
        _queue = []
        for (let i = stackRepeater.count - 1; i >= 0; --i) {
            const item = stackRepeater.itemAt(i)
            if (item && item.toast)
                item.toast.dismiss()
        }
        activeModel.clear()
    }

    function _resolvePosition(value) {
        if (typeof value === "number")
            return value
        const s = String(value).toLowerCase().replace(/[_\s-]/g, "")
        if (s === "topright" || s === "tr")
            return Md3ToastHost.TopRight
        if (s === "topleft" || s === "tl")
            return Md3ToastHost.TopLeft
        if (s === "bottomright" || s === "br")
            return Md3ToastHost.BottomRight
        if (s === "bottomleft" || s === "bl")
            return Md3ToastHost.BottomLeft
        return Md3ToastHost.TopCenter
    }

    function _pump() {
        while (activeModel.count < maxVisible && _queue.length > 0) {
            const next = _queue[0]
            _queue = _queue.slice(1)
            activeModel.append(next)
        }
    }

    function _removeById(toastId) {
        for (let i = 0; i < activeModel.count; ++i) {
            if (String(activeModel.get(i).toastId) === String(toastId)) {
                activeModel.remove(i)
                break
            }
        }
        Qt.callLater(_pump)
    }

    Column {
        id: col
        spacing: root.spacing
        width: Math.min(420, root.width - root.sideMargin * 2)
        anchors.margins: 0
        anchors.top: root._isTop ? parent.top : undefined
        anchors.bottom: root._isTop ? undefined : parent.bottom
        anchors.horizontalCenter: root._isCenter ? parent.horizontalCenter : undefined
        anchors.left: root._isLeft ? parent.left : undefined
        anchors.right: root._isRight ? parent.right : undefined
        anchors.topMargin: root._isTop ? (root.edgeMargin + root.dodgeTop) : 0
        anchors.bottomMargin: root._isTop ? 0 : (root.edgeMargin + root.dodgeBottom)
        anchors.leftMargin: root._isLeft ? root.sideMargin : 0
        anchors.rightMargin: root._isRight ? root.sideMargin : 0

        move: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: Md3Motion.spatialDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.emphasized
            }
        }
        add: Transition {
            NumberAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: Md3Motion.overlayDuration
            }
            NumberAnimation {
                property: "scale"
                from: 0.92
                to: 1
                duration: Md3Motion.spatialDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.emphasized
            }
        }

        Repeater {
            id: stackRepeater
            model: activeModel

            Item {
                id: wrap
                required property int index
                required property string toastId
                required property string text
                required property int severity
                required property int durationMs

                width: col.width
                height: toast.height
                scale: 1
                opacity: 1
                property alias toast: toast

                Md3Toast {
                    id: toast
                    anchors.horizontalCenter: root._isCenter ? parent.horizontalCenter : undefined
                    anchors.left: root._isLeft ? parent.left : undefined
                    anchors.right: root._isRight ? parent.right : undefined
                    width: Math.min(420, parent.width)
                    maxWidth: Math.min(420, parent.width)
                    text: wrap.text
                    severity: wrap.severity
                    durationMs: wrap.durationMs
                    Component.onCompleted: show(wrap.text, {
                        severity: wrap.severity,
                        durationMs: wrap.durationMs
                    })
                    onClosed: root._removeById(wrap.toastId)
                }
            }
        }
    }

    Component.onCompleted: Md3Notify.registerToastHost(root)
    Component.onDestruction: Md3Notify.unregisterToastHost(root)
}
