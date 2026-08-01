import QtQuick
import Md3

/// WinUI-style list: virtualization, section headers, single/multi selection.
Item {
    id: root

    enum SelectionMode { None, Single, Multiple }

    property var model: []
    property Component delegate: null
    property real itemHeight: 56
    property real sectionHeight: 32
    /// Model object key for ListView.section (e.g. "group").
    property string sectionRole: ""
    property int selectionMode: Md3ListView.Single
    property var selectedIndices: []
    property int currentIndex: -1
    property bool clipContent: true
    property int cacheBufferPx: 800
    property bool interactive: true
    property string emptyText: qsTr("No items")
    property string emptyIcon: "inbox"
    /// Screen-reader / AT name (defaults to “List”; do not reuse emptyText).
    property string accessibleName: ""
    /// Drop ListView delegates while page is off-display (shell size stays).
    property bool unloadWhenPageInactive: true

    signal itemActivated(int index, var item)
    signal itemClicked(int index, var item)
    signal selectionChanged()
    signal currentIndexChangedByUser(int index, var item)

    implicitWidth: 320
    implicitHeight: 280
    readonly property Md3HeightSync _heightSync: Md3HeightSync {
        target: root
        enabled: !root.anchors.fill
        policy: Md3HeightSync.AtLeastImplicit
    }

    Md3PageActivityGate {
        id: pageGate
        watchItem: root
        unloadWhenPageInactive: root.unloadWhenPageInactive
    }

    Accessible.role: Accessible.List
    Accessible.name: accessibleName.length ? accessibleName : qsTr("List")

    readonly property bool hasSections: sectionRole.length > 0

    function scrollToIndex(index) {
        if (index < 0 || index >= _count())
            return
        list.positionViewAtIndex(index, ListView.Center)
    }

    function clearSelection() {
        selectedIndices = []
        selectionChanged()
    }

    function selectAll() {
        if (selectionMode !== Md3ListView.Multiple)
            return
        const n = _count()
        const out = []
        for (let i = 0; i < n; ++i)
            out.push(i)
        selectedIndices = out
        selectionChanged()
    }

    function isSelected(index) {
        return selectedIndices.indexOf(index) >= 0
    }

    function toggleSelection(index) {
        if (selectionMode === Md3ListView.None || index < 0)
            return
        if (selectionMode === Md3ListView.Single) {
            selectedIndices = [index]
            currentIndex = index
            selectionChanged()
            return
        }
        const copy = selectedIndices.slice()
        const at = copy.indexOf(index)
        if (at >= 0)
            copy.splice(at, 1)
        else
            copy.push(index)
        copy.sort(function (a, b) { return a - b })
        selectedIndices = copy
        currentIndex = index
        selectionChanged()
    }

    function _count() {
        return model ? model.length : 0
    }

    function _itemAt(index) {
        if (!model || index < 0 || index >= model.length)
            return null
        return model[index]
    }

    function _syncDelegate(item, index, modelData, isCurrent, isSelected) {
        if (!item)
            return
        _trySet(item, "listIndex", index)
        _trySet(item, "modelData", modelData)
        _trySet(item, "current", isCurrent)
        _trySet(item, "selected", isSelected)
    }

    function _trySet(obj, name, value) {
        try { obj[name] = value } catch (e) { }
    }

    function _activateClick(index, modifiers) {
        const item = _itemAt(index)
        currentIndex = index
        list.currentIndex = index
        currentIndexChangedByUser(index, item)
        itemClicked(index, item)
        if (selectionMode === Md3ListView.Multiple && (modifiers & Qt.ControlModifier)) {
            toggleSelection(index)
        } else if (selectionMode === Md3ListView.Multiple && (modifiers & Qt.ShiftModifier)
                   && selectedIndices.length > 0) {
            const anchor = selectedIndices[selectedIndices.length - 1]
            const a = Math.min(anchor, index)
            const b = Math.max(anchor, index)
            const out = selectedIndices.slice()
            for (let i = a; i <= b; ++i) {
                if (out.indexOf(i) < 0)
                    out.push(i)
            }
            out.sort(function (x, y) { return x - y })
            selectedIndices = out
            selectionChanged()
        } else if (selectionMode !== Md3ListView.None) {
            selectedIndices = [index]
            selectionChanged()
        }
    }

    Item {
        anchors.fill: parent
        visible: root._count() === 0
        Md3EmptyState {
            anchors.centerIn: parent
            width: Math.min(parent.width - 24, 320)
            icon: root.emptyIcon
            title: root.emptyText
        }
    }

    ListView {
        id: list
        anchors.fill: parent
        model: pageGate.contentActive ? (root.model || []) : []
        clip: root.clipContent
        cacheBuffer: root.cacheBufferPx
        reuseItems: true
        interactive: root.interactive
        currentIndex: root.currentIndex
        boundsBehavior: Flickable.StopAtBounds
        visible: pageGate.contentActive && root._count() > 0
        focus: true
        activeFocusOnTab: true
        section.property: root.hasSections ? root.sectionRole : ""
        section.criteria: ViewSection.FullString
        section.labelPositioning: ViewSection.InlineLabels
        section.delegate: root.hasSections ? sectionDelegate : null

        Keys.onPressed: function (event) {
            if (event.key === Qt.Key_A && (event.modifiers & Qt.ControlModifier)
                    && root.selectionMode === Md3ListView.Multiple) {
                root.selectAll()
                event.accepted = true
            } else if (event.key === Qt.Key_Space && root.currentIndex >= 0
                       && root.selectionMode === Md3ListView.Multiple) {
                root.toggleSelection(root.currentIndex)
                event.accepted = true
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                if (root.currentIndex >= 0) {
                    root.itemActivated(root.currentIndex, root._itemAt(root.currentIndex))
                    event.accepted = true
                }
            }
        }

        delegate: Loader {
            id: rowLoader
            required property int index
            required property var modelData
            width: list.width
            height: root.itemHeight
            sourceComponent: root.delegate !== null ? root.delegate : fallbackDelegate

            /// Binding (not Connections) — avoids O(visible) fan-out on every selection change.
            readonly property bool rowSelected: {
                void root.selectedIndices
                return root.isSelected(index)
            }
            readonly property bool rowCurrent: ListView.isCurrentItem

            function sync() {
                root._syncDelegate(item, index, modelData, rowCurrent, rowSelected)
            }

            onLoaded: sync()
            onIndexChanged: sync()
            onModelDataChanged: sync()
            onRowSelectedChanged: sync()
            onRowCurrentChanged: sync()
            ListView.onReused: sync()
        }

        onCurrentIndexChanged: {
            if (root.currentIndex !== currentIndex)
                root.currentIndex = currentIndex
        }
    }

    Component {
        id: sectionDelegate
        Rectangle {
            required property string section
            width: ListView.view ? ListView.view.width : root.width
            height: root.sectionHeight
            color: Md3Theme.colorScheme.surfaceContainerLow

            Md3Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 16
                text: parent.section
                role: Md3Text.LabelMedium
                tone: Md3Text.OnSurfaceVariant
            }
        }
    }

    Component {
        id: fallbackDelegate
        Rectangle {
            id: rowRoot
            property int listIndex: -1
            property var modelData
            property bool current: false
            property bool selected: false

            color: (selected || current) ? Md3Theme.colorScheme.secondaryContainer : "transparent"

            Row {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 12

                Md3Checkbox {
                    anchors.verticalCenter: parent.verticalCenter
                    visible: root.selectionMode === Md3ListView.Multiple
                    checked: rowRoot.selected
                    onToggled: function (state) {
                        const on = state === Qt.Checked || state === true
                        if (on !== root.isSelected(rowRoot.listIndex))
                            root.toggleSelection(rowRoot.listIndex)
                    }
                }

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - (root.selectionMode === Md3ListView.Multiple ? 48 : 0)
                    spacing: 2
                    Md3Text {
                        width: parent.width
                        text: {
                            const m = rowRoot.modelData
                            if (typeof m === "string")
                                return m
                            if (m && m.title !== undefined)
                                return String(m.title)
                            if (m && m.text !== undefined)
                                return String(m.text)
                            return m ? JSON.stringify(m) : ""
                        }
                        role: Md3Text.BodyLarge
                        tone: Md3Text.Custom
                        customColor: (rowRoot.selected || rowRoot.current)
                                     ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                     : Md3Theme.colorScheme.colorOnSurface
                        elide: Text.ElideRight
                    }
                    Md3Text {
                        width: parent.width
                        visible: {
                            const m = rowRoot.modelData
                            return m && m.subtitle !== undefined && String(m.subtitle).length > 0
                        }
                        text: {
                            const m = rowRoot.modelData
                            return m && m.subtitle !== undefined ? String(m.subtitle) : ""
                        }
                        role: Md3Text.BodySmall
                        tone: Md3Text.OnSurfaceVariant
                        elide: Text.ElideRight
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                anchors.leftMargin: root.selectionMode === Md3ListView.Multiple ? 48 : 0
                cursorShape: Qt.PointingHandCursor
                onClicked: function (mouse) {
                    root._activateClick(rowRoot.listIndex, mouse.modifiers)
                }
                onDoubleClicked: root.itemActivated(rowRoot.listIndex, rowRoot.modelData)
            }

            Md3Divider {
                anchors.bottom: parent.bottom
                width: parent.width
            }
        }
    }
}
