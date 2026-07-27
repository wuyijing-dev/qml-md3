import QtQuick

/// Browser-like element picker overlay. Exclude the performance chrome via `excludeItem`.
Item {
    id: root

    property Item pickRoot: null
    property Item excludeItem: null
    property bool picking: false
    property var selectedInfo: ({})
    property var hoverInfo: ({})

    signal picked(var info, var item)

    visible: picking
    z: 1000000

    onPickingChanged: {
        if (picking)
            forceActiveFocus()
    }

    Md3Inspector {
        id: inspector
    }

    property var _hoverItem: null
    property var _hoverBounds: ({ x: 0, y: 0, width: 0, height: 0 })

    function _probe(mx, my) {
        if (!pickRoot)
            return
        const local = mapToItem(pickRoot, mx, my)
        // Always exclude this overlay; optional excludeItem for dock chrome etc.
        const hit = inspector.itemAt(pickRoot, local.x, local.y, root, excludeItem)
        if (hit && hit === root)
            return
        _hoverItem = hit
        hoverInfo = hit ? inspector.describe(hit) : ({})
        _hoverBounds = hit ? inspector.mapBounds(hit, root) : ({ x: 0, y: 0, width: 0, height: 0 })
    }

    Rectangle {
        x: root._hoverBounds.x || 0
        y: root._hoverBounds.y || 0
        width: Math.max(0, root._hoverBounds.width || 0)
        height: Math.max(0, root._hoverBounds.height || 0)
        color: Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.primary, 0.18)
        border.width: 2
        border.color: Md3Theme.colorScheme.primary
        radius: 2
        visible: width > 0 && height > 0
    }

    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 8
        width: tipText.implicitWidth + 16
        height: tipText.implicitHeight + 10
        radius: 6
        color: Md3Theme.colorScheme.surfaceContainerHigh
        border.color: Md3Theme.colorScheme.outlineVariant
        visible: !!(root.hoverInfo && root.hoverInfo.typeName)

        Text {
            id: tipText
            anchors.centerIn: parent
            text: {
                const i = root.hoverInfo || {}
                const name = i.objectName ? (i.typeName + "#" + i.objectName) : (i.typeName || "")
                const wh = (i.width !== undefined)
                          ? ("  " + Math.round(i.width) + "×" + Math.round(i.height))
                          : ""
                return name + wh
            }
            color: Md3Theme.colorScheme.colorOnSurface
            font.pixelSize: 11
            font.family: Md3Theme.typography.fontFamily
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.CrossCursor
        focus: root.picking
        onPositionChanged: function (mouse) { root._probe(mouse.x, mouse.y) }
        onClicked: function (mouse) {
            root._probe(mouse.x, mouse.y)
            root.selectedInfo = root.hoverInfo
            root.picked(root.hoverInfo, root._hoverItem)
            root.picking = false
        }
        Keys.onEscapePressed: root.picking = false
    }
}
