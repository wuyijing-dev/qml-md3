import QtQuick

/// Heatmap — matrix style or GitHub contribution calendar.
Item {
    id: root

    enum Style { Matrix, Contribution }

    property int style: Md3HeatmapChart.Contribution

    /// Matrix: [[n,...],...] or flat number[] + `columns`
    /// Contribution: number[] (day-major, oldest→newest) or [{ date, count }]
    property var values: []
    property int columns: 0
    property var rowLabels: []
    property var columnLabels: []
    property real minValue: Number.NaN
    property real maxValue: Number.NaN

    // Matrix colors
    property color lowColor: Md3Theme.colorScheme.surfaceContainerHighest
    property color highColor: Md3Theme.colorScheme.primary

    // Contribution (GitHub) options
    property int weeks: 53
    property int levels: 5
    /// Empty → theme-aware greens similar to GitHub
    property var levelColors: []
    property bool weekStartsOnMonday: true
    property bool showMonthLabels: true
    property bool showWeekdayLabels: true
    property real cellSize: 11
    property real cellGap: 3
    property real cellRadius: 2

    property bool showLegend: true
    property real legendHeight: 18

    readonly property var matrix: {
        if (style === Md3HeatmapChart.Contribution)
            return _contributionMatrix()
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

    readonly property var effectiveLevelColors: {
        if (levelColors && levelColors.length >= levels)
            return levelColors
        // GitHub-like: empty → dark green (light) / bright green (dark)
        const dark = Md3Theme.dark
        if (dark) {
            return [
                "#161b22",
                "#0e4429",
                "#006d32",
                "#26a641",
                "#39d353"
            ]
        }
        return [
            "#ebedf0",
            "#9be9a8",
            "#40c463",
            "#30a14e",
            "#216e39"
        ]
    }

    readonly property var monthLabels: style === Md3HeatmapChart.Contribution
                                       ? _monthLabels() : []

    function _dayCount(v) {
        if (v === undefined || v === null)
            return 0
        if (typeof v === "object" && v.count !== undefined)
            return Number(v.count)
        return Number(v)
    }

    function _contributionMatrix() {
        // 7 rows (weekdays) × weeks columns; day-major input oldest→newest
        const w = Math.max(1, weeks)
        const out = []
        for (let d = 0; d < 7; ++d) {
            const row = []
            for (let c = 0; c < w; ++c)
                row.push(0)
            out.push(row)
        }
        const src = values || []
        const total = w * 7
        // Align so the last cell is "today" at end of last column
        const offset = Math.max(0, total - src.length)
        for (let i = 0; i < src.length && i + offset < total; ++i) {
            const idx = i + offset
            const col = Math.floor(idx / 7)
            let row = idx % 7
            if (!weekStartsOnMonday) {
                // Sunday-first already matches row 0 = Sun
            } else {
                // Monday-first: shift so Mon=0 … Sun=6
                // If input is calendar Mon-first day sequence, row = idx % 7 is fine
            }
            out[row][col] = _dayCount(src[i])
        }
        return out
    }

    function _monthLabels() {
        // Approximate month labels across weeks (demo-friendly without full calendar)
        const names = [
            qsTr("Jan"), qsTr("Feb"), qsTr("Mar"), qsTr("Apr"),
            qsTr("May"), qsTr("Jun"), qsTr("Jul"), qsTr("Aug"),
            qsTr("Sep"), qsTr("Oct"), qsTr("Nov"), qsTr("Dec")
        ]
        const w = Math.max(1, weeks)
        const labels = []
        for (let c = 0; c < w; ++c)
            labels.push("")
        // Place ~12 labels evenly
        for (let m = 0; m < 12; ++m) {
            const col = Math.min(w - 1, Math.round(m * (w - 1) / 11))
            if (labels[col].length === 0)
                labels[col] = names[m]
        }
        return labels
    }

    function levelFor(v) {
        const n = Number(v)
        if (!(n > 0))
            return 0
        const lo = valueRange.min
        const hi = valueRange.max
        const t = Math.max(0, Math.min(1, (n - lo) / Math.max(1e-6, hi - lo)))
        return Math.max(1, Math.min(levels - 1, Math.ceil(t * (levels - 1))))
    }

    function cellColor(v) {
        if (style === Md3HeatmapChart.Contribution) {
            const lv = levelFor(v)
            const cols = effectiveLevelColors
            return cols[Math.max(0, Math.min(cols.length - 1, lv))]
        }
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

    readonly property real _weekdayW: (style === Md3HeatmapChart.Contribution && showWeekdayLabels) ? 28 : (
                                          rowLabels && rowLabels.length ? 48 : 0)
    readonly property real _monthH: (style === Md3HeatmapChart.Contribution && showMonthLabels) ? 18 : (
                                        columnLabels && columnLabels.length ? 18 : 0)

    implicitWidth: {
        if (style === Md3HeatmapChart.Contribution)
            return _weekdayW + weeks * (cellSize + cellGap) + 8
        return 360
    }
    implicitHeight: {
        const gridH = style === Md3HeatmapChart.Contribution
                    ? _monthH + 7 * (cellSize + cellGap) + 4
                    : 200
        return gridH + (showLegend ? legendHeight + 10 : 0)
    }
    width: parent ? Math.max(parent.width, implicitWidth) : implicitWidth
    height: implicitHeight

    onValuesChanged: requestPaint()
    onColumnsChanged: requestPaint()
    onStyleChanged: requestPaint()
    onWeeksChanged: requestPaint()
    onLowColorChanged: requestPaint()
    onHighColorChanged: requestPaint()
    onLevelColorsChanged: requestPaint()
    onRowLabelsChanged: requestPaint()
    onColumnLabelsChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()
    onCellSizeChanged: requestPaint()

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

                if (root.style === Md3HeatmapChart.Contribution)
                    root._paintContribution(ctx, width, height, m)
                else
                    root._paintMatrix(ctx, width, height, m)
            }
        }

        // GitHub-style legend: Less ■■■■■ More
        Item {
            id: legendRow
            visible: root.showLegend
            width: parent.width
            height: root.legendHeight

            Canvas {
                id: legendCanvas
                visible: root.style !== Md3HeatmapChart.Contribution
                anchors.fill: parent
                onPaint: {
                    if (root.style === Md3HeatmapChart.Contribution)
                        return
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

            Row {
                visible: root.style === Md3HeatmapChart.Contribution
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: 4
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Less")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.labelSmall.size
                    font.family: Md3Theme.typography.fontFamily
                }
                Repeater {
                    model: root.effectiveLevelColors
                    Rectangle {
                        required property var modelData
                        width: root.cellSize
                        height: root.cellSize
                        radius: root.cellRadius
                        color: modelData
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("More")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.labelSmall.size
                    font.family: Md3Theme.typography.fontFamily
                }
            }
        }
    }

    function _roundRect(ctx, x, y, w, h, r) {
        const rr = Math.min(r, w / 2, h / 2)
        ctx.beginPath()
        ctx.moveTo(x + rr, y)
        ctx.arcTo(x + w, y, x + w, y + h, rr)
        ctx.arcTo(x + w, y + h, x, y + h, rr)
        ctx.arcTo(x, y + h, x, y, rr)
        ctx.arcTo(x, y, x + w, y, rr)
        ctx.closePath()
        ctx.fill()
    }

    function _paintContribution(ctx, width, height, m) {
        const rows = 7
        const cols = m[0].length
        const cs = root.cellSize
        const gap = root.cellGap
        const labelW = root._weekdayW
        const labelH = root._monthH
        const days = root.weekStartsOnMonday
                   ? [qsTr("Mon"), "", qsTr("Wed"), "", qsTr("Fri"), "", ""]
                   : [qsTr("Sun"), "", qsTr("Tue"), "", qsTr("Thu"), "", ""]

        ctx.font = Md3Theme.typography.labelSmall.size + "px sans-serif"
        ctx.fillStyle = Md3Theme.colorScheme.colorOnSurfaceVariant
        ctx.textAlign = "left"
        ctx.textBaseline = "middle"
        if (root.showWeekdayLabels) {
            for (let r = 0; r < rows; ++r) {
                if (days[r] && days[r].length)
                    ctx.fillText(days[r], 0, labelH + r * (cs + gap) + cs / 2)
            }
        }
        ctx.textAlign = "left"
        ctx.textBaseline = "top"
        if (root.showMonthLabels) {
            const labels = root.monthLabels
            for (let c = 0; c < cols; ++c) {
                if (labels[c] && labels[c].length)
                    ctx.fillText(labels[c], labelW + c * (cs + gap), 0)
            }
        }

        for (let r = 0; r < rows; ++r) {
            for (let c = 0; c < cols; ++c) {
                const x = labelW + c * (cs + gap)
                const y = labelH + r * (cs + gap)
                const col = root.cellColor(m[r][c])
                ctx.fillStyle = col
                root._roundRect(ctx, x, y, cs, cs, root.cellRadius)
            }
        }
    }

    function _paintMatrix(ctx, width, height, m) {
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
                ctx.fillStyle = typeof col === "string" ? col
                              : Qt.rgba(col.r, col.g, col.b, 1)
                if (root.cellRadius > 0)
                    root._roundRect(ctx, x, y, cw, ch, root.cellRadius)
                else
                    ctx.fillRect(x, y, cw, ch)
            }
        }
    }

    Component.onCompleted: requestPaint()
}
