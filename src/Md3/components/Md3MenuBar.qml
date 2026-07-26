import QtQuick
import QtQuick.Window

Rectangle {
    id: root

    /// [{ text, icon?, items?: [...] }] — use `items` (not `children`; that clashes with Item)
    property var model: []
    signal itemClicked(string path)

    implicitHeight: 48
    height: implicitHeight
    width: parent ? parent.width : 400
    color: Md3Theme.colorScheme.surfaceContainer

    function _kidsOf(entry) {
        if (!entry)
            return []
        if (entry.items && entry.items.length)
            return entry.items
        // Back-compat with older `children` key (avoid reading Item.children)
        if (entry.items === undefined && entry.children && entry.children.length
                && typeof entry.children.length === "number"
                && !(entry.children[0] instanceof Item))
            return entry.children
        return []
    }

    function _buildItems(menu, entries, pathPrefix) {
        if (!menu)
            return
        menu.clearItems()
        if (!entries)
            return
        const hostCol = menu.itemColumn
        if (!hostCol)
            return
        for (let i = 0; i < entries.length; ++i) {
            const e = entries[i] || {}
            const label = e.text !== undefined ? e.text : String(e)
            const path = pathPrefix.length ? (pathPrefix + "/" + label) : label
            const kids = root._kidsOf(e)
            const hasKids = kids.length > 0
            // Must parent into itemColumn — createObject(menu) stacks on the 0×0 controller
            const item = (typeof menu.addItemObject === "function")
                         ? menu.addItemObject(itemComp, {
                               text: label,
                               icon: e.icon !== undefined ? e.icon : ""
                           })
                         : itemComp.createObject(hostCol, {
                               text: label,
                               icon: e.icon !== undefined ? e.icon : ""
                           })
            if (!item)
                continue
            if (hasKids) {
                const sub = menuComp.createObject(root)
                item.submenu = sub
                _buildItems(sub, kids, path)
            } else {
                item.clicked.connect(function () {
                    root.itemClicked(path)
                })
            }
        }
    }

    function _popupFor(dest) {
        menu.anchorIndex = dest.index
        menu.menuWidth = 220
        if (menu.open)
            menu.dismiss()
        // Ensure previous dynamic items are gone before rebuilding
        menu.clearItems()
        root._buildItems(menu, dest.submenuItems, dest.title)
        const win = Window.window
        const target = (win && win.contentItem) ? win.contentItem : null
        const p = dest.mapToItem(target, 0, dest.height)
        menu.popup(p.x, p.y)
    }

    Component {
        id: itemComp
        Md3MenuItem {}
    }
    Component {
        id: menuComp
        Md3Menu {
            menuWidth: 200
            modal: false
        }
    }

    Row {
        id: row
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height
        spacing: 0

        Repeater {
            model: root.model

            delegate: Item {
                id: dest
                required property int index
                // Avoid modelData.children clashing with Item.children — copy fields explicitly
                required property var modelData

                readonly property string title: {
                    const m = modelData
                    if (!m)
                        return ""
                    if (m.text !== undefined)
                        return String(m.text)
                    if (m.title !== undefined)
                        return String(m.title)
                    return ""
                }
                readonly property var submenuItems: root._kidsOf(modelData)

                // Explicit metrics — never bind width to a centered Text
                width: Math.max(56, metrics.advanceWidth + 28)
                height: Math.max(1, row.height)

                TextMetrics {
                    id: metrics
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.labelLarge.size
                    text: dest.title
                }

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 4
                    radius: Md3Theme.shape.small
                    color: menu.open && menu.anchorIndex === dest.index
                           ? Md3Theme.colorScheme.secondaryContainer
                           : (mouse.containsMouse
                              ? Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSurface, 0.08)
                              : "transparent")
                }

                Text {
                    anchors.centerIn: parent
                    text: dest.title
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.family: metrics.font.family
                    font.pixelSize: metrics.font.pixelSize
                }

                MouseArea {
                    id: mouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root._popupFor(dest)
                }
            }
        }
    }

    Md3Menu {
        id: menu
        property int anchorIndex: 0
        modal: true
    }
}
