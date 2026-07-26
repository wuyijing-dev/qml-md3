import QtQuick
import QtQuick.Window
import QtQuick.Shapes

/// Circular progress — Standard: PathAngleArc; wavy: PathPolyline + RoundJoin (GPU, no seams).
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

    function radToDeg(r) { return r * 180 / Math.PI }

    function _arcPoints(startRad, sweepRad) {
        if (Math.abs(sweepRad) < 0.001)
            return []
        const cx = width / 2
        const cy = height / 2
        const baseR = radius
        const steps = Math.max(24, Math.ceil(Math.abs(sweepRad) * 28))
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

    function rebuild() {
        if (width < 2 || height < 2)
            return
        if (isWavy) {
            trackPoly.path = _arcPoints(-Math.PI / 2, Math.PI * 2)
            if (indeterminate)
                indPoly.path = _arcPoints(rotation, sweep)
            else
                indPoly.path = _arcPoints(-Math.PI / 2, Math.PI * 2 * Math.max(0, Math.min(1, value)))
        } else {
            if (indeterminate) {
                indArc.startAngle = radToDeg(rotation)
                indArc.sweepAngle = -radToDeg(sweep)
            } else {
                indArc.startAngle = -90
                indArc.sweepAngle = -360 * Math.max(0, Math.min(1, value))
            }
        }
    }

    Timer {
        interval: 200
        running: root.enabled && (root.indeterminate || root.isWavy)
        repeat: true
        onTriggered: root._refreshTreeShown()
    }
    Component.onCompleted: {
        _refreshTreeShown()
        Qt.callLater(rebuild)
    }
    onVisibleChanged: _refreshTreeShown()
    onOpacityChanged: _refreshTreeShown()

    width: size
    height: size

    Shape {
        anchors.fill: parent
        visible: !root.isWavy
        preferredRendererType: Shape.CurveRenderer
        asynchronous: false

        ShapePath {
            strokeWidth: root.strokeWidth
            strokeColor: Md3Theme.colorScheme.surfaceContainerHighest
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
        ShapePath {
            strokeWidth: root.strokeWidth
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
                sweepAngle: 0
            }
        }
    }

    Shape {
        anchors.fill: parent
        visible: root.isWavy
        preferredRendererType: Shape.CurveRenderer
        asynchronous: false

        ShapePath {
            strokeWidth: root.strokeWidth
            strokeColor: Md3Theme.colorScheme.surfaceContainerHighest
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            PathPolyline { id: trackPoly }
        }
        ShapePath {
            strokeWidth: root.strokeWidth
            strokeColor: Md3Theme.colorScheme.primary
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            PathPolyline { id: indPoly }
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
            root.rebuild()
        }
    }

    onValueChanged: if (!indeterminate) rebuild()
    onStyleChanged: Qt.callLater(rebuild)
    onWidthChanged: rebuild()
    onHeightChanged: rebuild()
}
