import QtQuick
import Md3

/// Data-driven virtualized grid with selection (WinUI GridView).
Item {
    id: root

    enum SelectionMode { None, Single, Multiple }

    property var model: []
    property Component delegate: null
    property real cellWidth: 140
    property real cellHeight: 140
    property real spacing: 12
    property int selectionMode: Md3GridView.Single
    property var selectedIndices: []
    property int currentIndex: -1
    property bool clipContent: true
    property int cacheBufferPx: 800
    property string emptyText: qsTr("No items")
    property string emptyIcon: "grid_view"
    /// Drop GridView delegates while page is off-display (shell size stays).
    property bool unloadWhenPageInactive: true

    signal itemActivated(int index, var item)
    signal itemClicked(int index, var item)
    signal selectionChanged()
    signal currentIndexChangedByUser(int index, var item)

    implicitWidth: 400
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
    Accessible.name: emptyText.length ? emptyText : qsTr("Grid")

    function clearSelection() {
        selectedIndices = []
        selectionChanged()
    }

    function isSelected(index) {
        return selectedIndices.indexOf(index) >= 0
    }

    function toggleSelection(index) {
        if (selectionMode === Md3GridView.None || index < 0)
            return
        if (selectionMode === Md3GridView.Single) {
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

    function _count() { return model ? model.length : 0 }
    function _itemAt(index) {
        if (!model || index < 0 || index >= model.length)
            return null
        return model[index]
    }

    function _activateClick(index, modifiers) {
        const item = _itemAt(index)
        currentIndex = index
        grid.currentIndex = index
        currentIndexChangedByUser(index, item)
        itemClicked(index, item)
        if (selectionMode === Md3GridView.Multiple && (modifiers & Qt.ControlModifier))
            toggleSelection(index)
        else if (selectionMode !== Md3GridView.None) {
            selectedIndices = [index]
            selectionChanged()
        }
    }

    function _syncDelegate(item, index, modelData, isCurrent, isSelected) {
        if (!item)
            return
        try { item.listIndex = index } catch (e) { }
        try { item.modelData = modelData } catch (e) { }
        try { item.current = isCurrent } catch (e) { }
        try { item.selected = isSelected } catch (e) { }
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

    GridView {
        id: grid
        anchors.fill: parent
        anchors.margins: 4
        model: pageGate.contentActive ? (root.model || []) : []
        cellWidth: root.cellWidth + root.spacing
        cellHeight: root.cellHeight + root.spacing
        clip: root.clipContent
        cacheBuffer: root.cacheBufferPx
        reuseItems: true
        currentIndex: root.currentIndex
        visible: pageGate.contentActive && root._count() > 0
        focus: true
        activeFocusOnTab: true
        boundsBehavior: Flickable.StopAtBounds

        delegate: Loader {
            id: cellLoader
            required property int index
            required property var modelData
            width: root.cellWidth
            height: root.cellHeight
            sourceComponent: root.delegate !== null ? root.delegate : fallbackDelegate

            readonly property bool rowSelected: {
                void root.selectedIndices
                return root.isSelected(index)
            }
            readonly property bool rowCurrent: GridView.isCurrentItem

            function sync() {
                root._syncDelegate(item, index, modelData, rowCurrent, rowSelected)
            }
            onLoaded: sync()
            onIndexChanged: sync()
            onModelDataChanged: sync()
            onRowSelectedChanged: sync()
            onRowCurrentChanged: sync()
            GridView.onReused: sync()
        }

        onCurrentIndexChanged: {
            if (root.currentIndex !== currentIndex)
                root.currentIndex = currentIndex
        }

        Keys.onReturnPressed: {
            if (root.currentIndex >= 0)
                root.itemActivated(root.currentIndex, root._itemAt(root.currentIndex))
        }
        Keys.onEnterPressed: Keys.onReturnPressed(event)
    }

    Component {
        id: fallbackDelegate
        Rectangle {
            property int listIndex: -1
            property var modelData
            property bool current: false
            property bool selected: false

            radius: Md3Theme.shape.medium
            color: selected || current
                   ? Md3Theme.colorScheme.secondaryContainer
                   : Md3Theme.colorScheme.surfaceContainerHighest
            border.width: selected || current ? 2 : 0
            border.color: Md3Theme.colorScheme.primary

            Column {
                anchors.centerIn: parent
                spacing: 8
                width: parent.width - 16
                Md3Icon {
                    anchors.horizontalCenter: parent.horizontalCenter
                    icon: modelData && modelData.icon !== undefined ? String(modelData.icon) : "image"
                    size: 36
                    iconColor: Md3Theme.colorScheme.primary
                }
                Md3Text {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: {
                        if (typeof modelData === "string")
                            return modelData
                        if (modelData && modelData.title !== undefined)
                            return String(modelData.title)
                        return modelData ? JSON.stringify(modelData) : ""
                    }
                    role: Md3Text.LabelMedium
                    elide: Text.ElideRight
                    maximumLineCount: 2
                    wrapMode: Text.WordWrap
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: function (mouse) {
                    root._activateClick(listIndex, mouse.modifiers)
                }
                onDoubleClicked: root.itemActivated(listIndex, modelData)
            }
        }
    }
}
