import QtQuick
import QtQuick.Shapes

/// Line / area chart — QtQuick.Shapes. Extends Md3Chart.
Md3Chart {
    id: root

    property bool live: false
    property int livePointCount: 48
    property real liveSpeed: 2.4
    property real livePhase: 0
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
        rebuild()
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
        let rendered = 0
        const fill0 = resolvedFillColor()

        for (let s = 0; s < all.length; ++s) {
            const nums = seriesNums(all[s])
            if (nums.length < 1)
                continue
            const n = nums.length
            rendered += n
            let pts = []
            for (let i = 0; i < n; ++i) {
                const x = n === 1 ? (plotLeft + plotWidth / 2)
                                  : (plotLeft + plotWidth * i / (n - 1))
                pts.push(Qt.point(x, yAt(nums[i])))
            }
            if (smooth && !live && n <= smoothMaxPoints)
                pts = _catmull(pts, 4)

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
                fill: s === 0 ? fill0 : Qt.rgba(col.r, col.g, col.b, 0.12),
                dots: showDots && n <= dotsMaxPoints
            })
        }
        renderedPointCount = rendered
        geom.rangeMin = range.min
        geom.rangeMax = range.max
        geom.span = span
        geom.seriesModel = model
        rebuilt()
    }

    QtObject {
        id: geom
        property real rangeMin: 0
        property real rangeMax: 1
        property real span: 1
        property var seriesModel: []
    }

    FrameAnimation {
        running: root.live && root.chartActive
        onTriggered: root.advanceLive(frameTime)
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

    Shape {
        anchors.fill: parent
        visible: root.showGrid && root.horizontalGridLines > 0
        // Polyline grids/series: GeometryRenderer builds faster than CurveRenderer.
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
                asynchronous: true
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
                asynchronous: !root.live
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
}
