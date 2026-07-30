import QtQuick
import QtQuick.Window

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
    /// Cap wave redraws (Canvas 2D is expensive at 60fps).
    property int animationFps: 20
    property real size: 140
    property real strokeWidth: 3
    /// Radians advanced per second (wave travel speed).
    property real waveSpeed: 2.2

    readonly property real progress: {
        const span = Math.max(1e-6, to - from)
        return Math.max(0, Math.min(1, (value - from) / span))
    }
    readonly property string valueText: Number(value).toFixed(decimals) + (unit.length ? unit : "")

    /// Parent page slots hide via opacity/visible — child.visible stays true, so walk the tree.
    readonly property bool effectivelyShown: {
        let p = root
        while (p) {
            if (!p.visible || p.opacity < 0.01)
                return false
            p = p.parent
        }
        const w = Window.window
        if (w) {
            if (w.visibility === Window.Minimized || w.visibility === Window.Hidden)
                return false
            if (!w.active)
                return false
        }
        if (Qt.application.state === Qt.ApplicationSuspended
                || Qt.application.state === Qt.ApplicationHidden)
            return false
        return true
    }

    width: size
    height: size
    implicitWidth: size
    implicitHeight: size

    property real wavePhase: 0

    // Throttled wave — not FrameAnimation (that kept Canvas at display refresh).
    Timer {
        interval: Math.max(16, Math.round(1000 / Math.max(1, root.animationFps)))
        running: root.animated && root.effectivelyShown
        repeat: true
        onTriggered: {
            const dt = interval / 1000
            root.wavePhase += root.waveSpeed * dt
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
