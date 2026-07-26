import QtQuick
import QtQuick.Window

Item {
    id: root

    // Lightweight controller — overlay is hosted on the window
    width: 0
    height: 0

    property bool open: false
    property real menuX: 0
    property real menuY: 0
    property real menuWidth: 0 // 0 = content width
    property bool modal: true
    /// Cascading: parent of this submenu (null = root menu)
    property var parentMenu: null
    /// Currently open child submenu
    property var childMenu: null
    readonly property bool isSubMenu: parentMenu !== null
    default property alias content: column.data
    readonly property alias itemColumn: column

    readonly property real containerRadius: Md3Theme.shape.large
    readonly property var __md3Menu: root

    function clearItems() {
        // Destroy any items wrongly parented to the 0×0 controller (legacy createObject(menu))
        const strays = []
        for (let i = 0; i < root.children.length; ++i) {
            const c = root.children[i]
            if (c && c !== host)
                strays.push(c)
        }
        for (let s = 0; s < strays.length; ++s) {
            strays[s].visible = false
            strays[s].parent = null
            strays[s].destroy()
        }
        const kids = []
        for (let i = 0; i < column.children.length; ++i)
            kids.push(column.children[i])
        for (let i = 0; i < kids.length; ++i) {
            if (!kids[i])
                continue
            kids[i].visible = false
            kids[i].parent = null
            kids[i].destroy()
        }
    }

    function addItemObject(comp, props) {
        // Always parent into the visible column — never the 0×0 controller
        return comp.createObject(column, props || {})
    }

    function _contentItem() {
        const win = Window.window
        return (win && win.contentItem) ? win.contentItem : null
    }

    function hostEnsureParent(contentItem) {
        const target = contentItem || _contentItem()
        if (!target)
            return
        if (host.parent !== target) {
            host.parent = target
            host.x = 0
            host.y = 0
            host.anchors.fill = target
        }
        host.z = root.isSubMenu ? 6000 : 5000
    }

    function popup(x, y) {
        hostEnsureParent(_contentItem())
        menuX = x
        menuY = y
        open = true
    }

    function dismiss() {
        if (childMenu) {
            childMenu.dismiss()
            childMenu = null
        }
        open = false
        parentMenu = null
    }

    function dismissCascade() {
        let m = root
        while (m && m.parentMenu)
            m = m.parentMenu
        if (m)
            m.dismiss()
    }

    function popupAtItem(item, x, y) {
        if (!item)
            return
        const target = _contentItem() || host
        const p = item.mapToItem(target, x, y)
        popup(p.x, p.y)
    }

    /// Open `menu` as a cascading submenu anchored to `anchorItem`.
    function openSubMenu(menu, anchorItem) {
        if (!menu || !anchorItem)
            return
        if (childMenu && childMenu !== menu) {
            childMenu.dismiss()
            childMenu = null
        }
        childMenu = menu
        menu.parentMenu = root
        menu.modal = false
        const target = _contentItem() || host
        menu.hostEnsureParent(target)
        const p = anchorItem.mapToItem(target, anchorItem.width, 0)
        let x = p.x + 4
        let y = Math.max(8, p.y - 8)
        const mw = menu.menuWidth > 0 ? menu.menuWidth : 200
        if (target.width > 0 && x + mw > target.width - 8)
            x = Math.max(8, p.x - mw - 4)
        menu.popup(x, y)
    }

    Item {
        id: host
        // Reparented to Window.contentItem on first popup
        parent: root
        width: 0
        height: 0
        z: 5000
        visible: root.open || panel.opacity > 0.01
                 || (root.childMenu && root.childMenu.open)

        Rectangle {
            anchors.fill: parent
            color: Md3Theme.colorScheme.scrim
            opacity: root.open && root.modal && !root.isSubMenu ? 0.08 : 0
            visible: opacity > 0.001 && parent.width > 8
            Behavior on opacity {
                NumberAnimation {
                    duration: Md3Motion.short2
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.standard
                }
            }
            MouseArea {
                anchors.fill: parent
                enabled: root.open && root.modal && !root.isSubMenu
                onClicked: root.dismissCascade()
            }
        }

        Md3Shadow {
            anchors.fill: panel
            elevation: root.open ? 2 : 0
            cornerRadius: root.containerRadius
            opacity: panel.opacity
        }

        Rectangle {
            id: panel
            readonly property var __md3Menu: root
            x: root.menuX
            width: root.menuWidth > 0 ? root.menuWidth : Math.max(112, column.implicitWidth)
            height: column.implicitHeight + 16
            radius: root.containerRadius
            color: Md3Theme.colorScheme.surfaceContainer
            clip: true
            transformOrigin: Item.Top

            property real yOffset: root.open ? 0 : -6
            y: root.menuY + yOffset
            opacity: root.open ? 1 : 0
            scale: root.open ? 1 : 0.96
            enabled: root.open || opacity > 0.01

            Behavior on opacity {
                NumberAnimation {
                    duration: Md3Motion.short3
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.standard
                }
            }
            Behavior on scale {
                NumberAnimation {
                    duration: Md3Motion.short3
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.emphasizedDecelerate
                }
            }
            Behavior on yOffset {
                NumberAnimation {
                    duration: Md3Motion.short3
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.emphasized
                }
            }

            Column {
                id: column
                anchors.top: parent.top
                anchors.topMargin: 8
                anchors.left: parent.left
                anchors.right: parent.right
                width: parent.width
            }
        }
    }

    Component.onDestruction: dismiss()
}
