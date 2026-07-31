import QtQuick
import QtQuick.Shapes
import Md3

/// Full 360° ring / donut progress gauge.
Item {
    id: root

    property real value: 0
    property real from: 0
    property real to: 100
    property string label: ""
    property string unit: "%"
    property int decimals: 0
    property real strokeWidth: 12
    property real startAngle: -90
    property color trackColor: Md3Theme.colorScheme.gaugeTrack
    property color valueColor: Md3Theme.colorScheme.primary
    property bool showValue: true
    property bool roundedCaps: true
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
    height: implicitHeight

    Shape {
        anchors.fill: parent
        preferredRendererType: Shape.GeometryRenderer

        ShapePath {
            strokeWidth: root.strokeWidth
            strokeColor: root.trackColor
            fillColor: "transparent"
            capStyle: root.roundedCaps ? ShapePath.RoundCap : ShapePath.FlatCap
            PathAngleArc {
                centerX: root.width / 2
                centerY: root.height / 2
                radiusX: root._r
                radiusY: root._r
                startAngle: root.startAngle
                sweepAngle: 360
            }
        }

        ShapePath {
            strokeWidth: root.strokeWidth
            strokeColor: root.valueColor
            fillColor: "transparent"
            capStyle: root.roundedCaps ? ShapePath.RoundCap : ShapePath.FlatCap
            PathAngleArc {
                centerX: root.width / 2
                centerY: root.height / 2
                radiusX: root._r
                radiusY: root._r
                startAngle: root.startAngle
                sweepAngle: 360 * root.progress
            }
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 2
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
