import QtQuick
import QtQuick.Shapes
import Md3

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
    /// Optional Window for scene-active checks (else OverlayHost).
    property var hostWindow: null
    /// Drop Shape geometry while page is off-display.
    property bool unloadWhenPageInactive: true

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
    onOpacityChanged: _refreshTreeShown()
    Component.onCompleted: _refreshTreeShown()

    Rectangle {
        anchors.centerIn: parent
        width: root.box * 0.92
        height: width
        radius: width / 2
        visible: root.variant === Md3MorphLoadingIndicator.Contained && pageGate.contentActive
        color: root.containerColor
    }

    Loader {
        anchors.fill: parent
        active: pageGate.contentActive
        sourceComponent: morphComp
    }

    Component {
        id: morphComp
        Item {
            id: morph
            anchors.fill: parent

            property real morphPhase: root.morphPhase
            property real spin: root.spin
            property int _morphBucket: -1

            function rebuildPath() {
                const cx = width / 2
                const cy = height / 2
                const R = Math.min(width, height) * 0.42
                const t = morphPhase
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

            Component.onCompleted: rebuildPath()
            onWidthChanged: rebuildPath()
            onHeightChanged: rebuildPath()

            Shape {
                id: morphShape
                anchors.fill: parent
                preferredRendererType: Shape.GeometryRenderer
                asynchronous: false
                rotation: morph.spin * 180 / Math.PI
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
                    const ft = Math.min(frameTime, 0.05)
                    morph.spin = (morph.spin + ft * 1.2) % (Math.PI * 2)
                    morph.morphPhase = (morph.morphPhase + ft * 2.4) % (Math.PI * 2)
                    root.spin = morph.spin
                    root.morphPhase = morph.morphPhase
                    const bucket = Math.floor(morph.morphPhase * 20 / (Math.PI * 2))
                    if (bucket !== morph._morphBucket && !rebuildThrottle.running) {
                        morph._morphBucket = bucket
                        rebuildThrottle.start()
                    }
                }
            }

            Timer {
                id: rebuildThrottle
                interval: 50
                repeat: false
                onTriggered: morph.rebuildPath()
            }
        }
    }
}
