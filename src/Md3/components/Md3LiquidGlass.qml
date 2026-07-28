import QtQuick
import QtQuick.Effects

/// Draggable Liquid Glass — regional MultiEffect blur (cheap).
/// Heavy refraction shader only when quality >= 2.
Item {
    id: root

    property Item sourceItem: null
    property real radius: 28
    property real elevation: 1.5
    property bool draggable: true
    property bool boundToParent: true
    property real squircleN: 5.0
    property real adaptiveTint: 0.6
    property real liquidDeform: 1.0
    /// 0/1: MultiEffect blur only. 2: + edge refraction shader.
    property int quality: 0
    /// true = resample every frame (video). false = update on move end.
    property bool liveSampling: false

    property real blurAmount: 0.45
    property real blurMax: 48
    property real tintOpacity: 0.08
    property color tintColor: "#FFFFFF"
    property real edgeStrength: 0.85
    property real refraction: 1.0
    property real chromaticAberration: 0.35
    property real samplePadding: 16

    default property alias contentData: contentHost.data

    readonly property bool dragging: dragArea.pressed
    readonly property bool _blurReady: sourceItem !== null
                                       && sourceItem.width > 1 && sourceItem.height > 1
                                       && width > 1 && height > 1
    readonly property real _minSide: Math.min(width, height)
    readonly property real _radiusNorm: Math.max(0.02, Math.min(0.49, radius / Math.max(1, _minSide)))
    readonly property real _aspect: width / Math.max(1, height)
    readonly property real _thickness: Math.min(1.35, Math.max(0.55, _minSide / 150))
    readonly property real _effBlur: blurAmount * (0.7 + 0.35 * _thickness)
    readonly property real _effRefraction: refraction * (0.75 + 0.3 * _thickness)
    readonly property real _effElevation: elevation * (0.7 + 0.35 * _thickness)
    readonly property real _effEdge: edgeStrength * (0.8 + 0.25 * _thickness)
    readonly property bool _softMotion: !Md3Theme.reduceMotion && liquidDeform > 0.01
    readonly property bool _useLens: _blurReady && quality >= 2 && _effRefraction > 0.05
    readonly property bool _useSquircleShader: quality >= 2
    readonly property real _pad: _useLens ? samplePadding : 0
    readonly property bool _sampleLive: liveSampling || dragging

    property real _grabOffX: 0
    property real _grabOffY: 0
    property real _squashX: 1
    property real _squashY: 1

    implicitWidth: 280
    implicitHeight: 168
    z: dragging ? 20 : 1
    clip: false

    transform: Scale {
        origin.x: root.width * 0.5
        origin.y: root.height * 0.5
        xScale: root._squashX
        yScale: root._squashY
    }

    Behavior on _squashX {
        enabled: root._softMotion
        SpringAnimation { spring: 2.8; damping: 0.28; mass: 0.85 }
    }
    Behavior on _squashY {
        enabled: root._softMotion
        SpringAnimation { spring: 2.8; damping: 0.28; mass: 0.85 }
    }

    function _clampPos(nx, ny) {
        if (!boundToParent || !parent)
            return Qt.point(nx, ny)
        const maxX = Math.max(0, parent.width - width)
        const maxY = Math.max(0, parent.height - height)
        return Qt.point(Math.max(0, Math.min(maxX, nx)),
                        Math.max(0, Math.min(maxY, ny)))
    }

    function _setDeform(dx, dy) {
        if (!root._softMotion) {
            _squashX = 1
            _squashY = 1
            return
        }
        const k = 0.012 * root.liquidDeform
        const sx = 1 + Math.max(-0.07, Math.min(0.07, dx * k))
        const sy = 1 + Math.max(-0.07, Math.min(0.07, dy * k))
        _squashX = Math.max(0.92, Math.min(1.08, sx * (2.0 - sy) / (1.0 + Math.abs(sy - 1.0) * 0.35)))
        _squashY = Math.max(0.92, Math.min(1.08, sy * (2.0 - sx) / (1.0 + Math.abs(sx - 1.0) * 0.35)))
    }

    function _refreshSample() {
        if (root._blurReady && !root._sampleLive) {
            cardSample.scheduleUpdate()
            if (root._useLens)
                lensSample.scheduleUpdate()
        }
    }

    Md3Shadow {
        anchors.fill: parent
        elevation: root._effElevation
        cornerRadius: root.radius
        visible: root._effElevation > 0.05
    }

    Item {
        id: glassBody
        anchors.fill: parent
        layer.enabled: true
        layer.smooth: false
        layer.samples: 0
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: root._useSquircleShader ? squircleMask : roundMask
            autoPaddingEnabled: false
        }

        // Card-sized capture → Qt MultiEffect blur (much cheaper than custom frost taps).
        ShaderEffectSource {
            id: cardSample
            anchors.fill: parent
            visible: false
            live: root._sampleLive
            hideSource: false
            smooth: false
            sourceItem: root.sourceItem
            sourceRect: {
                if (!root.sourceItem)
                    return Qt.rect(0, 0, root.width, root.height)
                void root.x
                void root.y
                void root.width
                void root.height
                const p = root.mapToItem(root.sourceItem, 0, 0)
                return Qt.rect(p.x, p.y, root.width, root.height)
            }
        }

        MultiEffect {
            id: frostPlate
            anchors.fill: parent
            visible: root._blurReady
            source: cardSample
            autoPaddingEnabled: false
            blurEnabled: true
            blur: Math.max(0.1, root._effBlur)
            blurMax: Math.min(48, root.blurMax)
            blurMultiplier: 1.15
            saturation: 1.15
            brightness: 0.04 * root.adaptiveTint
            contrast: 0.02
        }

        // Optional edge lens — only quality 2 (was the GPU hog when always on).
        ShaderEffectSource {
            id: lensSample
            width: root.width + root._pad * 2
            height: root.height + root._pad * 2
            x: -root._pad
            y: -root._pad
            visible: false
            live: root._sampleLive && root._useLens
            hideSource: false
            smooth: false
            sourceItem: root.sourceItem
            sourceRect: {
                if (!root.sourceItem || !root._useLens)
                    return Qt.rect(0, 0, 1, 1)
                void root.x
                void root.y
                void root.width
                void root.height
                const pad = root._pad
                const p = root.mapToItem(root.sourceItem, -pad, -pad)
                return Qt.rect(p.x, p.y, root.width + pad * 2, root.height + pad * 2)
            }
        }

        ShaderEffect {
            id: lens
            anchors.fill: parent
            visible: root._useLens
            property variant source: lensSample
            property real bend: root._effRefraction
            property real frost: 0 // blur already done by MultiEffect
            property real chroma: root.chromaticAberration * 0.5
            property real radiusNorm: root._radiusNorm
            property real aspect: root._aspect
            property real padU: root._pad / Math.max(1, root.width + root._pad * 2)
            property real padV: root._pad / Math.max(1, root.height + root._pad * 2)
            property real squircleN: root.squircleN
            property real thickness: root._thickness
            property real adaptive: root.adaptiveTint
            property real baseTint: root.tintOpacity
            property real quality: 0 // force 1-sample path in shader
            vertexShader: "qrc:/qt/qml/Md3/shaders/md3liquidglass.vert.qsb"
            fragmentShader: "qrc:/qt/qml/Md3/shaders/md3liquidglass.frag.qsb"
        }

        Rectangle {
            anchors.fill: parent
            visible: !root._blurReady
            color: root.tintColor
            opacity: Math.max(0.25, root.tintOpacity)
        }

        Rectangle {
            anchors.fill: parent
            visible: root._blurReady
            color: root.tintColor
            opacity: root.tintOpacity * (0.4 + 0.15 * root._thickness)
        }

        Rectangle {
            anchors.fill: parent
            opacity: root._effEdge * 0.28
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(0.75, 0.9, 1.0, 0.14) }
                GradientStop { position: 0.5; color: "transparent" }
                GradientStop { position: 1.0; color: Qt.rgba(1.0, 0.85, 0.7, 0.08) }
            }
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 1
            height: Math.max(2, root.height * 0.03)
            opacity: root._effEdge * 0.75
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.2; color: Qt.rgba(1, 1, 1, 0.45) }
                GradientStop { position: 0.8; color: Qt.rgba(1, 1, 1, 0.2) }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        Item {
            id: contentHost
            anchors.fill: parent
            anchors.margins: 16 + 3 * root._thickness
            z: 2
        }
    }

    // Cheap mask (same pattern as Md3Button).
    Item {
        id: roundMask
        width: root.width
        height: root.height
        visible: false
        layer.enabled: true
        Rectangle {
            anchors.fill: parent
            radius: root.radius
            color: "#ffffff"
        }
    }

    Item {
        id: squircleMask
        width: root.width
        height: root.height
        visible: false
        layer.enabled: root._useSquircleShader
        layer.smooth: false
        ShaderEffect {
            anchors.fill: parent
            visible: root._useSquircleShader
            property real aspect: root._aspect
            property real squircleN: root.squircleN
            property real soft: 0.02
            vertexShader: "qrc:/qt/qml/Md3/shaders/md3squircle_mask.vert.qsb"
            fragmentShader: "qrc:/qt/qml/Md3/shaders/md3squircle_mask.frag.qsb"
        }
    }

    MouseArea {
        id: dragArea
        anchors.fill: parent
        z: 100
        enabled: root.draggable
        hoverEnabled: false
        cursorShape: pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor
        preventStealing: true
        propagateComposedEvents: false

        onPressed: function(mouse) {
            const p = mapToItem(root.parent, mouse.x, mouse.y)
            root._grabOffX = p.x - root.x
            root._grabOffY = p.y - root.y
        }
        onPositionChanged: function(mouse) {
            if (!pressed)
                return
            const p = mapToItem(root.parent, mouse.x, mouse.y)
            const next = root._clampPos(p.x - root._grabOffX, p.y - root._grabOffY)
            root._setDeform(next.x - root.x, next.y - root.y)
            root.x = next.x
            root.y = next.y
        }
        onReleased: {
            root._squashX = 1
            root._squashY = 1
            root._refreshSample()
        }
        onCanceled: {
            root._squashX = 1
            root._squashY = 1
            root._refreshSample()
        }
    }
}
