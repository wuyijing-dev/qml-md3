import QtQuick

/// Hierarchical tree: model nodes `{ title, icon?, children?, expanded?, data? }`.
Item {
    id: root

    property var model: []
    property int selectedIndex: -1 // index into flatRows
    property real rowHeight: 40
    property real indent: 20
    property bool showConnectors: false

    signal activated(int flatIndex, var node)
    signal expandedChanged(int flatIndex, var node, bool expanded)

    readonly property var flatRows: {
        const out = []
        function walk(nodes, depth, parentPath) {
            if (!nodes)
                return
            for (let i = 0; i < nodes.length; ++i) {
                const n = nodes[i]
                if (!n)
                    continue
                const kids = n.children
                const hasChildren = !!(kids && kids.length > 0)
                const expanded = n.expanded === true
                const path = parentPath.concat([i])
                out.push({
                    node: n,
                    depth: depth,
                    hasChildren: hasChildren,
                    expanded: expanded,
                    path: path
                })
                if (hasChildren && expanded)
                    walk(kids, depth + 1, path)
            }
        }
        walk(root.model, 0, [])
        return out
    }

    implicitWidth: 280
    implicitHeight: Math.min(flatRows.length * rowHeight, 360)
    width: parent ? parent.width : implicitWidth
    height: implicitHeight
    clip: true

    function toggleAt(flatIndex) {
        const row = flatRows[flatIndex]
        if (!row || !row.hasChildren)
            return
        const next = !row.expanded
        _setExpandedAtPath(row.path, next)
        expandedChanged(flatIndex, row.node, next)
    }

    function _setExpandedAtPath(path, expanded) {
        // Mutate a deep copy so model change notifies
        const copy = JSON.parse(JSON.stringify(model))
        let cur = copy
        for (let i = 0; i < path.length; ++i) {
            const idx = path[i]
            if (i === path.length - 1) {
                cur[idx].expanded = expanded
            } else {
                cur = cur[idx].children
            }
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
                    readonly property bool selected: root.selectedIndex === index

                    Rectangle {
                        anchors.fill: parent
                        color: row.selected ? Md3Theme.colorScheme.secondaryContainer : "transparent"
                        radius: Md3Theme.shape.small
                        anchors.leftMargin: 4
                        anchors.rightMargin: 4
                    }

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 8 + row.depth * root.indent
                        anchors.rightMargin: 8
                        spacing: 4

                        Item {
                            width: 32
                            height: parent.height
                            Md3Icon {
                                anchors.centerIn: parent
                                visible: row.hasChildren
                                icon: "expand_more"
                                size: 20
                                iconColor: Md3Theme.colorScheme.colorOnSurfaceVariant
                                rotation: row.expanded ? 0 : -90
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
                            icon: row.node.icon !== undefined ? String(row.node.icon) : ""
                            size: 20
                            iconColor: row.selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                                    : Md3Theme.colorScheme.colorOnSurfaceVariant
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            width: Math.max(40, parent.width - 80)
                            text: row.node.title !== undefined ? String(row.node.title)
                                  : (row.node.text !== undefined ? String(row.node.text) : "")
                            elide: Text.ElideRight
                            color: row.selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                                : Md3Theme.colorScheme.colorOnSurface
                            font.family: Md3Theme.typography.fontFamily
                            font.pixelSize: Md3Theme.typography.bodyLarge.size
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        anchors.leftMargin: 8 + row.depth * root.indent + 32
                        z: -1
                        onClicked: {
                            root.selectedIndex = row.index
                            root.activated(row.index, row.node)
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
