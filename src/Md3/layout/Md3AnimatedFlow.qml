import QtQuick
import Md3

/// Flow layout: children reflow with spatial easing.
/// Sizes use max(explicit, implicit) so callers need not mirror width/height into implicit*.
Item {
    id: root

    enum Alignment {
        Start,
        Center,
        End
    }

    default property alias content: host.data

    property real spacing: 8
    property real rowSpacing: 8
    property real padding: 0
    property real leftPadding: padding
    property real rightPadding: padding
    property real topPadding: padding
    property real bottomPadding: padding
    property bool animate: true
    property int moveDuration: Md3Motion.spatialDuration
    property var moveEasing: Md3Motion.spatialDefault
    property bool fillWidth: true
    property int alignment: Md3AnimatedFlow.Start

    readonly property int rowCount: _rowCount
    readonly property bool wrapped: _rowCount > 1
    readonly property real contentHeight: _contentHeight
    readonly property real contentWidth: _contentWidth
    property int _rowCount: 1
    property bool _firstLayout: true
    property real _contentWidth: 0
    property real _contentHeight: 0
    property var _sizeCache: ({})
    property var _animCache: ({})
    property var _rowRuns: []

    implicitWidth: fillWidth && parent ? parent.width : (_contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(_contentHeight + topPadding + bottomPadding, 0)
    width: fillWidth && parent ? parent.width : implicitWidth
    Binding {
        target: root
        property: "height"
        value: root.implicitHeight
        when: !root.anchors.fill
        restoreMode: Binding.RestoreNone
    }
    readonly property Md3HeightSync _heightSync: Md3HeightSync {
        target: root
        enabled: !root.anchors.fill
        policy: Md3HeightSync.AtLeastImplicit
    }

    Item {
        id: host
        anchors.left: parent.left
        anchors.leftMargin: root.leftPadding
        anchors.top: parent.top
        anchors.topMargin: root.topPadding
        width: Math.max(0, root.width - root.leftPadding - root.rightPadding)
        height: root._contentHeight
    }

    Component {
        id: moveAnim
        NumberAnimation {
            duration: root.moveDuration
            easing.type: Easing.BezierSpline
            easing.bezierCurve: root.moveEasing
        }
    }

    function _itemSize(item) {
        // Prefer the larger of explicit and intrinsic sizes (C++ policy — same on 6.5–6.10).
        let w = Number(Md3QtCompat.preferredWidth(item)) || 0
        let h = Number(Md3QtCompat.preferredHeight(item)) || 0
        if (item.Layout !== undefined) {
            const pw = item.Layout.preferredWidth
            const ph = item.Layout.preferredHeight
            if (pw > 0)
                w = Math.max(w, pw)
            if (ph > 0)
                h = Math.max(h, ph)
        }
        return Qt.size(Math.max(0, w), Math.max(0, h))
    }

    function _animKey(index, prop) {
        return String(index) + "_" + prop
    }

    function _moveTo(item, index, prop, value) {
        if (!item)
            return
        const cur = item[prop]
        if (!root.animate || root._firstLayout || Math.abs(cur - value) < 0.5) {
            item[prop] = value
            return
        }
        const key = _animKey(index, prop)
        const running = root._animCache[key]
        if (running) {
            running.stop()
            running.destroy()
            delete root._animCache[key]
        }
        const anim = moveAnim.createObject(root, {
            target: item,
            property: prop,
            from: cur,
            to: value
        })
        root._animCache[key] = anim
        anim.finished.connect(function () {
            if (root._animCache[key] === anim)
                delete root._animCache[key]
            anim.destroy()
        })
        anim.start()
    }

    function _rowOffset(rowWidth, maxW) {
        if (root.alignment === Md3AnimatedFlow.Center)
            return Math.max(0, (maxW - rowWidth) * 0.5)
        if (root.alignment === Md3AnimatedFlow.End)
            return Math.max(0, maxW - rowWidth)
        return 0
    }

    function relayout() {
        const kids = host.children
        const maxW = Math.max(0, host.width)
        let x = 0
        let y = 0
        let rowH = 0
        let rows = 1
        let maxRowW = 0
        const sizes = ({})
        const placements = []
        let rowItems = []

        function flushRow(atEnd) {
            if (rowItems.length === 0)
                return
            const rowW = x > 0 ? x - root.spacing : 0
            const ox = root._rowOffset(rowW, maxW)
            for (let r = 0; r < rowItems.length; ++r) {
                const p = rowItems[r]
                placements.push({ item: p.item, index: p.index, x: p.x + ox, y: p.y })
            }
            maxRowW = Math.max(maxRowW, rowW)
            rowItems = []
            if (!atEnd) {
                x = 0
                y += rowH + root.rowSpacing
                rowH = 0
                rows++
            }
        }

        for (let i = 0; i < kids.length; ++i) {
            const c = kids[i]
            if (!c || c.visible === false)
                continue
            const sz = _itemSize(c)
            sizes[i] = { w: sz.width, h: sz.height }
            if (sz.width <= 0 && sz.height <= 0)
                continue

            if (x > 0 && maxW > 0 && x + sz.width > maxW)
                flushRow(false)

            rowItems.push({ item: c, index: i, x: x, y: y })
            x += sz.width + root.spacing
            rowH = Math.max(rowH, sz.height)
        }
        flushRow(true)

        for (let p = 0; p < placements.length; ++p) {
            const pl = placements[p]
            _moveTo(pl.item, pl.index, "x", pl.x)
            _moveTo(pl.item, pl.index, "y", pl.y)
        }

        root._sizeCache = sizes
        _rowCount = Math.max(1, rows)
        _contentWidth = maxRowW
        _contentHeight = (rows > 0 && rowH > 0) || y > 0 ? y + rowH : 0
        _firstLayout = false
    }

    function _sizesDirty() {
        const kids = host.children
        const cache = root._sizeCache
        for (let i = 0; i < kids.length; ++i) {
            const c = kids[i]
            if (!c || c.visible === false)
                continue
            const sz = root._itemSize(c)
            const prev = cache[i]
            if (!prev || prev.w !== sz.width || prev.h !== sz.height)
                return true
        }
        return false
    }

    onWidthChanged: Qt.callLater(relayout)
    onSpacingChanged: Qt.callLater(relayout)
    onRowSpacingChanged: Qt.callLater(relayout)
    onPaddingChanged: Qt.callLater(relayout)
    onLeftPaddingChanged: Qt.callLater(relayout)
    onRightPaddingChanged: Qt.callLater(relayout)
    onTopPaddingChanged: Qt.callLater(relayout)
    onBottomPaddingChanged: Qt.callLater(relayout)
    onAlignmentChanged: Qt.callLater(relayout)
    Component.onCompleted: Qt.callLater(relayout)

    Connections {
        target: host
        function onChildrenChanged() {
            root._sizeCache = ({})
            Qt.callLater(root.relayout)
        }
    }

    Timer {
        interval: 48
        running: root.visible && host.children.length > 0
        repeat: true
        onTriggered: {
            if (root._sizesDirty())
                root.relayout()
        }
    }
}
