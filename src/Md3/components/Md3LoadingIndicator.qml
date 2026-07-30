import QtQuick
import QtQuick.Window
import QtQuick.Shapes
import Md3

/// Material 3 Loading indicator — PathAngleArc updated in-place (no per-frame Shape rebuild).
Item {
    id: root

    enum Size { Small, Medium, Large }

    property int sizePreset: Md3LoadingIndicator.Medium
    property real value: 0
    property bool indeterminate: true
    property string label: ""
    property color indicatorColor: Md3Theme.colorScheme.primary
    property color trackColor: Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.primary, 0.2)
    property real strokeWidth: {
        switch (sizePreset) {
        case Md3LoadingIndicator.Small: return 3
        case Md3LoadingIndicator.Large: return 5
        default: return 4
        }
    }
    property real indicatorSize: {
        switch (sizePreset) {
        case Md3LoadingIndicator.Small: return 24
        case Md3LoadingIndicator.Large: return 48
        default: return 36
        }
    }

    property bool _treeShown: true
    readonly property bool sceneActive: enabled && _treeShown
    readonly property real radius: indicatorSize / 2 - strokeWidth

    /// Arc start angle in radians (not Item.rotation).
    property real arcRotation: -Math.PI / 2
    property real sweep: Math.PI * 0.65
    property real sweepDir: 1
    property real spinSpeed: Math.PI * 2 / (Md3Motion.progressSpin / 1000)

    function _refreshTreeShown() {
        const ok = Md3TreeVisibility.isSceneActive(root, Window.window)
        if (_treeShown !== ok)
            _treeShown = ok
    }

    function radToDeg(r) { return r * 180 / Math.PI }

    function syncArc() {
        if (indeterminate) {
            indArc.startAngle = radToDeg(arcRotation)
            indArc.sweepAngle = -radToDeg(sweep)
        } else {
            indArc.startAngle = -90
            indArc.sweepAngle = -360 * Math.max(0.001, Math.min(1, value))
        }
    }

    Timer {
        interval: 400
        running: root.enabled && root.indeterminate
        repeat: true
        onTriggered: root._refreshTreeShown()
    }
    Component.onCompleted: {
        _refreshTreeShown()
        syncArc()
    }
    onVisibleChanged: {
        _refreshTreeShown()
        if (visible)
            syncArc()
    }
    onOpacityChanged: _refreshTreeShown()

    implicitWidth: Math.max(indicatorSize, labelItem.visible ? labelItem.implicitWidth : 0)
    implicitHeight: indicatorSize + (labelItem.visible ? labelItem.implicitHeight + 8 : 0)
    width: implicitWidth
    height: implicitHeight

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 8

        Item {
            width: root.indicatorSize
            height: root.indicatorSize
            anchors.horizontalCenter: parent.horizontalCenter

            Shape {
                anchors.fill: parent
                preferredRendererType: Shape.CurveRenderer
                asynchronous: false

                ShapePath {
                    strokeWidth: root.strokeWidth
                    strokeColor: root.trackColor
                    fillColor: "transparent"
                    capStyle: ShapePath.RoundCap
                    PathAngleArc {
                        centerX: root.indicatorSize / 2
                        centerY: root.indicatorSize / 2
                        radiusX: root.radius
                        radiusY: root.radius
                        startAngle: -90
                        sweepAngle: 360
                    }
                }
                ShapePath {
                    strokeWidth: root.strokeWidth
                    strokeColor: root.indicatorColor
                    fillColor: "transparent"
                    capStyle: ShapePath.RoundCap
                    PathAngleArc {
                        id: indArc
                        centerX: root.indicatorSize / 2
                        centerY: root.indicatorSize / 2
                        radiusX: root.radius
                        radiusY: root.radius
                        startAngle: -90
                        sweepAngle: 0
                    }
                }
            }
        }

        Text {
            id: labelItem
            visible: root.label.length > 0
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.label
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.bodySmall.size
            font.family: Md3Theme.typography.fontFamily
            horizontalAlignment: Text.AlignHCenter
        }
    }

    FrameAnimation {
        running: root.sceneActive && root.indeterminate
        onTriggered: {
            const dt = frameTime
            root.arcRotation += root.spinSpeed * dt
            root.sweep += root.sweepDir * Math.PI * 1.1 * dt
            if (root.sweep > Math.PI * 1.2) {
                root.sweep = Math.PI * 1.2
                root.sweepDir = -1
            } else if (root.sweep < Math.PI * 0.3) {
                root.sweep = Math.PI * 0.3
                root.sweepDir = 1
            }
            root.syncArc()
        }
    }

    onValueChanged: if (!indeterminate) syncArc()
    onIndeterminateChanged: syncArc()
}
