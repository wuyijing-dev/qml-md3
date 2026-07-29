import QtQuick

/// Multi-tag / chip input — Enter or comma commits; Backspace removes last tag.
Item {
    id: root

    enum Variant { Filled, Outlined }

    property int variant: Md3TagField.Filled
    property var tags: []
    property string label: ""
    property string placeholderText: qsTr("Add tag")
    property string supportingText: ""
    property string errorText: ""
    property bool error: false
    property string name: ""
    property bool allowDuplicates: false
    /// Characters that commit the draft (in addition to Enter).
    property string separators: ",;"
    property int maxTags: 0
    property string accessibleName: ""

    signal tagAdded(string tag)
    signal tagRemoved(string tag, int index)
    signal tagsChangedByUser()

    readonly property bool hasError: error || errorText.length > 0
    readonly property string helper: hasError ? (errorText.length ? errorText : supportingText) : supportingText
    readonly property bool focused: draft.activeFocus
    readonly property bool floated: focused || tags.length > 0 || draft.text.length > 0
    readonly property color activeColor: hasError ? Md3Theme.colorScheme.error
                                                  : Md3Theme.colorScheme.primary
    readonly property color fieldSurface: Md3Theme.colorScheme.surface

    function addTag(raw) {
        if (!enabled)
            return false
        const t = String(raw || "").trim()
        if (!t.length)
            return false
        if (maxTags > 0 && tags.length >= maxTags)
            return false
        if (!allowDuplicates) {
            for (let i = 0; i < tags.length; ++i) {
                if (String(tags[i]).toLowerCase() === t.toLowerCase())
                    return false
            }
        }
        tags = tags.concat([t])
        tagAdded(t)
        tagsChangedByUser()
        return true
    }

    function removeAt(index) {
        if (index < 0 || index >= tags.length)
            return
        const t = String(tags[index])
        const next = tags.slice()
        next.splice(index, 1)
        tags = next
        tagRemoved(t, index)
        tagsChangedByUser()
    }

    function clear() {
        if (!tags.length)
            return
        tags = []
        tagsChangedByUser()
    }

    function commitDraft() {
        if (addTag(draft.text))
            draft.text = ""
    }

    function _stripSeparators(text) {
        let s = String(text || "")
        for (let i = 0; i < separators.length; ++i)
            s = s.split(separators[i]).join("")
        return s
    }

    width: parent ? Math.min(parent.width, 480) : 360
    implicitHeight: col.implicitHeight
    height: implicitHeight
    activeFocusOnTab: enabled
    Accessible.name: accessibleName.length ? accessibleName : (label.length ? label : qsTr("Tags"))
    Accessible.role: Accessible.EditableText

    Column {
        id: col
        width: parent.width
        spacing: 4

        Item {
            id: field
            width: parent.width
            height: Math.max(56, flow.implicitHeight + 20)

            Rectangle {
                anchors.fill: parent
                radius: Md3Theme.shape.extraSmall
                color: root.variant === Md3TagField.Filled
                       ? Md3Theme.colorScheme.surfaceContainerHighest
                       : root.fieldSurface
                border.width: root.variant === Md3TagField.Outlined ? 1 : 0
                border.color: root.focused || root.hasError
                              ? root.activeColor
                              : Md3Theme.colorScheme.outline
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: root.focused || root.hasError ? 2 : 1
                visible: root.variant === Md3TagField.Filled
                color: root.focused || root.hasError ? root.activeColor
                                                     : Md3Theme.colorScheme.colorOnSurfaceVariant
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 16
                y: root.floated ? 6 : (parent.height - implicitHeight) / 2
                text: root.label
                visible: root.label.length > 0
                color: root.focused || root.hasError ? root.activeColor
                                                     : Md3Theme.colorScheme.colorOnSurfaceVariant
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: root.floated
                                ? Md3Theme.typography.bodySmall.size
                                : Md3Theme.typography.bodyLarge.size
                Behavior on y { NumberAnimation { duration: Md3Motion.effectsDuration } }
                Behavior on font.pixelSize { NumberAnimation { duration: Md3Motion.effectsDuration } }
            }

            Flow {
                id: flow
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 8
                anchors.topMargin: root.label.length ? 22 : 8
                spacing: 6

                Repeater {
                    model: root.tags
                    Md3InputChip {
                        required property int index
                        required property var modelData
                        text: String(modelData)
                        enabled: root.enabled
                        onRemoved: root.removeAt(index)
                    }
                }

                TextInput {
                    id: draft
                    width: Math.max(80, Math.min(160, implicitWidth + 8))
                    height: 32
                    verticalAlignment: TextInput.AlignVCenter
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.bodyLarge.size
                    enabled: root.enabled
                    clip: true
                    selectByMouse: true
                    KeyNavigation.priority: KeyNavigation.BeforeItem

                    Text {
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        visible: !draft.text.length && root.tags.length === 0
                        text: root.placeholderText
                        color: Md3Theme.colorScheme.colorOnSurfaceVariant
                        font: draft.font
                    }

                    Keys.onPressed: function (event) {
                        if (event.key === Qt.Key_Backspace && draft.text.length === 0
                                && root.tags.length > 0) {
                            root.removeAt(root.tags.length - 1)
                            event.accepted = true
                            return
                        }
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            root.commitDraft()
                            event.accepted = true
                        }
                    }

                    onTextChanged: {
                        if (!text.length || !root.separators.length)
                            return
                        for (let i = 0; i < root.separators.length; ++i) {
                            const sep = root.separators[i]
                            if (text.indexOf(sep) >= 0) {
                                const parts = text.split(sep)
                                for (let p = 0; p < parts.length - 1; ++p)
                                    root.addTag(parts[p])
                                text = root._stripSeparators(parts[parts.length - 1] || "")
                                break
                            }
                        }
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                z: -1
                enabled: root.enabled
                cursorShape: Qt.IBeamCursor
                onClicked: draft.forceActiveFocus()
            }
        }

        Text {
            width: parent.width
            leftPadding: 16
            visible: root.helper.length > 0
            text: root.helper
            color: root.hasError ? Md3Theme.colorScheme.error
                                 : Md3Theme.colorScheme.colorOnSurfaceVariant
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.bodySmall.size
            wrapMode: Text.Wrap
        }
    }
}
