import QtQuick
import Md3

/// Lightweight sparkline for KPIs / lists — Canvas only (no Md3Chart overhead).
Item {
    id: root

    property var values: []
    property color stroke: Md3Theme.colorScheme.primary
    property color fill: "transparent"
    property real minY: Number.NaN
    property real maxY: Number.NaN
    property real lineWidth: 1.5
    property bool showArea: true
    property bool showLastDot: false
    property real areaOpacity: 0.22

    readonly property color effectiveFill: fill.a > 0.01 ? fill
            : Qt.rgba(stroke.r, stroke.g, stroke.b, areaOpacity)

    onValuesChanged: canvas.requestPaint()
    onWidthChanged: canvas.requestPaint()
    onHeightChanged: canvas.requestPaint()
    onStrokeChanged: canvas.requestPaint()
    onFillChanged: canvas.requestPaint()
    onShowAreaChanged: canvas.requestPaint()
    onShowLastDotChanged: canvas.requestPaint()

    implicitWidth: 120
    implicitHeight: 36

    Canvas {
        id: canvas
        anchors.fill: parent
        renderTarget: Canvas.FramebufferObject
        renderStrategy: Canvas.Cooperative

        onPaint: {
            const ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            const vals = root.values
            if (!vals || vals.length < 2 || width < 2 || height < 2)
                return

            let lo = root.minY
            let hi = root.maxY
            if (isNaN(lo) || isNaN(hi)) {
                lo = Number(vals[0])
                hi = lo
                for (let i = 1; i < vals.length; ++i) {
                    const v = Number(vals[i])
                    if (v < lo) lo = v
                    if (v > hi) hi = v
                }
            }
            if (!(hi > lo)) {
                lo -= 1
                hi += 1
            }

            const n = vals.length
            const pad = 2
            const w = width - pad * 2
            const h = height - pad * 2
            const pts = []
            for (let i = 0; i < n; ++i) {
                const x = pad + (i / (n - 1)) * w
                const y = pad + (1 - (Number(vals[i]) - lo) / (hi - lo)) * h
                pts.push({ x: x, y: y })
            }

            if (root.showArea && pts.length >= 2) {
                ctx.beginPath()
                ctx.moveTo(pts[0].x, pad + h)
                for (let i = 0; i < pts.length; ++i)
                    ctx.lineTo(pts[i].x, pts[i].y)
                ctx.lineTo(pts[pts.length - 1].x, pad + h)
                ctx.closePath()
                const f = root.effectiveFill
                ctx.fillStyle = Qt.rgba(f.r, f.g, f.b, f.a)
                ctx.fill()
            }

            ctx.beginPath()
            ctx.strokeStyle = root.stroke
            ctx.lineWidth = root.lineWidth
            ctx.lineJoin = "round"
            ctx.lineCap = "round"
            for (let i = 0; i < pts.length; ++i) {
                if (i === 0)
                    ctx.moveTo(pts[i].x, pts[i].y)
                else
                    ctx.lineTo(pts[i].x, pts[i].y)
            }
            ctx.stroke()

            if (root.showLastDot) {
                const last = pts[pts.length - 1]
                ctx.beginPath()
                ctx.fillStyle = root.stroke
                ctx.arc(last.x, last.y, Math.max(2.5, root.lineWidth + 1), 0, Math.PI * 2)
                ctx.fill()
            }
        }
    }
}
