import QtQuick
import Md3

/// Thin virtualized list wrapper for large models with jump/scroll helpers.
/// Prefer Md3ListView when you need section headers or multi-select; this type
/// remains the lightweight ItemsRepeater-style primitive.
Item {
    id: root

    property var model: []
    property Component delegate: null
    property real itemHeight: Md3Theme.tableRowHeight
    property bool clipContent: true
    property int cacheBufferPx: 800
    property int currentIndex: -1
    property bool interactive: true
    property string emptyText: qsTr("No items")
    /// Screen-reader label (defaults to “Virtual list”).
    property string accessibleName: ""

    signal itemActivated(int index, var item)
    signal currentIndexChangedByUser(int index, var item)

    implicitWidth: 320
    implicitHeight: 280
    readonly property Md3HeightSync _heightSync: Md3HeightSync {
        target: root
        enabled: !root.anchors.fill
        policy: Md3HeightSync.AtLeastImplicit
    }

    Accessible.role: Accessible.List
    Accessible.name: accessibleName.length ? accessibleName : qsTr("Virtual list")

    function scrollToIndex(index) {
        if (index < 0 || index >= (model ? model.length : 0))
            return
        list.positionViewAtIndex(index, ListView.Center)
    }

    function revealIndex(index) {
        if (index < 0 || index >= (model ? model.length : 0))
            return
        list.positionViewAtIndex(index, ListView.Contain)
    }

    /// Opt-in sync: write only when the delegate declares the property (else ignore).
    function _syncDelegate(item, index, modelData, isCurrent) {
        if (!item)
            return
        _trySet(item, "listIndex", index)
        _trySet(item, "modelData", modelData)
        _trySet(item, "current", isCurrent)
    }

    function _trySet(obj, name, value) {
        try {
            obj[name] = value
        } catch (e) {
            // Delegate did not declare this property.
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        visible: !model || model.length === 0

        Text {
            anchors.centerIn: parent
            text: root.emptyText
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.bodyMedium.size
        }
    }

    ListView {
        id: list
        anchors.fill: parent
        model: root.model || []
        clip: root.clipContent
        cacheBuffer: root.cacheBufferPx
        reuseItems: true
        interactive: root.interactive
        currentIndex: root.currentIndex
        boundsBehavior: Flickable.StopAtBounds
        visible: model && model.length > 0
        focus: true
        activeFocusOnTab: true

        Keys.onPressed: function (event) {
            const n = root.model ? root.model.length : 0
            if (n <= 0)
                return
            if (event.key === Qt.Key_Up) {
                if (currentIndex > 0) {
                    currentIndex = currentIndex - 1
                    root.currentIndexChangedByUser(currentIndex, root.model[currentIndex])
                    positionViewAtIndex(currentIndex, ListView.Contain)
                }
                event.accepted = true
            } else if (event.key === Qt.Key_Down) {
                if (currentIndex < 0)
                    currentIndex = 0
                else if (currentIndex < n - 1)
                    currentIndex = currentIndex + 1
                else {
                    event.accepted = true
                    return
                }
                root.currentIndexChangedByUser(currentIndex, root.model[currentIndex])
                positionViewAtIndex(currentIndex, ListView.Contain)
                event.accepted = true
            } else if (event.key === Qt.Key_Home) {
                currentIndex = 0
                root.currentIndexChangedByUser(0, root.model[0])
                positionViewAtIndex(0, ListView.Beginning)
                event.accepted = true
            } else if (event.key === Qt.Key_End) {
                currentIndex = n - 1
                root.currentIndexChangedByUser(currentIndex, root.model[currentIndex])
                positionViewAtIndex(currentIndex, ListView.End)
                event.accepted = true
            } else if (event.key === Qt.Key_PageUp) {
                const step = Math.max(1, Math.floor(height / root.itemHeight) - 1)
                currentIndex = Math.max(0, (currentIndex < 0 ? 0 : currentIndex) - step)
                root.currentIndexChangedByUser(currentIndex, root.model[currentIndex])
                positionViewAtIndex(currentIndex, ListView.Contain)
                event.accepted = true
            } else if (event.key === Qt.Key_PageDown) {
                const step = Math.max(1, Math.floor(height / root.itemHeight) - 1)
                currentIndex = Math.min(n - 1, (currentIndex < 0 ? 0 : currentIndex) + step)
                root.currentIndexChangedByUser(currentIndex, root.model[currentIndex])
                positionViewAtIndex(currentIndex, ListView.Contain)
                event.accepted = true
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter
                       || event.key === Qt.Key_Space) {
                if (currentIndex >= 0) {
                    root.itemActivated(currentIndex, root.model[currentIndex])
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
            // Exposed for delegate Components that bind `modelData` / `index` via Loader scope.
            sourceComponent: root.delegate !== null ? root.delegate : fallbackDelegate

            function sync() {
                root._syncDelegate(item, index, modelData, ListView.isCurrentItem)
            }

            onLoaded: sync()
            onIndexChanged: sync()
            onModelDataChanged: sync()
            ListView.onIsCurrentItemChanged: sync()
        }

        onCurrentIndexChanged: {
            if (root.currentIndex !== currentIndex)
                root.currentIndex = currentIndex
        }
    }

    Component {
        id: fallbackDelegate
        Rectangle {
            property int listIndex: -1
            property var modelData
            property bool current: false

            color: current ? Md3Theme.colorScheme.secondaryContainer : "transparent"

            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 12
                anchors.right: parent.right
                anchors.rightMargin: 12
                text: typeof modelData === "string"
                      ? modelData
                      : (modelData && modelData.title !== undefined ? String(modelData.title) : JSON.stringify(modelData))
                color: current ? Md3Theme.colorScheme.colorOnSecondaryContainer
                               : Md3Theme.colorScheme.colorOnSurface
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.typography.bodyMedium.size
                elide: Text.ElideRight
            }

            MouseArea {
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                anchors.fill: parent
                onClicked: {
                    list.currentIndex = parent.listIndex
                    root.currentIndexChangedByUser(parent.listIndex, parent.modelData)
                }
                onDoubleClicked: {
                    list.currentIndex = parent.listIndex
                    root.itemActivated(parent.listIndex, parent.modelData)
                }
            }

            Md3Divider {
                anchors.bottom: parent.bottom
                width: parent.width
            }
        }
    }
}
