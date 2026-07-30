import QtQuick
import Md3

/// Transparent right-click host over a page / region.
/// Left-clicks pass through; right-click opens `contextMenu` at the cursor.
///
/// ```qml
/// Md3ContextMenuArea {
///     anchors.fill: parent
///     contextMenu: pageMenu
/// }
/// Md3Menu {
///     id: pageMenu
///     Md3MenuItem { text: qsTr("Refresh") }
/// }
/// ```
Item {
    id: root

    // Use Item.enabled (do not redeclare)
    /// Target Md3Menu (required for a useful menu).
    property var contextMenu: null
    property real menuWidth: 0
    /// Optional explicit Window for overlay mapping (else Window.window).
    property var overlayWindow: null
    signal aboutToShow(real x, real y)
    signal opened()
    signal closed()

    anchors.fill: parent
    z: 10000
    Accessible.role: Accessible.Pane
    Accessible.name: qsTr("Context menu area")

    function popupAt(x, y) {
        if (!enabled || !contextMenu)
            return
        aboutToShow(x, y)
        const p = Md3OverlayHost.mapToOverlay(root, x, y, root.overlayWindow)
        if (menuWidth > 0 && contextMenu.menuWidth !== undefined)
            contextMenu.menuWidth = menuWidth
        if (root.overlayWindow && contextMenu.overlayWindow !== undefined)
            contextMenu.overlayWindow = root.overlayWindow
        contextMenu.popup(p.x, p.y)
        opened()
    }

    function dismiss() {
        if (contextMenu && typeof contextMenu.dismiss === "function")
            contextMenu.dismiss()
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        enabled: root.enabled && root.contextMenu
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        preventStealing: true
        onPressed: function (mouse) {
            if (mouse.button === Qt.RightButton) {
                root.popupAt(mouse.x, mouse.y)
                mouse.accepted = true
            }
        }
    }

    Connections {
        target: root.contextMenu
        function onOpenChanged() {
            if (root.contextMenu && !root.contextMenu.open)
                root.closed()
        }
    }
}
