import QtQuick
import QtQuick.Shapes
import Md3

/// Line / area chart — QtQuick.Shapes. Extends Md3Chart.
/// Supports X zoom/pan (`interactive`) and nearest-point probe (`showProbe`).
Md3Chart {
    id: root

    property bool live: false
    property int livePointCount: 48
    property real liveSpeed: 2.4
    property real livePhase: 0
    /// 0 = display refresh (full quality). Set >0 only to explicitly cap.
    property int liveFps: 0
    /// Mutated in place — avoids allocating a new array every animation frame.
    property var liveBuffer: []

    function ensureLiveBuffer() {
        if (liveBuffer.length === livePointCount)
            return
        const out = new Array(livePointCount)
        for (let i = 0; i < livePointCount; ++i)
            out[i] = 50
        liveBuffer = out
    }

    function advanceLive(dt) {
        ensureLiveBuffer()
        livePhase = (livePhase + liveSpeed * dt) % (Math.PI * 200)
        const p = livePhase
        const buf = liveBuffer
        const n = livePointCount
        for (let i = 0; i < n; ++i) {
            const t = p + i * 0.22
            buf[i] = 50 + Math.sin(t) * 28 + Math.sin(t * 0.37) * 12
        }
        // Fixed Y axis: skip range scan / theme resolve / samples rebuild every frame.
        if (Number.isFinite(minY) && Number.isFinite(maxY))
            _rebuildLiveFast()
        else
            rebuild()
    }

    function _rebuildLiveFast() {
        const lo = minY
        const hi = maxY
        const span = Math.max(1e-6, hi - lo)
        const yAt = v => plotTop + plotHeight * (1 - (v - lo) / span)
        const buf = liveBuffer
        const n = buf.length
        if (n < 1)
            return
        const denom = Math.max(1, n - 1)
        const pts = new Array(n)
        for (let i = 0; i < n; ++i)
            pts[i] = Qt.point(plotLeft + plotWidth * i / denom, yAt(buf[i]))
        let area = []
        if (showArea && n >= 2) {
            area = pts.slice()
            area.push(Qt.point(pts[n - 1].x, plotBottom))
            area.push(Qt.point(pts[0].x, plotBottom))
        }
        const col = colorAt(0)
        geom.rangeMin = lo
        geom.rangeMax = hi
        geom.span = span
        geom.sampleCount = n
        geom.seriesModel = [{
            line: pts,
            area: area,
            color: col,
            fill: resolvedFillColor(),
            dots: false
        }]
        if (!geom.samples.length || geom.samples[0].nums !== buf)
            geom.samples = [{ nums: buf, color: col, label: qsTr("S1") }]
        renderedPointCount = n
        if (probeActive)
            _updateProbeAtPixel(probePixelX)
    }

    function _catmull(pts, seg) {
        const n = pts.length
        if (n < 3 || seg < 1)
            return pts
        const out = [pts[0]]
        for (let i = 0; i < n - 1; ++i) {
            const p0 = pts[Math.max(0, i - 1)]
            const p1 = pts[i]
            const p2 = pts[i + 1]
            const p3 = pts[Math.min(n - 1, i + 2)]
            for (let s = 1; s <= seg; ++s) {
                const t = s / seg
                const t2 = t * t
                const t3 = t2 * t
                out.push(Qt.point(
                    0.5 * ((2 * p1.x) + (-p0.x + p2.x) * t
                           + (2 * p0.x - 5 * p1.x + 4 * p2.x - p3.x) * t2
                           + (-p0.x + 3 * p1.x - 3 * p2.x + p3.x) * t3),
                    0.5 * ((2 * p1.y) + (-p0.y + p2.y) * t
                           + (2 * p0.y - 5 * p1.y + 4 * p2.y - p3.y) * t2
                           + (-p0.y + 3 * p1.y - 3 * p2.y + p3.y) * t3)
                ))
            }
        }
        return out
    }

    function rebuild() {
        if (live)
            ensureLiveBuffer()
        const all = live ? [liveBuffer]
                         : ((series && series.length > 0) ? series : [values])
        const range = rangeFromSeries(all.length ? all : [[0]])
        const span = Math.max(1e-6, range.max - range.min)
        const yAt = v => plotTop + plotHeight * (1 - (v - range.min) / span)
        const model = []
        const samples = []
        let rendered = 0
        const fill0 = resolvedFillColor()
        let maxN = 0

        for (let s = 0; s < all.length; ++s) {
            const nums = seriesNums(all[s])
            if (nums.length < 1)
                continue
            maxN = Math.max(maxN, nums.length)
            const n = nums.length
            const win = windowIndices(n)
            rendered += Math.max(0, win.i1 - win.i0 + 1)
            let pts = []
            const denom = Math.max(1e-6, win.end - win.start)
            for (let i = win.i0; i <= win.i1; ++i) {
                const x = plotLeft + plotWidth * (i - win.start) / denom
                pts.push(Qt.point(x, yAt(nums[i])))
            }
            // Skip Catmull while moving — switching smooth on release caused flicker.
            // Also honor global effectsLevel (smooth only on High).
            if (smooth && Md3Theme.effectsChartSmooth && !live && !viewMoving
                    && pts.length <= smoothMaxPoints && pts.length >= 3)
                pts = _catmull(pts, 3)

            const col = colorAt(s)
            let area = []
            if (showArea && pts.length >= 2) {
                area = pts.slice()
                area.push(Qt.point(pts[pts.length - 1].x, plotBottom))
                area.push(Qt.point(pts[0].x, plotBottom))
            }
            model.push({
                line: pts,
                area: area,
                color: col,
                fill: s === 0 ? fill0 : Qt.rgba(col.r, col.g, col.b,
                        root.areaEmphasis ? Math.min(0.45, root.areaOpacity * 1.4) : root.areaOpacity * 0.55),
                dots: showDots && pts.length <= dotsMaxPoints
            })
            samples.push({ nums: nums, color: col, label: qsTr("S%1").arg(s + 1) })
        }
        renderedPointCount = rendered
        geom.rangeMin = range.min
        geom.rangeMax = range.max
        geom.span = span
        geom.seriesModel = model
        geom.samples = samples
        geom.sampleCount = maxN
        rebuilt()
        if (probeActive)
            _updateProbeAtPixel(probePixelX)
    }

    function _updateProbeAtPixel(px) {
        if (!showProbe || geom.samples.length < 1) {
            clearProbe()
            return
        }
        const idx = indexAtPlotX(px, geom.sampleCount)
        if (idx < 0) {
            clearProbe()
            return
        }
        const x = plotXForIndex(idx, geom.sampleCount)
        const info = []
        let tipY = plotTop + plotHeight / 2
        const span = Math.max(1e-6, geom.span)
        for (let s = 0; s < geom.samples.length; ++s) {
            const sample = geom.samples[s]
            if (idx >= sample.nums.length)
                continue
            const v = sample.nums[idx]
            info.push({ label: sample.label, value: v, color: sample.color })
            tipY = plotTop + plotHeight * (1 - (v - geom.rangeMin) / span)
        }
        setProbe(idx, x, info, tipY)
    }

    QtObject {
        id: geom
        property real rangeMin: 0
        property real rangeMax: 1
        property real span: 1
        property var seriesModel: []
        property var samples: []
        property int sampleCount: 0
    }

    readonly property int _effectiveLiveFps: root.liveFps > 0 ? root.liveFps : Md3Theme.effectsLiveFps

    FrameAnimation {
        running: root.live && root.chartActive && Md3Theme.effectsLiveMotion
                 && root._effectiveLiveFps <= 0
        onTriggered: root.advanceLive(frameTime)
    }
    Timer {
        interval: Math.max(16, Math.round(1000 / Math.max(1, root._effectiveLiveFps)))
        running: root.live && root.chartActive && Md3Theme.effectsLiveMotion
                 && root._effectiveLiveFps > 0
        repeat: true
        onTriggered: root.advanceLive(interval / 1000)
    }

    onLiveChanged: {
        if (live)
            ensureLiveBuffer()
        requestRebuild()
    }
    onLivePointCountChanged: {
        liveBuffer = []
        ensureLiveBuffer()
        requestRebuild()
    }

    Rectangle {
        anchors.fill: parent
        color: root.backgroundColor
        radius: Md3Theme.shape.small
    }

    Item {
        id: plotClip
        anchors.fill: parent
        clip: true

        Shape {
            anchors.fill: parent
            visible: root.showGrid && root.horizontalGridLines > 0
            preferredRendererType: Shape.GeometryRenderer
            ShapePath {
                strokeWidth: 1
                strokeColor: {
                    const c = root.resolvedGridColor()
                    return Qt.rgba(c.r, c.g, c.b, 0.45)
                }
                fillColor: "transparent"
                PathMultiline {
                    paths: {
                        const out = []
                        const n = root.horizontalGridLines
                        for (let g = 0; g <= n; ++g) {
                            const t = g / n
                            const y = root.plotTop + root.plotHeight * (1 - t)
                            out.push([Qt.point(root.plotLeft, y), Qt.point(root.plotRight, y)])
                        }
                        return out
                    }
                }
            }
        }

        Repeater {
            model: geom.seriesModel
            delegate: Item {
                id: seriesItem
                required property var modelData
                readonly property color seriesColor: modelData.color
                anchors.fill: parent

                Shape {
                    anchors.fill: parent
                    preferredRendererType: Shape.GeometryRenderer
                    // Never flip async on gesture end — that flashed the plot after pan release.
                    asynchronous: false
                    visible: modelData.area && modelData.area.length > 2
                    ShapePath {
                        strokeWidth: 0
                        strokeColor: "transparent"
                        fillColor: modelData.fill
                        PathPolyline { path: modelData.area }
                    }
                }
                Shape {
                    anchors.fill: parent
                    preferredRendererType: Shape.GeometryRenderer
                    asynchronous: false
                    ShapePath {
                        strokeWidth: root.lineWidth
                        strokeColor: modelData.color
                        fillColor: "transparent"
                        capStyle: ShapePath.RoundCap
                        joinStyle: ShapePath.RoundJoin
                        PathPolyline { path: modelData.line }
                    }
                }
                Repeater {
                    model: modelData.dots ? modelData.line : []
                    delegate: Rectangle {
                        required property var modelData
                        width: root.dotRadius * 2
                        height: width
                        radius: width / 2
                        color: seriesItem.seriesColor
                        x: modelData.x - width / 2
                        y: modelData.y - height / 2
                        Rectangle {
                            anchors.centerIn: parent
                            width: Math.max(2, root.dotRadius * 2 - 2.4)
                            height: width
                            radius: width / 2
                            color: root.resolvedSurfaceColor()
                        }
                    }
                }
            }
        }

        Rectangle {
            visible: root.probeActive && root.showProbe
            x: root.probePixelX - 0.5
            y: root.plotTop
            width: 1
            height: root.plotHeight
            color: Md3Theme.colorScheme.outline
            opacity: 0.7
            z: 20
        }
        Repeater {
            model: root.probeActive ? root.probeSeries : []
            delegate: Rectangle {
                required property var modelData
                width: 8
                height: 8
                radius: 4
                z: 21
                color: modelData.color
                x: root.probePixelX - width / 2
                y: {
                    const span = Math.max(1e-6, geom.span)
                    return root.plotTop + root.plotHeight
                           * (1 - (modelData.value - geom.rangeMin) / span) - height / 2
                }
                border.width: 1.5
                border.color: root.resolvedSurfaceColor()
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
            z: 5
        }
    }

    Md3ChartInteraction {
        chart: root
        showCrosshair: false
    }
}
