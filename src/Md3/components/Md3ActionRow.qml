import QtQuick
import Md3

/// Compact vertical stack of full-width actions (detail cards / sheets).
Column {
    id: root

    property var model: []
    property real rowSpacing: 8
    /// When > 0 and model is longer, collapse remainder into an overflow menu.
    property int maxVisible: 0
    property string overflowText: qsTr("More actions")

    signal actionClicked(int index)

    width: parent ? parent.width : 200
    spacing: rowSpacing

    readonly property bool _overflow: maxVisible > 0 && model && model.length > maxVisible
    readonly property int _visibleCount: _overflow ? maxVisible : (model ? model.length : 0)

    function _variant(e) {
        if (!e || e.variant === undefined)
            return Md3Button.Outlined
        if (typeof e.variant === "number")
            return e.variant
        const s = String(e.variant).toLowerCase()
        if (s === "filled")
            return Md3Button.Filled
        if (s === "tonal" || s === "filledtonal")
            return Md3Button.FilledTonal
        if (s === "text")
            return Md3Button.Text
        if (s === "error" || s === "destructive")
            return Md3Button.Filled
        return Md3Button.Outlined
    }

    Repeater {
        model: root._visibleCount
        Md3Button {
            required property int index
            width: root.width
            text: {
                const e = root.model[index]
                return e && e.text !== undefined ? String(e.text) : String(e)
            }
            icon: {
                const e = root.model[index]
                return e && e.icon !== undefined ? String(e.icon) : ""
            }
            variant: root._variant(root.model[index])
            onClicked: root.actionClicked(index)
        }
    }

    Md3DropDownButton {
        visible: root._overflow
        width: root.width
        text: root.overflowText
        variant: Md3DropDownButton.Outlined
        menuModel: {
            const out = []
            for (let i = root._visibleCount; i < root.model.length; ++i) {
                const e = root.model[i]
                out.push({
                    text: e && e.text !== undefined ? String(e.text) : String(e),
                    _index: i
                })
            }
            return out
        }
        onMenuItemClicked: function (i) {
            const rows = menuModel
            if (!rows || i < 0 || i >= rows.length)
                return
            root.actionClicked(rows[i]._index !== undefined ? rows[i]._index : (root._visibleCount + i))
        }
    }
}
