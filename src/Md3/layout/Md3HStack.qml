import QtQuick
import Md3

/// Horizontal stack with spacing, padding, alignment, and expanding spacers.
/// Uses Row for horizontal placement (children keep their own widths). A deferred
/// Timer only adjusts expanders / vertical alignment — avoids polish loops and
/// never zeroes child widths (which stacked every icon at x=0).
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
    default property alias content: contentRow.data

    property bool _applying: false

    implicitWidth: contentRow.implicitWidth + leftPadding + rightPadding
    implicitHeight: Math.max(1, contentRow.implicitHeight + topPadding + bottomPadding)

    Timer {
        id: layoutTimer
        interval: 0
        repeat: false
        onTriggered: root._applyChildHints()
    }

    Row {
        id: contentRow
        clip: root.clipContent
        x: root.leftPadding
        y: root.topPadding
        height: root.fillHeight
                ? Math.max(0, root.height - root.topPadding - root.bottomPadding)
                : implicitHeight
        spacing: root.spacing

        onChildrenChanged: root._scheduleLayout()
        onWidthChanged: root._scheduleLayout()
        onHeightChanged: root._scheduleLayout()
    }

    onWidthChanged: _scheduleLayout()
    onSpacingChanged: _scheduleLayout()
    onAlignmentChanged: _scheduleLayout()
    onStretchChildrenChanged: _scheduleLayout()
    onFillHeightChanged: _scheduleLayout()
    Component.onCompleted: _scheduleLayout()
    Component.onDestruction: layoutTimer.stop()

    function _scheduleLayout() {
        if (!layoutTimer)
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
        // Prefer explicit width, then implicit — never force 0 onto controls.
        const w = c.width
        const iw = c.implicitWidth
        if (typeof w === "number" && w > 0.5)
            return w
        if (typeof iw === "number" && iw > 0.5)
            return iw
        return Math.max(w || 0, iw || 0, 0)
    }

    function _applyChildHints() {
        if (_applying || !contentRow)
            return
        _applying = true

        const kids = contentRow.children
        const availH = contentRow.height
        const availW = Math.max(0, root.width - root.leftPadding - root.rightPadding)

        let fixed = 0
        let expanders = []
        let visibleCount = 0
        for (let i = 0; i < kids.length; ++i) {
            const c = kids[i]
            if (!c || c.visible === false)
                continue
            visibleCount++
            if (c.expand === true)
                expanders.push(c)
            else
                fixed += _childPreferredWidth(c)
        }

        if (expanders.length > 0 && availW > 0) {
            const gaps = Math.max(0, visibleCount - 1) * root.spacing
            const remain = Math.max(0, availW - fixed - gaps)
            const each = remain / expanders.length
            for (let e = 0; e < expanders.length; ++e)
                _setReal(expanders[e], "width", each)
        }

        // Vertical hints only — Row owns horizontal positions.
        if (root.stretchChildren || root.fillHeight || root.alignment !== Md3HStack.Start) {
            for (let i = 0; i < kids.length; ++i) {
                const c = kids[i]
                if (!c || c.visible === false || c.expand === true)
                    continue

                if (root.stretchChildren || root.fillHeight)
                    _setReal(c, "height", availH)

                const ch = Math.max(c.height || 0, c.implicitHeight || 0)
                let y = 0
                if (root.alignment === Md3HStack.Center)
                    y = Math.max(0, (availH - ch) * 0.5)
                else if (root.alignment === Md3HStack.End)
                    y = Math.max(0, availH - ch)
                _setReal(c, "y", y)
            }
        }

        _applying = false
    }
}
