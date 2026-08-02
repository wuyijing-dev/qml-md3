import QtQuick
import Md3

/// Concentric multi-ring gauge — each ring is `{ value, from?, to?, color?, label? }`.
Item {
    id: root

    /// [{ value, from, to, color, label, unit }]
    property var rings: []
    property real strokeWidth: 10
    property real ringGap: 6
    property real startAngle: -90
    property color trackColor: Md3Theme.colorScheme.gaugeTrack
    property bool showCenterLabel: true
    property string centerLabel: ""
    property string centerValue: ""
    property real size: 160
    /// Minimum center hole as a fraction of diameter (keeps text readable).
    property real minCenterRatio: 0.40

    width: size
    height: size
    implicitWidth: size
    implicitHeight: size


    property var hostWindow: null
    property bool unloadWhenPageInactive: true
    property bool _treeShown: true
    property bool _paintPending: false

    Md3PageActivityGate {
        id: pageGate
        watchItem: root
        unloadWhenPageInactive: root.unloadWhenPageInactive
    }

    function _refreshTreeShown() {
        const ok = pageGate.contentActive
                && Md3TreeVisibility.isSceneActive(root, root.hostWindow)
        if (_treeShown !== ok)
            _treeShown = ok
        if (_treeShown && _paintPending)
            _requestPaint()
    }

    function _requestPaint() {
        if (!_treeShown) {
            _paintPending = true
            return
        }
        _paintPending = false
        if (canvasLoader.item)
            canvasLoader.item.requestPaint()
    }

    Connections {
        target: pageGate
        function onContentActiveChanged() { root._refreshTreeShown() }
    }
    Connections {
        target: Qt.application
        function onStateChanged() { root._refreshTreeShown() }
    }
    onVisibleChanged: root._refreshTreeShown()

    readonly property int _ringCount: rings && rings.length ? rings.length : 0
    readonly property real _dialR: Math.min(width, height) / 2
    /// Guaranteed readable hole; rings auto-thin to leave this clear.
    readonly property real innerHoleRadius: Math.max(22, _dialR * minCenterRatio)
    readonly property real _effGap: {
        const n = Math.max(1, _ringCount)
        const band = Math.max(8, _dialR - 2 - innerHoleRadius)
        return Math.min(ringGap, Math.max(2, band * 0.12))
    }
    readonly property real _effStroke: {
        const n = Math.max(1, _ringCount)
        const band = Math.max(8, _dialR - 2 - innerHoleRadius)
        const stroke = (band - (n - 1) * _effGap) / n
        return Math.max(3.5, Math.min(strokeWidth, stroke))
    }

    function _rad(deg) { return deg * Math.PI / 180 }

    function _progress(ring) {
        const from = ring.from !== undefined ? Number(ring.from) : 0
        const to = ring.to !== undefined ? Number(ring.to) : 100
        const v = Number(ring.value || 0)
        return Math.max(0, Math.min(1, (v - from) / Math.max(1e-6, to - from)))
    }

        Loader {
        id: canvasLoader
        anchors.fill: parent
        active: root._treeShown
        sourceComponent: canvasComp
        onLoaded: if (item) item.requestPaint()
    }

    Component {
        id: canvasComp
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
                const stroke = root._effStroke
                const gap = root._effGap
                let r = root._dialR - stroke * 0.5 - 1
                ctx.lineWidth = stroke
                ctx.lineCap = "round"
                for (let i = 0; i < list.length; ++i) {
                    const ring = list[i]
                    const p = root._progress(ring)
                    const col = ring.color !== undefined ? ring.color : Md3Theme.colorScheme.primary
                    // Keep stroke outside the reserved center hole
                    if (r - stroke * 0.5 < root.innerHoleRadius)
                        break
                    ctx.strokeStyle = root.trackColor
                    ctx.beginPath()
                    ctx.arc(cx, cy, r, 0, Math.PI * 2)
                    ctx.stroke()
                    ctx.strokeStyle = col
                    ctx.beginPath()
                    ctx.arc(cx, cy, r, root._rad(root.startAngle),
                            root._rad(root.startAngle + 360 * p), false)
                    ctx.stroke()
                    r -= stroke + gap
                }
            }
        }    }


    onRingsChanged: root._requestPaint()
    onTrackColorChanged: root._requestPaint()
    onWidthChanged: root._requestPaint()
    onHeightChanged: root._requestPaint()
    onStrokeWidthChanged: root._requestPaint()
    onRingGapChanged: root._requestPaint()
    Component.onCompleted: { root._refreshTreeShown(); root._requestPaint() }

    Item {
        id: centerHole
        visible: root.showCenterLabel
        anchors.centerIn: parent
        width: root.innerHoleRadius * 2 * 0.92
        height: root.innerHoleRadius * 2 * 0.92

        Column {
            anchors.centerIn: parent
            width: parent.width
            spacing: 1

            Text {
                width: parent.width
                height: parent.parent.height * (root.centerLabel.length ? 0.58 : 0.8)
                visible: root.centerValue.length > 0
                text: root.centerValue
                color: Md3Theme.colorScheme.colorOnSurface
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.Fit
                minimumPixelSize: 9
                font.pixelSize: 28
                font.weight: Font.DemiBold
                font.family: Md3Theme.typography.fontFamily
                wrapMode: Text.NoWrap
                elide: Text.ElideNone
            }
            Text {
                width: parent.width
                height: parent.parent.height * 0.32
                visible: root.centerLabel.length > 0
                text: root.centerLabel
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.Fit
                minimumPixelSize: 8
                font.pixelSize: 14
                font.family: Md3Theme.typography.fontFamily
                wrapMode: Text.NoWrap
                elide: Text.ElideNone
            }
        }
    }
}
