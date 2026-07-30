import QtQuick
import Md3

/// Circular dots gauge — progress as filled dots around a ring.
Item {
    id: root

    property real value: 0
    property real from: 0
    property real to: 100
    property string label: ""
    property string unit: ""
    property int decimals: 0
    property int dotCount: 24
    property real dotRadius: 4
    property real startAngle: -90
    property color trackColor: Md3Theme.colorScheme.gaugeTrack
    property color valueColor: Md3Theme.colorScheme.primary
    property bool showValue: true
    property real size: 140

    readonly property real progress: {
        const span = Math.max(1e-6, to - from)
        return Math.max(0, Math.min(1, (value - from) / span))
    }
    readonly property int filledDots: Math.round(progress * Math.max(1, dotCount))
    readonly property string valueText: Number(value).toFixed(decimals) + (unit.length ? unit : "")

    width: size
    height: size
    implicitWidth: size
    implicitHeight: size

    function _rad(deg) { return deg * Math.PI / 180 }

    Canvas {
        id: canvas
        anchors.fill: parent
        onPaint: {
            const ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            const n = Math.max(1, root.dotCount)
            const cx = width / 2
            const cy = height / 2
            const ringR = Math.min(width, height) / 2 - root.dotRadius - 2
            for (let i = 0; i < n; ++i) {
                const ang = root._rad(root.startAngle + (360 / n) * i)
                const x = cx + Math.cos(ang) * ringR
                const y = cy + Math.sin(ang) * ringR
                ctx.beginPath()
                ctx.arc(x, y, root.dotRadius, 0, Math.PI * 2)
                ctx.fillStyle = i < root.filledDots ? root.valueColor : root.trackColor
                ctx.fill()
            }
        }
    }

    onValueChanged: canvas.requestPaint()
    onTrackColorChanged: canvas.requestPaint()
    onDotCountChanged: canvas.requestPaint()
    onWidthChanged: canvas.requestPaint()
    onHeightChanged: canvas.requestPaint()
    Component.onCompleted: canvas.requestPaint()

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
