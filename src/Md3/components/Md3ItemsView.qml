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

    readonly property Item _activeView: layout === Md3ItemsView.Stack ? listLoader.item : gridLoader.item

    onSelectedIndicesChanged: {
        if (_activeView)
            _activeView.selectedIndices = selectedIndices
    }
    onCurrentIndexChanged: {
        if (_activeView)
            _activeView.currentIndex = currentIndex
    }

    function clearSelection() {
        selectedIndices = []
        if (_activeView)
            _activeView.clearSelection()
    }

    Loader {
        id: listLoader
        anchors.fill: parent
        active: root.layout === Md3ItemsView.Stack
        sourceComponent: listComponent
        onLoaded: {
            if (!item)
                return
            item.selectedIndices = root.selectedIndices
            item.currentIndex = root.currentIndex
        }
    }

    Loader {
        id: gridLoader
        anchors.fill: parent
        active: root.layout === Md3ItemsView.Grid
        sourceComponent: gridComponent
        onLoaded: {
            if (!item)
                return
            item.selectedIndices = root.selectedIndices
            item.currentIndex = root.currentIndex
        }
    }

    Component {
        id: listComponent
        Md3ListView {
            anchors.fill: parent
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
    }

    Component {
        id: gridComponent
        Md3GridView {
            anchors.fill: parent
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
}
