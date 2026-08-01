import QtQuick
import Md3

/// Unified items host with stack or grid layout strategy (WinUI ItemsView-lite).
Item {
    id: root

    enum Layout { Stack, Grid }

    property int layout: Md3ItemsView.Stack
    property var model: []
    property Component delegate: null
    property real itemHeight: 56
    property real cellWidth: 140
    property real cellHeight: 140
    property real spacing: 8
    property int selectionMode: Md3ListView.Single
    property var selectedIndices: []
    property int currentIndex: -1
    property string sectionRole: ""
    property string emptyText: qsTr("No items")

    signal itemActivated(int index, var item)
    signal itemClicked(int index, var item)
    signal selectionChanged()

    implicitWidth: 400
    implicitHeight: 280
    readonly property Md3HeightSync _heightSync: Md3HeightSync {
        target: root
        enabled: !root.anchors.fill
        policy: Md3HeightSync.AtLeastImplicit
    }

    onSelectedIndicesChanged: {
        if (layout === Md3ItemsView.Stack)
            listView.selectedIndices = selectedIndices
        else
            gridView.selectedIndices = selectedIndices
    }
    onCurrentIndexChanged: {
        if (layout === Md3ItemsView.Stack)
            listView.currentIndex = currentIndex
        else
            gridView.currentIndex = currentIndex
    }

    function clearSelection() {
        selectedIndices = []
        if (layout === Md3ItemsView.Stack)
            listView.clearSelection()
        else
            gridView.clearSelection()
    }

    Md3ListView {
        id: listView
        anchors.fill: parent
        visible: root.layout === Md3ItemsView.Stack
        model: root.model
        delegate: root.delegate
        itemHeight: root.itemHeight
        selectionMode: root.selectionMode
        sectionRole: root.sectionRole
        emptyText: root.emptyText
        onItemActivated: function (i, item) { root.itemActivated(i, item) }
        onItemClicked: function (i, item) { root.itemClicked(i, item) }
        onSelectionChanged: {
            root.selectedIndices = selectedIndices
            root.selectionChanged()
        }
        onCurrentIndexChanged: root.currentIndex = currentIndex
    }

    Md3GridView {
        id: gridView
        anchors.fill: parent
        visible: root.layout === Md3ItemsView.Grid
        model: root.model
        delegate: root.delegate
        cellWidth: root.cellWidth
        cellHeight: root.cellHeight
        spacing: root.spacing
        selectionMode: root.selectionMode
        emptyText: root.emptyText
        onItemActivated: function (i, item) { root.itemActivated(i, item) }
        onItemClicked: function (i, item) { root.itemClicked(i, item) }
        onSelectionChanged: {
            root.selectedIndices = selectedIndices
            root.selectionChanged()
        }
        onCurrentIndexChanged: root.currentIndex = currentIndex
    }
}
