import QtQuick
import QtQuick.Window

/// Base root for Md3PageHost destinations.
/// Declares injectables that PageHost fills — prefer these over Window.window duck-typing.
Item {
    id: root

    anchors.fill: parent

    property var md3HostWindow: null
    property var md3RouteParams: ({})
    property int md3NavDepth: 0
    /// function (opts) → bool
    property var md3GoBack: null
    /// function (index, params, opts) → …
    property var md3PushRoute: null

    readonly property var routeParams: md3RouteParams && typeof md3RouteParams === "object"
            ? md3RouteParams : ({})
    readonly property int navDepth: md3NavDepth

    function hostWindow() {
        return md3HostWindow || Window.window
    }

    function goBack(opts) {
        if (typeof md3GoBack === "function")
            return md3GoBack(opts)
        const win = hostWindow()
        if (win && typeof win.goBack === "function")
            return win.goBack(opts)
        return false
    }

    function pushRoute(index, params, opts) {
        if (typeof md3PushRoute === "function")
            return md3PushRoute(index, params, opts)
        const win = hostWindow()
        if (win && typeof win.pushRoute === "function")
            return win.pushRoute(index, params, opts)
        return false
    }
}
