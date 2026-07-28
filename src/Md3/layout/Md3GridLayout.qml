import QtQuick

/// Responsive uniform grid for arbitrary child items.
Item {
    id: root

    /// Fixed columns; <= 0 means auto by minCellWidth.
    property int columns: 0
    property real minCellWidth: 160
    property real spacing: 12
    property real rowSpacing: spacing
    property real padding: 0
    property bool stretchCells: true
    default property alias content: host.data

    readonly property int effectiveColumns: _effectiveColumns
    readonly property real cellWidth: _cellWidth
    property int _effectiveColumns: 1
    property real _cellWidth: 0
    property real _contentHeight: 0

    implicitWidth: Math.max(1, host.implicitWidth + padding * 2)
    implicitHeight: _contentHeight + padding * 2

    Item {
        id: host
        x: root.padding
        y: root.padding
        width: Math.max(0, root.width - root.padding * 2)
        height: root._contentHeight
        implicitWidth: childrenRect.width
        implicitHeight: childrenRect.height
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
        let cols = root.columns > 0 ? root.columns : Math.floor((avail + root.spacing) / Math.max(1, root.minCellWidth + root.spacing))
        cols = Math.max(1, cols)
        _effectiveColumns = cols

        const totalSpacing = (cols - 1) * root.spacing
        const cellW = Math.max(1, (avail - totalSpacing) / cols)
        _cellWidth = cellW

        const rowHeights = []
        for (let i = 0; i < visibleKids.length; ++i) {
            const child = visibleKids[i]
            const row = Math.floor(i / cols)
            const h = child.implicitHeight > 0 ? child.implicitHeight : child.height
            rowHeights[row] = Math.max(rowHeights[row] || 0, Math.max(1, h))
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
                child.x = c * (cellW + root.spacing)
                child.y = y
                if (root.stretchCells)
                    child.width = cellW
                if (child.height <= 0 && child.implicitHeight > 0)
                    child.height = child.implicitHeight
            }
            y += rowH + root.rowSpacing
        }
    }

    onWidthChanged: Qt.callLater(relayout)
    onColumnsChanged: Qt.callLater(relayout)
    onMinCellWidthChanged: Qt.callLater(relayout)
    onSpacingChanged: Qt.callLater(relayout)
    onRowSpacingChanged: Qt.callLater(relayout)
    onPaddingChanged: Qt.callLater(relayout)

    Component.onCompleted: Qt.callLater(relayout)

    Connections {
        target: host
        function onChildrenChanged() {
            Qt.callLater(root.relayout)
        }
    }
}
