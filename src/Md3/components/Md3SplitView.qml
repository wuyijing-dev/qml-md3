import QtQuick

/// Horizontal (or vertical) draggable split panes for list/detail layouts.
Item {
    id: root

    enum Orientation { Horizontal, Vertical }

    property int orientation: Md3SplitView.Horizontal
    property real splitRatio: 0.35
    property real minPane1: 180
    property real minPane2: 240
    property real handleThickness: 6
    property bool showHandle: true
    property color handleColor: Md3Theme.colorScheme.outlineVariant

    default property alias content: paneHost.data

    readonly property bool horizontal: orientation === Md3SplitView.Horizontal
    readonly property real _span: horizontal ? width : height
    readonly property real _handle: showHandle ? handleThickness : 0
    readonly property real _pane1Size: {
        const avail = Math.max(0, _span - _handle)
        const ideal = avail * Math.max(0.05, Math.min(0.95, splitRatio))
        const max1 = Math.max(minPane1, avail - minPane2)
        return Math.max(minPane1, Math.min(max1, ideal))
    }
    readonly property real _pane2Size: Math.max(0, _span - _handle - _pane1Size)

    Item {
        id: paneHost
        anchors.fill: parent

        // Children are expected as first two Items; positioned below.
        onChildrenChanged: root._layoutPanes()
    }

    onWidthChanged: _layoutPanes()
    onHeightChanged: _layoutPanes()
    onSplitRatioChanged: _layoutPanes()
    onOrientationChanged: _layoutPanes()
    onMinPane1Changed: _layoutPanes()
    onMinPane2Changed: _layoutPanes()
    Component.onCompleted: Qt.callLater(_layoutPanes)

    function _layoutPanes() {
        const kids = paneHost.children
        if (!kids || kids.length === 0)
            return
        const a = kids[0]
        const b = kids.length > 1 ? kids[1] : null
        if (horizontal) {
            a.x = 0
            a.y = 0
            a.width = _pane1Size
            a.height = height
            if (b) {
                b.x = _pane1Size + _handle
                b.y = 0
                b.width = _pane2Size
                b.height = height
            }
        } else {
            a.x = 0
            a.y = 0
            a.width = width
            a.height = _pane1Size
            if (b) {
                b.x = 0
                b.y = _pane1Size + _handle
                b.width = width
                b.height = _pane2Size
            }
        }
    }

    Rectangle {
        id: handle
        visible: root.showHandle && paneHost.children.length > 1
        z: 10
        color: root.handleColor
        width: root.horizontal ? root.handleThickness : parent.width
        height: root.horizontal ? parent.height : root.handleThickness
        x: root.horizontal ? root._pane1Size : 0
        y: root.horizontal ? 0 : root._pane1Size

        Rectangle {
            anchors.centerIn: parent
            width: root.horizontal ? 2 : 24
            height: root.horizontal ? 24 : 2
            radius: 1
            color: Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSurfaceVariant, 0.45)
        }

        MouseArea {
            anchors.fill: parent
            anchors.margins: root.horizontal ? -4 : 0
            cursorShape: root.horizontal ? Qt.SplitHCursor : Qt.SplitVCursor
            preventStealing: true
            property real _startPos: 0
            property real _startRatio: 0
            onPressed: function (mouse) {
                _startPos = root.horizontal ? mapToItem(root, mouse.x, 0).x
                                            : mapToItem(root, 0, mouse.y).y
                _startRatio = root.splitRatio
            }
            onPositionChanged: function (mouse) {
                if (!pressed)
                    return
                const pos = root.horizontal ? mapToItem(root, mouse.x, 0).x
                                            : mapToItem(root, 0, mouse.y).y
                const avail = Math.max(1, root._span - root._handle)
                const next = Math.max(root.minPane1,
                                      Math.min(avail - root.minPane2, pos))
                root.splitRatio = next / avail
            }
        }
    }
}
