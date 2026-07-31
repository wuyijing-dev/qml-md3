import QtQuick
import Md3

/// Pull-to-refresh host for a Flickable (touch / trackpad; desktop optional).
Item {
    id: root

    property Flickable flickable: null
    property bool refreshing: false
    property real triggerDistance: 72
    property string refreshingText: qsTr("Refreshing…")
    property string pullText: qsTr("Pull to refresh")
    property string releaseText: qsTr("Release to refresh")

    signal refreshRequested()

    anchors.fill: parent
    z: 40

    readonly property real _pull: {
        if (!flickable || refreshing)
            return 0
        return Math.max(0, -flickable.contentY)
    }
    readonly property bool _armed: _pull >= triggerDistance

    function endRefresh() {
        refreshing = false
        if (flickable && flickable.contentY < 0)
            flickable.contentY = 0
    }

    function beginRefresh() {
        if (refreshing)
            return
        refreshing = true
        refreshRequested()
    }

    Connections {
        target: root.flickable
        function onDraggingChanged() {
            if (!root.flickable || root.flickable.dragging || root.refreshing)
                return
            if (root._pull >= root.triggerDistance)
                root.beginRefresh()
        }
    }

    Item {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: Math.max(root.refreshing ? 48 : 0, Math.min(root.triggerDistance, root._pull))
        visible: height > 4 || root.refreshing
        clip: true

        Row {
            anchors.centerIn: parent
            spacing: 10
            Md3CircularProgressIndicator {
                size: 24
                indeterminate: true
                visible: root.refreshing || root._armed
            }
            Md3Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.refreshing ? root.refreshingText
                      : (root._armed ? root.releaseText : root.pullText)
                role: Md3Text.LabelMedium
                tone: Md3Text.OnSurfaceVariant
            }
        }
    }
}
