import QtQuick

/// Stacked / single area chart (filled series under a line).
Item {
    id: root

    /// number[] or [number[], ...] for stacked areas
    property var values: []
    property var labels: []
    property var seriesColors: []
    property real minY: Number.NaN
    property real maxY: Number.NaN
    property bool stacked: false
    property bool showLine: true
    property bool showGrid: true
    property real lineWidth: 2
    property real areaOpacity: 0.35

    implicitWidth: 320
    implicitHeight: 200
    width: parent ? parent.width : implicitWidth
    height: implicitHeight

    readonly property var _seriesList: {
        const v = values
        if (!v || v.length === 0)
            return []
        if (typeof v[0] === "object" && v[0] !== null && v[0].length !== undefined)
            return v
        return [v]
    }

    readonly property var _range: {
        let lo = isNaN(minY) ? Number.POSITIVE_INFINITY : minY
        let hi = isNaN(maxY) ? Number.NEGATIVE_INFINITY : maxY
        const list = _seriesList
        if (stacked) {
            const n = list.length ? list[0].length : 0
            for (let i = 0; i < n; ++i) {
                let sum = 0
                for (let s = 0; s < list.length; ++s)
                    sum += Number(list[s][i] || 0)
                if (isNaN(minY)) lo = Math.min(lo, 0, sum)
                if (isNaN(maxY)) hi = Math.max(hi, sum)
            }
        } else {
            for (let s = 0; s < list.length; ++s) {
                for (let i = 0; i < list[s].length; ++i) {
                    const n = Number(list[s][i] || 0)
                    if (isNaN(minY)) lo = Math.min(lo, n)
                    if (isNaN(maxY)) hi = Math.max(hi, n)
                }
            }
        }
        if (!(hi > lo)) {
            lo = 0
            hi = 1
        }
        return ({ min: lo, max: hi })
    }

    function _colorAt(i) {
        if (seriesColors && seriesColors[i] !== undefined)
            return seriesColors[i]
        const palette = [
            Md3Theme.colorScheme.primary,
            Md3Theme.colorScheme.tertiary,
            Md3Theme.colorScheme.secondary,
            Md3Theme.colorScheme.error
        ]
        return palette[i % palette.length]
    }

    function requestPaint() { canvas.requestPaint() }

    onValuesChanged: requestPaint()
    onStackedChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    Canvas {
        id: canvas
        anchors.fill: parent
        anchors.margins: 8
        onPaint: {
            const ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            const list = root._seriesList
            if (!list.length || !list[0].length)
                return
            const n = list[0].length
            const padL = 28
            const padB = 4
            const plotW = width - padL
            const plotH = height - padB
            const lo = root._range.min
            const hi = root._range.max
            const span = Math.max(1e-6, hi - lo)

            if (root.showGrid) {
                ctx.strokeStyle = Md3Theme.colorScheme.outlineVariant
                ctx.lineWidth = 1
                for (let g = 0; g <= 4; ++g) {
                    const y = plotH * (1 - g / 4)
                    ctx.beginPath()
                    ctx.moveTo(padL, y)
                    ctx.lineTo(width, y)
                    ctx.stroke()
                }
            }

            const baselines = []
            for (let i = 0; i < n; ++i)
                baselines.push(0)

            for (let s = 0; s < list.length; ++s) {
                const series = list[s]
                const col = root._colorAt(s)
                const top = []
                for (let i = 0; i < n; ++i) {
                    const v = Number(series[i] || 0)
                    const base = root.stacked ? baselines[i] : 0
                    const yVal = root.stacked ? (base + v) : v
                    top.push(yVal)
                    if (root.stacked)
                        baselines[i] = yVal
                }

                ctx.beginPath()
                for (let i = 0; i < n; ++i) {
                    const x = padL + (n === 1 ? plotW / 2 : i * plotW / (n - 1))
                    const y = plotH * (1 - (top[i] - lo) / span)
                    if (i === 0) ctx.moveTo(x, y)
                    else ctx.lineTo(x, y)
                }
                for (let i = n - 1; i >= 0; --i) {
                    const base = root.stacked ? (top[i] - Number(series[i] || 0)) : lo
                    const x = padL + (n === 1 ? plotW / 2 : i * plotW / (n - 1))
                    const y = plotH * (1 - (base - lo) / span)
                    ctx.lineTo(x, y)
                }
                ctx.closePath()
                ctx.fillStyle = Qt.rgba(col.r, col.g, col.b, root.areaOpacity)
                ctx.fill()

                if (root.showLine) {
                    ctx.beginPath()
                    for (let i = 0; i < n; ++i) {
                        const x = padL + (n === 1 ? plotW / 2 : i * plotW / (n - 1))
                        const y = plotH * (1 - (top[i] - lo) / span)
                        if (i === 0) ctx.moveTo(x, y)
                        else ctx.lineTo(x, y)
                    }
                    ctx.strokeStyle = col
                    ctx.lineWidth = root.lineWidth
                    ctx.stroke()
                }
            }
        }
    }

    Component.onCompleted: requestPaint()
}
