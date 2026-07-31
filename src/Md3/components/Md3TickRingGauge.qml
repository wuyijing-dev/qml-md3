import QtQuick
import Md3

/// Tick-ring gauge — circular progress with radial tick marks (no needle).
Item {
    id: root

    property real value: 0
    property real from: 0
    property real to: 100
    property string label: ""
    property string unit: "%"
    property int decimals: 0
    property int tickCount: 36
    property real strokeWidth: 8
    property real startAngle: -90
    property color trackColor: Md3Theme.colorScheme.gaugeTrack
    property color valueColor: Md3Theme.colorScheme.primary
    property color tickColor: Md3Theme.colorScheme.outlineVariant
    property bool showValue: true
    property real size: 140

    readonly property real progress: {
        const span = Math.max(1e-6, to - from)
        return Math.max(0, Math.min(1, (value - from) / span))
    }
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
            const r = Math.min(width, height) / 2 - root.strokeWidth - 6
            const n = Math.max(8, root.tickCount)

            for (let i = 0; i < n; ++i) {
                const t = i / n
                const ang = root._rad(root.startAngle + 360 * t)
                const major = (i % 3) === 0
                const len = major ? 8 : 4
                ctx.strokeStyle = t <= root.progress ? root.valueColor : root.tickColor
                ctx.lineWidth = major ? 2 : 1
                ctx.beginPath()
                ctx.moveTo(cx + Math.cos(ang) * (r + 2), cy + Math.sin(ang) * (r + 2))
                ctx.lineTo(cx + Math.cos(ang) * (r + 2 + len), cy + Math.sin(ang) * (r + 2 + len))
                ctx.stroke()
            }

            ctx.lineWidth = root.strokeWidth
            ctx.lineCap = "round"
            ctx.strokeStyle = root.trackColor
            ctx.beginPath()
            ctx.arc(cx, cy, r - 4, 0, Math.PI * 2)
            ctx.stroke()
            ctx.strokeStyle = root.valueColor
            ctx.beginPath()
            ctx.arc(cx, cy, r - 4, root._rad(root.startAngle),
                    root._rad(root.startAngle + 360 * root.progress), false)
            ctx.stroke()
        }
    }

    onValueChanged: canvas.requestPaint()
    onTrackColorChanged: canvas.requestPaint()
    onWidthChanged: canvas.requestPaint()
    onHeightChanged: canvas.requestPaint()
    Component.onCompleted: canvas.requestPaint()

    Column {
        anchors.centerIn: parent
        spacing: 0
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
