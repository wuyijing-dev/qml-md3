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
    /// Drop Shape / animated chrome while page is off-display.
    property bool unloadWhenPageInactive: true
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
    readonly property real _travelMs: Md3Motion.progressTravel
    readonly property real _liveFrameSec: {
        const fps = Md3Theme.effectsLiveFps
        return (!Md3Theme.reduceMotion && fps > 0) ? (1 / fps) : (1 / 30)
    }

    Md3PageActivityGate {
        id: pageGate
        watchItem: root
        unloadWhenPageInactive: root.unloadWhenPageInactive
    }

    function _refreshTreeShown() {
        const ok = pageGate.contentActive
                && Md3TreeVisibility.isLiveMotionScene(root, root.hostWindow)
        if (_treeShown !== ok)
            _treeShown = ok
    }

    Connections {
        target: pageGate
        function onContentActiveChanged() { root._refreshTreeShown() }
    }
    Connections {
        target: Qt.application
        function onStateChanged() { root._refreshTreeShown() }
    }
    onVisibleChanged: _refreshTreeShown()
    Component.onCompleted: _refreshTreeShown()

    Loader {
        anchors.fill: parent
        active: pageGate.contentActive
        sourceComponent: barComp
    }

    Component {
        id: barComp
        Item {
            id: bar
            anchors.fill: parent

            property real wavePhase: root.wavePhase
            property real travelX: root.travelX
            property real _waveAccum: 0

            function _wavePoints(fromX, toX) {
                if (toX <= fromX + 0.5)
                    return []
                const mid = height / 2
                const amp = root.amplitude
                const wl = Math.max(8, root.wavelength)
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
                if (!root.isWavy || width < 2)
                    return
                const thick = root.indicatorThickness
                trackPoly.path = _wavePoints(thick / 2, width - thick / 2)
                if (root.indeterminate)
                    indPoly.path = _wavePoints(travelX, travelX + root.barWidth)
                else {
                    const end = Math.max(thick / 2, (width - thick) * root.progress + thick / 2)
                    indPoly.path = _wavePoints(thick / 2, end)
                }
            }

            Timer {
                id: deferredWaveTimer
                interval: 0
                repeat: false
                onTriggered: bar.rebuildWave()
            }
            Component.onCompleted: {
                if (root.isWavy)
                    deferredWaveTimer.restart()
            }

            Connections {
                target: root
                function onWidthChanged() {
                    travelAnim.from = -root.barWidth
                    travelAnim.to = root.width
                    if (root.isWavy)
                        bar.rebuildWave()
                }
                function onValueChanged() {
                    if (root.isWavy)
                        bar.rebuildWave()
                }
                function onStyleChanged() {
                    if (root.isWavy)
                        deferredWaveTimer.restart()
                }
                function onIndeterminateChanged() {
                    if (!root.indeterminate)
                        bar.travelX = 0
                    else
                        bar.travelX = -root.barWidth
                    root.travelX = bar.travelX
                }
            }

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
                    x: root.indeterminate ? bar.travelX : 0
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
                target: bar
                property: "travelX"
                from: -root.barWidth
                to: root.width
                duration: root._travelMs
                loops: Animation.Infinite
                running: !root.isWavy && root.indeterminate && root.sceneActive
                easing.type: Easing.Linear
                onRunningChanged: if (running) bar.travelX = -root.barWidth
            }

            onTravelXChanged: root.travelX = travelX

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
                running: root.isWavy && root.sceneActive
                onTriggered: {
                    const ft = Math.min(frameTime, 0.05)
                    bar.wavePhase = (bar.wavePhase + root.waveSpeed * ft) % (Math.PI * 2)
                    root.wavePhase = bar.wavePhase
                    if (root.indeterminate) {
                        const span = root.width + root.barWidth
                        bar.travelX += span * ft / (root._travelMs / 1000)
                        if (bar.travelX > root.width)
                            bar.travelX = -root.barWidth
                        root.travelX = bar.travelX
                    }
                    bar._waveAccum += ft
                    if (bar._waveAccum >= root._liveFrameSec) {
                        bar._waveAccum = 0
                        bar.rebuildWave()
                    }
                }
            }
        }
    }
}
