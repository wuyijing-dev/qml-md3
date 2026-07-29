import QtQuick
import QtQuick.Effects

/// Draggable Liquid Glass — regional backdrop sample (not full-scene blur).
Item {
    id: root

    property Item sourceItem: null
    property real radius: 28
    property real elevation: 2
    property bool draggable: true
    property bool boundToParent: true
    property real squircleN: 5.0
    property real adaptiveTint: 1.0
    property real liquidDeform: 1.0
    /// 0=Low, 1=Medium, 2=High — scales sample res, frost taps, chroma.
    property int quality: 1
    /// Keep sampling every frame (video). For static images set false — updates on move.
    property bool liveSampling: true

    property real blurAmount: 0.45
    property real blurMax: 64
    property real tintOpacity: 0.08
    property color tintColor: "#FFFFFF"
    property real edgeStrength: 0.9
    property real refraction: 1.2
    property real chromaticAberration: 0.5
    /// 0..1 SDF blend between base glass body and droplets.
    property real fusionAmount: 0.0
    /// Optional droplets in UV space: Qt.vector4d(x, y, radius, enabled)
    property vector4d dropletA: Qt.vector4d(0.5, 0.5, 0.0, 0.0)
    property vector4d dropletB: Qt.vector4d(0.5, 0.5, 0.0, 0.0)
    property vector4d dropletC: Qt.vector4d(0.5, 0.5, 0.0, 0.0)
    /// Scene-light color from refracted edge highlights.
    property real edgeSpectralStrength: 0.75
    /// Background dynamic color pickup.
    property real sceneColorStrength: 0.55
    property real samplePadding: 24
    property int layoutMode: Md3ContainerBody.Fit

    default property alias contentData: contentHost.content

    readonly property bool dragging: dragArea.pressed
    readonly property bool _blurReady: sourceItem !== null
                                       && sourceItem.width > 1 && sourceItem.height > 1
                                       && width > 1 && height > 1
    readonly property real _minSide: Math.min(width, height)
    readonly property real _radiusNorm: Math.max(0.02, Math.min(0.49, radius / Math.max(1, _minSide)))
    readonly property real _aspect: width / Math.max(1, height)
    readonly property real _thickness: Math.min(1.45, Math.max(0.55, _minSide / 150))
    readonly property real _effBlur: blurAmount * (0.65 + 0.45 * _thickness)
    readonly property real _effRefraction: refraction * (0.7 + 0.4 * _thickness)
    readonly property real _effElevation: elevation * (0.65 + 0.5 * _thickness)
    readonly property real _effEdge: edgeStrength * (0.75 + 0.3 * _thickness)
    readonly property bool _softMotion: !Md3Theme.reduceMotion && liquidDeform > 0.01
    readonly property real _pad: {
        if (quality <= 0)
            return Math.min(samplePadding, 12)
        if (quality === 1)
            return Math.min(samplePadding, 20)
        return samplePadding
    }
    /// Downscale capture texture on lower quality.
    readonly property real _texScale: quality >= 2 ? 1.0 : (quality === 1 ? 0.55 : 0.35)
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
        _squashX = sx * (2.0 - sy) / (1.0 + Math.abs(sy - 1.0) * 0.35)
        _squashY = sy * (2.0 - sx) / (1.0 + Math.abs(sx - 1.0) * 0.35)
        _squashX = Math.max(0.9, Math.min(1.1, _squashX))
        _squashY = Math.max(0.9, Math.min(1.1, _squashY))
    }

    function _refreshSample() {
        if (root._blurReady && !root._sampleLive)
            regionSample.scheduleUpdate()
    }

    onXChanged: _refreshSample()
    onYChanged: _refreshSample()
    onWidthChanged: _refreshSample()
    onHeightChanged: _refreshSample()

    Md3Shadow {
        anchors.fill: parent
        elevation: root._effElevation
        cornerRadius: root.radius
        // Skip expensive shadow blur layers when flat.
        visible: root._effElevation > 0.05
    }

    Item {
        id: glassBody
        anchors.fill: parent
        layer.enabled: true
        layer.smooth: root.quality >= 1
        layer.samples: root.quality >= 2 ? 2 : 0
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: squircleMask
            autoPaddingEnabled: false
        }

        // Only the card neighbourhood — not the full backdrop.
        ShaderEffectSource {
            id: regionSample
            width: Math.max(2, Math.round((root.width + root._pad * 2) * root._texScale))
            height: Math.max(2, Math.round((root.height + root._pad * 2) * root._texScale))
            x: -root._pad
            y: -root._pad
            visible: false
            live: root._sampleLive
            hideSource: false
            smooth: root.quality >= 1
            sourceItem: root.sourceItem
            sourceRect: {
                if (!root.sourceItem)
                    return Qt.rect(0, 0, width, height)
                void root.x
                void root.y
                void root.width
                void root.height
                void root._pad
                const pad = root._pad
                const p = root.mapToItem(root.sourceItem, -pad, -pad)
                return Qt.rect(p.x, p.y, root.width + pad * 2, root.height + pad * 2)
            }
        }

        ShaderEffect {
            id: lens
            anchors.fill: parent
            visible: root._blurReady
            property variant source: regionSample
            property real bend: root._effRefraction
            property real frost: root._effBlur * (root.quality >= 2 ? 0.012 : 0.008)
            property real chroma: root.quality >= 1 ? root.chromaticAberration : 0
            property real radiusNorm: root._radiusNorm
            property real aspect: root._aspect
            property real padU: root._pad / Math.max(1, root.width + root._pad * 2)
            property real padV: root._pad / Math.max(1, root.height + root._pad * 2)
            property real squircleN: root.squircleN
            property real thickness: root._thickness
            property real adaptive: root.adaptiveTint
            property real baseTint: root.tintOpacity
            property real quality: root.quality
            property real fusion: Math.max(0.0, Math.min(1.0, root.fusionAmount))
            property vector4d dropA: root.dropletA
            property vector4d dropB: root.dropletB
            property vector4d dropC: root.dropletC
            property real edgeSpectral: root.edgeSpectralStrength
            property real sceneColor: root.sceneColorStrength
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
            opacity: root.tintOpacity * (0.35 + 0.2 * root._thickness) * (1.0 - root.adaptiveTint * 0.55)
        }

        Rectangle {
            anchors.fill: parent
            opacity: root._effEdge * 0.32
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(0.75, 0.9, 1.0, 0.16) }
                GradientStop { position: 0.45; color: "transparent" }
                GradientStop { position: 1.0; color: Qt.rgba(1.0, 0.85, 0.7, 0.09) }
            }
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 1
            height: Math.max(2, root.height * (0.028 + 0.012 * root._thickness))
            opacity: root._effEdge * 0.8
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.2; color: Qt.rgba(1, 1, 1, 0.5) }
                GradientStop { position: 0.8; color: Qt.rgba(1, 1, 1, 0.22) }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        Md3ContainerBody {
            id: contentHost
            anchors.fill: parent
            anchors.margins: 16 + 4 * root._thickness
            z: 2
            layoutMode: root.layoutMode
            clipContent: false
        }
    }

    Item {
        id: squircleMask
        width: root.width
        height: root.height
        visible: false
        layer.enabled: true
        layer.smooth: root.quality >= 1
        ShaderEffect {
            anchors.fill: parent
            property real aspect: root._aspect
            property real squircleN: root.squircleN
            property real soft: root.quality >= 2 ? 0.014 : 0.022
            vertexShader: "qrc:/qt/qml/Md3/shaders/md3squircle_mask.vert.qsb"
            fragmentShader: "qrc:/qt/qml/Md3/shaders/md3squircle_mask.frag.qsb"
        }
    }

    MouseArea {
        id: dragArea
        anchors.fill: parent
        z: 100
        enabled: root.draggable
        hoverEnabled: true
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
