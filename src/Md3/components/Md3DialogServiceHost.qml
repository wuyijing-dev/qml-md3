import QtQuick
import Md3

/// Overlay host for ``Md3DialogHost.confirm`` / ``prompt``. Placed by ApplicationWindow.
Item {
    id: root

    anchors.fill: parent
    z: 1400

    property var _onConfirmed: null
    property var _onDismissed: null
    property bool _isPrompt: false

    Component.onCompleted: Md3DialogHost.registerHost(root)
    Component.onDestruction: Md3DialogHost.unregisterHost(root)

    function confirm(options) {
        const o = options || {}
        _isPrompt = false
        _onConfirmed = typeof o.onConfirmed === "function" ? o.onConfirmed : null
        _onDismissed = typeof o.onDismissed === "function" ? o.onDismissed : null
        dlg.title = o.title !== undefined ? String(o.title) : qsTr("Confirm")
        dlg.text = o.text !== undefined ? String(o.text) : ""
        dlg.confirmText = o.confirmText !== undefined ? String(o.confirmText) : qsTr("OK")
        dlg.dismissText = o.dismissText !== undefined ? String(o.dismissText) : qsTr("Cancel")
        dlg.showDismiss = o.showDismiss !== false
        dlg.confirmTone = o.confirmTone !== undefined ? o.confirmTone : Md3Dialog.Primary
        dlg.preferredWidth = o.preferredWidth !== undefined ? o.preferredWidth : 560
        promptField.visible = false
        dlg.open = true
        return true
    }

    function prompt(options) {
        const o = options || {}
        _isPrompt = true
        _onConfirmed = typeof o.onConfirmed === "function" ? o.onConfirmed : null
        _onDismissed = typeof o.onDismissed === "function" ? o.onDismissed : null
        dlg.title = o.title !== undefined ? String(o.title) : qsTr("Input")
        dlg.text = o.text !== undefined ? String(o.text) : ""
        dlg.confirmText = o.confirmText !== undefined ? String(o.confirmText) : qsTr("OK")
        dlg.dismissText = o.dismissText !== undefined ? String(o.dismissText) : qsTr("Cancel")
        dlg.showDismiss = o.showDismiss !== false
        dlg.confirmTone = o.confirmTone !== undefined ? o.confirmTone : Md3Dialog.Primary
        dlg.preferredWidth = o.preferredWidth !== undefined ? o.preferredWidth : 560
        promptField.label = o.label !== undefined ? String(o.label) : ""
        promptField.placeholderText = o.placeholder !== undefined ? String(o.placeholder) : ""
        promptField.text = o.value !== undefined ? String(o.value) : ""
        promptField.visible = true
        dlg.open = true
        Qt.callLater(function () { promptField.forceActiveFocus() })
        return true
    }

    Md3Dialog {
        id: dlg
        anchors.fill: parent
        writeOpenOnClose: true
        onConfirmed: {
            const cb = root._onConfirmed
            root._onConfirmed = null
            root._onDismissed = null
            if (cb) {
                if (root._isPrompt)
                    cb(promptField.text)
                else
                    cb()
            }
        }
        onDismissed: {
            const cb = root._onDismissed
            root._onConfirmed = null
            root._onDismissed = null
            if (cb)
                cb()
        }

        Md3TextField {
            id: promptField
            width: parent ? parent.width : 280
            visible: false
        }
    }
}
