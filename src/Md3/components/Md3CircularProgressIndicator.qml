import QtQuick
import QtQuick.Shapes
import Md3

/// Circular progress — Standard spins the Shape (no per-frame Path mutation);
/// wavy / expressive styles use a throttled polyline rebuild.
Item {
    id: root

    enum Style { Standard, Wavy, Lively, Soft }

    property real value: 0
    property bool indeterminate: true
    property int style: Md3CircularProgressIndicator.Standard
    /// Optional Window for scene-active checks (else OverlayHost).
    property var hostWindow: null
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
    /// Arc start angle in radians (wavy / determinate standard).
    property real arcRotation: -Math.PI / 2
    property real sweep: Math.PI * 0.55
    property real waveSpeed: Math.PI * 2 / 1.8
    /// Thin track + thicker active arc (M3 expressive).
    property bool contained: true
    readonly property real trackLineWidth: contained
            ? Math.max(2, strokeWidth * 0.4)
            : strokeWidth
    readonly property real indicatorLineWidth: strokeWidth

    readonly property real sweepMin: Math.PI * 0.28
    readonly property real sweepMax: Math.PI * 1.15
    readonly property bool isWavy: style !== Md3CircularProgressIndicator.Standard
    property bool _treeShown: true
    readonly property bool sceneActive: enabled && _treeShown
    readonly property real radius: Math.min(width, height) / 2 - indicatorLineWidth - (isWavy ? amplitude : 0)

    property real sweepDir: 1
    property real _waveAccum: 0
    /// Loaders ignore reduceMotion collapse (Md3Motion.essential / progress* tokens).
    readonly property real _spinMs: Math.max(800, Md3Motion.progressSpin)
    readonly property real _sweepMs: Md3Motion.progressSweep
    readonly property real _liveFrameSec: {
        const fps = Md3Theme.effectsLiveFps
        // When reduceMotion, effectsLiveFps still applies for wavy throttle; 0 → uncapped vsync.
        return (!Md3Theme.reduceMotion && fps > 0) ? (1 / fps) : (1 / 30)
    }

    function _refreshTreeShown() {
        const ok = Md3TreeVisibility.isLiveMotionScene(root, root.hostWindow)
        if (_treeShown !== ok)
            _treeShown = ok
    }

    function radToDeg(r) { return r * 180 / Math.PI }

    function _arcPoints(startRad, sweepRad) {
        if (Math.abs(sweepRad) < 0.001)
            return []
        const cx = width / 2
        const cy = height / 2
        const baseR = radius
        const steps = Math.max(14, Math.ceil(Math.abs(sweepRad) * 8))
        const pts = []
        for (let i = 0; i <= steps; ++i) {
            const t = i / steps
            const a = startRad + sweepRad * t
            let r = baseR
            if (amplitude > 0)
                r = baseR + Math.sin(a * waveCount + wavePhase) * amplitude
            pts.push(Qt.point(cx + Math.cos(a) * r, cy + Math.sin(a) * r))
        }
        return pts
    }

    function rebuildWavy() {
        if (width < 2 || height < 2 || !isWavy)
            return
        trackPoly.path = _arcPoints(-Math.PI / 2, Math.PI * 2)
        if (indeterminate)
            indPoly.path = _arcPoints(arcRotation, sweep)
        else
            indPoly.path = _arcPoints(-Math.PI / 2, Math.PI * 2 * Math.max(0, Math.min(1, value)))
    }

    function syncStandardDeterminate() {
        if (isWavy)
            return
        if (indeterminate) {
            indArc.startAngle = -90
            indArc.sweepAngle = -200
            return
        }
        indArc.startAngle = -90
        indArc.sweepAngle = -360 * Math.max(0, Math.min(1, value))
    }

    Timer {
        interval: 2000
        running: root.enabled && (root.indeterminate || root.isWavy)
        repeat: true
        onTriggered: root._refreshTreeShown()
    }
    Connections {
        target: Qt.application
        function onStateChanged() { root._refreshTreeShown() }
    }
    Timer {
        id: deferredSyncTimer
        interval: 0
        repeat: false
        onTriggered: {
            if (root.isWavy)
                root.rebuildWavy()
            else
                root.syncStandardDeterminate()
        }
    }
    Component.onCompleted: {
        _refreshTreeShown()
        deferredSyncTimer.restart()
    }
    onVisibleChanged: _refreshTreeShown()

    width: size
    height: size

    // Standard track + indicator. Indeterminate spins this item — avoids dirtying Path every frame.
    Item {
        id: standardHost
        anchors.fill: parent
        visible: !root.isWavy

        Shape {
            anchors.fill: parent
            preferredRendererType: Shape.GeometryRenderer
            asynchronous: false

            ShapePath {
                strokeWidth: root.contained ? root.trackLineWidth : root.strokeWidth
                strokeColor: Md3Theme.colorScheme.gaugeTrack
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                PathAngleArc {
                    centerX: root.width / 2
                    centerY: root.height / 2
                    radiusX: root.radius
                    radiusY: root.radius
                    startAngle: -90
                    sweepAngle: 360
                }
            }
        }

        Shape {
            id: standardIndicator
            anchors.fill: parent
            preferredRendererType: Shape.GeometryRenderer
            asynchronous: false
            // Fixed sweep for indeterminate; rotate the Shape instead of rewriting the arc.
            rotation: 0
            transformOrigin: Item.Center

            ShapePath {
                strokeWidth: root.contained ? root.indicatorLineWidth : root.strokeWidth
                strokeColor: Md3Theme.colorScheme.primary
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                PathAngleArc {
                    id: indArc
                    centerX: root.width / 2
                    centerY: root.height / 2
                    radiusX: root.radius
                    radiusY: root.radius
                    startAngle: -90
                    sweepAngle: -200
                }
            }

            RotationAnimator on rotation {
                from: 0
                to: 360
                duration: root._spinMs
                loops: Animation.Infinite
                running: root.indeterminate && root.sceneActive && !root.isWavy
            }
        }
    }

    Shape {
        anchors.fill: parent
        visible: root.isWavy
        preferredRendererType: Shape.GeometryRenderer
        asynchronous: false

        ShapePath {
            strokeWidth: root.trackLineWidth
            strokeColor: Md3Theme.colorScheme.gaugeTrack
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            PathPolyline { id: trackPoly }
        }
        ShapePath {
            strokeWidth: root.indicatorLineWidth
            strokeColor: Md3Theme.colorScheme.primary
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            PathPolyline { id: indPoly }
        }
    }

    FrameAnimation {
        running: root.sceneActive && root.isWavy
        onTriggered: {
            const ft = Math.min(frameTime, 0.05)
            root.wavePhase = (root.wavePhase + root.waveSpeed * ft) % (Math.PI * 2)
            if (root.indeterminate) {
                const spin = (Math.PI * 2) / (root._spinMs / 1000)
                root.arcRotation = (root.arcRotation + spin * ft) % (Math.PI * 2)
                root.sweep += root.sweepDir * (root.sweepMax - root.sweepMin)
                             * ft / (root._sweepMs / 1000)
                if (root.sweep >= root.sweepMax) {
                    root.sweep = root.sweepMax
                    root.sweepDir = -1
                } else if (root.sweep <= root.sweepMin) {
                    root.sweep = root.sweepMin
                    root.sweepDir = 1
                }
            }
            root._waveAccum += ft
            const minDt = root._liveFrameSec > 0 ? root._liveFrameSec : (1 / 30)
            if (root._waveAccum >= minDt) {
                root._waveAccum = 0
                root.rebuildWavy()
            }
        }
    }

    onValueChanged: {
        if (indeterminate)
            return
        if (isWavy)
            rebuildWavy()
        else
            syncStandardDeterminate()
    }
    onIndeterminateChanged: {
        standardIndicator.rotation = 0
        deferredSyncTimer.restart()
    }
    onStyleChanged: deferredSyncTimer.restart()
    onWidthChanged: deferredSyncTimer.restart()
    onHeightChanged: deferredSyncTimer.restart()
}
