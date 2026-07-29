import QtQuick

/// Concentric multi-ring gauge — each ring is `{ value, from?, to?, color?, label? }`.
Item {
    id: root

    /// [{ value, from, to, color, label, unit }]
    property var rings: []
    property real strokeWidth: 10
    property real ringGap: 6
    property real startAngle: -90
    property color trackColor: Md3Theme.colorScheme.surfaceContainerHighest
    property bool showCenterLabel: true
    property string centerLabel: ""
    property string centerValue: ""
    property real size: 160

    width: size
    height: size
    implicitWidth: size
    implicitHeight: size

    function _rad(deg) { return deg * Math.PI / 180 }

    function _progress(ring) {
        const from = ring.from !== undefined ? Number(ring.from) : 0
        const to = ring.to !== undefined ? Number(ring.to) : 100
        const v = Number(ring.value || 0)
        return Math.max(0, Math.min(1, (v - from) / Math.max(1e-6, to - from)))
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        onPaint: {
            const ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            const list = root.rings || []
            if (!list.length)
                return
            const cx = width / 2
            const cy = height / 2
            let r = Math.min(width, height) / 2 - root.strokeWidth
            ctx.lineWidth = root.strokeWidth
            ctx.lineCap = "round"
            for (let i = 0; i < list.length; ++i) {
                const ring = list[i]
                const p = root._progress(ring)
                const col = ring.color !== undefined ? ring.color : Md3Theme.colorScheme.primary
                ctx.strokeStyle = root.trackColor
                ctx.beginPath()
                ctx.arc(cx, cy, r, 0, Math.PI * 2)
                ctx.stroke()
                ctx.strokeStyle = col
                ctx.beginPath()
                ctx.arc(cx, cy, r, root._rad(root.startAngle),
                        root._rad(root.startAngle + 360 * p), false)
                ctx.stroke()
                r -= root.strokeWidth + root.ringGap
                if (r < root.strokeWidth)
                    break
            }
        }
    }

    onRingsChanged: canvas.requestPaint()
    onWidthChanged: canvas.requestPaint()
    onHeightChanged: canvas.requestPaint()
    onStrokeWidthChanged: canvas.requestPaint()
    Component.onCompleted: canvas.requestPaint()

    Column {
        anchors.centerIn: parent
        spacing: 2
        visible: root.showCenterLabel
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            visible: root.centerValue.length > 0
            text: root.centerValue
            color: Md3Theme.colorScheme.colorOnSurface
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.titleLarge.size
            font.weight: Font.Medium
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            visible: root.centerLabel.length > 0
            text: root.centerLabel
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.labelMedium.size
        }
    }
}
