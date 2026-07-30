import QtQuick
import Md3

/// Model-driven radio row/column — no host QtObject + manual Md3Radio list.
Item {
    id: root

    enum Orientation { Horizontal, Vertical }

    /// [{ text, value?, enabled? }] — value defaults to text when omitted.
    property var model: []
    property var value: null
    property int orientation: Md3RadioGroup.Horizontal
    property real spacing: 8
    // Use Item.enabled (do not redeclare)

    /// Emitted when the user picks a radio (not when `value` is set programmatically with the same value).
    signal selected(var value)

    readonly property int currentIndex: {
        const list = model || []
        for (let i = 0; i < list.length; ++i) {
            if (_entryValue(list[i]) === root.value)
                return i
        }
        return -1
    }

    implicitWidth: orientation === Md3RadioGroup.Horizontal ? row.implicitWidth : col.implicitWidth
    implicitHeight: orientation === Md3RadioGroup.Horizontal ? row.implicitHeight : col.implicitHeight
    width: implicitWidth
    height: implicitHeight

    function _entryValue(e) {
        if (e === undefined || e === null)
            return null
        if (typeof e === "object")
            return e.value !== undefined ? e.value : (e.text !== undefined ? e.text : e)
        return e
    }

    function _entryText(e) {
        if (e === undefined || e === null)
            return ""
        if (typeof e === "object")
            return e.text !== undefined ? String(e.text) : String(_entryValue(e))
        return String(e)
    }

    function _entryEnabled(e) {
        if (!root.enabled)
            return false
        if (e && typeof e === "object" && e.enabled === false)
            return false
        return true
    }

    function select(v) {
        if (root.value === v)
            return
        root.value = v
        selected(v)
    }

    QtObject {
        id: groupBridge
        property var selectedValue: root.value
        onSelectedValueChanged: {
            if (root.value !== selectedValue)
                root.select(selectedValue)
        }
    }

    onValueChanged: groupBridge.selectedValue = value
    Component.onCompleted: groupBridge.selectedValue = value

    component RadioDelegate: Md3Radio {
        required property var modelData
        text: root._entryText(modelData)
        value: root._entryValue(modelData)
        enabled: root._entryEnabled(modelData)
        group: groupBridge
        checked: root.value === value
    }

    Row {
        id: row
        visible: root.orientation === Md3RadioGroup.Horizontal
        spacing: root.spacing
        Repeater {
            model: root.orientation === Md3RadioGroup.Horizontal ? root.model : []
            delegate: RadioDelegate {}
        }
    }

    Column {
        id: col
        visible: root.orientation === Md3RadioGroup.Vertical
        spacing: root.spacing
        Repeater {
            model: root.orientation === Md3RadioGroup.Vertical ? root.model : []
            delegate: RadioDelegate {}
        }
    }
}
