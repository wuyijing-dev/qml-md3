import QtQuick

/// ARCHIVED — QML Canvas / FrameAnimation paint path (too slow for wavy + indeterminate).
/// Production: Scene Graph nodes in src/Md3/progress/. Do not re-add to qt_add_qml_module as the public type.
Item {
    id: root

    enum Style { Standard, Wavy, Lively, Soft }

    property real value: 0
    property bool indeterminate: false
    property bool enabled: true
    property int style: Md3LinearProgressIndicator.Standard
    property real wavelength: style === Md3LinearProgressIndicator.Lively ? 28
                            : (style === Md3LinearProgressIndicator.Soft ? 56 : 40)
    property real amplitude: {
        switch (style) {
        case Md3LinearProgressIndicator.Lively: return 5
        case Md3LinearProgressIndicator.Soft: return 2
        case Md3LinearProgressIndicator.Wavy: return 3
        default: return 0
        }
    }
    property real trackThickness: {
        switch (style) {
        case Md3LinearProgressIndicator.Lively: return 10
        case Md3LinearProgressIndicator.Soft: return 6
        case Md3LinearProgressIndicator.Wavy: return 8
        default: return 4
        }
    }
    property real wavePhase: 0
    property bool showStopIndicator: true
    /// Wave scroll speed (rad/s) — Flutter expressive defaults ~2π / 1.5–2.5s
    property real waveSpeed: Math.PI * 2 / 1.8

    implicitWidth: 200
    implicitHeight: Math.max(trackThickness, amplitude * 2 + trackThickness)
    height: implicitHeight
    width: implicitWidth
    clip: true

    readonly property bool isWavy: style !== Md3LinearProgressIndicator.Standard
    readonly property real progress: Math.max(0, Math.min(1, value))
    readonly property real barWidth: indeterminate ? Math.max(48, width * 0.35) : width * progress
    /// Pause when off-screen / cached (does not change on-screen quality).
    property bool _treeShown: true
    readonly property bool sceneActive: enabled && _treeShown

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
        running: root.enabled && (root.isWavy || root.indeterminate)
        repeat: true
        onTriggered: root._refreshTreeShown()
    }
    Component.onCompleted: {
        _refreshTreeShown()
        if (isWavy)
            Qt.callLater(function () { wave.requestPaint() })
    }
    onVisibleChanged: _refreshTreeShown()
    onOpacityChanged: _refreshTreeShown()

    property real travelX: -barWidth

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        height: root.trackThickness
        radius: height / 2
        color: Md3Theme.colorScheme.surfaceContainerHighest
        visible: !root.isWavy
        clip: true

        Rectangle {
            height: parent.height
            radius: parent.radius
            color: Md3Theme.colorScheme.primary
            width: root.indeterminate ? root.barWidth : Math.min(root.barWidth, parent.width)
            x: root.indeterminate ? root.travelX : 0
        }

        Rectangle {
            visible: !root.indeterminate && root.showStopIndicator && root.progress < 0.999
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            width: parent.height
            height: parent.height
            radius: width / 2
            color: Md3Theme.colorScheme.primary
        }
    }

    Canvas {
        id: wave
        anchors.fill: parent
        visible: root.isWavy
        renderStrategy: Canvas.Cooperative
        antialiasing: true
        smooth: true

        onPaint: {
            const ctx = getContext("2d")
            ctx.reset()
            ctx.clearRect(0, 0, width, height)
            const mid = height / 2
            const amp = root.amplitude
            const thick = root.trackThickness
            const wl = Math.max(8, root.wavelength)
            const phase = root.wavePhase

            function strokeWave(fromX, toX, color) {
                if (toX <= fromX + 0.5)
                    return
                ctx.beginPath()
                ctx.lineWidth = thick
                ctx.lineCap = "round"
                ctx.lineJoin = "round"
                ctx.strokeStyle = color
                // ~2px steps like Flutter CustomPainter density
                const steps = Math.max(2, Math.ceil((toX - fromX) / 2))
                for (let i = 0; i <= steps; ++i) {
                    const t = i / steps
                    const x = fromX + (toX - fromX) * t
                    const y = mid + Math.sin((x / wl) * Math.PI * 2 + phase) * amp
                    if (i === 0)
                        ctx.moveTo(x, y)
                    else
                        ctx.lineTo(x, y)
                }
                ctx.stroke()
            }

            strokeWave(thick / 2, width - thick / 2, Md3Theme.colorScheme.surfaceContainerHighest)
            if (root.indeterminate)
                strokeWave(root.travelX, root.travelX + root.barWidth, Md3Theme.colorScheme.primary)
            else {
                const end = Math.max(thick / 2, (width - thick) * root.progress + thick / 2)
                strokeWave(thick / 2, end, Md3Theme.colorScheme.primary)
                if (root.showStopIndicator && root.progress < 0.999) {
                    ctx.beginPath()
                    ctx.fillStyle = Md3Theme.colorScheme.primary
                    ctx.arc(width - thick / 2, mid, thick / 2, 0, Math.PI * 2)
                    ctx.fill()
                }
            }
        }
    }

    // Vsync-tied clock (Flutter AnimationController equivalent)
    FrameAnimation {
        id: waveFrames
        running: root.isWavy && root.sceneActive
        onTriggered: {
            root.wavePhase = (root.wavePhase + root.waveSpeed * frameTime) % (Math.PI * 2)
            if (root.indeterminate) {
                const span = root.width + root.barWidth
                root.travelX += span * frameTime / (Md3Motion.progressTravel / 1000)
                if (root.travelX > root.width)
                    root.travelX = -root.barWidth
            }
            wave.requestPaint()
        }
    }

    NumberAnimation {
        id: travelAnim
        target: root
        property: "travelX"
        from: -root.barWidth
        to: root.width
        duration: Md3Motion.progressTravel
        loops: Animation.Infinite
        // Wavy indeterminate uses FrameAnimation travel; flat bar uses this
        running: !root.isWavy && root.indeterminate && root.sceneActive
        easing.type: Easing.Linear
        onRunningChanged: if (running) root.travelX = -root.barWidth
    }

    onWidthChanged: {
        travelAnim.from = -barWidth
        travelAnim.to = width
        if (isWavy)
            wave.requestPaint()
    }
    onValueChanged: if (isWavy) wave.requestPaint()
    onStyleChanged: if (isWavy) Qt.callLater(function () { wave.requestPaint() })
}
