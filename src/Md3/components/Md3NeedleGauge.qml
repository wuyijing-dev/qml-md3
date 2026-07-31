import QtQuick
import QtQuick.Shapes
import Md3

/// Analog needle gauge with tick marks (speedometer-style).
Item {
    id: root

    property real value: 0
    property real from: 0
    property real to: 100
    property string label: ""
    property string unit: ""
    property int decimals: 0
    property int tickCount: 11
    property int minorTicksPerMajor: 4
    property real startAngle: -210
    property real sweepAngle: 240
    property real strokeWidth: 8
    property color trackColor: Md3Theme.colorScheme.gaugeTrack
    property color valueColor: Md3Theme.colorScheme.primary
    property color needleColor: Md3Theme.colorScheme.error
    property color tickColor: Md3Theme.colorScheme.colorOnSurfaceVariant
    property bool showValue: true
    property bool showTicks: true
    property real size: 160

    readonly property real progress: {
        const span = Math.max(1e-6, to - from)
        return Math.max(0, Math.min(1, (value - from) / span))
    }
    readonly property string valueText: Number(value).toFixed(decimals) + (unit.length ? unit : "")
    readonly property real _cx: width / 2
    readonly property real _cy: height / 2
    readonly property real _r: Math.min(width, height) / 2 - strokeWidth - 4

    width: size
    height: size
    implicitWidth: size
    implicitHeight: size

    function _rad(deg) { return deg * Math.PI / 180 }

    Shape {
        id: dial
        anchors.fill: parent
        preferredRendererType: Shape.GeometryRenderer

        ShapePath {
            strokeWidth: root.strokeWidth
            strokeColor: root.trackColor
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            PathAngleArc {
                centerX: root._cx
                centerY: root._cy
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
            capStyle: ShapePath.RoundCap
            PathAngleArc {
                centerX: root._cx
                centerY: root._cy
                radiusX: root._r
                radiusY: root._r
                startAngle: root.startAngle
                sweepAngle: root.sweepAngle * root.progress
            }
        }
    }

    // Ticks + needle via Canvas for simpler polar math
    Canvas {
        id: ticks
        anchors.fill: parent
        onPaint: {
            const ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            const cx = root._cx
            const cy = root._cy
            const r = root._r
            if (root.showTicks) {
                const majors = Math.max(2, root.tickCount)
                const minors = Math.max(0, root.minorTicksPerMajor)
                const steps = (majors - 1) * (minors + 1)
                for (let i = 0; i <= steps; ++i) {
                    const t = i / steps
                    const ang = root._rad(root.startAngle + root.sweepAngle * t)
                    const major = (i % (minors + 1)) === 0
                    const len = major ? 10 : 5
                    const w = major ? 2 : 1
                    const x0 = cx + Math.cos(ang) * (r - 2)
                    const y0 = cy + Math.sin(ang) * (r - 2)
                    const x1 = cx + Math.cos(ang) * (r - 2 - len)
                    const y1 = cy + Math.sin(ang) * (r - 2 - len)
                    ctx.strokeStyle = root.tickColor
                    ctx.lineWidth = w
                    ctx.beginPath()
                    ctx.moveTo(x0, y0)
                    ctx.lineTo(x1, y1)
                    ctx.stroke()
                }
            }
            // Needle
            const nang = root._rad(root.startAngle + root.sweepAngle * root.progress)
            ctx.strokeStyle = root.needleColor
            ctx.fillStyle = root.needleColor
            ctx.lineWidth = 2.5
            ctx.lineCap = "round"
            ctx.beginPath()
            ctx.moveTo(cx - Math.cos(nang) * 8, cy - Math.sin(nang) * 8)
            ctx.lineTo(cx + Math.cos(nang) * (r - 18), cy + Math.sin(nang) * (r - 18))
            ctx.stroke()
            ctx.beginPath()
            ctx.arc(cx, cy, 5, 0, Math.PI * 2)
            ctx.fill()
        }
    }

    onValueChanged: ticks.requestPaint()
    onWidthChanged: ticks.requestPaint()
    onHeightChanged: ticks.requestPaint()
    onShowTicksChanged: ticks.requestPaint()
    Component.onCompleted: ticks.requestPaint()

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: root.size * 0.18
        spacing: 2
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
