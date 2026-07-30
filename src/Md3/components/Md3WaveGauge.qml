import QtQuick

/// Circular gauge with animated liquid / wave fill level.
Item {
    id: root

    property real value: 0
    property real from: 0
    property real to: 100
    property string label: ""
    property string unit: "%"
    property int decimals: 0
    property color trackColor: Md3Theme.colorScheme.surfaceContainerHighest
    property color valueColor: Md3Theme.colorScheme.primary
    property color waveColor: Qt.rgba(valueColor.r, valueColor.g, valueColor.b, 0.55)
    property bool showValue: true
    property bool animated: !Md3Theme.reduceMotion
    property real size: 140
    property real strokeWidth: 3

    readonly property real progress: {
        const span = Math.max(1e-6, to - from)
        return Math.max(0, Math.min(1, (value - from) / span))
    }
    readonly property string valueText: Number(value).toFixed(decimals) + (unit.length ? unit : "")

    width: size
    height: size
    implicitWidth: size
    implicitHeight: size

    property real wavePhase: 0

    NumberAnimation on wavePhase {
        running: root.animated && root.visible
        from: 0
        to: Math.PI * 2
        duration: 2400
        loops: Animation.Infinite
    }

    onWavePhaseChanged: canvas.requestPaint()
    onValueChanged: canvas.requestPaint()
    onWidthChanged: canvas.requestPaint()
    onHeightChanged: canvas.requestPaint()

    Canvas {
        id: canvas
        anchors.fill: parent
        onPaint: {
            const ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            const cx = width / 2
            const cy = height / 2
            const r = Math.min(width, height) / 2 - root.strokeWidth - 1

            ctx.beginPath()
            ctx.arc(cx, cy, r, 0, Math.PI * 2)
            ctx.fillStyle = root.trackColor
            ctx.fill()

            ctx.save()
            ctx.beginPath()
            ctx.arc(cx, cy, r - 1, 0, Math.PI * 2)
            ctx.clip()

            const levelY = cy + r - (2 * r * root.progress)
            const amp = 4 + 2 * (1 - Math.abs(root.progress - 0.5) * 2)
            ctx.beginPath()
            ctx.moveTo(cx - r, cy + r + 2)
            ctx.lineTo(cx - r, levelY)
            const steps = 32
            for (let i = 0; i <= steps; ++i) {
                const t = i / steps
                const x = cx - r + t * 2 * r
                const y = levelY + Math.sin(t * Math.PI * 2 + root.wavePhase) * amp
                        + Math.sin(t * Math.PI * 4 - root.wavePhase * 1.3) * (amp * 0.35)
                ctx.lineTo(x, y)
            }
            ctx.lineTo(cx + r, cy + r + 2)
            ctx.closePath()
            ctx.fillStyle = root.waveColor
            ctx.fill()

            // Second quieter wave
            ctx.beginPath()
            ctx.moveTo(cx - r, cy + r + 2)
            ctx.lineTo(cx - r, levelY + 3)
            for (let i = 0; i <= steps; ++i) {
                const t = i / steps
                const x = cx - r + t * 2 * r
                const y = levelY + 3 + Math.sin(t * Math.PI * 2 - root.wavePhase * 0.8) * (amp * 0.6)
                ctx.lineTo(x, y)
            }
            ctx.lineTo(cx + r, cy + r + 2)
            ctx.closePath()
            ctx.fillStyle = root.valueColor
            ctx.globalAlpha = 0.85
            ctx.fill()
            ctx.globalAlpha = 1
            ctx.restore()

            ctx.beginPath()
            ctx.arc(cx, cy, r, 0, Math.PI * 2)
            ctx.strokeStyle = root.valueColor
            ctx.lineWidth = root.strokeWidth
            ctx.stroke()
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 0
        z: 2
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            visible: root.showValue
            text: root.valueText
            color: Md3Theme.colorScheme.colorOnSurface
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.titleLarge.size
            font.weight: Font.DemiBold
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            visible: root.label.length > 0
            text: root.label
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.labelMedium.size
        }
    }

    Component.onCompleted: canvas.requestPaint()
}
