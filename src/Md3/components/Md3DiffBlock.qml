import QtQuick
import Md3

/// Diff / patch block with optional per-hunk action footer (stage, discard, …).
Item {
    id: root

    property string code: ""
    property string language: "plain"
    property var hunkActions: []
    property int previewLineCount: 12
    property bool expanded: false
    property bool showCopyButton: true
    property int maxHeight: 280
    property bool fill: false

    signal hunkActionClicked(int index)
    signal copied(string text)

    readonly property string _previewCode: {
        const raw = String(code || "")
        if (expanded || previewLineCount <= 0)
            return raw
        const lines = raw.split("\n")
        if (lines.length <= previewLineCount)
            return raw
        return lines.slice(0, previewLineCount).join("\n") + "\n…"
    }
    readonly property bool _truncated: {
        const lines = String(code || "").split("\n")
        return previewLineCount > 0 && lines.length > previewLineCount
    }

    implicitWidth: 360
    implicitHeight: col.implicitHeight
    width: parent ? parent.width : implicitWidth
    height: fill && parent ? parent.height : implicitHeight

    Column {
        id: col
        width: parent.width
        spacing: 0

        Md3CodeBlock {
            id: block
            width: parent.width
            code: root._previewCode
            language: root.language
            maxHeight: root.fill ? Math.max(120, root.height - actionsRow.height - (_truncated ? 40 : 0))
                                  : root.maxHeight
            scrollable: true
            showCopyButton: root.showCopyButton
            showLineNumbers: false
            wrap: false
            onCopied: function (t) { root.copied(t) }
        }

        Md3Button {
            visible: root._truncated
            text: root.expanded ? qsTr("Show less") : qsTr("Show more")
            variant: Md3Button.Text
            onClicked: root.expanded = !root.expanded
        }

        Row {
            id: actionsRow
            visible: root.hunkActions && root.hunkActions.length > 0
            width: parent.width
            spacing: 8
            leftPadding: 8
            rightPadding: 8
            bottomPadding: 8

            Repeater {
                model: root.hunkActions
                Md3Button {
                    required property int index
                    required property var modelData
                    text: modelData.text !== undefined ? String(modelData.text) : String(modelData)
                    icon: modelData.icon !== undefined ? String(modelData.icon) : ""
                    variant: Md3Button.Text
                    onClicked: root.hunkActionClicked(index)
                }
            }
        }
    }
}
