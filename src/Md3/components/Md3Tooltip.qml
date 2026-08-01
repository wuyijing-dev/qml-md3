import QtQuick
import Md3

/// Plain or rich tooltip: hover, keyboard focus, and long-press; flips to stay on-screen.
Item {
    id: root

    enum Placement { Top, Bottom, Start, End }

    property string text: ""
    property bool open: false
    property int showDelay: 500
    property int longPressMs: 550
    property bool showOnFocus: true
    property int placement: Md3Tooltip.Top
    /// Applied placement after edge avoidance (read-only for hosts).
    property int effectivePlacement: placement
    default property alias content: host.data

    width: host.childrenRect.width
    height: host.childrenRect.height

    Accessible.role: Accessible.StaticText
    Accessible.name: text.length ? text : qsTr("Tooltip")

    function showNow() {
        if (text.length === 0)
            return
        _reposition()
        open = true
    }

    function hideNow() {
        delay.stop()
        open = false
    }

    function _reposition() {
        const tipW = Math.max(tip.implicitWidth + 16, 32)
        const tipH = Math.max(tip.implicitHeight + 8, 24)
        const gap = 4
        let place = placement
        const win = Md3OverlayHost.resolveWindow(null, root)
        const content = win && win.contentItem ? win.contentItem : null

        function tryPlace(p) {
            let lx = 0
            let ly = 0
            switch (p) {
            case Md3Tooltip.Bottom:
                lx = (width - tipW) / 2
                ly = height + gap
                break
            case Md3Tooltip.Start:
                lx = -tipW - gap
                ly = (height - tipH) / 2
                break
            case Md3Tooltip.End:
                lx = width + gap
                ly = (height - tipH) / 2
                break
            default: // Top
                lx = (width - tipW) / 2
                ly = -tipH - gap
                break
            }
            if (!content)
                return { ok: true, x: lx, y: ly, p: p }
            const g = mapToItem(content, lx, ly)
            const margin = 8
            const ok = g.x >= margin && g.y >= margin
                    && g.x + tipW <= content.width - margin
                    && g.y + tipH <= content.height - margin
            return { ok: ok, x: lx, y: ly, p: p }
        }

        let best = tryPlace(place)
        if (!best.ok) {
            const order = [Md3Tooltip.Top, Md3Tooltip.Bottom, Md3Tooltip.End, Md3Tooltip.Start]
            for (let i = 0; i < order.length; ++i) {
                if (order[i] === place)
                    continue
                const cand = tryPlace(order[i])
                if (cand.ok) {
                    best = cand
                    break
                }
            }
        }
        effectivePlacement = best.p
        tipBg.x = best.x
        tipBg.y = best.y
        tipBg.width = tipW
        tipBg.height = tipH
    }

    FocusScope {
        id: host
        anchors.fill: parent
        onActiveFocusChanged: {
            if (!root.showOnFocus)
                return
            if (activeFocus)
                delay.restart()
            else if (!hover.hovered && !press.pressed)
                root.hideNow()
        }
    }

    Timer {
        id: delay
        interval: root.showDelay
        onTriggered: root.showNow()
    }

    HoverHandler {
        id: hover
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onHoveredChanged: {
            if (hovered)
                delay.restart()
            else if (!host.activeFocus)
                root.hideNow()
        }
    }

    TapHandler {
        id: press
        acceptedDevices: PointerDevice.TouchScreen | PointerDevice.Stylus
        longPressThreshold: root.longPressMs
        onLongPressed: root.showNow()
        onCanceled: root.hideNow()
        onReleased: root.hideNow()
    }

    Rectangle {
        id: tipBg
        visible: root.open && root.text.length > 0
        z: 2000
        radius: Md3Theme.shape.extraSmall
        color: Md3Theme.colorScheme.inverseSurface
        opacity: visible ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: Md3Motion.overlayDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.standard
            }
        }

        Text {
            id: tip
            anchors.centerIn: parent
            text: root.text
            color: Md3Theme.colorScheme.colorOnInverseSurface
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.bodySmall.size
            wrapMode: Text.Wrap
            width: Math.min(implicitWidth, 280)
        }
    }

    onWidthChanged: if (open) _reposition()
    onHeightChanged: if (open) _reposition()
    onTextChanged: if (open) _reposition()
    onPlacementChanged: if (open) _reposition()
}
