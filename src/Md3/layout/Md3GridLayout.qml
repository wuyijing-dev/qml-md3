import QtQuick
import Md3

/// Responsive uniform grid for arbitrary child items.
Item {
    id: root

    enum Alignment {
        Start,
        Center,
        End
    }

    /// Fixed columns; <= 0 means auto by minCellWidth.
    property int columns: 0
    property real minCellWidth: 160
    property real minCellHeight: 0
    property real spacing: 12
    property real rowSpacing: spacing
    property real padding: 0
    property real leftPadding: padding
    property real rightPadding: padding
    property real topPadding: padding
    property real bottomPadding: padding
    property bool stretchCells: true
    property bool equalRowHeight: true
    property int cellAlignment: Md3GridLayout.Center
    default property alias content: host.data

    readonly property int effectiveColumns: _effectiveColumns
    readonly property real cellWidth: _cellWidth
    property int _effectiveColumns: 1
    property real _cellWidth: 0
    property real _contentHeight: 0

    implicitWidth: Math.max(1, host.implicitWidth + leftPadding + rightPadding)
    implicitHeight: _contentHeight + topPadding + bottomPadding
    width: parent ? parent.width : implicitWidth
    readonly property Md3HeightSync _heightSync: Md3HeightSync {
        target: root
        enabled: !root.anchors.fill
        policy: Md3HeightSync.AtLeastImplicit
    }

    Item {
        id: host
        x: root.leftPadding
        y: root.topPadding
        width: Math.max(0, root.width - root.leftPadding - root.rightPadding)
        height: root._contentHeight
        implicitWidth: childrenRect.width
        implicitHeight: childrenRect.height
    }

    function _itemSize(item) {
        let w = Md3QtCompat.preferredWidth(item)
        let h = Md3QtCompat.preferredHeight(item)
        if (root.minCellHeight > 0)
            h = Math.max(h, root.minCellHeight)
        return Qt.size(Math.max(1, w), Math.max(1, h))
    }

    function relayout() {
        const kids = host.children
        const visibleKids = []
        for (let i = 0; i < kids.length; ++i) {
            const c = kids[i]
            if (c && c.visible !== false)
                visibleKids.push(c)
        }

        if (visibleKids.length === 0) {
            _effectiveColumns = 1
            _cellWidth = Math.max(0, host.width)
            _contentHeight = 0
            return
        }

        const avail = Math.max(1, host.width)
        let cols = root.columns > 0
                 ? root.columns
                 : Math.floor((avail + root.spacing) / Math.max(1, root.minCellWidth + root.spacing))
        cols = Math.max(1, cols)
        _effectiveColumns = cols

        const totalSpacing = (cols - 1) * root.spacing
        const cellW = Math.max(1, (avail - totalSpacing) / cols)
        _cellWidth = cellW

        const rowHeights = []
        for (let i = 0; i < visibleKids.length; ++i) {
            const child = visibleKids[i]
            const row = Math.floor(i / cols)
            const sz = _itemSize(child)
            rowHeights[row] = Math.max(rowHeights[row] || 0, sz.height)
        }

        if (root.equalRowHeight && rowHeights.length > 0) {
            let maxH = 0
            for (let r = 0; r < rowHeights.length; ++r)
                maxH = Math.max(maxH, rowHeights[r])
            for (let r = 0; r < rowHeights.length; ++r)
                rowHeights[r] = maxH
        }

        let contentH = 0
        for (let r = 0; r < rowHeights.length; ++r)
            contentH += rowHeights[r]
        if (rowHeights.length > 1)
            contentH += (rowHeights.length - 1) * root.rowSpacing
        _contentHeight = contentH

        let y = 0
        for (let r = 0; r < rowHeights.length; ++r) {
            const rowH = rowHeights[r]
            for (let c = 0; c < cols; ++c) {
                const index = r * cols + c
                if (index >= visibleKids.length)
                    break
                const child = visibleKids[index]
                const sz = _itemSize(child)
                child.x = c * (cellW + root.spacing)
                if (root.stretchCells) {
                    child.width = cellW
                    child.height = rowH
                    child.y = y
                } else {
                    if (child.width <= 0)
                        child.width = sz.width
                    if (child.height <= 0)
                        child.height = sz.height
                    if (root.cellAlignment === Md3GridLayout.Center)
                        child.y = y + Math.max(0, (rowH - child.height) * 0.5)
                    else if (root.cellAlignment === Md3GridLayout.End)
                        child.y = y + Math.max(0, rowH - child.height)
                    else
                        child.y = y
                }
            }
            y += rowH + root.rowSpacing
        }
    }

    onWidthChanged: Qt.callLater(relayout)
    onColumnsChanged: Qt.callLater(relayout)
    onMinCellWidthChanged: Qt.callLater(relayout)
    onMinCellHeightChanged: Qt.callLater(relayout)
    onSpacingChanged: Qt.callLater(relayout)
    onRowSpacingChanged: Qt.callLater(relayout)
    onPaddingChanged: Qt.callLater(relayout)
    onLeftPaddingChanged: Qt.callLater(relayout)
    onRightPaddingChanged: Qt.callLater(relayout)
    onTopPaddingChanged: Qt.callLater(relayout)
    onBottomPaddingChanged: Qt.callLater(relayout)
    onStretchCellsChanged: Qt.callLater(relayout)
    onEqualRowHeightChanged: Qt.callLater(relayout)
    onCellAlignmentChanged: Qt.callLater(relayout)

    Component.onCompleted: Qt.callLater(relayout)

    Connections {
        target: host
        function onChildrenChanged() {
            Qt.callLater(root.relayout)
        }
    }

    Timer {
        interval: 48
        running: root.visible && host.children.length > 0
        repeat: true
        onTriggered: root.relayout()
    }
}
