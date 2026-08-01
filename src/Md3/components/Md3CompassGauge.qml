import QtQuick
import Md3

/// Compass-style circular dial with heading needle (0–360°).
Item {
    id: root

    property real value: 0
    property real from: 0
    property real to: 360
    property string label: ""
    property string unit: "°"
    property int decimals: 0
    property color trackColor: Md3Theme.colorScheme.gaugeTrack
    property color dialColor: Md3Theme.colorScheme.gaugeDial
    property color valueColor: Md3Theme.colorScheme.error
    property color tickColor: Md3Theme.colorScheme.colorOnSurfaceVariant
    property bool showCardinals: true
    property bool showValue: true
    property real size: 140

    readonly property real progress: {
        const span = Math.max(1e-6, to - from)
        let p = (value - from) / span
        p = p - Math.floor(p)
        return p
    }
    readonly property string valueText: Number(value).toFixed(decimals) + (unit.length ? unit : "")
    readonly property real _captionH: (showValue || label.length) ? 22 : 0

    width: size
    height: size + _captionH
    implicitWidth: size
    implicitHeight: size + _captionH


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
        (canvasLoader.item && canvasLoader.item.requestPaint())
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

    function _rad(deg) { return deg * Math.PI / 180 }

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
            width: root.size
            height: root.size
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            onPaint: {
                const ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                const cx = width / 2
                const cy = height / 2
                const r = Math.min(width, height) / 2 - 6

                ctx.beginPath()
                ctx.arc(cx, cy, r, 0, Math.PI * 2)
                ctx.fillStyle = root.dialColor
                ctx.fill()
                ctx.strokeStyle = Md3Theme.colorScheme.outline
                ctx.lineWidth = 1.5
                ctx.stroke()

                for (let i = 0; i < 24; ++i) {
                    const ang = root._rad(-90 + i * 15)
                    const major = (i % 3) === 0
                    ctx.strokeStyle = root.tickColor
                    ctx.lineWidth = major ? 2 : 1
                    ctx.beginPath()
                    ctx.moveTo(cx + Math.cos(ang) * (r - 2), cy + Math.sin(ang) * (r - 2))
                    ctx.lineTo(cx + Math.cos(ang) * (r - (major ? 12 : 7)),
                               cy + Math.sin(ang) * (r - (major ? 12 : 7)))
                    ctx.stroke()
                }

                if (root.showCardinals) {
                    const cards = [
                        { t: "N", a: -90 }, { t: "E", a: 0 },
                        { t: "S", a: 90 }, { t: "W", a: 180 }
                    ]
                    ctx.fillStyle = Md3Theme.colorScheme.colorOnSurface
                    ctx.font = "bold " + Md3Theme.typography.labelMedium.size + "px sans-serif"
                    ctx.textAlign = "center"
                    ctx.textBaseline = "middle"
                    for (let i = 0; i < cards.length; ++i) {
                        const a = root._rad(cards[i].a)
                        ctx.fillText(cards[i].t,
                                     cx + Math.cos(a) * (r - 22),
                                     cy + Math.sin(a) * (r - 22))
                    }
                }

                const nang = root._rad(-90 + 360 * root.progress)
                ctx.strokeStyle = root.valueColor
                ctx.fillStyle = root.valueColor
                ctx.lineWidth = 2.5
                ctx.lineCap = "round"
                ctx.beginPath()
                ctx.moveTo(cx - Math.cos(nang) * 10, cy - Math.sin(nang) * 10)
                ctx.lineTo(cx + Math.cos(nang) * (r - 28), cy + Math.sin(nang) * (r - 28))
                ctx.stroke()
                ctx.beginPath()
                ctx.arc(cx, cy, 5, 0, Math.PI * 2)
                ctx.fill()
            }
        }    }


    onValueChanged: root._requestPaint()
    onDialColorChanged: root._requestPaint()
    onTrackColorChanged: root._requestPaint()
    onWidthChanged: root._requestPaint()
    onHeightChanged: root._requestPaint()
    Component.onCompleted: { root._refreshTreeShown(); root._requestPaint() }

    // Caption sits under the dial — never over N/E/S/W
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: canvas.bottom
        anchors.topMargin: 2
        width: root.size
        horizontalAlignment: Text.AlignHCenter
        visible: root.showValue || root.label.length > 0
        text: root.label.length ? (root.label + " " + root.valueText) : root.valueText
        color: Md3Theme.colorScheme.colorOnSurfaceVariant
        font.family: Md3Theme.typography.fontFamily
        font.pixelSize: Md3Theme.typography.labelMedium.size
        elide: Text.ElideRight
    }
}
