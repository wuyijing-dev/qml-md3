import QtQuick
import Md3

/// Scatter chart — X/Y points with zoom/pan/probe (parity with line chart ops).
/// Points drawn on one Canvas; unloaded while !chartActive.
Md3Chart {
    id: root

    showArea: false
    showDots: true
    smooth: false
    property real pointRadius: 4
    /// Optional parallel X coordinates (default: 0..n-1).
    property var xValues: []

    function _xAt(i, n) {
        if (xValues && i < xValues.length && typeof xValues[i] === "number")
            return xValues[i]
        return i
    }

    function _xRange(n) {
        if (xValues && xValues.length >= n) {
            let lo = Infinity
            let hi = -Infinity
            for (let i = 0; i < n; ++i) {
                const x = Number(xValues[i])
                if (isNaN(x))
                    continue
                lo = Math.min(lo, x)
                hi = Math.max(hi, x)
            }
            if (!isFinite(lo))
                return { min: 0, max: 1 }
            if (hi <= lo) {
                lo -= 1
                hi += 1
            }
            return { min: lo, max: hi }
        }
        return { min: 0, max: Math.max(1, n - 1) }
    }

    function rebuild() {
        if (!chartActive) {
            geom.points = []
            geom.numsList = []
            geom.sampleCount = 0
            renderedPointCount = 0
            return
        }
        const all = (series && series.length > 0) ? series : [values]
        const range = rangeFromSeries(all.length ? all : [[0]])
        const span = Math.max(1e-6, range.max - range.min)
        let maxN = 0
        const numsList = []
        for (let s = 0; s < all.length; ++s) {
            const nums = seriesNums(all[s] || [])
            numsList.push(nums)
            maxN = Math.max(maxN, nums.length)
        }
        const xr = _xRange(maxN)
        const xSpan = Math.max(1e-6, xr.max - xr.min)
        const x0 = xr.min + viewStart * xSpan
        const x1 = xr.min + (viewStart + viewSpan) * xSpan
        const visSpan = Math.max(1e-6, x1 - x0)

        const pts = []
        let rendered = 0
        for (let s = 0; s < numsList.length; ++s) {
            const nums = numsList[s]
            const col = colorAt(s)
            for (let i = 0; i < nums.length; ++i) {
                const xv = _xAt(i, maxN)
                if (xv < x0 || xv > x1)
                    continue
                const px = plotLeft + plotWidth * (xv - x0) / visSpan
                const py = plotTop + plotHeight * (1 - (nums[i] - range.min) / span)
                pts.push({
                    x: px, y: py, r: pointRadius,
                    color: col, index: i, series: s, value: nums[i], xv: xv
                })
                rendered++
            }
        }

        renderedPointCount = rendered
        geom.rangeMin = range.min
        geom.rangeMax = range.max
        geom.span = span
        geom.xMin = xr.min
        geom.xMax = xr.max
        geom.points = pts
        geom.numsList = numsList
        geom.sampleCount = maxN
        rebuilt()
        if (plotCanvas.item)
            plotCanvas.item.requestPaint()
        if (probeActive)
            _updateProbeAtPixel(probePixelX)
    }

    function _updateProbeAtPixel(px) {
        if (!showProbe || geom.points.length < 1) {
            clearProbe()
            return
        }
        let best = -1
        let bestD = Infinity
        for (let i = 0; i < geom.points.length; ++i) {
            const p = geom.points[i]
            const d = Math.abs(p.x - px)
            if (d < bestD) {
                bestD = d
                best = i
            }
        }
        if (best < 0 || bestD > 48) {
            clearProbe()
            return
        }
        const hit = geom.points[best]
        const info = []
        for (let s = 0; s < geom.numsList.length; ++s) {
            const nums = geom.numsList[s]
            if (hit.index >= nums.length)
                continue
            info.push({
                label: qsTr("S%1").arg(s + 1),
                value: nums[hit.index],
                color: colorAt(s)
            })
        }
        setProbe(hit.index, hit.x, info, hit.y)
        if (plotCanvas.item)
            plotCanvas.item.requestPaint()
    }

    QtObject {
        id: geom
        property real rangeMin: 0
        property real rangeMax: 1
        property real span: 1
        property real xMin: 0
        property real xMax: 1
        property var points: []
        property var numsList: []
        property int sampleCount: 0
    }

    onXValuesChanged: requestRebuild()
    onPointRadiusChanged: requestRebuild()
    onProbeActiveChanged: if (plotCanvas.item) plotCanvas.item.requestPaint()
    onProbeIndexChanged: if (plotCanvas.item) plotCanvas.item.requestPaint()
    onCleared: if (plotCanvas.item) plotCanvas.item.requestPaint()
    onRebuilt: if (plotCanvas.item) plotCanvas.item.requestPaint()

    Connections {
        target: root
        function onChartActiveChanged() {
            if (!root.chartActive) {
                geom.points = []
                geom.numsList = []
                geom.sampleCount = 0
                renderedPointCount = 0
                return
            }
            root.requestRebuild()
        }
    }

    Rectangle {
        anchors.fill: parent
        color: root.backgroundColor
        radius: Md3Theme.shape.small
    }

    Loader {
        id: plotCanvas
        anchors.fill: parent
        active: root.chartActive
        sourceComponent: plotComp
        onLoaded: if (item) item.requestPaint()
    }

    Component {
        id: plotComp
        Canvas {
            anchors.fill: parent
            onPaint: {
                const ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                if (root.showGrid) {
                    const n = root.horizontalGridLines + 1
                    ctx.strokeStyle = root.resolvedGridColor()
                    ctx.globalAlpha = 0.45
                    ctx.lineWidth = 1
                    for (let i = 0; i < n; ++i) {
                        const t = i / Math.max(1, root.horizontalGridLines)
                        const y = root.plotTop + root.plotHeight * (1 - t)
                        ctx.beginPath()
                        ctx.moveTo(root.plotLeft, y)
                        ctx.lineTo(root.plotLeft + root.plotWidth, y)
                        ctx.stroke()
                    }
                    ctx.globalAlpha = 1
                }
                const pts = geom.points || []
                const probeOn = root.probeActive
                const probeIdx = root.probeIndex
                for (let i = 0; i < pts.length; ++i) {
                    const p = pts[i]
                    ctx.globalAlpha = probeOn && probeIdx !== p.index ? 0.45 : 1
                    ctx.fillStyle = p.color
                    ctx.beginPath()
                    ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2)
                    ctx.fill()
                    if (probeOn && probeIdx === p.index) {
                        ctx.strokeStyle = root.resolvedSurfaceColor()
                        ctx.lineWidth = 2
                        ctx.stroke()
                    }
                }
                ctx.globalAlpha = 1
            }
        }
    }

    Repeater {
        model: root.chartActive && root.showYLabels ? root.horizontalGridLines + 1 : 0
        delegate: Text {
            required property int index
            readonly property real t: index / Math.max(1, root.horizontalGridLines)
            readonly property real v: geom.rangeMin + geom.span * t
            x: 0
            y: root.plotTop + root.plotHeight * (1 - t) - 8
            width: root.plotLeft - 6
            height: 16
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            text: v.toFixed(root.valueDecimals) + root.yUnit
            color: root.resolvedAxisLabelColor()
            font.pixelSize: 11
            font.family: Md3Theme.typography.fontFamily
        }
    }

    Md3ChartInteraction {
        chart: root
    }
}
