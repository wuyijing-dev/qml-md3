import QtQuick
import Md3

/// Horizontal stack with spacing, padding, alignment, and expanding spacers.
/// Manual layout (no Row) — avoids QQuickItem::polish() loops from mutating
/// child geometry during Row.updatePolish().
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
    property int _layoutGen: 0

    implicitWidth: contentHost.implicitWidth + leftPadding + rightPadding
    implicitHeight: Math.max(1, contentHost.implicitHeight + topPadding + bottomPadding)

    Item {
        id: contentHost
        clip: root.clipContent
        x: root.leftPadding
        y: root.topPadding
        width: Math.max(0, root.width - root.leftPadding - root.rightPadding)
        height: root.fillHeight
                ? Math.max(0, root.height - root.topPadding - root.bottomPadding)
                : implicitHeight

        property real implicitWidth: 0
        property real implicitHeight: 0

        onChildrenChanged: {
            root._hookChildSizeSignals()
            root._scheduleLayout()
        }
        onWidthChanged: root._scheduleLayout()
        onHeightChanged: root._scheduleLayout()
    }

    onSpacingChanged: _scheduleLayout()
    onAlignmentChanged: _scheduleLayout()
    onStretchChildrenChanged: _scheduleLayout()
    onFillHeightChanged: _scheduleLayout()
    Component.onCompleted: {
        _hookChildSizeSignals()
        _scheduleLayout()
    }

    function _hookChildSizeSignals() {
        const kids = contentHost.children
        for (let i = 0; i < kids.length; ++i) {
            const c = kids[i]
            if (!c)
                continue
            // Disconnect first to avoid stacking handlers on repeated childrenChanged.
            try {
                c.implicitWidthChanged.disconnect(root._scheduleLayout)
            } catch (e) { /* not connected */ }
            try {
                c.implicitHeightChanged.disconnect(root._scheduleLayout)
            } catch (e2) { /* not connected */ }
            try {
                c.visibleChanged.disconnect(root._scheduleLayout)
            } catch (e3) { /* not connected */ }
            c.implicitWidthChanged.connect(root._scheduleLayout)
            c.implicitHeightChanged.connect(root._scheduleLayout)
            c.visibleChanged.connect(root._scheduleLayout)
        }
    }
    function _scheduleLayout() {
        const gen = ++_layoutGen
        Qt.callLater(function () {
            if (gen !== root._layoutGen)
                return
            root._applyChildHints()
        })
    }

    function _setReal(item, prop, value) {
        if (!item)
            return
        const cur = item[prop]
        if (typeof cur === "number" && Math.abs(cur - value) < 0.5)
            return
        item[prop] = value
    }

    function _applyChildHints() {
        if (_applying)
            return
        _applying = true

        const kids = contentHost.children
        const availH = contentHost.height
        const availW = contentHost.width

        let fixed = 0
        let expanders = []
        let visible = []
        for (let i = 0; i < kids.length; ++i) {
            const c = kids[i]
            if (!c || c.visible === false)
                continue
            visible.push(c)
            if (c.expand === true)
                expanders.push(c)
            else
                fixed += Math.max(c.implicitWidth || 0, 0)
        }

        const gaps = Math.max(0, visible.length - 1) * root.spacing
        const remain = Math.max(0, availW - fixed - gaps)
        const each = expanders.length > 0 ? remain / expanders.length : 0

        let x = 0
        let rowH = 0
        for (let i = 0; i < visible.length; ++i) {
            const c = visible[i]
            const isExp = c.expand === true
            const w = isExp ? each : Math.max(c.implicitWidth || 0, 0)
            const hHint = Math.max(c.implicitHeight || 0, 0)
            const h = (root.stretchChildren || root.fillHeight) ? availH : hHint

            _setReal(c, "width", w)
            if (root.stretchChildren || root.fillHeight)
                _setReal(c, "height", h)

            let y = 0
            const ch = Math.max(c.height || 0, hHint)
            if (root.alignment === Md3HStack.Center)
                y = Math.max(0, (availH - ch) * 0.5)
            else if (root.alignment === Md3HStack.End)
                y = Math.max(0, availH - ch)

            _setReal(c, "x", x)
            _setReal(c, "y", y)

            x += w + (i < visible.length - 1 ? root.spacing : 0)
            rowH = Math.max(rowH, ch)
        }

        const laidW = expanders.length > 0 ? availW : Math.max(0, x)
        const laidH = root.fillHeight ? availH : Math.max(rowH, 1)
        if (Math.abs(contentHost.implicitWidth - laidW) >= 0.5)
            contentHost.implicitWidth = laidW
        if (Math.abs(contentHost.implicitHeight - laidH) >= 0.5)
            contentHost.implicitHeight = laidH

        _applying = false
    }
}
