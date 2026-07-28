import QtQuick
import QtQuick.Effects

/// Draggable Liquid Glass card — backdrop blur, adaptive tint, edge lensing, specular highlight.
Item {
    id: root

    /// Scene content sampled behind this card (typically a sibling under the same parent).
    property Item sourceItem: null
    property real radius: Md3Theme.shape.extraLarge
    property real elevation: 3
    property bool draggable: true
    property real blurAmount: 0.62
    property real blurMax: 56
    property real tintOpacity: Md3Theme.colorScheme.dark ? 0.32 : 0.48
    property color tintColor: Md3Theme.colorScheme.surface
    property real specularStrength: 0.58
    property real edgeStrength: 0.55
    /// Keep the card inside its parent while dragging.
    property bool boundToParent: true

    default property alias contentData: contentHost.data

    readonly property bool dragging: drag.active

    implicitWidth: 280
    implicitHeight: 168
    clip: false
    z: dragging ? 10 : 1

    readonly property bool _blurReady: sourceItem !== null && width > 0 && height > 0
    property real _specNX: 0.28
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

        Item {
            id: blurHost
            anchors.fill: parent
            visible: root._blurReady

            ShaderEffectSource {
                id: backdropSample
                anchors.fill: parent
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
                    const p = root.mapToItem(root.sourceItem, 0, 0)
                    return Qt.rect(p.x, p.y, root.width, root.height)
                }
            }

            MultiEffect {
                anchors.fill: parent
                source: backdropSample
                blurEnabled: true
                blur: root.blurAmount
                blurMax: root.blurMax
                blurMultiplier: 1.15
                saturation: 1.08
                brightness: Md3Theme.colorScheme.dark ? -0.04 : 0.06
                contrast: 0.04
            }
        }

        Rectangle {
            anchors.fill: parent
            color: root.tintColor
            opacity: root._blurReady ? root.tintOpacity * 0.72 : root.tintOpacity
        }

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: Qt.rgba(0.66, 0.83, 1.0, Md3Theme.colorScheme.dark ? 0.14 : 0.18)
                }
                GradientStop {
                    position: 0.45
                    color: "transparent"
                }
                GradientStop {
                    position: 1.0
                    color: Qt.rgba(1.0, 0.83, 0.66, Md3Theme.colorScheme.dark ? 0.08 : 0.10)
                }
            }
            opacity: root.edgeStrength
        }

        Rectangle {
            id: specular
            width: root.width * 0.72
            height: root.height * 0.55
            x: root.width * root._specNX - width * 0.5
            y: root.height * root._specNY - height * 0.5
            radius: Math.min(width, height) * 0.5
            rotation: -18
            opacity: root.specularStrength * (drag.active ? 0.95 : 0.7)
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.55) }
                GradientStop { position: 0.35; color: Qt.rgba(1, 1, 1, 0.12) }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 1
            height: Math.max(1.5, root.height * 0.035)
            opacity: Md3Theme.colorScheme.dark ? 0.35 : 0.55
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.2; color: Qt.rgba(1, 1, 1, 0.65) }
                GradientStop { position: 0.8; color: Qt.rgba(1, 1, 1, 0.35) }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.width: 1
            border.color: Qt.rgba(1, 1, 1, Md3Theme.colorScheme.dark ? 0.22 : 0.45)
            radius: root.radius
        }

        Item {
            id: contentHost
            anchors.fill: parent
            anchors.margins: 20
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

    DragHandler {
        id: drag
        enabled: root.draggable
        target: root
        cursorShape: Qt.OpenHandCursor
        xAxis.minimum: root.boundToParent && parent ? 0 : -100000
        xAxis.maximum: root.boundToParent && parent ? Math.max(0, parent.width - root.width) : 100000
        yAxis.minimum: root.boundToParent && parent ? 0 : -100000
        yAxis.maximum: root.boundToParent && parent ? Math.max(0, parent.height - root.height) : 100000

        onActiveChanged: {
            root._pressScale = active ? 1.035 : 1
            if (!active) {
                root._specNX = 0.28
                root._specNY = 0.22
            }
        }

        onCentroidChanged: {
            if (!active || root.width <= 0 || root.height <= 0)
                return
            const lx = centroid.position.x / Math.max(1, root.width)
            const ly = centroid.position.y / Math.max(1, root.height)
            root._specNX = Math.max(0.12, Math.min(0.88, lx))
            root._specNY = Math.max(0.1, Math.min(0.75, ly))
        }
    }

    HoverHandler {
        enabled: root.draggable
        cursorShape: drag.active ? Qt.ClosedHandCursor : Qt.OpenHandCursor
    }
}
