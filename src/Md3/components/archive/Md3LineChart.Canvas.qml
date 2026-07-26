import QtQuick

/// ARCHIVED — pure QML Canvas line chart (reference).
/// Production: Md3LineChart.qml (Shapes) + Md3ChartData (C++ downsample).
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
    /// Cap of vertices after downsampling (≈ 2–4× plot width). 0 = auto from width.
    property int maxRenderPoints: 0
    /// Skip smooth Bezier above this raw length (too costly / unstable).
    property int smoothMaxPoints: 400
    /// Never draw per-point dots above this rendered length.
    property int dotsMaxPoints: 80

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

    /// Fast numeric extraction — avoids allocating intermediate objects for plain numbers.
    function _seriesNums(s) {
        if (!s || s.length === undefined)
            return []
        const n = s.length
        if (n === 0)
            return []
        // Fast path: dense number array
        if (typeof s[0] === "number") {
            const out = new Array(n)
            for (let i = 0; i < n; ++i)
                out[i] = s[i]
            return out
        }
        const out = []
        for (let i = 0; i < n; ++i) {
            const v = _asNumber(s[i])
            if (!isNaN(v))
                out.push(v)
        }
        return out
    }

    /// Min/max bucket downsample — preserves peaks for large n, O(n), ~2 pts/bucket.
    function _downsample(nums, target) {
        const n = nums.length
        if (n <= target || target < 3)
            return nums
        const buckets = Math.max(1, Math.floor((target - 2) / 2))
        const out = new Array(buckets * 2 + 2)
        out[0] = nums[0]
        let o = 1
        for (let b = 0; b < buckets; ++b) {
            const start = Math.floor(b * (n - 2) / buckets) + 1
            const end = Math.floor((b + 1) * (n - 2) / buckets) + 1
            let lo = nums[start]
            let hi = nums[start]
            let loI = start
            let hiI = start
            for (let i = start + 1; i < end; ++i) {
                const v = nums[i]
                if (v < lo) {
                    lo = v
                    loI = i
                }
                if (v > hi) {
                    hi = v
                    hiI = i
                }
            }
            if (loI <= hiI) {
                out[o++] = lo
                if (hiI !== loI)
                    out[o++] = hi
            } else {
                out[o++] = hi
                if (loI !== hiI)
                    out[o++] = lo
            }
        }
        out[o++] = nums[n - 1]
        out.length = o
        return out
    }

    function _rangeFromSeries(all) {
        let lo = minY
        let hi = maxY
        if (!isNaN(lo) && !isNaN(hi) && hi > lo)
            return { min: lo, max: hi }
        let found = false
        lo = Infinity
        hi = -Infinity
        for (let s = 0; s < all.length; ++s) {
            const nums = _seriesNums(all[s])
            // For huge series, sample stride for axis range (full pass still used in downsample).
            const step = nums.length > 200000 ? Math.floor(nums.length / 100000) : 1
            for (let i = 0; i < nums.length; i += step) {
                const v = nums[i]
                if (isNaN(v))
                    continue
                found = true
                if (v < lo)
                    lo = v
                if (v > hi)
                    hi = v
            }
            // Always include endpoints
            if (nums.length > 0) {
                found = true
                lo = Math.min(lo, nums[0], nums[nums.length - 1])
                hi = Math.max(hi, nums[0], nums[nums.length - 1])
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
    onMaxRenderPointsChanged: requestRedraw()

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
            const all = root._flatSeries
            const range = root._rangeFromSeries(all)
            const span = Math.max(1e-6, range.max - range.min)
            const target = root.maxRenderPoints > 0
                          ? root.maxRenderPoints
                          : Math.max(64, Math.floor(plotW * 2.5))

            function yAt(v) {
                return top + plotH * (1 - (v - range.min) / span)
            }

            function buildPath(pts, closeToBaseline, useSmooth) {
                ctx.beginPath()
                ctx.moveTo(pts[0].x, pts[0].y)
                if (useSmooth && pts.length > 2) {
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

            for (let s = 0; s < all.length; ++s) {
                const raw = root._seriesNums(all[s])
                if (raw.length < 1)
                    continue
                const nums = root._downsample(raw, target)
                const col = root._colorAt(s)
                const n = nums.length
                const pts = new Array(n)
                for (let i = 0; i < n; ++i) {
                    const x = left + (n === 1 ? plotW / 2 : (plotW * i / (n - 1)))
                    pts[i] = { x: x, y: yAt(nums[i]) }
                }

                const useSmooth = root.smooth && raw.length <= root.smoothMaxPoints && n <= root.smoothMaxPoints
                const useDots = root.showDots && n <= root.dotsMaxPoints

                if (root.showArea) {
                    buildPath(pts, true, useSmooth)
                    ctx.globalAlpha = s === 0 ? 0.22 : 0.12
                    ctx.fillStyle = col
                    ctx.fill()
                    ctx.globalAlpha = 1
                }

                buildPath(pts, false, useSmooth)
                ctx.strokeStyle = col
                ctx.lineWidth = root.lineWidth
                ctx.lineJoin = "round"
                ctx.lineCap = "round"
                ctx.stroke()

                if (useDots) {
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
