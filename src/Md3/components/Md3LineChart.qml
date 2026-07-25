import QtQuick

/// MD3 / Flutter-style line chart: smooth curve, area fill, grid, optional dots.
Item {
    id: root

    property var values: []
    property var series: []
    property var seriesColors: []
    property color lineColor: Md3Theme.colorScheme.primary
    property color fillColor: Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.primary, 0.20)
    property color gridColor: Md3Theme.colorScheme.outlineVariant
    property color axisLabelColor: Md3Theme.colorScheme.colorOnSurfaceVariant
    property color backgroundColor: "transparent"

    property real lineWidth: 2.5
    property bool showArea: true
    property bool showDots: false
    property bool showGrid: true
    property bool showYLabels: true
    property bool showXLabels: false
    property bool smooth: true
    property real minY: Number.NaN
    property real maxY: Number.NaN
    property int horizontalGridLines: 4
    property real contentPadding: 8
    property real labelWidth: showYLabels ? 36 : 0
    property real dotRadius: 3
    property string yUnit: ""
    property int valueDecimals: 0

    implicitWidth: 280
    implicitHeight: 160

    readonly property var _flatSeries: {
        if (series && series.length > 0)
            return series
        return [values]
    }

    function _asNumber(v) {
        if (v === undefined || v === null)
            return Number.NaN
        if (typeof v === "number")
            return v
        if (typeof v === "object" && v.y !== undefined)
            return Number(v.y)
        return Number(v)
    }

    function _seriesNums(s) {
        const out = []
        if (!s)
            return out
        for (let i = 0; i < s.length; ++i) {
            const n = _asNumber(s[i])
            if (!isNaN(n))
                out.push(n)
        }
        return out
    }

    function _range() {
        let lo = minY
        let hi = maxY
        if (!isNaN(lo) && !isNaN(hi) && hi > lo)
            return { min: lo, max: hi }
        let found = false
        lo = Infinity
        hi = -Infinity
        const all = _flatSeries
        for (let s = 0; s < all.length; ++s) {
            const nums = _seriesNums(all[s])
            for (let i = 0; i < nums.length; ++i) {
                found = true
                lo = Math.min(lo, nums[i])
                hi = Math.max(hi, nums[i])
            }
        }
        if (!found)
            return { min: 0, max: 1 }
        if (hi <= lo) {
            lo -= 1
            hi += 1
        }
        const pad = (hi - lo) * 0.08
        return { min: lo - pad, max: hi + pad }
    }

    function _colorAt(index) {
        if (seriesColors && index < seriesColors.length)
            return seriesColors[index]
        if (index === 0)
            return lineColor
        const roles = [
            Md3Theme.colorScheme.primary,
            Md3Theme.colorScheme.secondary,
            Md3Theme.colorScheme.tertiary,
            Md3Theme.colorScheme.error
        ]
        return roles[index % roles.length]
    }

    property bool _paintScheduled: false

    function requestRedraw() {
        if (_paintScheduled)
            return
        _paintScheduled = true
        Qt.callLater(function () {
            root._paintScheduled = false
            if (canvas.available)
                canvas.requestPaint()
        })
    }

    onValuesChanged: requestRedraw()
    onSeriesChanged: requestRedraw()
    onSeriesColorsChanged: requestRedraw()
    onLineColorChanged: requestRedraw()
    onFillColorChanged: requestRedraw()
    onGridColorChanged: requestRedraw()
    onShowAreaChanged: requestRedraw()
    onShowDotsChanged: requestRedraw()
    onShowGridChanged: requestRedraw()
    onSmoothChanged: requestRedraw()
    onWidthChanged: requestRedraw()
    onHeightChanged: requestRedraw()
    onMinYChanged: requestRedraw()
    onMaxYChanged: requestRedraw()

    Connections {
        target: Md3Theme
        function onDarkChanged() { root.requestRedraw() }
    }

    Rectangle {
        anchors.fill: parent
        color: root.backgroundColor
        radius: Md3Theme.shape.small
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        antialiasing: true
        smooth: true

        onPaint: {
            const ctx = getContext("2d")
            ctx.reset()
            ctx.clearRect(0, 0, width, height)

            const pad = root.contentPadding
            const left = pad + root.labelWidth
            const right = width - pad
            const top = pad + 4
            const bottom = height - pad - (root.showXLabels ? 16 : 0)
            const plotW = Math.max(1, right - left)
            const plotH = Math.max(1, bottom - top)
            const range = root._range()
            const span = Math.max(1e-6, range.max - range.min)

            function yAt(v) {
                return top + plotH * (1 - (v - range.min) / span)
            }

            function buildPath(pts, closeToBaseline) {
                ctx.beginPath()
                ctx.moveTo(pts[0].x, pts[0].y)
                if (root.smooth && pts.length > 2) {
                    for (let i = 0; i < pts.length - 1; ++i) {
                        const p0 = pts[Math.max(0, i - 1)]
                        const p1 = pts[i]
                        const p2 = pts[i + 1]
                        const p3 = pts[Math.min(pts.length - 1, i + 2)]
                        const cp1x = p1.x + (p2.x - p0.x) / 6
                        const cp1y = p1.y + (p2.y - p0.y) / 6
                        const cp2x = p2.x - (p3.x - p1.x) / 6
                        const cp2y = p2.y - (p3.y - p1.y) / 6
                        ctx.bezierCurveTo(cp1x, cp1y, cp2x, cp2y, p2.x, p2.y)
                    }
                } else {
                    for (let i = 1; i < pts.length; ++i)
                        ctx.lineTo(pts[i].x, pts[i].y)
                }
                if (closeToBaseline) {
                    ctx.lineTo(pts[pts.length - 1].x, bottom)
                    ctx.lineTo(pts[0].x, bottom)
                    ctx.closePath()
                }
            }

            if (root.showGrid && root.horizontalGridLines > 0) {
                ctx.strokeStyle = root.gridColor
                ctx.lineWidth = 1
                ctx.globalAlpha = 0.5
                for (let g = 0; g <= root.horizontalGridLines; ++g) {
                    const t = g / root.horizontalGridLines
                    const y = top + plotH * (1 - t)
                    ctx.beginPath()
                    ctx.moveTo(left, y)
                    ctx.lineTo(right, y)
                    ctx.stroke()
                }
                ctx.globalAlpha = 1
            }

            if (root.showYLabels) {
                ctx.fillStyle = root.axisLabelColor
                ctx.font = "11px sans-serif"
                ctx.textAlign = "right"
                ctx.textBaseline = "middle"
                for (let g = 0; g <= root.horizontalGridLines; ++g) {
                    const t = g / root.horizontalGridLines
                    const v = range.min + span * t
                    const y = top + plotH * (1 - t)
                    ctx.fillText(v.toFixed(root.valueDecimals) + root.yUnit, left - 6, y)
                }
            }

            const all = root._flatSeries
            for (let s = 0; s < all.length; ++s) {
                const nums = root._seriesNums(all[s])
                if (nums.length < 1)
                    continue
                const col = root._colorAt(s)
                const pts = []
                const n = nums.length
                for (let i = 0; i < n; ++i) {
                    const x = left + (n === 1 ? plotW / 2 : (plotW * i / (n - 1)))
                    pts.push({ x: x, y: yAt(nums[i]) })
                }

                if (root.showArea) {
                    buildPath(pts, true)
                    ctx.globalAlpha = s === 0 ? 0.22 : 0.12
                    ctx.fillStyle = col
                    ctx.fill()
                    ctx.globalAlpha = 1
                }

                buildPath(pts, false)
                ctx.strokeStyle = col
                ctx.lineWidth = root.lineWidth
                ctx.lineJoin = "round"
                ctx.lineCap = "round"
                ctx.stroke()

                if (root.showDots) {
                    for (let i = 0; i < pts.length; ++i) {
                        ctx.beginPath()
                        ctx.fillStyle = col
                        ctx.arc(pts[i].x, pts[i].y, root.dotRadius, 0, Math.PI * 2)
                        ctx.fill()
                        ctx.beginPath()
                        ctx.fillStyle = Md3Theme.colorScheme.surface
                        ctx.arc(pts[i].x, pts[i].y, Math.max(1, root.dotRadius - 1.2), 0, Math.PI * 2)
                        ctx.fill()
                    }
                }
            }
        }
    }
}
