import QtQuick

/// Heatmap chart — `values` as row-major 2D array, or flat `values` + `columns`.
Item {
    id: root

    /// [[n,...], ...] or flat number[] with `columns`
    property var values: []
    property int columns: 0
    property var rowLabels: []
    property var columnLabels: []
    property real minValue: Number.NaN
    property real maxValue: Number.NaN
    property color lowColor: Md3Theme.colorScheme.surfaceContainerHighest
    property color highColor: Md3Theme.colorScheme.primary
    property real cellGap: 2
    property real cellRadius: 4
    property bool showLegend: true
    property real legendHeight: 16

    readonly property var matrix: {
        const v = values
        if (!v || v.length === 0)
            return []
        if (typeof v[0] === "object" && v[0] !== null && v[0].length !== undefined)
            return v
        const cols = Math.max(1, columns)
        const rows = []
        for (let i = 0; i < v.length; i += cols)
            rows.push(v.slice(i, i + cols))
        return rows
    }

    readonly property var valueRange: {
        let lo = minValue
        let hi = maxValue
        if (!isNaN(lo) && !isNaN(hi))
            return ({ min: lo, max: hi })
        lo = Number.POSITIVE_INFINITY
        hi = Number.NEGATIVE_INFINITY
        const m = matrix
        for (let r = 0; r < m.length; ++r) {
            const row = m[r]
            for (let c = 0; c < row.length; ++c) {
                const n = Number(row[c])
                if (n < lo) lo = n
                if (n > hi) hi = n
            }
        }
        if (!(hi > lo)) {
            lo = 0
            hi = 1
        }
        return ({ min: lo, max: hi })
    }

    function cellColor(v) {
        const t = Math.max(0, Math.min(1, (Number(v) - valueRange.min)
                         / Math.max(1e-6, valueRange.max - valueRange.min)))
        return Qt.rgba(
            lowColor.r + (highColor.r - lowColor.r) * t,
            lowColor.g + (highColor.g - lowColor.g) * t,
            lowColor.b + (highColor.b - lowColor.b) * t,
            1
        )
    }

    function requestPaint() {
        canvas.requestPaint()
        legendCanvas.requestPaint()
    }

    implicitWidth: 360
    implicitHeight: 220
    width: parent ? parent.width : implicitWidth
    height: implicitHeight

    onValuesChanged: requestPaint()
    onColumnsChanged: requestPaint()
    onLowColorChanged: requestPaint()
    onHighColorChanged: requestPaint()
    onRowLabelsChanged: requestPaint()
    onColumnLabelsChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    Column {
        anchors.fill: parent
        spacing: 8

        Canvas {
            id: canvas
            width: parent.width
            height: parent.height - (root.showLegend ? root.legendHeight + 8 : 0)
            renderTarget: Canvas.FramebufferObject
            renderStrategy: Canvas.Cooperative

            onPaint: {
                const ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                const m = root.matrix
                if (!m.length)
                    return
                const rows = m.length
                const cols = m[0].length
                const labelW = root.rowLabels && root.rowLabels.length ? 48 : 0
                const labelH = root.columnLabels && root.columnLabels.length ? 18 : 0
                const gw = width - labelW
                const gh = height - labelH
                const cw = (gw - root.cellGap * (cols - 1)) / Math.max(1, cols)
                const ch = (gh - root.cellGap * (rows - 1)) / Math.max(1, rows)

                ctx.font = Md3Theme.typography.labelSmall.size + "px sans-serif"
                ctx.fillStyle = Md3Theme.colorScheme.colorOnSurfaceVariant
                ctx.textAlign = "right"
                ctx.textBaseline = "middle"
                for (let r = 0; r < rows; ++r) {
                    if (root.rowLabels && root.rowLabels[r] !== undefined) {
                        ctx.fillText(String(root.rowLabels[r]), labelW - 6,
                                     labelH + r * (ch + root.cellGap) + ch / 2)
                    }
                }
                ctx.textAlign = "center"
                ctx.textBaseline = "top"
                for (let c = 0; c < cols; ++c) {
                    if (root.columnLabels && root.columnLabels[c] !== undefined) {
                        ctx.fillText(String(root.columnLabels[c]),
                                     labelW + c * (cw + root.cellGap) + cw / 2, 0)
                    }
                }

                for (let r = 0; r < rows; ++r) {
                    for (let c = 0; c < m[r].length; ++c) {
                        const x = labelW + c * (cw + root.cellGap)
                        const y = labelH + r * (ch + root.cellGap)
                        const col = root.cellColor(m[r][c])
                        ctx.fillStyle = Qt.rgba(col.r, col.g, col.b, 1)
                        ctx.fillRect(x, y, cw, ch)
                    }
                }
            }
        }

        Canvas {
            id: legendCanvas
            visible: root.showLegend
            width: parent.width
            height: root.legendHeight
            onPaint: {
                const ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                const g = ctx.createLinearGradient(0, 0, width, 0)
                const lo = root.lowColor
                const hi = root.highColor
                g.addColorStop(0, Qt.rgba(lo.r, lo.g, lo.b, 1))
                g.addColorStop(1, Qt.rgba(hi.r, hi.g, hi.b, 1))
                ctx.fillStyle = g
                ctx.fillRect(0, 4, width, height - 8)
            }
        }
    }

    Component.onCompleted: requestPaint()
}
