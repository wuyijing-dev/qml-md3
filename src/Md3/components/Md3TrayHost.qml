import QtQuick
import QtQuick.Window
import Md3

/// Binds system-tray activation to an `Md3Menu` (library menu, not QMenu).
/// Place inside `Md3ApplicationWindow` (or any Window that owns `windowHelper`).
///
/// ```qml
/// Md3TrayHost {
///     hostWindow: window
///     Md3MenuItem { text: qsTr("Show"); onClicked: window.raiseWindow() }
///     Md3MenuItem { text: qsTr("Quit"); onClicked: Qt.quit() }
/// }
/// // then: window.showSystemTrayIcon(icon, tip)
/// ```
Item {
    id: root
    width: 0
    height: 0

    Accessible.role: Accessible.Grouping
    Accessible.name: qsTr("System tray menu host")
    Accessible.ignored: true

    /// Window that called `showSystemTrayIcon` (must expose `windowHelper`).
    property var hostWindow: null
    /// Show the app on left / double-click (default true).
    property bool raiseOnActivate: true
    /// Show `menu` on tray right-click (default true).
    property bool popupOnContext: true

    default property alias menuData: trayMenu.content
    property alias menu: trayMenu

    readonly property var helper: hostWindow && hostWindow.windowHelper
                                  ? hostWindow.windowHelper : null

    signal activated(int reason)
    signal contextMenuAboutToShow()

    Md3Menu {
        id: trayMenu
    }

    function _popupAtCursor() {
        const h = root.helper
        const win = hostWindow
        const content = Md3OverlayHost.contentItem(win, root)
        if (!h || !content)
            return
        root.contextMenuAboutToShow()
        if (trayMenu.overlayWindow !== undefined)
            trayMenu.overlayWindow = win
        const screen = h.cursorScreenPos()
        const local = content.mapFromGlobal(screen.x, screen.y)
        trayMenu.popup(local.x, local.y)
    }

    function _raiseHost() {
        const win = hostWindow
        if (!win)
            return
        if (win.visibility === Window.Minimized || win.visibility === Window.Hidden)
            win.showNormal()
        if (typeof win.raiseWindow === "function")
            win.raiseWindow()
        else {
            win.show()
            win.raise()
            win.requestActivate()
        }
    }

    Connections {
        target: root.helper
        enabled: root.helper !== null
        function onTrayActivated(reason) {
            root.activated(reason)
            // Md3WindowHelper.TrayLeftClick=1, DoubleClick=2, RightClick=3
            if (root.raiseOnActivate && (reason === 1 || reason === 2))
                root._raiseHost()
            if (root.popupOnContext && reason === 3)
                root._popupAtCursor()
        }
    }
}
