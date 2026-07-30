import QtQuick

/// Radial bar chart — each category as an arc bar on concentric tracks.
Item {
    id: root

    /// [{ label, value, color? }] or number[] + labels
    property var values: []
    property var labels: []
    property real maxValue: Number.NaN
    property real barWidth: 10
    property real barGap: 6
    property real startAngle: -90
    property real sweepAngle: 270
    property color trackColor: Md3Theme.colorScheme.gaugeTrack
    property bool showLabels: true

    implicitWidth: 280
    implicitHeight: 280
    width: parent ? parent.width : implicitWidth
    height: implicitHeight

    readonly property var bars: {
        const v = values || []
        const out = []
        for (let i = 0; i < v.length; ++i) {
            if (typeof v[i] === "object" && v[i] !== null && v[i].value !== undefined) {
                out.push({
                    label: v[i].label !== undefined ? String(v[i].label)
                          : (labels[i] !== undefined ? String(labels[i]) : String(i + 1)),
                    value: Number(v[i].value),
                    color: v[i].color
                })
            } else {
                out.push({
                    label: labels[i] !== undefined ? String(labels[i]) : String(i + 1),
                    value: Number(v[i]),
                    color: undefined
                })
            }
        }
        return out
    }

    readonly property real _max: {
        if (!isNaN(maxValue))
            return Math.max(1e-6, maxValue)
        let hi = 0
        for (let i = 0; i < bars.length; ++i)
            hi = Math.max(hi, bars[i].value)
        return Math.max(1, hi)
    }

    function _rad(deg) { return deg * Math.PI / 180 }

    function _colorAt(i, explicit) {
        if (explicit !== undefined)
            return explicit
        const palette = [
            Md3Theme.colorScheme.primary,
            Md3Theme.colorScheme.secondary,
            Md3Theme.colorScheme.tertiary,
            Md3Theme.colorScheme.error
        ]
        return palette[i % palette.length]
    }

    function requestPaint() { canvas.requestPaint() }

    onValuesChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    Canvas {
        id: canvas
        anchors.fill: parent
        anchors.margins: 8
        onPaint: {
            const ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            const list = root.bars
            const n = list.length
            if (!n)
                return
            const cx = width / 2
            const cy = height / 2
            let r = Math.min(width, height) / 2 - 4
            ctx.lineCap = "round"
            ctx.lineWidth = root.barWidth

            for (let i = 0; i < n; ++i) {
                const p = Math.max(0, Math.min(1, list[i].value / root._max))
                const col = root._colorAt(i, list[i].color)
                ctx.strokeStyle = root.trackColor
                ctx.beginPath()
                ctx.arc(cx, cy, r, root._rad(root.startAngle),
                        root._rad(root.startAngle + root.sweepAngle), false)
                ctx.stroke()
                ctx.strokeStyle = col
                ctx.beginPath()
                ctx.arc(cx, cy, r, root._rad(root.startAngle),
                        root._rad(root.startAngle + root.sweepAngle * p), false)
                ctx.stroke()

                if (root.showLabels) {
                    ctx.fillStyle = Md3Theme.colorScheme.colorOnSurfaceVariant
                    ctx.font = Md3Theme.typography.labelSmall.size + "px sans-serif"
                    ctx.textAlign = "left"
                    ctx.textBaseline = "middle"
                    const a = root._rad(root.startAngle + root.sweepAngle + 6)
                    ctx.fillText(list[i].label + " " + list[i].value,
                                 cx + Math.cos(a) * (r - 2),
                                 cy + Math.sin(a) * (r - 2))
                }
                r -= root.barWidth + root.barGap
                if (r < root.barWidth)
                    break
            }
        }
    }

    Component.onCompleted: requestPaint()
}
