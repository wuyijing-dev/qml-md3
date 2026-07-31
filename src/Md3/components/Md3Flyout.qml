import QtQuick
import Md3

/// Anchored light-dismiss panel (WinUI Flyout–inspired).
/// Reparents onto Window.contentItem via Md3OverlayHost — not ApplicationWindow.overlay.
Item {
    id: root

    width: 0
    height: 0

    property bool open: false
    /// When true, use a light scrim; when false, transparent catcher (DateField-style).
    property bool modal: false
    property var overlayWindow: null
    property var anchor: null
    property real offsetX: 0
    property real offsetY: 4
    /// Explicit panel position in overlay coords (set by popup / show).
    property real panelX: 0
    property real panelY: 0
    /// 0 → content implicit width (min 160).
    property real flyoutWidth: 0
    property real padding: 12
    property real elevation: 2
    property string accessibleName: qsTr("Flyout")

    default property alias content: contentHost.data

    signal opened()
    signal closed()
    signal dismissed()

    Accessible.role: Accessible.Dialog
    Accessible.name: accessibleName

    property var _restoreFocus: null

    function _contentItem() {
        return Md3OverlayHost.contentItem(root.overlayWindow, root.anchor || root)
    }

    function hostEnsureParent() {
        Md3OverlayHost.ensureHostParent(host, root.overlayWindow, root.anchor || root, 5500)
    }

    function popup(x, y) {
        hostEnsureParent()
        const target = _contentItem()
        if (!target)
            return
        panelX = x
        panelY = y
        _clampPanel()
        _open()
    }

    function popupAtItem(item, x, y) {
        if (!item)
            return
        const p = Md3OverlayHost.mapToOverlay(item, x, y, root.overlayWindow)
        popup(p.x, p.y)
    }

    /// Open below `anchorItem` (defaults to `anchor`). Saves focus for restore on dismiss.
    function show(anchorItem) {
        const a = anchorItem || root.anchor
        if (!a)
            return
        root.anchor = a
        const win = Md3OverlayHost.resolveWindow(root.overlayWindow, a)
        if (win && win.activeFocusItem)
            _restoreFocus = win.activeFocusItem
        else
            _restoreFocus = a

        hostEnsureParent()
        const target = _contentItem()
        if (!target)
            return
        const p = Md3OverlayHost.mapToOverlay(a, root.offsetX, a.height + root.offsetY, root.overlayWindow)
        panelX = p.x
        panelY = p.y
        _clampPanel()
        _open()
    }

    function dismiss() {
        if (!open && !host.visible)
            return
        open = false
        host.visible = false
        dismissed()
        closed()
        const f = _restoreFocus
        _restoreFocus = null
        if (f && typeof f.forceActiveFocus === "function")
            Qt.callLater(function () {
                try { f.forceActiveFocus() } catch (e) { /* destroyed */ }
            })
    }

    function toggle(anchorItem) {
        if (open)
            dismiss()
        else
            show(anchorItem)
    }

    function _open() {
        open = true
        host.visible = true
        opened()
        Qt.callLater(function () {
            if (host.visible)
                host.forceActiveFocus()
        })
    }

    function _clampPanel() {
        const target = _contentItem()
        if (!target)
            return
        // Use estimated size; refine after layout via panel width/height bindings.
        const pw = Math.max(flyoutWidth > 0 ? flyoutWidth : 200, 160)
        const ph = Math.max(panel.implicitHeight || 120, 48)
        panelX = Math.max(8, Math.min(panelX, target.width - pw - 8))
        panelY = Math.max(8, Math.min(panelY, target.height - ph - 8))
    }

    onOpenChanged: {
        if (!open && host.visible)
            host.visible = false
    }

    Item {
        id: host
        visible: false
        parent: root
        width: 0
        height: 0
        focus: visible
        Keys.onPressed: function (event) {
            if (event.key === Qt.Key_Escape) {
                root.dismiss()
                event.accepted = true
            }
        }

        Rectangle {
            anchors.fill: parent
            color: root.modal ? Qt.alpha(Md3Theme.colorScheme.scrim, 0.08) : "transparent"
            MouseArea {
                anchors.fill: parent
                enabled: host.visible
                onClicked: root.dismiss()
            }
        }

        Md3Surface {
            id: panel
            x: root.panelX
            y: root.panelY
            width: {
                if (root.flyoutWidth > 0)
                    return root.flyoutWidth
                return Math.max(contentHost.implicitWidth + root.padding * 2, 160)
            }
            height: contentHost.implicitHeight + root.padding * 2
            elevation: root.elevation
            radius: Md3Theme.shape.medium
            color: Md3Theme.colorScheme.surfaceContainer
            clipContent: true

            // Keep outside-click from falling through the panel to the dismiss layer.
            MouseArea {
                anchors.fill: parent
                z: -1
                acceptedButtons: Qt.AllButtons
                onClicked: { /* consume */ }
            }

            Item {
                id: contentHost
                x: root.padding
                y: root.padding
                width: root.flyoutWidth > 0
                       ? Math.max(0, root.flyoutWidth - root.padding * 2)
                       : Math.max(childrenRect.width, 1)
                height: Math.max(childrenRect.height, 1)
                implicitWidth: childrenRect.width
                implicitHeight: childrenRect.height
            }

            opacity: host.visible ? 1 : 0
            scale: host.visible ? 1 : 0.96
            transformOrigin: Item.TopLeft
            Behavior on opacity {
                NumberAnimation {
                    duration: Md3Motion.short3
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.emphasized
                }
            }
            Behavior on scale {
                NumberAnimation {
                    duration: Md3Motion.short3
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.emphasized
                }
            }
        }
    }
}
