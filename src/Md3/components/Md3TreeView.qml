import QtQuick
import QtQuick.Window

/// Hierarchical tree: `{ title, icon?, children?, expanded?, checked?, data? }`.
Item {
    id: root

    property var model: []
    property int selectedIndex: -1
    property real rowHeight: 40
    property real indent: 20
    property bool showConnectors: false
    property bool checkEnabled: false
    property string filterText: ""
    property bool lazyLoad: false
  property var contextMenu: null

    signal activated(int flatIndex, var node)
    signal expandedChanged(int flatIndex, var node, bool expanded)
    signal checkedChanged()
    signal fetchChildren(var node, var path)
    signal contextMenuRequested(int flatIndex, var node, real globalX, real globalY)

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
    implicitHeight: Math.min(flatRows.length * rowHeight, 360)
    width: parent ? parent.width : implicitWidth
    height: implicitHeight
    clip: true
    focus: true
    activeFocusOnTab: true

    function _pathKey(path) {
        return JSON.stringify(path || [])
    }

    function isChecked(path) {
        const n = _nodeAtPath(path)
        return !!(n && n.checked === true)
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

    function setChecked(path, on) {
        const copy = JSON.parse(JSON.stringify(model))
        let cur = copy
        for (let i = 0; i < path.length; ++i) {
            const idx = path[i]
            if (i === path.length - 1)
                cur[idx].checked = on
            else
                cur = cur[idx].children
        }
        model = copy
        checkedChanged()
    }

    function toggleCheckAt(flatIndex) {
        const row = flatRows[flatIndex]
        if (!row)
            return
        setChecked(row.path, !isChecked(row.path))
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
            event.accepted = true
            break
        case Qt.Key_Down:
            selectedIndex = Math.min(n - 1, selectedIndex < 0 ? 0 : selectedIndex + 1)
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
        }
    }

    Flickable {
        id: flick
        anchors.fill: parent
        contentWidth: width
        contentHeight: col.height
        clip: true
        boundsBehavior: Flickable.StopAtBounds

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
                    }

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 8 + row.depth * root.indent
                        anchors.rightMargin: 8
                        spacing: 4

                        Md3Checkbox {
                            visible: root.checkEnabled
                            anchors.verticalCenter: parent.verticalCenter
                            checked: row.node.checked === true
                            onToggled: function (state) {
                                root.setChecked(row.path, state === Qt.Checked)
                            }
                        }

                        Item {
                            width: 32
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
                                onClicked: root.toggleAt(row.index)
                            }
                        }

                        Md3Icon {
                            visible: !!(row.node.icon && String(row.node.icon).length)
                            anchors.verticalCenter: parent.verticalCenter
                            icon: String(row.node.icon)
                            size: 20
                            iconColor: row.selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                                    : Md3Theme.colorScheme.colorOnSurfaceVariant
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            width: Math.max(40, parent.width - (root.checkEnabled ? 120 : 88))
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
                        anchors.leftMargin: 8 + row.depth * root.indent + (root.checkEnabled ? 36 : 0) + 32
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        z: -1
                        onClicked: function (mouse) {
                            if (mouse.button === Qt.RightButton) {
                                const win = Window.window
                                const g = mapToGlobal(mouse.x, mouse.y)
                                contextMenuRequested(row.index, row.node, g.x, g.y)
                                if (root.contextMenu)
                                    root.contextMenu.popup(g.x, g.y)
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
}
