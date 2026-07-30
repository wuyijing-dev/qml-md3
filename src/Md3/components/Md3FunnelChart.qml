import QtQuick
import Md3

/// Funnel chart — stages as stacked trapezoids (conversion / pipeline).
Item {
    id: root

    /// [{ label, value, color? }] or number[] with `labels`
    property var values: []
    property var labels: []
    property real gap: 4
    property real minWidthRatio: 0.18
    property bool showLabels: true
    property bool showValues: true

    implicitWidth: 320
    implicitHeight: 240
    width: parent ? parent.width : implicitWidth
    height: implicitHeight

    readonly property var stages: {
        const v = values || []
        const out = []
        for (let i = 0; i < v.length; ++i) {
            if (typeof v[i] === "object" && v[i] !== null && v[i].value !== undefined) {
                out.push({
                    label: v[i].label !== undefined ? String(v[i].label)
                          : (labels[i] !== undefined ? String(labels[i]) : qsTr("Stage %1").arg(i + 1)),
                    value: Number(v[i].value),
                    color: v[i].color
                })
            } else {
                out.push({
                    label: labels[i] !== undefined ? String(labels[i]) : qsTr("Stage %1").arg(i + 1),
                    value: Number(v[i]),
                    color: undefined
                })
            }
        }
        return out
    }

    readonly property real _max: {
        let hi = 0
        for (let i = 0; i < stages.length; ++i)
            hi = Math.max(hi, stages[i].value)
        return Math.max(1e-6, hi)
    }

    function _colorAt(i, explicit) {
        if (explicit !== undefined)
            return explicit
        const palette = [
            Md3Theme.colorScheme.primary,
            Md3Theme.colorScheme.secondary,
            Md3Theme.colorScheme.tertiary,
            Md3Theme.colorScheme.primaryContainer,
            Md3Theme.colorScheme.tertiaryContainer
        ]
        return palette[i % palette.length]
    }

    function requestPaint() { canvas.requestPaint() }

    onValuesChanged: requestPaint()
    onLabelsChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    Canvas {
        id: canvas
        anchors.fill: parent
        onPaint: {
            const ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            const list = root.stages
            const n = list.length
            if (!n)
                return
            const rowH = (height - root.gap * (n - 1)) / n
            const cx = width / 2
            const maxW = width * 0.92
            const minW = width * root.minWidthRatio

            ctx.font = Md3Theme.typography.labelMedium.size + "px sans-serif"
            ctx.textAlign = "center"
            ctx.textBaseline = "middle"

            for (let i = 0; i < n; ++i) {
                const t0 = list[i].value / root._max
                const t1 = i + 1 < n ? list[i + 1].value / root._max : root.minWidthRatio
                const w0 = minW + (maxW - minW) * Math.max(root.minWidthRatio, t0)
                const w1 = minW + (maxW - minW) * Math.max(root.minWidthRatio, Math.min(t0, t1))
                const y0 = i * (rowH + root.gap)
                const y1 = y0 + rowH
                const col = root._colorAt(i, list[i].color)

                ctx.beginPath()
                ctx.moveTo(cx - w0 / 2, y0)
                ctx.lineTo(cx + w0 / 2, y0)
                ctx.lineTo(cx + w1 / 2, y1)
                ctx.lineTo(cx - w1 / 2, y1)
                ctx.closePath()
                ctx.fillStyle = col
                ctx.fill()

                if (root.showLabels || root.showValues) {
                    const lum = 0.299 * col.r + 0.587 * col.g + 0.114 * col.b
                    ctx.fillStyle = lum > 0.55
                            ? Md3Theme.colorScheme.colorOnSurface
                            : Md3Theme.colorScheme.colorOnPrimary
                    let text = ""
                    if (root.showLabels)
                        text = list[i].label
                    if (root.showValues)
                        text += (text.length ? "  ·  " : "") + String(list[i].value)
                    ctx.fillText(text, cx, y0 + rowH / 2)
                }
            }
        }
    }

    Component.onCompleted: requestPaint()
}
