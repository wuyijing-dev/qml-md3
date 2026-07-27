import QtQuick
import QtQuick.Window
import QtQuick.Shapes

/// Material 3 Expressive morph loading indicator — rounded 8-lobe clover / asterisk.
Item {
    id: root

    enum Variant { Bare, Contained }
    enum Size { Small, Medium, Large }

    property int variant: Md3MorphLoadingIndicator.Bare
    property int sizePreset: Md3MorphLoadingIndicator.Medium
    property bool indeterminate: true
    property color indicatorColor: Md3Theme.colorScheme.primary
    property color containerColor: Md3Theme.colorScheme.primaryContainer
    property real morphPhase: 0
    property real spin: 0

    readonly property real box: {
        switch (sizePreset) {
        case Md3MorphLoadingIndicator.Small: return 28
        case Md3MorphLoadingIndicator.Large: return 56
        default: return 40
        }
    }

    property bool _treeShown: true
    readonly property bool sceneActive: enabled && _treeShown && indeterminate

    width: box
    height: box

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

    /// Flower / clover path: r(θ) = R*(a + b*cos(8θ)) with morphing a/b.
    function rebuildPath() {
        const cx = width / 2
        const cy = height / 2
        const R = Math.min(width, height) * 0.42
        const t = morphPhase
        // Morph between tight asterisk and softer clover
        const a = 0.55 + 0.12 * Math.sin(t)
        const b = 0.45 + 0.10 * Math.cos(t * 1.3)
        const steps = 64
        const pts = []
        for (let i = 0; i <= steps; ++i) {
            const th = (i / steps) * Math.PI * 2
            const r = R * (a + b * Math.cos(8 * th))
            pts.push(Qt.point(cx + Math.cos(th) * r, cy + Math.sin(th) * r))
        }
        morphPoly.path = pts
    }

    Timer {
        interval: 400
        running: root.enabled && root.indeterminate
        repeat: true
        onTriggered: root._refreshTreeShown()
    }
    Component.onCompleted: {
        _refreshTreeShown()
        rebuildPath()
    }
    onVisibleChanged: _refreshTreeShown()
    onOpacityChanged: _refreshTreeShown()
    onWidthChanged: rebuildPath()
    onHeightChanged: rebuildPath()

    Rectangle {
        anchors.centerIn: parent
        width: root.box * 0.92
        height: width
        radius: width / 2
        visible: root.variant === Md3MorphLoadingIndicator.Contained
        color: root.containerColor
    }

    Shape {
        id: morphShape
        anchors.fill: parent
        preferredRendererType: Shape.GeometryRenderer
        asynchronous: false
        rotation: root.spin * 180 / Math.PI
        transformOrigin: Item.Center

        ShapePath {
            fillColor: root.indicatorColor
            strokeWidth: 0
            PathPolyline { id: morphPoly }
        }
    }

    FrameAnimation {
        running: root.sceneActive
        onTriggered: {
            root.spin = (root.spin + frameTime * 1.2) % (Math.PI * 2)
            root.morphPhase = (root.morphPhase + frameTime * 2.4) % (Math.PI * 2)
            // Rebuild ~30fps — morph path is heavier than arc updates
            if (!rebuildThrottle.running)
                rebuildThrottle.start()
        }
    }

    Timer {
        id: rebuildThrottle
        interval: 33
        repeat: false
        onTriggered: root.rebuildPath()
    }
}
