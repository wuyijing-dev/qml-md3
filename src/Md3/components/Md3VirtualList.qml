import QtQuick
import Md3

/// Thin virtualized list wrapper for large models with jump/scroll helpers.
Item {
    id: root

    property var model: []
    property Component delegate: null
    property real itemHeight: 40
    property bool clipContent: true
    property int cacheBufferPx: 800
    property int currentIndex: -1
    property bool interactive: true
    property string emptyText: qsTr("No items")

    signal itemActivated(int index, var item)
    signal currentIndexChangedByUser(int index, var item)

    implicitWidth: 320
    implicitHeight: 280

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

        delegate: Loader {
            required property int index
            required property var modelData
            width: list.width
            height: root.itemHeight
            sourceComponent: root.delegate !== null ? root.delegate : fallbackDelegate
            onLoaded: {
                if (!item)
                    return
                item.listIndex = index
                item.modelData = modelData
                item.current = ListView.isCurrentItem
            }
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

