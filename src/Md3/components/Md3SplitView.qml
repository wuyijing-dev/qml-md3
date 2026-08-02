import QtQuick
import Md3

/// Horizontal (or vertical) draggable split panes for list/detail layouts.
///
/// **Do not put ``anchors.fill: parent`` on direct pane children** — this control
/// assigns ``x/y/width/height`` itself. Nest an inner ``Item { anchors.fill }``
/// if you need fill layout inside a pane.
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
    /// When true (default), this control owns pane geometry.
    property bool manageGeometry: true
    /// Collapse first / second pane (ratio → 0 / 1). Prefer SideSheet for transient detail.
    property bool pane1Collapsed: false
    property bool pane2Collapsed: false
    /// Warn in console when a direct child uses anchors.fill (Debug / Qt.debug builds).
    property bool warnAnchorsFill: true

    default property alias content: paneHost.data

    readonly property bool horizontal: orientation === Md3SplitView.Horizontal
    readonly property real _span: horizontal ? width : height
    readonly property real _handle: {
        if (!showHandle || pane1Collapsed || pane2Collapsed)
            return 0
        return handleThickness
    }
    readonly property real _pane1Size: {
        const avail = Math.max(0, _span - _handle)
        if (pane1Collapsed)
            return 0
        if (pane2Collapsed)
            return avail
        const ideal = avail * Math.max(0.05, Math.min(0.95, splitRatio))
        const max1 = Math.max(minPane1, avail - minPane2)
        return Math.max(minPane1, Math.min(max1, ideal))
    }
    readonly property real _pane2Size: Math.max(0, _span - _handle - _pane1Size)

    Accessible.role: Accessible.Pane
    Accessible.name: qsTr("Split view")

    Item {
        id: paneHost
        anchors.fill: parent
        onChildrenChanged: {
            root._warnPaneAnchors()
            root._layoutPanes()
        }
    }

    onWidthChanged: _layoutPanes()
    onHeightChanged: _layoutPanes()
    onSplitRatioChanged: _layoutPanes()
    onOrientationChanged: _layoutPanes()
    onMinPane1Changed: _layoutPanes()
    onMinPane2Changed: _layoutPanes()
    onPane1CollapsedChanged: _layoutPanes()
    onPane2CollapsedChanged: _layoutPanes()
    onManageGeometryChanged: _layoutPanes()
    Component.onCompleted: Qt.callLater(function () {
        root._warnPaneAnchors()
        root._layoutPanes()
    })

    function _warnPaneAnchors() {
        if (!warnAnchorsFill || !manageGeometry)
            return
        const kids = paneHost.children
        for (let i = 0; i < kids.length && i < 2; ++i) {
            const c = kids[i]
            if (!c || !c.anchors)
                continue
            if (c.anchors.fill === paneHost || c.anchors.fill === root) {
                console.warn("Md3SplitView: pane child uses anchors.fill — "
                             + "remove it (SplitView sets width/height). "
                             + "Nest an inner Item with anchors.fill instead.")
            }
        }
    }

    function _layoutPanes() {
        if (!manageGeometry)
            return
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
            a.visible = !pane1Collapsed && _pane1Size > 0.5
            if (b) {
                b.x = _pane1Size + _handle
                b.y = 0
                b.width = _pane2Size
                b.height = height
                b.visible = !pane2Collapsed && _pane2Size > 0.5
            }
        } else {
            a.x = 0
            a.y = 0
            a.width = width
            a.height = _pane1Size
            a.visible = !pane1Collapsed && _pane1Size > 0.5
            if (b) {
                b.x = 0
                b.y = _pane1Size + _handle
                b.width = width
                b.height = _pane2Size
                b.visible = !pane2Collapsed && _pane2Size > 0.5
            }
        }
    }

    Rectangle {
        id: handle
        visible: root.showHandle && paneHost.children.length > 1
                 && !root.pane1Collapsed && !root.pane2Collapsed
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
