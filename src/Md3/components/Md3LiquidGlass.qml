import QtQuick
import QtQuick.Effects

/// Draggable Liquid Glass — squircle shape, size-scaled thickness,
/// backdrop-adaptive tint, soft elastic drag deform.
Item {
    id: root

    property Item sourceItem: null
    /// Corner softness hint (squircle uses continuous curvature; this scales the bevel).
    property real radius: 28
    property real elevation: 2
    property bool draggable: true
    property bool boundToParent: true
    /// Superellipse exponent — 2=ellipse, ~5=Apple-ish squircle, →∞ rectangle.
    property real squircleN: 5.0
    /// Backdrop-aware lift/veil for legibility (0=off, 1=full).
    property real adaptiveTint: 1.0
    /// How much the card soft-squishes while dragging.
    property real liquidDeform: 1.0

    property real blurAmount: 0.45
    property real blurMax: 64
    property real tintOpacity: 0.08
    property color tintColor: "#FFFFFF"
    property real edgeStrength: 0.9
    property real refraction: 1.2
    property real chromaticAberration: 0.5
    property real samplePadding: 32

    default property alias contentData: contentHost.data

    readonly property bool dragging: dragArea.pressed
    readonly property bool _blurReady: sourceItem !== null
                                       && sourceItem.width > 1 && sourceItem.height > 1
                                       && width > 1 && height > 1
    readonly property real _minSide: Math.min(width, height)
    readonly property real _radiusNorm: Math.max(0.02, Math.min(0.49, radius / Math.max(1, _minSide)))
    readonly property real _aspect: width / Math.max(1, height)
    /// Larger panel → thicker glass (more blur / bend / elevation).
    readonly property real _thickness: Math.min(1.45, Math.max(0.55, _minSide / 150))
    readonly property real _effBlur: blurAmount * (0.65 + 0.45 * _thickness)
    readonly property real _effRefraction: refraction * (0.7 + 0.4 * _thickness)
    readonly property real _effElevation: elevation * (0.65 + 0.5 * _thickness)
    readonly property real _effEdge: edgeStrength * (0.75 + 0.3 * _thickness)
    readonly property bool _softMotion: !Md3Theme.reduceMotion && liquidDeform > 0.01

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
        // Stretch along motion, slight compress on the other axis.
        _squashX = sx * (2.0 - sy) / (1.0 + Math.abs(sy - 1.0) * 0.35)
        _squashY = sy * (2.0 - sx) / (1.0 + Math.abs(sx - 1.0) * 0.35)
        _squashX = Math.max(0.9, Math.min(1.1, _squashX))
        _squashY = Math.max(0.9, Math.min(1.1, _squashY))
    }

    Md3Shadow {
        anchors.fill: parent
        elevation: root._effElevation
        cornerRadius: root.radius
    }

    Item {
        id: glassBody
        anchors.fill: parent
        layer.enabled: true
        layer.smooth: true
        layer.samples: 4
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: squircleMask
            autoPaddingEnabled: false
        }

        MultiEffect {
            id: fluidBg
            visible: root._blurReady
            width: root.sourceItem ? root.sourceItem.width : 0
            height: root.sourceItem ? root.sourceItem.height : 0
            x: {
                if (!root.sourceItem)
                    return 0
                void root.x
                void root.y
                return glassBody.mapFromItem(root.sourceItem, 0, 0).x
            }
            y: {
                if (!root.sourceItem)
                    return 0
                void root.x
                void root.y
                return glassBody.mapFromItem(root.sourceItem, 0, 0).y
            }
            source: root.sourceItem
            autoPaddingEnabled: false
            blurEnabled: true
            blur: Math.max(0.12, root._effBlur)
            blurMax: root.blurMax * (0.85 + 0.25 * root._thickness)
            blurMultiplier: 1.35 + 0.25 * root._thickness
            saturation: 1.25
            brightness: 0.06
            contrast: 0.04
        }

        ShaderEffectSource {
            id: lensSample
            width: root.width + root.samplePadding * 2
            height: root.height + root.samplePadding * 2
            x: -root.samplePadding
            y: -root.samplePadding
            visible: false
            live: true
            hideSource: false
            smooth: true
            sourceItem: root.sourceItem
            sourceRect: {
                if (!root.sourceItem)
                    return Qt.rect(0, 0, width, height)
                void root.x
                void root.y
                void root.width
                void root.height
                void root.samplePadding
                const pad = root.samplePadding
                const p = root.mapToItem(root.sourceItem, -pad, -pad)
                return Qt.rect(p.x, p.y, root.width + pad * 2, root.height + pad * 2)
            }
        }

        ShaderEffect {
            id: lens
            anchors.fill: parent
            visible: root._blurReady && root._effRefraction > 0.02
            property variant source: lensSample
            property real bend: root._effRefraction
            property real frost: root._effBlur * 0.01
            property real chroma: root.chromaticAberration
            property real radiusNorm: root._radiusNorm
            property real aspect: root._aspect
            property real padU: root.samplePadding / Math.max(1, lensSample.width)
            property real padV: root.samplePadding / Math.max(1, lensSample.height)
            property real squircleN: root.squircleN
            property real thickness: root._thickness
            property real adaptive: root.adaptiveTint
            property real baseTint: root.tintOpacity
            vertexShader: "qrc:/qt/qml/Md3/shaders/md3liquidglass.vert.qsb"
            fragmentShader: "qrc:/qt/qml/Md3/shaders/md3liquidglass.frag.qsb"
        }

        Rectangle {
            anchors.fill: parent
            visible: !root._blurReady
            color: root.tintColor
            opacity: Math.max(0.25, root.tintOpacity)
        }

        // Light residual veil; most adaptivity is in the lens shader.
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

        // No Rectangle border — rounded-rect stroke reads as a square frame under squircle clip.

        Item {
            id: contentHost
            anchors.fill: parent
            anchors.margins: 16 + 4 * root._thickness
            z: 2
        }
    }

    // Same mask pattern as Md3Button: layered Item, coverage in alpha.
    Item {
        id: squircleMask
        width: root.width
        height: root.height
        visible: false
        layer.enabled: true
        layer.smooth: true
        ShaderEffect {
            anchors.fill: parent
            property real aspect: root._aspect
            property real squircleN: root.squircleN
            property real soft: 0.018
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
            const nx = p.x - root._grabOffX
            const ny = p.y - root._grabOffY
            const next = root._clampPos(nx, ny)
            root._setDeform(next.x - root.x, next.y - root.y)
            root.x = next.x
            root.y = next.y
        }
        onReleased: {
            root._squashX = 1
            root._squashY = 1
        }
        onCanceled: {
            root._squashX = 1
            root._squashY = 1
        }
    }
}
