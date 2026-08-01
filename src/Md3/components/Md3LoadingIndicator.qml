import QtQuick
import QtQuick.Shapes
import Md3

/// Material 3 Loading indicator — spins a fixed arc (no per-frame Path mutation).
Item {
    id: root

    enum Size { Small, Medium, Large }

    property int sizePreset: Md3LoadingIndicator.Medium
    property real value: 0
    property bool indeterminate: true
    property string label: ""
    property color indicatorColor: Md3Theme.colorScheme.primary
    property color trackColor: Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.primary, 0.2)
    /// Optional Window for scene-active checks (else OverlayHost).
    property var hostWindow: null
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
    readonly property real _spinMs: Math.max(800, Md3Motion.progressSpin)

    function _refreshTreeShown() {
        const ok = Md3TreeVisibility.isLiveMotionScene(root, root.hostWindow)
        if (_treeShown !== ok)
            _treeShown = ok
    }

    function syncDeterminate() {
        if (indeterminate) {
            indArc.sweepAngle = -220
            indicatorShape.rotation = 0
            return
        }
        indArc.sweepAngle = -360 * Math.max(0.001, Math.min(1, value))
        indicatorShape.rotation = 0
    }

    Timer {
        interval: 2000
        running: root.enabled && root.indeterminate
        repeat: true
        onTriggered: root._refreshTreeShown()
    }
    Connections {
        target: Qt.application
        function onStateChanged() { root._refreshTreeShown() }
    }
    Component.onCompleted: {
        _refreshTreeShown()
        syncDeterminate()
    }
    onVisibleChanged: {
        _refreshTreeShown()
        if (visible)
            syncDeterminate()
    }

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
                preferredRendererType: Shape.GeometryRenderer
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
            }

            Shape {
                id: indicatorShape
                anchors.fill: parent
                preferredRendererType: Shape.GeometryRenderer
                asynchronous: false
                transformOrigin: Item.Center

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
                        sweepAngle: -220
                    }
                }

                RotationAnimator on rotation {
                    from: 0
                    to: 360
                    duration: root._spinMs
                    loops: Animation.Infinite
                    running: root.indeterminate && root.sceneActive
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

    onValueChanged: if (!indeterminate) syncDeterminate()
    onIndeterminateChanged: {
        indicatorShape.rotation = 0
        syncDeterminate()
    }
}
