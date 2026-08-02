import QtQuick
import Md3

// Filter-chip group: single or multi select; moves as one unit in Md3AnimatedFlow
Item {
    id: root

    enum SelectionMode { Single, Multiple }

    /// Object rows `[{ text, icon?, enabled?, selected? }]`, or a string list / QStringList
    /// (each entry becomes `{ text: String(entry) }`).
    property var model: []
    property int selectionMode: Md3ChipGroup.Single
    property int currentIndex: -1
    property var selectedIndices: []
    property real spacing: 8
    property bool elevated: false
    property real chipHeight: 32
    property real iconSize: 18
    property real fontSize: Md3Theme.scaled(Md3Theme.typography.labelLarge.size)

    signal clicked(int index)
    signal selectionChanged()

    /// Normalize `model` so Repeater always sees `{ text, … }` objects.
    readonly property var normalizedModel: {
        const m = model
        if (!m)
            return []
        if (typeof m === "string")
            return [{ text: m }]
        // QStringList / JS string array
        const n = (m.length !== undefined) ? m.length
                  : (m.count !== undefined ? m.count : 0)
        if (!n)
            return Array.isArray(m) ? m : []
        const out = []
        for (let i = 0; i < n; ++i) {
            const entry = (m.length !== undefined) ? m[i]
                          : (typeof m.get === "function" ? m.get(i) : m[i])
            if (entry === undefined || entry === null)
                continue
            if (typeof entry === "string" || typeof entry === "number")
                out.push({ text: String(entry) })
            else if (typeof entry === "object")
                out.push(entry)
            else
                out.push({ text: String(entry) })
        }
        return out
    }

    implicitHeight: flow.implicitHeight
    implicitWidth: flow.implicitWidth
    height: implicitHeight
    width: implicitWidth

    Accessible.role: Accessible.Grouping
    Accessible.name: qsTr("Chip group")

    function isSelected(index) {
        if (selectionMode === Md3ChipGroup.Single)
            return currentIndex === index
        return selectedIndices.indexOf(index) >= 0
    }

    function _setSingle(index) {
        if (currentIndex === index)
            return
        currentIndex = index
        selectedIndices = index >= 0 ? [index] : []
        selectionChanged()
    }

    function _toggleMulti(index) {
        const next = selectedIndices.slice()
        const at = next.indexOf(index)
        if (at >= 0)
            next.splice(at, 1)
        else
            next.push(index)
        next.sort(function (a, b) { return a - b })
        selectedIndices = next
        currentIndex = next.length ? next[next.length - 1] : -1
        selectionChanged()
    }

    function select(index) {
        const rows = normalizedModel
        if (!enabled || index < 0 || index >= rows.length)
            return
        const item = rows[index]
        if (item && item.enabled === false)
            return
        if (selectionMode === Md3ChipGroup.Single)
            _setSingle(index)
        else
            _toggleMulti(index)
        clicked(index)
    }

    // Keep chips in a tight row — whole group is one flow cell for title-bar reflow
    Row {
        id: flow
        spacing: root.spacing

        Repeater {
            model: root.normalizedModel
            delegate: Md3FilterChip {
                required property int index
                required property var modelData
                text: modelData.text !== undefined ? modelData.text : ""
                icon: modelData.icon !== undefined ? modelData.icon : ""
                elevated: root.elevated
                enabled: root.enabled && !(modelData.enabled === false)
                selected: root.isSelected(index)
                chipHeight: root.chipHeight
                iconSize: root.iconSize
                fontSize: root.fontSize
                onClicked: root.select(index)
            }
        }
    }
}
