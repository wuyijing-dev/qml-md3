import QtQuick

/// Rotary knob-style gauge (value as dial rotation with notch).
Item {
    id: root

    property real value: 0
    property real from: 0
    property real to: 100
    property string label: ""
    property string unit: ""
    property int decimals: 0
    property real startAngle: -135
    property real sweepAngle: 270
    property color trackColor: Md3Theme.colorScheme.surfaceContainerHighest
    property color valueColor: Md3Theme.colorScheme.primary
    property color knobColor: Md3Theme.colorScheme.surfaceContainerHigh
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
            const r = Math.min(width, height) / 2 - 4
            const a0 = root._rad(root.startAngle)
            const a1 = root._rad(root.startAngle + root.sweepAngle)
            const ap = root._rad(root.startAngle + root.sweepAngle * root.progress)

            // Track arc
            ctx.lineWidth = 6
            ctx.lineCap = "round"
            ctx.strokeStyle = root.trackColor
            ctx.beginPath()
            ctx.arc(cx, cy, r - 2, a0, a1, false)
            ctx.stroke()
            ctx.strokeStyle = root.valueColor
            ctx.beginPath()
            ctx.arc(cx, cy, r - 2, a0, ap, false)
            ctx.stroke()

            // Knob body
            ctx.beginPath()
            ctx.arc(cx, cy, r * 0.62, 0, Math.PI * 2)
            ctx.fillStyle = root.knobColor
            ctx.fill()
            ctx.strokeStyle = Md3Theme.colorScheme.outlineVariant
            ctx.lineWidth = 1
            ctx.stroke()

            // Notch
            const nr = r * 0.42
            ctx.strokeStyle = root.valueColor
            ctx.lineWidth = 3
            ctx.lineCap = "round"
            ctx.beginPath()
            ctx.moveTo(cx + Math.cos(ap) * (nr * 0.25), cy + Math.sin(ap) * (nr * 0.25))
            ctx.lineTo(cx + Math.cos(ap) * nr, cy + Math.sin(ap) * nr)
            ctx.stroke()

            // Center pip
            ctx.beginPath()
            ctx.arc(cx, cy, 4, 0, Math.PI * 2)
            ctx.fillStyle = root.valueColor
            ctx.fill()
        }
    }

    onValueChanged: canvas.requestPaint()
    onWidthChanged: canvas.requestPaint()
    onHeightChanged: canvas.requestPaint()
    Component.onCompleted: canvas.requestPaint()

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 6
        spacing: 0
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            visible: root.showValue
            text: root.valueText
            color: Md3Theme.colorScheme.colorOnSurface
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.labelLarge.size
            font.weight: Font.Medium
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            visible: root.label.length > 0
            text: root.label
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.labelSmall.size
        }
    }
}
