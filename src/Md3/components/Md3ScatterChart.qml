import QtQuick
import Md3

/// Scatter chart — X/Y points with zoom/pan/probe (parity with line chart ops).
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
        // Map viewStart/viewSpan onto X domain
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
        // Gather all series at same index
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

    Rectangle {
        anchors.fill: parent
        color: root.backgroundColor
        radius: Md3Theme.shape.small
    }

    Item {
        anchors.fill: parent
        clip: true

        Repeater {
            model: root.showGrid ? root.horizontalGridLines + 1 : 0
            delegate: Rectangle {
                required property int index
                readonly property real t: index / Math.max(1, root.horizontalGridLines)
                width: root.plotWidth
                height: 1
                x: root.plotLeft
                y: root.plotTop + root.plotHeight * (1 - t)
                color: root.resolvedGridColor()
                opacity: 0.45
            }
        }

        Repeater {
            model: geom.points
            delegate: Rectangle {
                required property var modelData
                width: modelData.r * 2
                height: width
                radius: width / 2
                x: modelData.x - width / 2
                y: modelData.y - height / 2
                color: modelData.color
                border.width: root.probeActive && root.probeIndex === modelData.index ? 2 : 0
                border.color: root.resolvedSurfaceColor()
                opacity: root.probeActive && root.probeIndex !== modelData.index ? 0.45 : 1
            }
        }
    }

    Repeater {
        model: root.showYLabels ? root.horizontalGridLines + 1 : 0
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
