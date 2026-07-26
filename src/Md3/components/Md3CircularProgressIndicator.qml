import QtQuick
import QtQuick.Window

/*
  Circular progress — vsync FrameAnimation paint (Flutter CustomPainter style).
*/
Item {
    id: root

    enum Style { Standard, Wavy, Lively, Soft }

    property real value: 0
    property bool indeterminate: true
    property int style: Md3CircularProgressIndicator.Standard
    property real strokeWidth: {
        switch (style) {
        case Md3CircularProgressIndicator.Lively: return 7
        case Md3CircularProgressIndicator.Soft: return 5
        case Md3CircularProgressIndicator.Wavy: return 6
        default: return 4
        }
    }
    property real size: style === Md3CircularProgressIndicator.Standard ? 48 : 52
    property real amplitude: {
        switch (style) {
        case Md3CircularProgressIndicator.Lively: return 3.5
        case Md3CircularProgressIndicator.Soft: return 1.5
        case Md3CircularProgressIndicator.Wavy: return 2.5
        default: return 0
        }
    }
    property int waveCount: {
        switch (style) {
        case Md3CircularProgressIndicator.Lively: return 8
        case Md3CircularProgressIndicator.Soft: return 4
        case Md3CircularProgressIndicator.Wavy: return 5
        default: return 0
        }
    }
    property real wavePhase: 0
    property real rotation: -Math.PI / 2
    property real sweep: Math.PI * 0.55
    property real waveSpeed: Math.PI * 2 / 1.8
    property real spinSpeed: Math.PI * 2 / (Md3Motion.progressSpin / 1000)

    readonly property real sweepMin: Math.PI * 0.28
    readonly property real sweepMax: Math.PI * 1.15
    readonly property bool isWavy: style !== Md3CircularProgressIndicator.Standard
    property bool _treeShown: true
    readonly property bool sceneActive: enabled && _treeShown
    readonly property real radius: Math.min(width, height) / 2 - strokeWidth - (isWavy ? amplitude : 0)

    property real sweepDir: 1

    function _refreshTreeShown() {
        let ok = visible && opacity > 0.01
        let p = parent
        while (ok && p) {
            if (p.visible === false)
                ok = false
            else if (p.opacity !== undefined && p.opacity < 0.01)
                ok = false
            else
                p = p.parent
        }
        const w = Window.window
        if (!w || w.visibility === Window.Hidden || w.visibility === Window.Minimized)
            ok = false
        if (_treeShown !== ok)
            _treeShown = ok
    }

    Timer {
        interval: 200
        running: root.enabled && (root.indeterminate || root.isWavy)
        repeat: true
        onTriggered: root._refreshTreeShown()
    }
    Component.onCompleted: _refreshTreeShown()
    onVisibleChanged: _refreshTreeShown()
    onOpacityChanged: _refreshTreeShown()

    width: size
    height: size

    Canvas {
        id: canvas
        anchors.fill: parent
        renderStrategy: Canvas.Cooperative
        antialiasing: true
        smooth: true

        onPaint: {
            const ctx = getContext("2d")
            ctx.reset()
            ctx.clearRect(0, 0, width, height)
            const cx = width / 2
            const cy = height / 2
            const baseR = root.radius
            ctx.lineWidth = root.strokeWidth
            ctx.lineCap = "round"
            ctx.lineJoin = "round"

            function strokeArc(start, sweepAngle, color, wavy) {
                if (Math.abs(sweepAngle) < 0.001)
                    return
                ctx.beginPath()
                ctx.strokeStyle = color
                const steps = Math.max(24, Math.ceil(Math.abs(sweepAngle) * 28))
                for (let i = 0; i <= steps; ++i) {
                    const t = i / steps
                    const a = start + sweepAngle * t
                    let r = baseR
                    if (wavy && root.amplitude > 0)
                        r = baseR + Math.sin(a * root.waveCount + root.wavePhase) * root.amplitude
                    const x = cx + Math.cos(a) * r
                    const y = cy + Math.sin(a) * r
                    if (i === 0)
                        ctx.moveTo(x, y)
                    else
                        ctx.lineTo(x, y)
                }
                ctx.stroke()
            }

            const wavy = root.isWavy
            strokeArc(-Math.PI / 2, Math.PI * 2, Md3Theme.colorScheme.surfaceContainerHighest, wavy)
            if (root.indeterminate)
                strokeArc(root.rotation, root.sweep, Md3Theme.colorScheme.primary, wavy)
            else
                strokeArc(-Math.PI / 2, Math.PI * 2 * Math.max(0, Math.min(1, root.value)),
                          Md3Theme.colorScheme.primary, wavy)
        }
    }

    FrameAnimation {
        running: root.sceneActive && (root.indeterminate || root.isWavy)
        onTriggered: {
            if (root.isWavy)
                root.wavePhase = (root.wavePhase + root.waveSpeed * frameTime) % (Math.PI * 2)
            if (root.indeterminate) {
                root.rotation = (root.rotation + root.spinSpeed * frameTime) % (Math.PI * 2)
                root.sweep += root.sweepDir * (root.sweepMax - root.sweepMin)
                             * frameTime / (Md3Motion.progressSweep / 1000)
                if (root.sweep >= root.sweepMax) {
                    root.sweep = root.sweepMax
                    root.sweepDir = -1
                } else if (root.sweep <= root.sweepMin) {
                    root.sweep = root.sweepMin
                    root.sweepDir = 1
                }
            }
            canvas.requestPaint()
        }
    }

    onValueChanged: if (!indeterminate) canvas.requestPaint()
    onStyleChanged: Qt.callLater(function () { canvas.requestPaint() })
    Component.onCompleted: Qt.callLater(function () { canvas.requestPaint() })
}
