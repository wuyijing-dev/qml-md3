import QtQuick

// Filter-chip group: single or multi select; moves as one unit in Md3AnimatedFlow
Item {
    id: root

    enum SelectionMode { Single, Multiple }

    property var model: [] // [{ text, icon?, enabled?, selected? }]
    property int selectionMode: Md3ChipGroup.Single
    property int currentIndex: -1
    property var selectedIndices: []
    property real spacing: 8
    property bool elevated: false
    property bool enabled: true
    property real chipHeight: 32
    property real iconSize: 18
    property real fontSize: Md3Theme.scaled(Md3Theme.typography.labelLarge.size)

    signal clicked(int index)
    signal selectionChanged()

    implicitHeight: flow.implicitHeight
    implicitWidth: flow.implicitWidth
    height: implicitHeight
    width: implicitWidth

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
        if (!enabled || index < 0 || index >= model.length)
            return
        const item = model[index]
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
            model: root.model
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
