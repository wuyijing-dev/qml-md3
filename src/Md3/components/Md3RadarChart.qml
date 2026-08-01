import QtQuick
import Md3

/// Radar / spider chart — categories around a polygon, one or more series.
Item {
    id: root

    /// Category labels around the axes
    property var categories: []
    /// One series: number[] aligned with categories; or multiple: [number[], ...]
    property var values: []
    property real maxValue: Number.NaN
    property color fillColor: Qt.rgba(Md3Theme.colorScheme.primary.r,
                                      Md3Theme.colorScheme.primary.g,
                                      Md3Theme.colorScheme.primary.b, 0.22)
    property color strokeColor: Md3Theme.colorScheme.primary
    property var seriesColors: []
    property int levels: 4
    property bool showLabels: true
    property bool showDots: true
    property real strokeWidth: 2
    /// Drop Canvas while page/window inactive (FBO free).
    readonly property bool _plotActive: Md3TreeVisibility.isLiveMotionScene(root, null)

    implicitWidth: 280
    implicitHeight: 280
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

    readonly property real _max: {
        if (!isNaN(maxValue))
            return Math.max(1e-6, maxValue)
        let hi = 0
        const list = _seriesList
        for (let s = 0; s < list.length; ++s) {
            for (let i = 0; i < list[s].length; ++i)
                hi = Math.max(hi, Number(list[s][i]) || 0)
        }
        return Math.max(1, hi)
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

    function requestPaint() {
        if (canvasLoader.item)
            canvasLoader.item.requestPaint()
    }

    onCategoriesChanged: requestPaint()
    onValuesChanged: requestPaint()
    onMaxValueChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()
    on_PlotActiveChanged: if (_plotActive) requestPaint()

        Loader {
        id: canvasLoader
        anchors.fill: parent
        active: root._plotActive
        sourceComponent: canvasComp
        onLoaded: if (item) item.requestPaint()
    }

    Component {
        id: canvasComp
    Canvas {
            id: canvas
            anchors.fill: parent
            anchors.margins: 8
            onPaint: {
                const ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                const cats = root.categories || []
                const n = Math.max(3, cats.length || (root._seriesList[0] ? root._seriesList[0].length : 0))
                if (n < 3)
                    return
                const cx = width / 2
                const cy = height / 2
                const r = Math.min(width, height) / 2 - (root.showLabels ? 22 : 8)
                const start = -Math.PI / 2

                // Grid levels
                ctx.strokeStyle = Md3Theme.colorScheme.outlineVariant
                ctx.lineWidth = 1
                for (let lv = 1; lv <= root.levels; ++lv) {
                    const rr = r * (lv / root.levels)
                    ctx.beginPath()
                    for (let i = 0; i <= n; ++i) {
                        const a = start + (Math.PI * 2 * (i % n)) / n
                        const x = cx + Math.cos(a) * rr
                        const y = cy + Math.sin(a) * rr
                        if (i === 0) ctx.moveTo(x, y)
                        else ctx.lineTo(x, y)
                    }
                    ctx.closePath()
                    ctx.stroke()
                }
                // Axes
                for (let i = 0; i < n; ++i) {
                    const a = start + (Math.PI * 2 * i) / n
                    ctx.beginPath()
                    ctx.moveTo(cx, cy)
                    ctx.lineTo(cx + Math.cos(a) * r, cy + Math.sin(a) * r)
                    ctx.stroke()
                }

                // Series
                const list = root._seriesList
                for (let s = 0; s < list.length; ++s) {
                    const series = list[s]
                    const col = root._colorAt(s)
                    ctx.beginPath()
                    for (let i = 0; i < n; ++i) {
                        const v = Number(series[i] || 0)
                        const t = Math.max(0, Math.min(1, v / root._max))
                        const a = start + (Math.PI * 2 * i) / n
                        const x = cx + Math.cos(a) * r * t
                        const y = cy + Math.sin(a) * r * t
                        if (i === 0) ctx.moveTo(x, y)
                        else ctx.lineTo(x, y)
                    }
                    ctx.closePath()
                    const fill = Qt.rgba(col.r, col.g, col.b, 0.22)
                    ctx.fillStyle = fill
                    ctx.fill()
                    ctx.strokeStyle = col
                    ctx.lineWidth = root.strokeWidth
                    ctx.stroke()

                    if (root.showDots) {
                        ctx.fillStyle = col
                        for (let i = 0; i < n; ++i) {
                            const v = Number(series[i] || 0)
                            const t = Math.max(0, Math.min(1, v / root._max))
                            const a = start + (Math.PI * 2 * i) / n
                            ctx.beginPath()
                            ctx.arc(cx + Math.cos(a) * r * t, cy + Math.sin(a) * r * t, 3, 0, Math.PI * 2)
                            ctx.fill()
                        }
                    }
                }

                if (root.showLabels && cats.length) {
                    ctx.fillStyle = Md3Theme.colorScheme.colorOnSurfaceVariant
                    ctx.font = Md3Theme.typography.labelSmall.size + "px sans-serif"
                    ctx.textAlign = "center"
                    ctx.textBaseline = "middle"
                    for (let i = 0; i < Math.min(n, cats.length); ++i) {
                        const a = start + (Math.PI * 2 * i) / n
                        const x = cx + Math.cos(a) * (r + 14)
                        const y = cy + Math.sin(a) * (r + 14)
                        ctx.fillText(String(cats[i]), x, y)
                    }
                }
            }
        }    }


    Component.onCompleted: requestPaint()
}
