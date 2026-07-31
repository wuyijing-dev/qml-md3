import QtQuick
import QtQuick.Shapes
import Md3

/// Semicircle / half-dial gauge (flat bottom).
Item {
    id: root

    property real value: 0
    property real from: 0
    property real to: 100
    property string label: ""
    property string unit: "%"
    property int decimals: 0
    property real strokeWidth: 12
    property real startAngle: 180
    property real sweepAngle: 180
    property color trackColor: Md3Theme.colorScheme.gaugeTrack
    property color valueColor: Md3Theme.colorScheme.primary
    property bool showValue: true
    property real size: 140

    readonly property real progress: {
        const span = Math.max(1e-6, to - from)
        return Math.max(0, Math.min(1, (value - from) / span))
    }
    readonly property string valueText: Number(value).toFixed(decimals) + (unit.length ? unit : "")

    width: size
    height: size * 0.62
    implicitWidth: size
    implicitHeight: size * 0.62
    height: implicitHeight

    Shape {
        anchors.fill: parent
        preferredRendererType: Shape.GeometryRenderer

        ShapePath {
            strokeWidth: root.strokeWidth
            strokeColor: root.trackColor
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            PathAngleArc {
                centerX: root.width / 2
                centerY: root.height - root.strokeWidth
                radiusX: Math.min(root.width / 2, root.height) - root.strokeWidth
                radiusY: radiusX
                startAngle: root.startAngle
                sweepAngle: root.sweepAngle
            }
        }
        ShapePath {
            strokeWidth: root.strokeWidth
            strokeColor: root.valueColor
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            PathAngleArc {
                centerX: root.width / 2
                centerY: root.height - root.strokeWidth
                radiusX: Math.min(root.width / 2, root.height) - root.strokeWidth
                radiusY: radiusX
                startAngle: root.startAngle
                sweepAngle: root.sweepAngle * root.progress
            }
        }
    }

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 2
        spacing: 0
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            visible: root.showValue
            text: root.valueText
            color: Md3Theme.colorScheme.colorOnSurface
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.titleMedium.size
            font.weight: Font.Medium
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            visible: root.label.length > 0
            text: root.label
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.labelMedium.size
        }
    }
}
