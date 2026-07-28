import QtQuick
import QtQuick.Effects

/// Draggable Liquid Glass card.
/// Backdrop technique (classic QML frosted glass / Acrylic):
/// blur the *full* sourceItem, then offset it by mapFromItem so the slice under
/// the card tracks the real background as you drag — the "fluid reflection".
/// Edge refraction uses a displacement ShaderEffect (GitHub liquid-glass style).
Item {
    id: root

    /// Backdrop to refract (sibling under the same parent works best).
    property Item sourceItem: null
    property real radius: 28
    property real elevation: 2
    property bool draggable: true
    property bool boundToParent: true

    property real blurAmount: 0.45
    property real blurMax: 64
    property real tintOpacity: 0.08
    property color tintColor: "#FFFFFF"
    property real specularStrength: 0.75
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

    property real _specNX: 0.30
    property real _specNY: 0.22
    property real _pressScale: 1
    property real _grabOffX: 0
    property real _grabOffY: 0

    implicitWidth: 280
    implicitHeight: 168
    z: dragging ? 20 : 1
    clip: false

    function _clampPos(nx, ny) {
        if (!boundToParent || !parent)
            return Qt.point(nx, ny)
        const maxX = Math.max(0, parent.width - width)
        const maxY = Math.max(0, parent.height - height)
        return Qt.point(Math.max(0, Math.min(maxX, nx)),
                        Math.max(0, Math.min(maxY, ny)))
    }

    // Shadow stays on the outer item (not scaled).
    Md3Shadow {
        anchors.fill: parent
        elevation: root.elevation
        cornerRadius: root.radius
    }

    // Visual stack — scale here so drag x/y on root stay stable.
    Item {
        id: visual
        anchors.fill: parent
        scale: root._pressScale
        transformOrigin: Item.Center

        Behavior on scale {
            NumberAnimation {
                duration: Md3Motion.short4
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.standard
            }
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

            // --- Fluid reflection: full backdrop blur, reverse-offset ---
            // blur.x = mapFromItem(source, 0, 0).x  ⇒  as the card moves, the
            // blurred world slides underneath (same idea as Aero / Acrylic demos).
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
                    return root.mapFromItem(root.sourceItem, 0, 0).x
                }
                y: {
                    if (!root.sourceItem)
                        return 0
                    void root.x
                    void root.y
                    return root.mapFromItem(root.sourceItem, 0, 0).y
                }
                source: root.sourceItem
                blurEnabled: true
                blur: Math.max(0.12, root.blurAmount)
                blurMax: root.blurMax
                blurMultiplier: 1.5
                saturation: 1.25
                brightness: 0.08
                contrast: 0.04
            }

            // Live card-sized sample for edge refraction (displacement).
            ShaderEffectSource {
                id: lensSample
                anchors.fill: parent
                visible: false
                live: true
                hideSource: false
                smooth: true
                sourceItem: root.sourceItem
                sourceRect: {
                    if (!root.sourceItem)
                        return Qt.rect(0, 0, root.width, root.height)
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

            // Edge lens / chromatic fringe (Apple Liquid Glass “lensing”).
            ShaderEffect {
                id: lens
                anchors.fill: parent
                visible: root._blurReady && root.refraction > 0.02
                opacity: 0.92
                property variant source: lensSample
                property real bend: root.refraction
                property real frost: root.blurAmount * 0.012
                property real chroma: root.chromaticAberration
                property real radiusNorm: root._radiusNorm
                property real aspect: root._aspect
                property real padU: 0
                property real padV: 0
                // sourceRect already includes samplePadding; UV 0..1 is the padded capture.
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
                opacity: root.tintOpacity
            }

            Rectangle {
                anchors.fill: parent
                opacity: root.edgeStrength * 0.45
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(0.75, 0.9, 1.0, 0.22) }
                    GradientStop { position: 0.4; color: Qt.rgba(1, 1, 1, 0.02) }
                    GradientStop { position: 1.0; color: Qt.rgba(1.0, 0.85, 0.7, 0.14) }
                }
            }

            Rectangle {
                width: root.width * 0.8
                height: root.height * 0.5
                x: root.width * root._specNX - width * 0.5
                y: root.height * root._specNY - height * 0.5
                radius: Math.min(width, height) * 0.5
                rotation: -16
                opacity: root.specularStrength * (root.dragging ? 1.0 : 0.7)
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.6) }
                    GradientStop { position: 0.35; color: Qt.rgba(1, 1, 1, 0.1) }
                    GradientStop { position: 1.0; color: "transparent" }
                }
                Behavior on x {
                    NumberAnimation {
                        duration: Md3Motion.medium2
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.standard
                    }
                }
                Behavior on y {
                    NumberAnimation {
                        duration: Md3Motion.medium2
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.standard
                    }
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
                    GradientStop { position: 0.2; color: Qt.rgba(1, 1, 1, 0.8) }
                    GradientStop { position: 0.8; color: Qt.rgba(1, 1, 1, 0.35) }
                    GradientStop { position: 1.0; color: "transparent" }
                }
            }

            Rectangle {
                anchors.fill: parent
                radius: root.radius
                color: "transparent"
                border.width: 1.5
                border.color: Qt.rgba(1, 1, 1, 0.5 * root.edgeStrength)
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
    }

    // Manual drag — drag.target + scale on the same item jumps to (0,0).
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
            root._pressScale = 1.045
        }
        onPositionChanged: function(mouse) {
            if (!pressed)
                return
            const p = mapToItem(root.parent, mouse.x, mouse.y)
            const next = root._clampPos(p.x - root._grabOffX, p.y - root._grabOffY)
            root.x = next.x
            root.y = next.y
            root._specNX = Math.max(0.12, Math.min(0.88, mouse.x / Math.max(1, width)))
            root._specNY = Math.max(0.1, Math.min(0.75, mouse.y / Math.max(1, height)))
        }
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
    }
}
