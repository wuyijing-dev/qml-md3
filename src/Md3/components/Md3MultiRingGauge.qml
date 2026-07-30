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
    /// Extra inset so center text stays clear of the innermost stroke.
    property real centerPadding: 6

    width: size
    height: size
    implicitWidth: size
    implicitHeight: size

    readonly property int _ringCount: rings && rings.length ? rings.length : 0
    /// Clear radius inside the innermost ring track (center hole).
    readonly property real innerHoleRadius: {
        const n = Math.max(1, _ringCount)
        const outer = Math.min(width, height) / 2 - strokeWidth
        const hole = outer - (n - 1) * (strokeWidth + ringGap) - strokeWidth * 0.5 - centerPadding
        return Math.max(8, hole)
    }
    readonly property real _valuePx: Math.max(11, Math.min(22, innerHoleRadius * 0.55))
    readonly property real _labelPx: Math.max(9, Math.min(12, innerHoleRadius * 0.28))

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
    onRingGapChanged: canvas.requestPaint()
    Component.onCompleted: canvas.requestPaint()

    Item {
        id: centerHole
        visible: root.showCenterLabel
        anchors.centerIn: parent
        width: root.innerHoleRadius * 2
        height: root.innerHoleRadius * 2
        clip: true

        Column {
            anchors.centerIn: parent
            width: parent.width - 4
            spacing: 0

            Text {
                width: parent.width
                visible: root.centerValue.length > 0
                text: root.centerValue
                color: Md3Theme.colorScheme.colorOnSurface
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                maximumLineCount: 1
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: root._valuePx
                font.weight: Font.DemiBold
            }
            Text {
                width: parent.width
                visible: root.centerLabel.length > 0
                text: root.centerLabel
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                maximumLineCount: 1
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: root._labelPx
            }
        }
    }
}
