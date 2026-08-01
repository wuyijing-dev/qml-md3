import QtQuick
import Md3

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
    property int layoutMode: Md3ContainerBody.Fit
    property real maxMenuHeight: 480
    /// Declarative menu from data: [{ text, icon?, divider?, items?, destructive?, enabled?, selected?, showCheck? }, ...]
    /// When non-empty, rebuilds children (replaces hand-written Md3MenuItem trees).
    property var model: []
    readonly property bool isSubMenu: parentMenu !== null
    default property alias content: column.data
    property int highlightedIndex: -1
    readonly property alias itemColumn: column
    /// Optional explicit Window for overlay reparent (else Window.window).
    property var overlayWindow: null
    property var _restoreFocus: null

    readonly property real containerRadius: Md3Theme.shape.large
    readonly property var __md3Menu: root

    signal itemClicked(string path)

    function _menuItems() {
        const out = []
        const kids = column.children
        for (let i = 0; i < kids.length; ++i) {
            const c = kids[i]
            // Md3MenuItem exposes ownerMenu(); skip dividers / spacers.
            if (c && typeof c.ownerMenu === "function" && c.visible !== false && c.enabled !== false)
                out.push(c)
        }
        return out
    }

    function _syncHighlight() {
        const items = _menuItems()
        for (let i = 0; i < items.length; ++i)
            items[i].highlighted = (i === highlightedIndex)
    }

    function _moveHighlight(delta) {
        const items = _menuItems()
        if (!items.length)
            return
        let next = highlightedIndex
        if (next < 0)
            next = delta > 0 ? 0 : items.length - 1
        else
            next = (next + delta + items.length) % items.length
        highlightedIndex = next
        _syncHighlight()
    }

    function _activateHighlighted() {
        const items = _menuItems()
        if (highlightedIndex < 0 || highlightedIndex >= items.length)
            return
        const item = items[highlightedIndex]
        if (item.hasSubMenu && typeof item.openSubmenu === "function")
            item.openSubmenu()
        else if (typeof item.clicked === "function")
            item.clicked()
    }

    function _openHighlightedSubmenu() {
        const items = _menuItems()
        if (highlightedIndex < 0 || highlightedIndex >= items.length)
            return
        const item = items[highlightedIndex]
        if (item.hasSubMenu && typeof item.openSubmenu === "function")
            item.openSubmenu()
    }

    onOpenChanged: {
        if (open) {
            if (!isSubMenu) {
                const win = Md3OverlayHost.resolveWindow(root.overlayWindow, root)
                if (win && win.activeFocusItem)
                    _restoreFocus = win.activeFocusItem
            }
            highlightedIndex = 0
            Qt.callLater(function () {
                _syncHighlight()
                host.forceActiveFocus()
            })
        } else {
            highlightedIndex = -1
            _syncHighlight()
            if (!isSubMenu) {
                const f = _restoreFocus
                _restoreFocus = null
                if (f && typeof f.forceActiveFocus === "function")
                    Qt.callLater(function () {
                        try { f.forceActiveFocus() } catch (e) { /* destroyed */ }
                    })
            }
        }
    }

    Component {
        id: itemComp
        Md3MenuItem {}
    }
    Component {
        id: dividerComp
        Md3MenuDivider {}
    }

    /// Must not use `Component { Md3Menu {} }` here — that recurses the type compiler.
    property var _subMenuComp: null

    function _subMenuComponent() {
        if (_subMenuComp)
            return _subMenuComp
        _subMenuComp = Qt.createComponent(Qt.resolvedUrl("Md3Menu.qml"))
        return _subMenuComp
    }

    function _createSubMenu(parentObj) {
        const comp = _subMenuComponent()
        if (!comp)
            return null
        if (comp.status === Component.Error) {
            console.warn("Md3Menu submenu:", comp.errorString())
            return null
        }
        if (comp.status !== Component.Ready) {
            // Local module resources resolve synchronously; bail if not ready.
            console.warn("Md3Menu submenu: component not ready", comp.status)
            return null
        }
        return comp.createObject(parentObj || root, { menuWidth: 200, modal: false })
    }

    onModelChanged: {
        if (model && model.length > 0)
            Qt.callLater(rebuildFromModel)
    }
    Component.onCompleted: {
        if (model && model.length > 0)
            Qt.callLater(rebuildFromModel)
    }

    function rebuildFromModel() {
        if (!model || model.length === 0)
            return
        clearItems()
        _buildEntries(root, model, "")
    }

    function _kidsOf(entry) {
        if (!entry)
            return []
        if (entry.items && entry.items.length)
            return entry.items
        if (entry.items === undefined && entry.children && entry.children.length
                && typeof entry.children.length === "number"
                && !(entry.children[0] instanceof Item))
            return entry.children
        return []
    }

    function _buildEntries(menu, entries, pathPrefix) {
        if (!menu || !entries)
            return
        for (let i = 0; i < entries.length; ++i) {
            const e = entries[i] || {}
            if (e.divider === true || e.type === "divider") {
                menu.addItemObject(dividerComp, {})
                continue
            }
            const label = e.text !== undefined ? String(e.text) : String(e)
            const path = pathPrefix.length ? (pathPrefix + "/" + label) : label
            const kids = _kidsOf(e)
            const item = menu.addItemObject(itemComp, {
                text: label,
                icon: e.icon !== undefined ? String(e.icon) : "",
                trailingIcon: e.trailingIcon !== undefined ? String(e.trailingIcon) : "",
                enabled: e.enabled !== undefined ? !!e.enabled : true,
                destructive: !!e.destructive,
                selected: !!e.selected,
                showCheck: !!e.showCheck,
                leadingCheck: e.leadingCheck !== undefined ? !!e.leadingCheck : true
            })
            if (!item)
                continue
            if (kids.length > 0) {
                const sub = menu._createSubMenu ? menu._createSubMenu(menu) : _createSubMenu(menu)
                item.submenu = sub
                _buildEntries(sub, kids, path)
            } else {
                item.clicked.connect(function () {
                    menu.itemClicked(path)
                    let m = menu
                    while (m && m.parentMenu)
                        m = m.parentMenu
                    if (m && m !== menu)
                        m.itemClicked(path)
                })
            }
        }
    }

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
        return Md3OverlayHost.contentItem(root.overlayWindow, root)
    }

    function hostEnsureParent(contentItem) {
        if (contentItem) {
            if (host.parent !== contentItem) {
                host.parent = contentItem
                host.x = 0
                host.y = 0
                host.anchors.fill = contentItem
            }
            host.z = root.isSubMenu ? 6000 : 5000
            return
        }
        Md3OverlayHost.ensureHostParent(host, root.overlayWindow, root,
                                        root.isSubMenu ? 6000 : 5000)
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
        const p = Md3OverlayHost.mapToOverlay(item, x, y, root.overlayWindow)
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
        const p = Md3OverlayHost.mapToOverlay(anchorItem, anchorItem.width, 0, root.overlayWindow)
        let x = p.x + 4
        let y = Math.max(8, p.y - 8)
        const mw = menu.menuWidth > 0 ? menu.menuWidth : 200
        if (target && target.width > 0 && x + mw > target.width - 8)
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
        focus: root.open && !root.isSubMenu
        Accessible.role: Accessible.PopupMenu
        Accessible.name: qsTr("Menu")

        Keys.onPressed: function (event) {
            if (!root.open)
                return
            switch (event.key) {
            case Qt.Key_Escape:
                root.dismissCascade()
                event.accepted = true
                break
            case Qt.Key_Up:
                root._moveHighlight(-1)
                event.accepted = true
                break
            case Qt.Key_Down:
                root._moveHighlight(1)
                event.accepted = true
                break
            case Qt.Key_Return:
            case Qt.Key_Enter:
            case Qt.Key_Space:
                root._activateHighlighted()
                event.accepted = true
                break
            case Qt.Key_Right:
                root._openHighlightedSubmenu()
                event.accepted = true
                break
            case Qt.Key_Left:
                if (root.isSubMenu)
                    root.dismiss()
                event.accepted = true
                break
            case Qt.Key_Home:
                root.highlightedIndex = 0
                root._syncHighlight()
                event.accepted = true
                break
            case Qt.Key_End: {
                const items = root._menuItems()
                root.highlightedIndex = items.length ? items.length - 1 : -1
                root._syncHighlight()
                event.accepted = true
                break
            }
            }
        }

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
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
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
            height: root.layoutMode === Md3ContainerBody.Scroll
                    ? Math.min(root.maxMenuHeight, menuBody.contentImplicitHeight + 16)
                    : menuBody.contentImplicitHeight + 16
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

            Md3ContainerBody {
                id: menuBody
                anchors.top: parent.top
                anchors.topMargin: 8
                anchors.left: parent.left
                anchors.right: parent.right
                height: parent.height - 8
                layoutMode: root.layoutMode

                Column {
                    id: column
                    width: parent.width
                }
            }
        }
    }

    Component.onDestruction: dismiss()
}
