import QtQuick
import QtQuick.Effects

/// Draggable Liquid Glass card — refraction + frost + specular (iOS 26–inspired).
Item {
    id: root

    /// Scene content sampled behind this card (sibling under the same parent).
    property Item sourceItem: null
    property real radius: 28
    property real elevation: 2
    property bool draggable: true
    property bool boundToParent: true

    /// Frost amount 0..1 (shader taps + MultiEffect fallback).
    property real blurAmount: 0.28
    property real blurMax: 48
    /// Keep low for clear glass (≈0.06–0.15). Higher = frosted plate.
    property real tintOpacity: 0.10
    property color tintColor: "#FFFFFF"
    property real specularStrength: 0.72
    property real edgeStrength: 0.85
    /// Edge lens bend (0 = frost only).
    property real refraction: 1.15
    /// RGB fringe at the rim (0..1).
    property real chromaticAberration: 0.45
    property real samplePadding: 28

    default property alias contentData: contentHost.data

    readonly property bool dragging: dragArea.drag.active || dragArea.pressed

    implicitWidth: 280
    implicitHeight: 168
    z: dragging ? 20 : 1

    readonly property bool _blurReady: sourceItem !== null && width > 1 && height > 1
    readonly property real _minSide: Math.min(width, height)
    readonly property real _radiusNorm: Math.max(0.02, Math.min(0.49, radius / Math.max(1, _minSide)))
    readonly property real _aspect: width / Math.max(1, height)
    readonly property bool _useLens: _blurReady && refraction > 0.02

    property real _specNX: 0.30
    property real _specNY: 0.22
    property real _pressScale: 1

    scale: _pressScale
    transformOrigin: Item.Center

    Behavior on _pressScale {
        NumberAnimation {
            duration: Md3Motion.short4
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Md3Motion.standard
        }
    }
    Behavior on _specNX {
        NumberAnimation {
            duration: Md3Motion.medium2
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Md3Motion.standard
        }
    }
    Behavior on _specNY {
        NumberAnimation {
            duration: Md3Motion.medium2
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Md3Motion.standard
        }
    }

    function _sourceRect(pad) {
        if (!sourceItem)
            return Qt.rect(0, 0, width, height)
        void x; void y; void width; void height; void refraction
        // Slight zoom with refraction → convex-lens feel even without the shader.
        const zoom = Math.max(0.72, 1.0 - refraction * 0.045)
        const rw = (width + pad * 2) * zoom
        const rh = (height + pad * 2) * zoom
        const ox = (width + pad * 2 - rw) * 0.5 - pad
        const oy = (height + pad * 2 - rh) * 0.5 - pad
        const p = mapToItem(sourceItem, ox, oy)
        return Qt.rect(p.x, p.y, rw, rh)
    }

    Md3Shadow {
        anchors.fill: parent
        elevation: root.elevation
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
            maskSource: roundMask
            autoPaddingEnabled: false
        }

        // Card-sized live sample (frost fallback + always available).
        ShaderEffectSource {
            id: cardSample
            anchors.fill: parent
            visible: false
            live: true
            hideSource: false
            smooth: true
            sourceItem: root.sourceItem
            sourceRect: root._sourceRect(0)
        }

        // Padded sample for lens shader (needs outer pixels).
        ShaderEffectSource {
            id: paddedSample
            width: root.width + root.samplePadding * 2
            height: root.height + root.samplePadding * 2
            x: -root.samplePadding
            y: -root.samplePadding
            visible: false
            live: true
            hideSource: false
            smooth: true
            sourceItem: root.sourceItem
            sourceRect: root._sourceRect(root.samplePadding)
        }

        // Always-on frosted backdrop (works without custom shaders / HLSL).
        MultiEffect {
            anchors.fill: parent
            visible: root._blurReady
            source: cardSample
            blurEnabled: true
            blur: Math.max(0.08, root.blurAmount)
            blurMax: root.blurMax
            blurMultiplier: 1.35
            saturation: 1.2
            brightness: 0.07
            contrast: 0.03
        }

        // Refraction + chromatic aberration. When the QSB lacks a D3D variant,
        // this layer may no-op and the MultiEffect frost above still shows through.
        ShaderEffect {
            id: lens
            anchors.fill: parent
            visible: root._useLens
            property variant source: paddedSample
            property real bend: root.refraction
            property real frost: root.blurAmount * 0.022
            property real chroma: root.chromaticAberration
            property real radiusNorm: root._radiusNorm
            property real aspect: root._aspect
            property real padU: root.samplePadding / Math.max(1, paddedSample.width)
            property real padV: root.samplePadding / Math.max(1, paddedSample.height)
            vertexShader: "qrc:/qt/qml/Md3/shaders/md3liquidglass.vert.qsb"
            fragmentShader: "qrc:/qt/qml/Md3/shaders/md3liquidglass.frag.qsb"
        }

        Rectangle {
            anchors.fill: parent
            visible: !root._blurReady
            color: root.tintColor
            opacity: Math.max(0.22, root.tintOpacity)
        }

        // Clear glass tint — keep low so backdrop reads through.
        Rectangle {
            anchors.fill: parent
            visible: root._blurReady
            color: root.tintColor
            opacity: root.tintOpacity
        }

        Rectangle {
            anchors.fill: parent
            opacity: root.edgeStrength * 0.5
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(0.75, 0.88, 1.0, 0.20) }
                GradientStop { position: 0.45; color: Qt.rgba(1, 1, 1, 0.03) }
                GradientStop { position: 1.0; color: Qt.rgba(1.0, 0.86, 0.72, 0.12) }
            }
        }

        Rectangle {
            width: root.width * 0.78
            height: root.height * 0.52
            x: root.width * root._specNX - width * 0.5
            y: root.height * root._specNY - height * 0.5
            radius: Math.min(width, height) * 0.5
            rotation: -16
            opacity: root.specularStrength * (root.dragging ? 1.0 : 0.72)
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.58) }
                GradientStop { position: 0.4; color: Qt.rgba(1, 1, 1, 0.10) }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 1
            height: Math.max(2, root.height * 0.04)
            opacity: root.edgeStrength
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.18; color: Qt.rgba(1, 1, 1, 0.78) }
                GradientStop { position: 0.82; color: Qt.rgba(1, 1, 1, 0.38) }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            radius: Math.max(0, root.radius - 1)
            color: "transparent"
            border.width: 1
            border.color: Qt.rgba(1, 1, 1, 0.28 * root.edgeStrength)
        }
        Rectangle {
            anchors.fill: parent
            radius: root.radius
            color: "transparent"
            border.width: 1
            border.color: Qt.rgba(1, 1, 1, 0.45 * root.edgeStrength)
        }

        Item {
            id: contentHost
            anchors.fill: parent
            anchors.margins: 20
            z: 2
        }
    }

    Item {
        id: roundMask
        width: root.width
        height: root.height
        visible: false
        layer.enabled: true
        layer.smooth: true
        Rectangle {
            anchors.fill: parent
            radius: root.radius
            color: "#ffffff"
        }
    }

    // Flickable steals DragHandler — MouseArea + preventStealing is required.
    MouseArea {
        id: dragArea
        anchors.fill: parent
        z: 100
        enabled: root.draggable
        hoverEnabled: true
        cursorShape: pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor
        preventStealing: true
        propagateComposedEvents: false
        drag.target: root
        drag.axis: Drag.XAndYAxis
        drag.threshold: 1
        drag.minimumX: root.boundToParent && parent ? 0 : -100000
        drag.maximumX: root.boundToParent && parent ? Math.max(0, parent.width - root.width) : 100000
        drag.minimumY: root.boundToParent && parent ? 0 : -100000
        drag.maximumY: root.boundToParent && parent ? Math.max(0, parent.height - root.height) : 100000

        onPressed: root._pressScale = 1.04
        onReleased: {
            root._pressScale = 1
            root._specNX = 0.30
            root._specNY = 0.22
        }
        onCanceled: {
            root._pressScale = 1
            root._specNX = 0.30
            root._specNY = 0.22
        }
        onPositionChanged: {
            if (!pressed)
                return
            root._specNX = Math.max(0.12, Math.min(0.88, mouseX / Math.max(1, width)))
            root._specNY = Math.max(0.1, Math.min(0.75, mouseY / Math.max(1, height)))
        }
    }
}
