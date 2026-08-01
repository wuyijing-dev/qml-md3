import QtQuick
import Md3

/// Rotary knob-style gauge — drag or arrow keys to change value.
Item {
    id: root

    property real value: 0
    property real from: 0
    property real to: 100
    property real step: 1
    property string label: ""
    property string unit: ""
    property int decimals: 0
    property real startAngle: -135
    property real sweepAngle: 270
    property color trackColor: Md3Theme.colorScheme.gaugeTrack
    property color valueColor: Md3Theme.colorScheme.primary
    property color knobColor: Md3Theme.colorScheme.gaugeDial
    property bool showValue: true
    property bool interactive: true
    property real size: 140

    signal valueEdited(real value)

    readonly property real progress: {
        const span = Math.max(1e-6, to - from)
        return Math.max(0, Math.min(1, (value - from) / span))
    }
    readonly property string valueText: Number(value).toFixed(decimals) + (unit.length ? unit : "")
    readonly property real _captionH: (showValue || label.length) ? 36 : 0

    width: size
    height: size + _captionH
    implicitWidth: size
    implicitHeight: size + _captionH
    focus: true
    activeFocusOnTab: interactive


    property var hostWindow: null
    property bool _treeShown: true
    property bool _paintPending: false

    function _refreshTreeShown() {
        const ok = Md3TreeVisibility.isSceneActive(root, root.hostWindow)
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

    Timer {
        // Fast while shown/pending; slow while opacity-hidden so resume still works.
        interval: root._treeShown || root._paintPending ? 2000 : 6000
        running: root.visible
        repeat: true
        onTriggered: root._refreshTreeShown()
    }
    Connections {
        target: Qt.application
        function onStateChanged() { root._refreshTreeShown() }
    }
    onVisibleChanged: root._refreshTreeShown()

    Accessible.role: Accessible.Dial
    Accessible.name: label.length ? label : qsTr("Knob")
    // Accessible.value is not available on Item in all Qt 6.x kits — use description.
    Accessible.description: valueText
    Accessible.onIncreaseAction: if (interactive) _nudge(1)
    Accessible.onDecreaseAction: if (interactive) _nudge(-1)

    function _rad(deg) { return deg * Math.PI / 180 }

    function _clampValue(v) {
        return Math.max(from, Math.min(to, v))
    }

    function _setValue(v, announce) {
        const next = _clampValue(v)
        if (Math.abs(next - value) < 1e-9)
            return
        value = next
        valueEdited(next)
        if (announce)
            Md3Accessibility.announce(valueText)
    }

    function _nudge(steps) {
        const s = step > 0 ? step : 1
        _setValue(value + steps * s, true)
    }

    /// Map pointer in canvas coords → value along the dial arc.
    function _valueFromCanvasPos(px, py) {
        const cx = canvas.width / 2
        const cy = canvas.height / 2
        let deg = Math.atan2(py - cy, px - cx) * 180 / Math.PI
        // Normalize into [startAngle, startAngle+sweep]
        let rel = deg - startAngle
        while (rel < 0) rel += 360
        while (rel >= 360) rel -= 360
        const span = Math.max(1e-6, sweepAngle)
        let t = rel / span
        if (rel > sweepAngle) {
            // Past arc end — snap to nearer endpoint
            t = (rel - sweepAngle) < (360 - rel) ? 1 : 0
        }
        t = Math.max(0, Math.min(1, t))
        const raw = from + t * (to - from)
        if (step > 0) {
            const steps = Math.round((raw - from) / step)
            return _clampValue(from + steps * step)
        }
        return _clampValue(raw)
    }

    Keys.onPressed: function (event) {
        if (!interactive)
            return
        if (event.key === Qt.Key_Left || event.key === Qt.Key_Down
                || event.key === Qt.Key_Minus) {
            _nudge(-1)
            event.accepted = true
        } else if (event.key === Qt.Key_Right || event.key === Qt.Key_Up
                   || event.key === Qt.Key_Plus || event.key === Qt.Key_Equal) {
            _nudge(1)
            event.accepted = true
        } else if (event.key === Qt.Key_Home) {
            _setValue(from, true)
            event.accepted = true
        } else if (event.key === Qt.Key_End) {
            _setValue(to, true)
            event.accepted = true
        } else if (event.key === Qt.Key_PageUp) {
            _nudge(10)
            event.accepted = true
        } else if (event.key === Qt.Key_PageDown) {
            _nudge(-10)
            event.accepted = true
        }
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
            width: root.size
            height: root.size
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            onPaint: {
                const ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                const cx = width / 2
                const cy = height / 2
                const r = Math.min(width, height) / 2 - 4
                const a0 = root._rad(root.startAngle)
                const a1 = root._rad(root.startAngle + root.sweepAngle)
                const ap = root._rad(root.startAngle + root.sweepAngle * root.progress)

                ctx.lineWidth = 6
                ctx.lineCap = "round"
                ctx.strokeStyle = root.trackColor
                ctx.beginPath()
                ctx.arc(cx, cy, r - 2, a0, a1, false)
                ctx.stroke()
                ctx.strokeStyle = root.valueColor
                ctx.beginPath()
                ctx.arc(cx, cy, r - 2, a0, ap, false)
                ctx.stroke()

                ctx.beginPath()
                ctx.arc(cx, cy, r * 0.62, 0, Math.PI * 2)
                ctx.fillStyle = root.knobColor
                ctx.fill()
                ctx.strokeStyle = Md3Theme.colorScheme.outline
                ctx.lineWidth = 1.5
                ctx.stroke()

                const nr = r * 0.42
                ctx.strokeStyle = root.valueColor
                ctx.lineWidth = 3
                ctx.lineCap = "round"
                ctx.beginPath()
                ctx.moveTo(cx + Math.cos(ap) * (nr * 0.25), cy + Math.sin(ap) * (nr * 0.25))
                ctx.lineTo(cx + Math.cos(ap) * nr, cy + Math.sin(ap) * nr)
                ctx.stroke()

                ctx.beginPath()
                ctx.arc(cx, cy, 4, 0, Math.PI * 2)
                ctx.fillStyle = root.valueColor
                ctx.fill()
            }

            MouseArea {
                anchors.fill: parent
                enabled: root.interactive
                hoverEnabled: true
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                preventStealing: true
                onPressed: function (mouse) {
                    root.forceActiveFocus()
                    root._setValue(root._valueFromCanvasPos(mouse.x, mouse.y), false)
                }
                onPositionChanged: function (mouse) {
                    if (pressed)
                        root._setValue(root._valueFromCanvasPos(mouse.x, mouse.y), false)
                }
                onReleased: Md3Accessibility.announce(root.valueText)
            }
        }    }


    onValueChanged: root._requestPaint()
    onKnobColorChanged: root._requestPaint()
    onTrackColorChanged: root._requestPaint()
    onWidthChanged: root._requestPaint()
    onHeightChanged: root._requestPaint()
    Component.onCompleted: { root._refreshTreeShown(); root._requestPaint() }

    Md3FocusRing {
        anchors.horizontalCenter: canvas.horizontalCenter
        anchors.verticalCenter: canvas.verticalCenter
        width: canvas.width + 8
        height: canvas.height + 8
        radius: width / 2
        focused: root.activeFocus
        visualFocus: root.activeFocus
        controlEnabled: root.interactive
    }

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: canvas.bottom
        anchors.topMargin: 2
        width: root.size
        spacing: 0

        Text {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            visible: root.showValue
            text: root.valueText
            color: Md3Theme.colorScheme.colorOnSurface
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.labelLarge.size
            font.weight: Font.Medium
        }
        Text {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            visible: root.label.length > 0
            text: root.label
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.labelSmall.size
        }
    }
}
