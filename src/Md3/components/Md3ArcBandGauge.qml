import QtQuick
import QtQuick.Shapes
import Md3

/// Thick arc-band gauge with an end cap marker (dashboard KPI band).
Item {
    id: root

    property real value: 0
    property real from: 0
    property real to: 100
    property string label: ""
    property string unit: "%"
    property int decimals: 0
    property real strokeWidth: 16
    property real startAngle: -210
    property real sweepAngle: 240
    property color trackColor: Md3Theme.colorScheme.gaugeTrack
    property color valueColor: Md3Theme.colorScheme.primary
    property color markerColor: Md3Theme.colorScheme.colorOnPrimary
    property bool showValue: true
    property bool showMarker: true
    property real size: 140

    readonly property real progress: {
        const span = Math.max(1e-6, to - from)
        return Math.max(0, Math.min(1, (value - from) / span))
    }
    readonly property string valueText: Number(value).toFixed(decimals) + (unit.length ? unit : "")
    readonly property real _r: Math.min(width, height) / 2 - strokeWidth

    width: size
    height: size
    implicitWidth: size
    implicitHeight: size

    function _rad(deg) { return deg * Math.PI / 180 }

    Shape {
        anchors.fill: parent
        preferredRendererType: Shape.GeometryRenderer
        ShapePath {
            strokeWidth: root.strokeWidth
            strokeColor: root.trackColor
            fillColor: "transparent"
            capStyle: ShapePath.FlatCap
            PathAngleArc {
                centerX: root.width / 2
                centerY: root.height / 2
                radiusX: root._r
                radiusY: root._r
                startAngle: root.startAngle
                sweepAngle: root.sweepAngle
            }
        }
        ShapePath {
            strokeWidth: root.strokeWidth
            strokeColor: root.valueColor
            fillColor: "transparent"
            capStyle: ShapePath.FlatCap
            PathAngleArc {
                centerX: root.width / 2
                centerY: root.height / 2
                radiusX: root._r
                radiusY: root._r
                startAngle: root.startAngle
                sweepAngle: root.sweepAngle * root.progress
            }
        }
    }

    // End marker
    Rectangle {
        visible: root.showMarker && root.progress > 0.001
        width: root.strokeWidth + 4
        height: root.strokeWidth + 4
        radius: width / 2
        color: root.markerColor
        border.width: 2
        border.color: root.valueColor
        x: root.width / 2 + Math.cos(root._rad(root.startAngle + root.sweepAngle * root.progress)) * root._r - width / 2
        y: root.height / 2 + Math.sin(root._rad(root.startAngle + root.sweepAngle * root.progress)) * root._r - height / 2
    }

    Column {
        anchors.centerIn: parent
        spacing: 0
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            visible: root.showValue
            text: root.valueText
            color: Md3Theme.colorScheme.colorOnSurface
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.headlineSmall.size
            font.weight: Font.Medium
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            visible: root.label.length > 0
            text: root.label
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.labelLarge.size
        }
    }
}
