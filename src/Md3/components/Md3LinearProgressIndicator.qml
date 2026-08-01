import QtQuick
import QtQuick.Shapes
import Md3

/// Linear progress — Standard uses Rectangles + NumberAnimation;
/// wavy styles rebuild polylines on a capped cadence (not every vsync).
Item {
    id: root

    enum Style { Standard, Wavy, Lively, Soft }

    property real value: 0
    property bool indeterminate: false
    property int style: Md3LinearProgressIndicator.Standard
    /// Optional Window for scene-active checks (else OverlayHost).
    property var hostWindow: null
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
    /// Expressive look: thin track + thicker active segment (matches M3 specs).
    property bool contained: true
    readonly property real trackLineThickness: contained
            ? Math.max(2, trackThickness * 0.38)
            : trackThickness
    readonly property real indicatorThickness: trackThickness
    property real wavePhase: 0
    property bool showStopIndicator: true
    property real waveSpeed: Math.PI * 2 / 1.8

    implicitWidth: 200
    implicitHeight: Math.max(indicatorThickness, amplitude * 2 + indicatorThickness)
    height: implicitHeight
    width: implicitWidth
    clip: true

    readonly property bool isWavy: style !== Md3LinearProgressIndicator.Standard
    readonly property real progress: Math.max(0, Math.min(1, value))
    readonly property real barWidth: indeterminate ? Math.max(48, width * 0.35) : width * progress
    property bool _treeShown: true
    readonly property bool sceneActive: enabled && _treeShown
    property real travelX: -barWidth
    property real _waveAccum: 0
    readonly property real _travelMs: Md3Motion.progressTravel
    readonly property real _liveFrameSec: {
        const fps = Md3Theme.effectsLiveFps
        return (!Md3Theme.reduceMotion && fps > 0) ? (1 / fps) : (1 / 30)
    }

    function _refreshTreeShown() {
        const ok = Md3TreeVisibility.isLiveMotionScene(root, root.hostWindow)
        if (_treeShown !== ok)
            _treeShown = ok
    }

    function _wavePoints(fromX, toX) {
        if (toX <= fromX + 0.5)
            return []
        const mid = height / 2
        const amp = amplitude
        const wl = Math.max(8, wavelength)
        const phase = wavePhase
        const stepPx = 6
        const steps = Math.max(2, Math.ceil((toX - fromX) / stepPx))
        const pts = []
        for (let i = 0; i <= steps; ++i) {
            const t = i / steps
            const x = fromX + (toX - fromX) * t
            const y = mid + Math.sin((x / wl) * Math.PI * 2 + phase) * amp
            pts.push(Qt.point(x, y))
        }
        return pts
    }

    function rebuildWave() {
        if (!isWavy || width < 2)
            return
        const thick = indicatorThickness
        trackPoly.path = _wavePoints(thick / 2, width - thick / 2)
        if (indeterminate)
            indPoly.path = _wavePoints(travelX, travelX + barWidth)
        else {
            const end = Math.max(thick / 2, (width - thick) * progress + thick / 2)
            indPoly.path = _wavePoints(thick / 2, end)
        }
    }

    Timer {
        interval: 2000
        running: root.enabled && (root.isWavy || root.indeterminate)
        repeat: true
        onTriggered: root._refreshTreeShown()
    }
    Connections {
        target: Qt.application
        function onStateChanged() { root._refreshTreeShown() }
    }
    Timer {
        id: deferredWaveTimer
        interval: 0
        repeat: false
        onTriggered: root.rebuildWave()
    }
    Component.onCompleted: {
        _refreshTreeShown()
        if (isWavy)
            deferredWaveTimer.restart()
    }
    onVisibleChanged: _refreshTreeShown()

    Rectangle {
        id: standardTrack
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        height: root.contained ? root.trackLineThickness : root.trackThickness
        radius: height / 2
        color: Md3Theme.colorScheme.gaugeTrack
        visible: !root.isWavy

        Rectangle {
            id: standardBar
            anchors.verticalCenter: parent.verticalCenter
            height: root.contained ? root.indicatorThickness : parent.height
            radius: height / 2
            color: Md3Theme.colorScheme.primary
            width: root.indeterminate ? root.barWidth : Math.min(root.barWidth, root.width)
            x: root.indeterminate ? root.travelX : 0
            opacity: 1
        }

        Rectangle {
            visible: !root.indeterminate && root.showStopIndicator && root.progress < 0.999
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            width: root.contained ? root.indicatorThickness : parent.height
            height: width
            radius: width / 2
            color: Md3Theme.colorScheme.primary
        }
    }

    NumberAnimation {
        id: travelAnim
        target: root
        property: "travelX"
        from: -root.barWidth
        to: root.width
        duration: root._travelMs
        loops: Animation.Infinite
        running: !root.isWavy && root.indeterminate && root.sceneActive
        easing.type: Easing.Linear
        onRunningChanged: if (running) root.travelX = -root.barWidth
    }

    Shape {
        id: waveShape
        anchors.fill: parent
        visible: root.isWavy
        preferredRendererType: Shape.GeometryRenderer
        asynchronous: false

        ShapePath {
            strokeWidth: root.trackLineThickness
            strokeColor: Md3Theme.colorScheme.gaugeTrack
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            PathPolyline { id: trackPoly }
        }
        ShapePath {
            strokeWidth: root.indicatorThickness
            strokeColor: Md3Theme.colorScheme.primary
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            PathPolyline { id: indPoly }
        }
    }

    Rectangle {
        visible: root.isWavy && !root.indeterminate && root.showStopIndicator && root.progress < 0.999
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        width: root.indicatorThickness
        height: root.indicatorThickness
        radius: width / 2
        color: Md3Theme.colorScheme.primary
    }

    FrameAnimation {
        id: waveFrames
        running: root.isWavy && root.sceneActive
        onTriggered: {
            const ft = Math.min(frameTime, 0.05)
            root.wavePhase = (root.wavePhase + root.waveSpeed * ft) % (Math.PI * 2)
            if (root.indeterminate) {
                const span = root.width + root.barWidth
                root.travelX += span * ft / (root._travelMs / 1000)
                if (root.travelX > root.width)
                    root.travelX = -root.barWidth
            }
            root._waveAccum += ft
            if (root._waveAccum >= root._liveFrameSec) {
                root._waveAccum = 0
                root.rebuildWave()
            }
        }
    }

    onWidthChanged: {
        travelAnim.from = -barWidth
        travelAnim.to = width
        if (isWavy)
            rebuildWave()
    }
    onValueChanged: if (isWavy) rebuildWave()
    onStyleChanged: if (isWavy) deferredWaveTimer.restart()
    onIndeterminateChanged: {
        if (!indeterminate)
            travelX = 0
        else
            travelX = -barWidth
    }
}
