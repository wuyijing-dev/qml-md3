import QtQuick
import Md3

/// Horizontal stack with spacing, padding, alignment, and expanding spacers.
/// Manual Item layout (not Row): setting y/height on Row children re-enters
/// updatePolish and triggers "polish() loop" warnings.
Item {
    id: root

    enum Alignment {
        Start,
        Center,
        End
    }

    property real spacing: 8
    property real padding: 0
    property real leftPadding: padding
    property real rightPadding: padding
    property real topPadding: padding
    property real bottomPadding: padding
    property bool fillHeight: false
    property bool stretchChildren: false
    property bool clipContent: false
    property int alignment: Md3HStack.Center
    default property alias content: contentHost.data

    property bool _applying: false

    implicitWidth: leftPadding + rightPadding + contentHost._laidOutWidth
    implicitHeight: Math.max(1, topPadding + bottomPadding + contentHost._laidOutHeight)

    Timer {
        id: layoutTimer
        interval: 0
        repeat: false
        onTriggered: root._applyLayout()
    }

    Item {
        id: contentHost
        clip: root.clipContent
        x: root.leftPadding
        y: root.topPadding
        width: {
            const inner = root.width - root.leftPadding - root.rightPadding
            if (inner > 0.5)
                return inner
            return Math.max(0, _laidOutWidth)
        }
        height: root.fillHeight
                ? Math.max(0, root.height - root.topPadding - root.bottomPadding)
                : Math.max(1, _laidOutHeight)

        property real _laidOutWidth: 0
        property real _laidOutHeight: 1

        onChildrenChanged: root._scheduleLayout()
    }

    onWidthChanged: _scheduleLayout()
    onHeightChanged: _scheduleLayout()
    onSpacingChanged: _scheduleLayout()
    onAlignmentChanged: _scheduleLayout()
    onStretchChildrenChanged: _scheduleLayout()
    onFillHeightChanged: _scheduleLayout()
    onLeftPaddingChanged: _scheduleLayout()
    onRightPaddingChanged: _scheduleLayout()
    onTopPaddingChanged: _scheduleLayout()
    onBottomPaddingChanged: _scheduleLayout()
    Component.onCompleted: _scheduleLayout()
    Component.onDestruction: layoutTimer.stop()

    function _scheduleLayout() {
        if (_applying || !layoutTimer)
            return
        layoutTimer.restart()
    }

    function _setReal(item, prop, value) {
        if (!item)
            return
        const cur = item[prop]
        if (typeof cur === "number" && Math.abs(cur - value) < 0.5)
            return
        item[prop] = value
    }

    function _childPreferredWidth(c) {
        // Never force 0 — that stacked every icon at x=0 in an older layout pass.
        const w = Number(c.width) || 0
        const iw = Number(c.implicitWidth) || 0
        return Math.max(w, iw, 0)
    }

    function _childPreferredHeight(c) {
        const h = Number(c.height) || 0
        const ih = Number(c.implicitHeight) || 0
        return Math.max(h, ih, 0)
    }

    function _applyLayout() {
        if (_applying || !contentHost)
            return
        _applying = true

        const kids = contentHost.children
        const availW = contentHost.width

        let fixed = 0
        let expanders = []
        let visible = []
        let maxH = 0
        for (let i = 0; i < kids.length; ++i) {
            const c = kids[i]
            if (!c || c.visible === false)
                continue
            visible.push(c)
            if (c.expand === true)
                expanders.push(c)
            else
                fixed += _childPreferredWidth(c)
            maxH = Math.max(maxH, _childPreferredHeight(c))
        }

        const gaps = Math.max(0, visible.length - 1) * root.spacing
        let expandEach = 0
        if (expanders.length > 0 && availW > 0)
            expandEach = Math.max(0, (availW - fixed - gaps) / expanders.length)

        const boxH = root.fillHeight
                ? Math.max(0, root.height - root.topPadding - root.bottomPadding)
                : Math.max(1, maxH)

        let x = 0
        for (let i = 0; i < visible.length; ++i) {
            const c = visible[i]
            const isExpand = c.expand === true
            const w = isExpand ? expandEach : _childPreferredWidth(c)

            if (isExpand)
                _setReal(c, "width", w)

            let h = _childPreferredHeight(c)
            if (root.stretchChildren || root.fillHeight) {
                h = boxH
                _setReal(c, "height", h)
            }

            let y = 0
            if (root.alignment === Md3HStack.Center)
                y = Math.max(0, (boxH - h) * 0.5)
            else if (root.alignment === Md3HStack.End)
                y = Math.max(0, boxH - h)

            _setReal(c, "x", x)
            _setReal(c, "y", y)
            x += w + root.spacing
        }

        const laidW = visible.length > 0 ? Math.max(0, x - root.spacing) : 0
        const laidH = root.fillHeight ? boxH : Math.max(1, maxH)
        if (Math.abs(contentHost._laidOutWidth - laidW) >= 0.5)
            contentHost._laidOutWidth = laidW
        if (Math.abs(contentHost._laidOutHeight - laidH) >= 0.5)
            contentHost._laidOutHeight = laidH

        _applying = false
    }
}
