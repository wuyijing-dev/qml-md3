import QtQuick

/// Segmented arc gauge — discrete wedges (battery / steps style).
Item {
    id: root

    property real value: 0
    property real from: 0
    property real to: 100
    property string label: ""
    property string unit: ""
    property int decimals: 0
    property int segments: 12
    property real segmentGapDeg: 4
    property real startAngle: -210
    property real sweepAngle: 240
    property real strokeWidth: 12
    property color trackColor: Md3Theme.colorScheme.surfaceContainerHighest
    property color valueColor: Md3Theme.colorScheme.primary
    property bool showValue: true
    property real size: 140

    readonly property real progress: {
        const span = Math.max(1e-6, to - from)
        return Math.max(0, Math.min(1, (value - from) / span))
    }
    readonly property int filledSegments: Math.round(progress * Math.max(1, segments))
    readonly property string valueText: Number(value).toFixed(decimals) + (unit.length ? unit : "")

    width: size
    height: size
    implicitWidth: size
    implicitHeight: size

    function _rad(deg) { return deg * Math.PI / 180 }

    Canvas {
        id: canvas
        anchors.fill: parent
        onPaint: {
            const ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            const cx = width / 2
            const cy = height / 2
            const r = Math.min(width, height) / 2 - root.strokeWidth
            const n = Math.max(1, root.segments)
            const gap = root.segmentGapDeg
            const usable = root.sweepAngle - gap * n
            const seg = Math.max(1, usable / n)
            ctx.lineWidth = root.strokeWidth
            ctx.lineCap = "round"
            for (let i = 0; i < n; ++i) {
                const a0 = root._rad(root.startAngle + i * (seg + gap) + gap * 0.5)
                const a1 = root._rad(root.startAngle + i * (seg + gap) + gap * 0.5 + seg)
                ctx.strokeStyle = i < root.filledSegments ? root.valueColor : root.trackColor
                ctx.beginPath()
                ctx.arc(cx, cy, r, a0, a1, false)
                ctx.stroke()
            }
        }
    }

    onValueChanged: canvas.requestPaint()
    onSegmentsChanged: canvas.requestPaint()
    onWidthChanged: canvas.requestPaint()
    onHeightChanged: canvas.requestPaint()
    onValueColorChanged: canvas.requestPaint()
    onTrackColorChanged: canvas.requestPaint()
    Component.onCompleted: canvas.requestPaint()

    Column {
        anchors.centerIn: parent
        spacing: 2
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            visible: root.showValue
            text: root.valueText
            color: Md3Theme.colorScheme.colorOnSurface
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.headlineSmall.size
            font.weight: Font.Medium
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            visible: root.label.length > 0
            text: root.label
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.labelLarge.size
        }
    }
}
