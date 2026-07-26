import QtQuick
import QtQuick.Shapes

/// MD3 line chart — QtQuick.Shapes GPU stroke (RoundCap/Join = Canvas-quality look).
/// Large series: feed already-downsampled points from Md3ChartData (C++), not raw millions.
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
    property color surfaceColor: Md3Theme.colorScheme.surface

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
    property int smoothMaxPoints: 400
    property int dotsMaxPoints: 80

    /// Live sine without JS million-alloc; small point count only.
    property bool live: false
    property int livePointCount: 48
    property real liveSpeed: 2.4
    property real livePhase: 0

    readonly property int rawPointCount: 0
    property int renderedPointCount: 0

    implicitWidth: 280
    implicitHeight: 160

    readonly property real _left: contentPadding + labelWidth
    readonly property real _right: width - contentPadding
    readonly property real _top: contentPadding + 4
    readonly property real _bottom: height - contentPadding - (showXLabels ? 16 : 0)
    readonly property real _plotW: Math.max(1, _right - _left)
    readonly property real _plotH: Math.max(1, _bottom - _top)

    readonly property var _flatSeries: {
        if (live)
            return [liveValues]
        if (series && series.length > 0)
            return series
        return [values]
    }

    readonly property var liveValues: {
        const p = livePhase
        const n = livePointCount
        const out = []
        for (let i = 0; i < n; ++i) {
            const t = p + i * 0.22
            out.push(50 + Math.sin(t) * 28 + Math.sin(t * 0.37) * 12)
        }
        return out
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
        if (!s || s.length === undefined)
            return []
        const n = s.length
        if (n === 0)
            return []
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

    function _rangeFromSeries(all) {
        let lo = minY
        let hi = maxY
        if (!isNaN(lo) && !isNaN(hi) && hi > lo)
            return { min: lo, max: hi }
        lo = Infinity
        hi = -Infinity
        let found = false
        for (let s = 0; s < all.length; ++s) {
            const nums = _seriesNums(all[s])
            for (let i = 0; i < nums.length; ++i) {
                found = true
                if (nums[i] < lo) lo = nums[i]
                if (nums[i] > hi) hi = nums[i]
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

    function _buildGeom() {
        const all = _flatSeries
        const range = _rangeFromSeries(all)
        const span = Math.max(1e-6, range.max - range.min)
        const yAt = v => _top + _plotH * (1 - (v - range.min) / span)

        const model = []
        let rendered = 0
        for (let s = 0; s < all.length; ++s) {
            const nums = _seriesNums(all[s])
            if (nums.length < 1)
                continue
            const n = nums.length
            rendered += n
            let pts = []
            for (let i = 0; i < n; ++i) {
                const x = n === 1 ? (_left + _plotW / 2) : (_left + _plotW * i / (n - 1))
                pts.push(Qt.point(x, yAt(nums[i])))
            }
            const useSmooth = smooth && n <= smoothMaxPoints
            if (useSmooth)
                pts = _catmull(pts, 4)

            const col = _colorAt(s)
            let area = []
            if (showArea && pts.length >= 2) {
                area = pts.slice()
                area.push(Qt.point(pts[pts.length - 1].x, _bottom))
                area.push(Qt.point(pts[0].x, _bottom))
            }
            model.push({
                line: pts,
                area: area,
                color: col,
                fill: s === 0 ? fillColor : Qt.rgba(col.r, col.g, col.b, 0.12),
                dots: showDots && n <= dotsMaxPoints
            })
        }
        root.renderedPointCount = rendered
        geom.rangeMin = range.min
        geom.rangeMax = range.max
        geom.span = span
        geom.seriesModel = model
    }

    QtObject {
        id: geom
        property real rangeMin: 0
        property real rangeMax: 1
        property real span: 1
        property var seriesModel: []
    }

    onWidthChanged: rebuildTimer.restart()
    onHeightChanged: rebuildTimer.restart()
    onValuesChanged: rebuildTimer.restart()
    onSeriesChanged: rebuildTimer.restart()
    onSeriesColorsChanged: rebuildTimer.restart()
    onLineColorChanged: rebuildTimer.restart()
    onFillColorChanged: rebuildTimer.restart()
    onShowAreaChanged: rebuildTimer.restart()
    onShowDotsChanged: rebuildTimer.restart()
    onSmoothChanged: rebuildTimer.restart()
    onMinYChanged: rebuildTimer.restart()
    onMaxYChanged: rebuildTimer.restart()
    onLiveChanged: rebuildTimer.restart()
    onLiveValuesChanged: if (live) rebuildTimer.restart()

    Timer {
        id: rebuildTimer
        interval: 0
        onTriggered: root._buildGeom()
    }
    Component.onCompleted: _buildGeom()

    FrameAnimation {
        running: root.live && root.visible && root.enabled
        onTriggered: {
            root.livePhase = (root.livePhase + root.liveSpeed * frameTime) % (Math.PI * 200)
        }
    }

    Rectangle {
        anchors.fill: parent
        color: root.backgroundColor
        radius: Md3Theme.shape.small
    }

    // Grid
    Shape {
        anchors.fill: parent
        visible: root.showGrid && root.horizontalGridLines > 0
        preferredRendererType: Shape.CurveRenderer
        ShapePath {
            strokeWidth: 1
            strokeColor: Qt.rgba(root.gridColor.r, root.gridColor.g, root.gridColor.b, 0.45)
            fillColor: "transparent"
            PathMultiline {
                paths: {
                    const out = []
                    const n = root.horizontalGridLines
                    for (let g = 0; g <= n; ++g) {
                        const t = g / n
                        const y = root._top + root._plotH * (1 - t)
                        out.push([Qt.point(root._left, y), Qt.point(root._right, y)])
                    }
                    return out
                }
            }
        }
    }

    // Series fills + strokes
    Repeater {
        model: geom.seriesModel
        delegate: Item {
            id: seriesItem
            required property var modelData
            readonly property color seriesColor: modelData.color
            anchors.fill: parent

            Shape {
                anchors.fill: parent
                preferredRendererType: Shape.CurveRenderer
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
                preferredRendererType: Shape.CurveRenderer
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
                        color: root.surfaceColor
                    }
                }
            }
        }
    }

    // Y labels
    Repeater {
        model: root.showYLabels ? root.horizontalGridLines + 1 : 0
        delegate: Text {
            required property int index
            readonly property real t: index / Math.max(1, root.horizontalGridLines)
            readonly property real v: geom.rangeMin + geom.span * t
            x: 0
            y: root._top + root._plotH * (1 - t) - 8
            width: root._left - 6
            height: 16
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            text: v.toFixed(root.valueDecimals) + root.yUnit
            color: root.axisLabelColor
            font.pixelSize: 11
            font.family: Md3Theme.typography.fontFamily
        }
    }
}
