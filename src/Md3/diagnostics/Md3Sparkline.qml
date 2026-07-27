import QtQuick

/// Lightweight sparkline — Canvas only, no Shape/Md3Chart overhead.
Item {
    id: root

    property var values: []
    property color stroke: Md3Theme.colorScheme.primary
    property real minY: Number.NaN
    property real maxY: Number.NaN
    property real lineWidth: 1.5

    onValuesChanged: canvas.requestPaint()
    onWidthChanged: canvas.requestPaint()
    onHeightChanged: canvas.requestPaint()
    onStrokeChanged: canvas.requestPaint()

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
                lo = vals[0]
                hi = vals[0]
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
            const pad = 1
            const w = width - pad * 2
            const h = height - pad * 2
            ctx.beginPath()
            ctx.strokeStyle = root.stroke
            ctx.lineWidth = root.lineWidth
            ctx.lineJoin = "round"
            ctx.lineCap = "round"
            for (let i = 0; i < n; ++i) {
                const x = pad + (i / (n - 1)) * w
                const y = pad + (1 - (Number(vals[i]) - lo) / (hi - lo)) * h
                if (i === 0)
                    ctx.moveTo(x, y)
                else
                    ctx.lineTo(x, y)
            }
            ctx.stroke()
        }
    }
}
