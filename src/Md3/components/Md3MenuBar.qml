import QtQuick
import QtQuick.Window

Rectangle {
    id: root

    /// [{ text, icon?, children?: [...] }] — children nest into cascading submenus
    property var model: []
    signal itemClicked(string path)

    implicitHeight: 48
    height: implicitHeight
    width: parent ? parent.width : 400
    color: Md3Theme.colorScheme.surfaceContainer

    function _buildItems(menu, entries, pathPrefix) {
        if (!menu)
            return
        menu.clearItems()
        if (!entries)
            return
        for (let i = 0; i < entries.length; ++i) {
            const e = entries[i] || {}
            const label = e.text !== undefined ? e.text : String(e)
            const path = pathPrefix.length ? (pathPrefix + "/" + label) : label
            const hasKids = e.children && e.children.length > 0
            const item = itemComp.createObject(menu, {
                text: label,
                icon: e.icon !== undefined ? e.icon : ""
            })
            if (!item)
                continue
            if (hasKids) {
                const sub = menuComp.createObject(root)
                item.submenu = sub
                _buildItems(sub, e.children, path)
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
        root._buildItems(menu, dest.childrenModel, dest.title)
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
                required property var modelData

                readonly property string title: {
                    const m = modelData
                    if (m && m.text !== undefined)
                        return m.text
                    return String(m)
                }
                readonly property var childrenModel: {
                    const m = modelData
                    return (m && m.children !== undefined) ? m.children : []
                }

                // Size from label only — never anchors.centerIn + width: label (binding loop → width 0)
                width: Math.max(48, label.implicitWidth + 24)
                height: row.height

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
                    id: label
                    // Position without anchors that participate in width resolution
                    x: Math.round((parent.width - implicitWidth) / 2)
                    y: Math.round((parent.height - implicitHeight) / 2)
                    text: dest.title
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.labelLarge.size
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
