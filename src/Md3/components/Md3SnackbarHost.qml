import QtQuick
import Md3

/// Window-level snackbar queue: stacks up to maxVisible, then queues the rest.
Item {
    id: root

    property int maxVisible: 3
    property int spacing: 10
    property int defaultDurationMs: 4000
    property real bottomMargin: 16
    property real sideMargin: 16
    /// Extra lift from bottom (e.g. dodge a performance dock).
    property real dodgeBottom: 0

    signal actionTriggered(string snackId, string actionText)
    signal messageClosed(string snackId)

    anchors.left: parent ? parent.left : undefined
    anchors.right: parent ? parent.right : undefined
    anchors.bottom: parent ? parent.bottom : undefined
    anchors.leftMargin: sideMargin
    anchors.rightMargin: sideMargin
    anchors.bottomMargin: bottomMargin + dodgeBottom
    height: col.implicitHeight
    z: 1200

    property var _queue: []
    property int _serial: 0

    ListModel {
        id: activeModel
    }

    function show(message, options) {
        const opts = options || {}
        const snackId = opts.id !== undefined ? String(opts.id) : ("snack-" + (++_serial))
        const priority = opts.priority !== undefined ? Number(opts.priority) : 0
        const entry = {
            snackId: snackId,
            text: String(message || ""),
            actionText: opts.actionText !== undefined ? String(opts.actionText) : "",
            dualLine: !!opts.dualLine,
            durationMs: opts.durationMs !== undefined ? Number(opts.durationMs) : defaultDurationMs,
            priority: priority
        }
        // Higher priority first; equal priority keeps FIFO order.
        let inserted = false
        const next = []
        for (let i = 0; i < _queue.length; ++i) {
            if (!inserted && priority > Number(_queue[i].priority || 0)) {
                next.push(entry)
                inserted = true
            }
            next.push(_queue[i])
        }
        if (!inserted)
            next.push(entry)
        _queue = next
        _pump()
        return snackId
    }

    function dismissAll() {
        _queue = []
        for (let i = stackRepeater.count - 1; i >= 0; --i) {
            const item = stackRepeater.itemAt(i)
            if (item && item.snack)
                item.snack.dismiss()
        }
        activeModel.clear()
    }

    function _pump() {
        while (activeModel.count < maxVisible && _queue.length > 0) {
            const next = _queue[0]
            _queue = _queue.slice(1)
            activeModel.append(next)
        }
    }

    function _removeById(snackId) {
        for (let i = 0; i < activeModel.count; ++i) {
            if (String(activeModel.get(i).snackId) === String(snackId)) {
                activeModel.remove(i)
                break
            }
        }
        messageClosed(snackId)
        Qt.callLater(_pump)
    }

    Column {
        id: col
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        spacing: root.spacing

        Repeater {
            id: stackRepeater
            model: activeModel

            Item {
                id: wrap
                required property int index
                required property string snackId
                required property string text
                required property string actionText
                required property bool dualLine
                required property int durationMs

                width: col.width
                height: snack.height
                property alias snack: snack

                Md3Snackbar {
                    id: snack
                    anchors.left: parent.left
                    anchors.right: parent.right
                    text: wrap.text
                    actionText: wrap.actionText
                    dualLine: wrap.dualLine
                    durationMs: wrap.durationMs
                    Component.onCompleted: show()
                    onClosed: root._removeById(wrap.snackId)
                    onActionClicked: root.actionTriggered(wrap.snackId, wrap.actionText)
                }
            }
        }
    }

    Component.onCompleted: Md3Notify.registerHost(root)
    Component.onDestruction: Md3Notify.unregisterHost(root)
}
