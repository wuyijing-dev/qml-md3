import QtQuick

/// Circular gauge with animated liquid / wave fill level (seamless loop).
Item {
    id: root

    property real value: 0
    property real from: 0
    property real to: 100
    property string label: ""
    property string unit: "%"
    property int decimals: 0
    property color trackColor: Md3Theme.colorScheme.gaugeTrack
    property color dialColor: Md3Theme.colorScheme.gaugeDial
    property color valueColor: Md3Theme.colorScheme.primary
    property color waveColor: Qt.rgba(valueColor.r, valueColor.g, valueColor.b, 0.55)
    property bool showValue: true
    property bool animated: !Md3Theme.reduceMotion
    property real size: 140
    property real strokeWidth: 3
    /// Radians advanced per second (wave travel speed).
    property real waveSpeed: 2.2

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

    // Continuous phase — no Animation loops restart (that caused a visible hitch
    // when secondary waves used non-integer phase multipliers).
    FrameAnimation {
        running: root.animated && root.visible
        onTriggered: {
            root.wavePhase += root.waveSpeed * frameTime
            // Keep phase bounded; all wave terms use integer multiples of phase
            // so wrapping by 2π is C∞ continuous for sin().
            if (root.wavePhase > Math.PI * 2)
                root.wavePhase -= Math.PI * 2
            canvas.requestPaint()
        }
    }

    onValueChanged: canvas.requestPaint()
    onDialColorChanged: canvas.requestPaint()
    onTrackColorChanged: canvas.requestPaint()
    onValueColorChanged: canvas.requestPaint()
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
            const phase = root.wavePhase

            ctx.beginPath()
            ctx.arc(cx, cy, r, 0, Math.PI * 2)
            ctx.fillStyle = root.dialColor
            ctx.fill()

            ctx.save()
            ctx.beginPath()
            ctx.arc(cx, cy, r - 1, 0, Math.PI * 2)
            ctx.clip()

            const levelY = cy + r - (2 * r * root.progress)
            const amp = 4 + 2 * (1 - Math.abs(root.progress - 0.5) * 2)
            const steps = 40

            // Primary wave: sin(2πt + φ) + 0.35·sin(4πt − 2φ) — period 2π in φ
            ctx.beginPath()
            ctx.moveTo(cx - r, cy + r + 2)
            ctx.lineTo(cx - r, levelY)
            for (let i = 0; i <= steps; ++i) {
                const t = i / steps
                const x = cx - r + t * 2 * r
                const y = levelY
                        + Math.sin(t * Math.PI * 2 + phase) * amp
                        + Math.sin(t * Math.PI * 4 - phase * 2) * (amp * 0.35)
                ctx.lineTo(x, y)
            }
            ctx.lineTo(cx + r, cy + r + 2)
            ctx.closePath()
            ctx.fillStyle = root.waveColor
            ctx.fill()

            // Secondary wave: sin(2πt − φ) — same period, phase-offset look
            ctx.beginPath()
            ctx.moveTo(cx - r, cy + r + 2)
            ctx.lineTo(cx - r, levelY + 3)
            for (let i = 0; i <= steps; ++i) {
                const t = i / steps
                const x = cx - r + t * 2 * r
                const y = levelY + 3 + Math.sin(t * Math.PI * 2 - phase) * (amp * 0.6)
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
            // Outer silhouette so the dial doesn't sink into dark surfaces
            ctx.beginPath()
            ctx.arc(cx, cy, r + root.strokeWidth * 0.5, 0, Math.PI * 2)
            ctx.strokeStyle = Md3Theme.colorScheme.outlineVariant
            ctx.lineWidth = 1
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
