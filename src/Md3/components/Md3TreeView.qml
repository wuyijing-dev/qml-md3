import QtQuick
import Md3

/// Hierarchical tree: `{ title, icon?, children?, expanded?, checked?, data? }`.
Item {
    id: root

    property var model: []
    property int selectedIndex: -1
    /// Row height follows Theme density (override for custom trees).
    property real rowHeight: Md3Theme.tableRowHeight
    property real indent: 20
    property bool showConnectors: false
    property bool checkEnabled: false
    property bool triStateCheck: true
    property string filterText: ""
    /// Built-in filter field (no external TextField sync glue).
    property bool showFilter: false
    property string filterPlaceholder: qsTr("Filter")
    property string filterLabel: qsTr("Filter")
    /// Expand all / Collapse all buttons beside the filter.
    property bool showExpandControls: false
    property bool lazyLoad: false
    property var contextMenu: null
    /// Optional explicit Window for context-menu overlay coords.
    property var overlayWindow: null
    /// Cap scroll viewport in Column layouts (0 = natural full content height).
    property real preferredMaxHeight: 0

    signal activated(int flatIndex, var node)
    signal expandedChanged(int flatIndex, var node, bool expanded)
    signal checkedChanged()
    signal fetchChildren(var node, var path)
    signal contextMenuRequested(int flatIndex, var node, real globalX, real globalY)

    Accessible.role: Accessible.Tree
    Accessible.name: qsTr("Tree view")

    readonly property real _chromeH: {
        if (!showFilter && !showExpandControls)
            return 0
        // Prefer live chrome height once laid out (label + field); fall back to token.
        if (chrome.visible && chrome.height > 1)
            return chrome.height + 4
        return Md3Theme.fieldHeight + 8
    }

    readonly property real _contentH: flatRows.length * rowHeight
    readonly property real _bodyH: preferredMaxHeight > 0
                                   ? Math.min(_contentH, preferredMaxHeight)
                                   : _contentH

    readonly property var flatRows: {
        const out = []
        const filter = String(filterText || "").trim().toLowerCase()
        function titleOf(n) {
            if (!n)
                return ""
            if (n.title !== undefined)
                return String(n.title)
            if (n.text !== undefined)
                return String(n.text)
            return ""
        }
        function nodeMatches(n) {
            if (!filter.length)
                return true
            return titleOf(n).toLowerCase().indexOf(filter) >= 0
        }
        function subtreeMatches(n) {
            if (nodeMatches(n))
                return true
            const kids = n.children
            if (!kids)
                return false
            for (let i = 0; i < kids.length; ++i) {
                if (subtreeMatches(kids[i]))
                    return true
            }
            return false
        }
        function walk(nodes, depth, parentPath, forceOpen) {
            if (!nodes)
                return
            for (let i = 0; i < nodes.length; ++i) {
                const n = nodes[i]
                if (!n)
                    continue
                const kids = n.children
                const lazyPending = lazyLoad && n.childrenLoaded === false
                const hasChildren = lazyPending || !!(kids && kids.length > 0)
                const expanded = forceOpen || filter.length > 0 || n.expanded === true
                const path = parentPath.concat([i])
                const include = !filter.length || nodeMatches(n) || subtreeMatches(n)
                if (!include)
                    continue
                out.push({
                    node: n,
                    depth: depth,
                    hasChildren: hasChildren,
                    expanded: expanded && hasChildren,
                    path: path,
                    lazyPending: lazyPending
                })
                if (hasChildren && (expanded || filter.length > 0))
                    walk(kids, depth + 1, path, filter.length > 0)
            }
        }
        walk(root.model, 0, [], false)
        return out
    }

    implicitWidth: 280
    implicitHeight: _bodyH + _chromeH
    width: parent ? parent.width : implicitWidth
    // Do not bind height → implicitHeight (breaks anchors.fill hosts).
    readonly property Md3HeightSync _heightSync: Md3HeightSync {
        target: root
        enabled: !root.anchors.fill
        policy: Md3HeightSync.AtLeastImplicit
    }
    clip: true
    focus: true
    activeFocusOnTab: true

    function _pathKey(path) {
        return JSON.stringify(path || [])
    }

    function isChecked(path) {
        const n = _nodeAtPath(path)
        return !!(n && (n.checkState === Qt.Checked || n.checked === true))
    }

    function checkStateAt(path) {
        const n = _nodeAtPath(path)
        if (!n)
            return Qt.Unchecked
        if (n.checkState !== undefined)
            return n.checkState
        return n.checked ? Qt.Checked : Qt.Unchecked
    }

    function _nodeAtPath(path) {
        let cur = model
        let node = null
        for (let i = 0; i < path.length; ++i) {
            if (!cur || path[i] < 0 || path[i] >= cur.length)
                return null
            node = cur[path[i]]
            cur = node && node.children ? node.children : null
        }
        return node
    }

    function _applyCheckStateDown(node, state) {
        if (!node)
            return
        node.checkState = state
        node.checked = state === Qt.Checked
        if (!node.children)
            return
        for (let i = 0; i < node.children.length; ++i)
            _applyCheckStateDown(node.children[i], state)
    }

    function _syncCheckStateUp(nodes) {
        if (!nodes)
            return Qt.Unchecked
        for (let i = 0; i < nodes.length; ++i) {
            const n = nodes[i]
            if (!n)
                continue
            if (n.children && n.children.length) {
                _syncCheckStateUp(n.children)
                let checked = 0
                let partial = 0
                for (let j = 0; j < n.children.length; ++j) {
                    const cs = n.children[j].checkState !== undefined
                            ? n.children[j].checkState
                            : (n.children[j].checked ? Qt.Checked : Qt.Unchecked)
                    if (cs === Qt.Checked)
                        ++checked
                    else if (cs === Qt.PartiallyChecked)
                        ++partial
                }
                if (checked === n.children.length)
                    n.checkState = Qt.Checked
                else if (checked === 0 && partial === 0)
                    n.checkState = Qt.Unchecked
                else
                    n.checkState = Qt.PartiallyChecked
                n.checked = n.checkState === Qt.Checked
            } else {
                n.checkState = n.checkState !== undefined ? n.checkState
                                                          : (n.checked ? Qt.Checked : Qt.Unchecked)
                n.checked = n.checkState === Qt.Checked
            }
        }
    }

    function setChecked(path, on) {
        setCheckState(path, on ? Qt.Checked : Qt.Unchecked)
    }

    function setCheckState(path, state) {
        const copy = JSON.parse(JSON.stringify(model))
        let cur = copy
        for (let i = 0; i < path.length; ++i) {
            const idx = path[i]
            if (i === path.length - 1) {
                const node = cur[idx]
                if (triStateCheck) {
                    const target = (state === Qt.PartiallyChecked) ? Qt.Checked : state
                    _applyCheckStateDown(node, target)
                } else {
                    node.checkState = state === Qt.Checked ? Qt.Checked : Qt.Unchecked
                    node.checked = node.checkState === Qt.Checked
                }
            } else {
                cur = cur[idx].children
            }
        }
        if (triStateCheck)
            _syncCheckStateUp(copy)
        model = copy
        checkedChanged()
    }

    function toggleCheckAt(flatIndex) {
        const row = flatRows[flatIndex]
        if (!row)
            return
        const cs = checkStateAt(row.path)
        const next = cs === Qt.Checked ? Qt.Unchecked : Qt.Checked
        setCheckState(row.path, next)
    }

    function toggleAt(flatIndex) {
        const row = flatRows[flatIndex]
        if (!row || !row.hasChildren)
            return
        if (lazyLoad && row.lazyPending) {
            fetchChildren(row.node, row.path)
            return
        }
        const next = !row.expanded
        _setExpandedAtPath(row.path, next)
        expandedChanged(flatIndex, row.node, next)
    }

    function _setExpandedAtPath(path, expanded) {
        const copy = JSON.parse(JSON.stringify(model))
        let cur = copy
        for (let i = 0; i < path.length; ++i) {
            const idx = path[i]
            if (i === path.length - 1)
                cur[idx].expanded = expanded
            else
                cur = cur[idx].children
        }
        model = copy
    }

    function expandAll() {
        function mark(nodes, on) {
            if (!nodes)
                return
            for (let i = 0; i < nodes.length; ++i) {
                if (nodes[i].children && nodes[i].children.length) {
                    nodes[i].expanded = on
                    mark(nodes[i].children, on)
                }
            }
        }
        const copy = JSON.parse(JSON.stringify(model))
        mark(copy, true)
        model = copy
        forceActiveFocus()
        Qt.callLater(function () { root._ensureVisible(Math.max(0, root.selectedIndex)) })
    }

    function collapseAll() {
        function mark(nodes, on) {
            if (!nodes)
                return
            for (let i = 0; i < nodes.length; ++i) {
                if (nodes[i].children && nodes[i].children.length) {
                    nodes[i].expanded = on
                    mark(nodes[i].children, on)
                }
            }
        }
        const copy = JSON.parse(JSON.stringify(model))
        mark(copy, false)
        model = copy
        forceActiveFocus()
        Qt.callLater(function () { root._ensureVisible(Math.max(0, root.selectedIndex)) })
    }

    function _titleText(node) {
        if (!node)
            return ""
        if (node.title !== undefined)
            return String(node.title)
        if (node.text !== undefined)
            return String(node.text)
        return ""
    }

    Keys.onPressed: function (event) {
        const n = flatRows.length
        if (!n)
            return
        switch (event.key) {
        case Qt.Key_Up:
            selectedIndex = Math.max(0, selectedIndex <= 0 ? 0 : selectedIndex - 1)
            _ensureVisible(selectedIndex)
            event.accepted = true
            break
        case Qt.Key_Down:
            selectedIndex = Math.min(n - 1, selectedIndex < 0 ? 0 : selectedIndex + 1)
            _ensureVisible(selectedIndex)
            event.accepted = true
            break
        case Qt.Key_Left:
            if (selectedIndex >= 0) {
                const row = flatRows[selectedIndex]
                if (row && row.expanded && row.hasChildren)
                    toggleAt(selectedIndex)
                else if (row && row.depth > 0) {
                    for (let i = selectedIndex - 1; i >= 0; --i) {
                        if (flatRows[i].depth === row.depth - 1) {
                            selectedIndex = i
                            break
                        }
                    }
                }
                _ensureVisible(selectedIndex)
            }
            event.accepted = true
            break
        case Qt.Key_Right:
            if (selectedIndex >= 0) {
                const row = flatRows[selectedIndex]
                if (row && row.hasChildren) {
                    if (!row.expanded)
                        toggleAt(selectedIndex)
                    else if (selectedIndex + 1 < n)
                        selectedIndex = selectedIndex + 1
                }
                _ensureVisible(selectedIndex)
            }
            event.accepted = true
            break
        case Qt.Key_Return:
        case Qt.Key_Enter:
            if (selectedIndex >= 0) {
                const row = flatRows[selectedIndex]
                activated(selectedIndex, row.node)
            }
            event.accepted = true
            break
        case Qt.Key_Space:
            if (checkEnabled && selectedIndex >= 0)
                toggleCheckAt(selectedIndex)
            event.accepted = true
            break
        case Qt.Key_Home:
            selectedIndex = 0
            _ensureVisible(0)
            event.accepted = true
            break
        case Qt.Key_End:
            selectedIndex = n - 1
            _ensureVisible(selectedIndex)
            event.accepted = true
            break
        }
    }

    function _ensureVisible(flatIndex) {
        if (flatIndex < 0 || !flick)
            return
        const y = flatIndex * root.rowHeight
        const viewTop = flick.contentY
        const viewBot = viewTop + flick.height
        if (y < viewTop)
            flick.contentY = Math.max(0, y)
        else if (y + root.rowHeight > viewBot)
            flick.contentY = Math.max(0, y + root.rowHeight - flick.height)
    }

    Md3HStack {
        id: chrome
        visible: root.showFilter || root.showExpandControls
        width: parent.width
        spacing: 8
        alignment: Md3HStack.Center

        Md3TextField {
            visible: root.showFilter
            property bool expand: true
            label: root.filterLabel
            placeholderText: root.filterPlaceholder
            text: root.filterText
            leadingIcon: "search"
            onTextChanged: root.filterText = text
        }

        Md3Button {
            id: expandBtn
            visible: root.showExpandControls
            text: qsTr("Expand all")
            variant: Md3Button.Text
            onClicked: root.expandAll()
        }
        Md3Button {
            id: collapseBtn
            visible: root.showExpandControls
            text: qsTr("Collapse all")
            variant: Md3Button.Text
            onClicked: root.collapseAll()
        }
    }

    Flickable {
        id: flick
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.topMargin: root._chromeH
        // Always reserve gutter when vertical bar can appear — avoids label under scrollbar.
        anchors.rightMargin: vBar.needed ? Math.max(vBar.width, 10) : 0
        anchors.bottomMargin: hBar.needed ? Math.max(hBar.height, 10) : 0
        contentWidth: width
        contentHeight: Math.max(col.implicitHeight, col.height)
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.VerticalFlick

        Column {
            id: col
            width: flick.width

            Repeater {
                model: root.flatRows
                delegate: Item {
                    id: row
                    required property int index
                    required property var modelData
                    width: col.width
                    height: root.rowHeight
                    implicitWidth: width
                    implicitHeight: height

                    readonly property var node: modelData.node
                    readonly property int depth: modelData.depth
                    readonly property bool hasChildren: modelData.hasChildren
                    readonly property bool expanded: modelData.expanded
                    readonly property var path: modelData.path
                    readonly property bool selected: root.selectedIndex === index
                    readonly property string title: root._titleText(node)
                    readonly property bool filterHit: {
                        const f = String(root.filterText || "").trim().toLowerCase()
                        return f.length > 0 && title.toLowerCase().indexOf(f) >= 0
                    }

                    Accessible.role: Accessible.TreeItem
                    Accessible.name: title
                    Accessible.checkable: root.checkEnabled
                    Accessible.checked: root.checkEnabled && (row.node.checked === true
                                        || row.node.checkState === Qt.Checked)
                    Accessible.onPressAction: {
                        root.selectedIndex = index
                        root.activated(index, row.node)
                    }

                    // Tree connectors
                    Repeater {
                        model: root.showConnectors ? row.depth : 0
                        delegate: Rectangle {
                            required property int index
                            x: 8 + index * root.indent + root.indent * 0.5
                            width: 1
                            height: parent.height
                            color: Md3Theme.colorScheme.outlineVariant
                            opacity: 0.55
                        }
                    }

                    Rectangle {
                        anchors.fill: parent
                        anchors.leftMargin: 4
                        anchors.rightMargin: 4
                        color: row.selected ? Md3Theme.colorScheme.secondaryContainer : "transparent"
                        radius: Md3Theme.shape.small
                        border.width: row.selected && root.activeFocus ? 2 : 0
                        border.color: Md3Theme.colorScheme.secondary
                    }

                    // Fixed chrome widths so the label gets a real remaining width (ElideRight)
                    // instead of being hard-clipped by Flickable when the pane is narrow.
                    readonly property real _checkW: root.checkEnabled ? 28 : 0
                    readonly property real _chevronW: 28
                    readonly property real _iconW: (row.node.icon && String(row.node.icon).length) ? 22 : 0
                    readonly property real _rowLeft: 8 + row.depth * root.indent
                    readonly property real _rowGap: 8
                    readonly property int _chromeCount: (root.checkEnabled ? 1 : 0) + 1
                                                     + ((row.node.icon && String(row.node.icon).length) ? 1 : 0)
                    readonly property real _labelW: {
                        const gaps = Math.max(0, _chromeCount) * _rowGap
                        const used = _rowLeft + _checkW + _chevronW + _iconW + gaps + 8
                        return Math.max(24, row.width - used)
                    }

                    Row {
                        id: rowInner
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: row._rowLeft
                        anchors.right: parent.right
                        anchors.rightMargin: 8
                        spacing: row._rowGap
                        height: Math.min(parent.height, 36)

                        // Compact check (48px Md3Checkbox overflows rowHeight and steals label width).
                        Item {
                            id: checkSlot
                            visible: root.checkEnabled
                            width: row._checkW
                            height: parent.height

                            Rectangle {
                                anchors.centerIn: parent
                                width: 18
                                height: 18
                                radius: 2
                                color: {
                                    const st = row.node.checkState !== undefined
                                             ? row.node.checkState
                                             : (row.node.checked ? Qt.Checked : Qt.Unchecked)
                                    if (st === Qt.Checked || st === Qt.PartiallyChecked)
                                        return Md3Theme.colorScheme.primary
                                    return "transparent"
                                }
                                border.width: {
                                    const st = row.node.checkState !== undefined
                                             ? row.node.checkState
                                             : (row.node.checked ? Qt.Checked : Qt.Unchecked)
                                    return (st === Qt.Checked || st === Qt.PartiallyChecked) ? 0 : 2
                                }
                                border.color: Md3Theme.colorScheme.colorOnSurfaceVariant

                                // check mark
                                Canvas {
                                    id: checkMark
                                    anchors.fill: parent
                                    anchors.margins: 2
                                    visible: {
                                        const st = row.node.checkState !== undefined
                                                 ? row.node.checkState
                                                 : (row.node.checked ? Qt.Checked : Qt.Unchecked)
                                        return st === Qt.Checked
                                    }
                                    onVisibleChanged: requestPaint()
                                    onWidthChanged: requestPaint()
                                    onHeightChanged: requestPaint()
                                    onPaint: {
                                        const ctx = getContext("2d")
                                        ctx.clearRect(0, 0, width, height)
                                        ctx.strokeStyle = Md3Theme.colorScheme.colorOnPrimary
                                        ctx.lineWidth = 2
                                        ctx.lineCap = "round"
                                        ctx.lineJoin = "round"
                                        ctx.beginPath()
                                        ctx.moveTo(width * 0.15, height * 0.5)
                                        ctx.lineTo(width * 0.4, height * 0.75)
                                        ctx.lineTo(width * 0.85, height * 0.25)
                                        ctx.stroke()
                                    }
                                }
                                // indeterminate bar
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: 10
                                    height: 2
                                    radius: 1
                                    color: Md3Theme.colorScheme.colorOnPrimary
                                    visible: {
                                        const st = row.node.checkState !== undefined
                                                 ? row.node.checkState
                                                 : (row.node.checked ? Qt.Checked : Qt.Unchecked)
                                        return st === Qt.PartiallyChecked
                                    }
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.toggleCheckAt(row.index)
                            }
                        }

                        Item {
                            width: row._chevronW
                            height: parent.height
                            Md3Icon {
                                anchors.centerIn: parent
                                visible: row.hasChildren
                                icon: row.modelData.lazyPending ? "more_horiz" : "expand_more"
                                size: 20
                                iconColor: Md3Theme.colorScheme.colorOnSurfaceVariant
                                rotation: row.expanded && !row.modelData.lazyPending ? 0 : -90
                                Behavior on rotation {
                                    NumberAnimation {
                                        duration: Md3Motion.spatialSnapDuration
                                        easing.type: Easing.BezierSpline
                                        easing.bezierCurve: Md3Motion.emphasized
                                    }
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                enabled: row.hasChildren
                                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                                onClicked: root.toggleAt(row.index)
                            }
                        }

                        Md3Icon {
                            visible: row._iconW > 0
                            width: row._iconW
                            anchors.verticalCenter: parent.verticalCenter
                            icon: String(row.node.icon || "")
                            size: 20
                            iconColor: row.selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                                    : Md3Theme.colorScheme.colorOnSurfaceVariant
                        }

                        Text {
                            width: row._labelW
                            anchors.verticalCenter: parent.verticalCenter
                            text: row.title
                            elide: Text.ElideRight
                            color: row.filterHit ? Md3Theme.colorScheme.primary
                                  : (row.selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                                  : Md3Theme.colorScheme.colorOnSurface)
                            font.family: Md3Theme.typography.fontFamily
                            font.pixelSize: Md3Theme.typography.bodyLarge.size
                            font.weight: row.filterHit ? Font.Medium : Font.Normal
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        anchors.leftMargin: row._rowLeft + row._checkW
                                            + (row._checkW > 0 ? row._rowGap : 0) + row._chevronW
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        z: -1
                        onClicked: function (mouse) {
                            if (mouse.button === Qt.RightButton) {
                                const g = mapToGlobal(mouse.x, mouse.y)
                                contextMenuRequested(row.index, row.node, g.x, g.y)
                                if (root.contextMenu) {
                                    const p = Md3OverlayHost.mapToOverlay(this, mouse.x, mouse.y,
                                                                          root.overlayWindow)
                                    if (root.contextMenu.overlayWindow !== undefined)
                                        root.contextMenu.overlayWindow = root.overlayWindow
                                    root.contextMenu.popup(p.x, p.y)
                                }
                                return
                            }
                            root.selectedIndex = row.index
                            root.activated(row.index, row.node)
                            root.forceActiveFocus()
                        }
                        onDoubleClicked: {
                            if (row.hasChildren)
                                root.toggleAt(row.index)
                            else {
                                root.selectedIndex = row.index
                                root.activated(row.index, row.node)
                            }
                        }
                    }
                }
            }
        }
    }

    Md3ScrollBar {
        id: vBar
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: root._chromeH
        anchors.bottom: parent.bottom
        anchors.bottomMargin: hBar.needed ? Math.max(hBar.height, 10) : 0
        flickable: flick
        orientation: Qt.Vertical
    }

    Md3ScrollBar {
        id: hBar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: vBar.needed ? Math.max(vBar.width, 10) : 0
        anchors.bottom: parent.bottom
        flickable: flick
        orientation: Qt.Horizontal
    }
}
