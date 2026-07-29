import QtQuick
import QtQuick.Window

Item {
    id: root

    property string text: ""
    property string icon: ""
    property string trailingIcon: ""
    property bool destructive: false
    property bool selected: false
    property bool showCheck: false
    property bool leadingCheck: true
    /// Keyboard highlight from parent Md3Menu.
    property bool highlighted: false
    /// Nested cascading menu (Md3Menu). Hover / click opens it to the side.
    /// Use `var` so inline / sibling menus assign reliably across Loaders.
    property var submenu: null
    readonly property bool hasSubMenu: submenu !== null && submenu !== undefined

    signal clicked()

    readonly property real itemRadius: Md3Theme.shape.large
    readonly property bool showLeadingCheck: showCheck && leadingCheck && selected
    readonly property bool showTrailingCheck: showCheck && !leadingCheck && selected
    readonly property string resolvedTrailing: {
        if (trailingIcon.length > 0)
            return trailingIcon
        if (submenu !== null)
            return "chevron_right"
        return ""
    }

    function ownerMenu() {
        let p = parent
        while (p) {
            if (p.__md3Menu)
                return p.__md3Menu
            p = p.parent
        }
        return null
    }

    function openSubmenu() {
        if (!submenu)
            return
        const owner = ownerMenu()
        if (owner && typeof owner.openSubMenu === "function")
            owner.openSubMenu(submenu, root)
        else {
            submenu.modal = false
            const win = Window.window
            if (!win)
                return
            const host = win.contentItem
            const p = root.mapToItem(host, root.width, 0)
            submenu.popup(p.x + 2, p.y - 8)
        }
    }

    function closeSiblingSubmenus() {
        const owner = ownerMenu()
        if (owner && owner.childMenu && owner.childMenu !== submenu)
            owner.childMenu.dismiss()
    }

    height: 48
    width: parent ? parent.width : 200
    implicitWidth: Math.max(168, 12 + 24 + 12 + textMetrics.width + 12
                            + ((resolvedTrailing.length > 0 || showCheck) ? 36 : 0) + 12)

    TextMetrics {
        id: textMetrics
        font.family: Md3Theme.typography.fontFamily
        font.pixelSize: Md3Theme.typography.bodyLarge.size
        text: root.text
    }

    Timer {
        id: openSubTimer
        interval: 180
        onTriggered: root.openSubmenu()
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        height: 40
        anchors.verticalCenter: parent.verticalCenter
        radius: root.itemRadius
        color: root.selected ? Md3Theme.colorScheme.secondaryContainer : "transparent"

        Behavior on color {
            ColorAnimation {
                duration: Md3Motion.short4
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.standard
            }
        }

        Md3Ripple {
            id: ripple
            rippleColor: root.selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                       : Md3Theme.colorScheme.colorOnSurface
            clipRadius: root.itemRadius
        }
        Md3StateOverlay {
            overlayColor: root.selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                        : Md3Theme.colorScheme.colorOnSurface
            hovered: mouse.containsMouse || root.highlighted
            pressed: mouse.pressed
            focused: root.highlighted
            controlEnabled: root.enabled
            radius: bg.radius
        }

        Md3FocusRing {
            anchors.fill: parent
            anchors.margins: -2
            radius: root.itemRadius + 2
            focused: root.highlighted
            controlEnabled: root.enabled
            visualFocus: root.highlighted
        }

        Row {
            id: leading
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            spacing: 12

            Item {
                width: 24
                height: 24
                visible: root.showCheck && root.leadingCheck
                anchors.verticalCenter: parent.verticalCenter
                Md3Icon {
                    anchors.centerIn: parent
                    icon: "check"
                    size: 20
                    iconColor: root.enabled ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                            : Md3Theme.colorScheme.disabledContent()
                    opacity: root.showLeadingCheck ? 1 : 0
                    scale: root.showLeadingCheck ? 1 : 0.6
                    Behavior on opacity {
                        NumberAnimation {
                            duration: Md3Motion.short3
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: Md3Motion.standard
                        }
                    }
                    Behavior on scale {
                        NumberAnimation {
                            duration: Md3Motion.spatialSnapDuration
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: Md3Motion.emphasized
                        }
                    }
                }
            }

            Md3Icon {
                visible: root.icon.length > 0
                icon: root.icon
                size: 24
                iconColor: root.enabled
                           ? (root.destructive ? Md3Theme.colorScheme.error
                              : (root.selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                               : Md3Theme.colorScheme.colorOnSurfaceVariant))
                           : Md3Theme.colorScheme.disabledContent()
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: root.text
                elide: Text.ElideRight
                width: Math.max(40, bg.width - 24
                                - leading.spacing * 2
                                - (root.showCheck && root.leadingCheck ? 24 : 0)
                                - (root.icon.length > 0 ? 24 : 0)
                                - ((root.resolvedTrailing.length > 0 || root.showTrailingCheck) ? 36 : 0)
                                - 12)
                color: root.enabled
                       ? (root.destructive ? Md3Theme.colorScheme.error
                          : (root.selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                           : Md3Theme.colorScheme.colorOnSurface))
                       : Md3Theme.colorScheme.disabledContent()
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.typography.bodyLarge.size
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Row {
            anchors.right: parent.right
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            spacing: 4

            Md3Icon {
                visible: root.showTrailingCheck
                icon: "check"
                size: 20
                iconColor: Md3Theme.colorScheme.primary
                anchors.verticalCenter: parent.verticalCenter
            }

            Md3Icon {
                visible: root.resolvedTrailing.length > 0 && !root.showTrailingCheck
                icon: root.resolvedTrailing
                size: 24
                iconColor: root.enabled ? Md3Theme.colorScheme.colorOnSurfaceVariant
                                        : Md3Theme.colorScheme.disabledContent()
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        enabled: root.enabled
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onEntered: {
            root.closeSiblingSubmenus()
            const owner = root.ownerMenu()
            if (owner) {
                const items = owner._menuItems ? owner._menuItems() : []
                for (let i = 0; i < items.length; ++i) {
                    if (items[i] === root) {
                        owner.highlightedIndex = i
                        owner._syncHighlight()
                        break
                    }
                }
            }
            if (root.submenu)
                openSubTimer.restart()
        }
        onExited: openSubTimer.stop()
        onClicked: function (ev) {
            const local = mapToItem(bg, ev.x, ev.y)
            ripple.pulse(local.x, local.y)
            if (root.submenu) {
                root.openSubmenu()
                return
            }
            root.clicked()
            const owner = root.ownerMenu()
            if (owner && typeof owner.dismissCascade === "function")
                owner.dismissCascade()
        }
    }
}
