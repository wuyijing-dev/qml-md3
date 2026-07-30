import QtQuick
import Md3

/// Waterfall chart — floating bars for stepwise +/− contributions to a total.
Item {
    id: root

    /// [{ label, value, color? }] — positive = increase, negative = decrease
    property var values: []
    property color upColor: Md3Theme.colorScheme.primary
    property color downColor: Md3Theme.colorScheme.error
    property color totalColor: Md3Theme.colorScheme.tertiary
    property bool lastIsTotal: true
    property real barGap: 8
    property bool showValues: true

    implicitWidth: 360
    implicitHeight: 220
    width: parent ? parent.width : implicitWidth
    height: implicitHeight

    readonly property var steps: {
        const v = values || []
        const out = []
        for (let i = 0; i < v.length; ++i) {
            if (typeof v[i] === "object" && v[i] !== null) {
                out.push({
                    label: v[i].label !== undefined ? String(v[i].label) : String(i + 1),
                    value: Number(v[i].value),
                    color: v[i].color,
                    isTotal: !!v[i].isTotal
                })
            } else {
                out.push({
                    label: String(i + 1),
                    value: Number(v[i]),
                    color: undefined,
                    isTotal: false
                })
            }
        }
        if (lastIsTotal && out.length)
            out[out.length - 1].isTotal = true
        return out
    }

    function requestPaint() { canvas.requestPaint() }

    onValuesChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    Canvas {
        id: canvas
        anchors.fill: parent
        onPaint: {
            const ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            const list = root.steps
            const n = list.length
            if (!n)
                return

            // Running totals for layout
            let run = 0
            const spans = []
            let minV = 0
            let maxV = 0
            for (let i = 0; i < n; ++i) {
                const v = list[i].value
                let y0, y1
                if (list[i].isTotal) {
                    y0 = 0
                    y1 = run
                    // total bar from 0 to current run (before adding if total replaces)
                    // Convention: total row shows cumulative; value may equal run
                    if (Math.abs(v) > 1e-9 && Math.abs(v - run) > 1e-6)
                        y1 = v
                    else
                        y1 = run
                    y0 = 0
                } else {
                    y0 = run
                    run += v
                    y1 = run
                }
                spans.push({ y0: y0, y1: y1, v: v })
                minV = Math.min(minV, y0, y1)
                maxV = Math.max(maxV, y0, y1)
            }
            if (!(maxV > minV)) {
                minV = 0
                maxV = 1
            }

            const padL = 8
            const padB = 22
            const padT = 8
            const plotW = width - padL * 2
            const plotH = height - padB - padT
            const barW = Math.max(8, (plotW - root.barGap * (n - 1)) / n)
            const span = Math.max(1e-6, maxV - minV)

            function yAt(v) {
                return padT + plotH * (1 - (v - minV) / span)
            }

            // Zero line
            ctx.strokeStyle = Md3Theme.colorScheme.outlineVariant
            ctx.lineWidth = 1
            ctx.beginPath()
            ctx.moveTo(padL, yAt(0))
            ctx.lineTo(width - padL, yAt(0))
            ctx.stroke()

            ctx.font = Md3Theme.typography.labelSmall.size + "px sans-serif"
            ctx.textAlign = "center"

            for (let i = 0; i < n; ++i) {
                const x = padL + i * (barW + root.barGap)
                const s = spans[i]
                const top = Math.min(s.y0, s.y1)
                const bot = Math.max(s.y0, s.y1)
                const y = yAt(bot)
                const h = Math.max(2, yAt(top) - yAt(bot))
                let col = list[i].color
                if (col === undefined) {
                    if (list[i].isTotal)
                        col = root.totalColor
                    else
                        col = s.v >= 0 ? root.upColor : root.downColor
                }
                ctx.fillStyle = col
                ctx.fillRect(x, y, barW, h)

                // Connector to next
                if (i < n - 1 && !list[i].isTotal) {
                    ctx.strokeStyle = Md3Theme.colorScheme.outlineVariant
                    ctx.setLineDash([3, 3])
                    ctx.beginPath()
                    ctx.moveTo(x + barW, yAt(s.y1))
                    ctx.lineTo(x + barW + root.barGap, yAt(s.y1))
                    ctx.stroke()
                    ctx.setLineDash([])
                }

                ctx.fillStyle = Md3Theme.colorScheme.colorOnSurfaceVariant
                ctx.textBaseline = "top"
                ctx.fillText(list[i].label, x + barW / 2, height - padB + 4)
                if (root.showValues) {
                    ctx.textBaseline = "bottom"
                    ctx.fillStyle = Md3Theme.colorScheme.colorOnSurface
                    ctx.fillText(String(list[i].value), x + barW / 2, y - 2)
                }
            }
        }
    }

    Component.onCompleted: requestPaint()
}
