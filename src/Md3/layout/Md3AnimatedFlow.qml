import QtQuick

// Flow layout: children (chips, ChipGroup, ButtonGroup, …) reflow with spatial easing.
Item {
    id: root

    property alias content: host.data
    default property alias data: host.data

    property real spacing: 8
    property real rowSpacing: 8
    property bool animate: true
    property int moveDuration: Md3Motion.spatialDuration
    property var moveEasing: Md3Motion.spatialDefault
    property bool fillWidth: true

    readonly property int rowCount: _rowCount
    readonly property bool wrapped: _rowCount > 1
    readonly property real contentHeight: _contentHeight
    readonly property real contentWidth: _contentWidth
    property int _rowCount: 1
    property bool _firstLayout: true
    property real _contentWidth: 0
    property real _contentHeight: 0
    /// Per-child last size { w, h } keyed by child index — no dynamic props on Items
    property var _sizeCache: ({})
    property var _animCache: ({})

    implicitWidth: fillWidth && parent ? parent.width : _contentWidth
    implicitHeight: Math.max(_contentHeight, 0)
    width: fillWidth && parent ? parent.width : implicitWidth
    height: implicitHeight

    Item {
        id: host
        anchors.left: parent.left
        anchors.top: parent.top
        width: root.width
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
        const w = item.implicitWidth > 0 ? item.implicitWidth : item.width
        const h = item.implicitHeight > 0 ? item.implicitHeight : item.height
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

    function relayout() {
        const kids = host.children
        const maxW = Math.max(0, root.width)
        let x = 0
        let y = 0
        let rowH = 0
        let rows = 1
        let maxRowW = 0
        const sizes = ({})

        for (let i = 0; i < kids.length; ++i) {
            const c = kids[i]
            if (!c || c.visible === false)
                continue
            const sz = _itemSize(c)
            sizes[i] = { w: sz.width, h: sz.height }
            if (sz.width <= 0 && sz.height <= 0)
                continue

            if (x > 0 && maxW > 0 && x + sz.width > maxW) {
                maxRowW = Math.max(maxRowW, x - root.spacing)
                x = 0
                y += rowH + root.rowSpacing
                rowH = 0
                rows++
            }

            _moveTo(c, i, "x", x)
            _moveTo(c, i, "y", y)
            x += sz.width + root.spacing
            rowH = Math.max(rowH, sz.height)
        }

        if (x > 0)
            maxRowW = Math.max(maxRowW, x - root.spacing)

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
