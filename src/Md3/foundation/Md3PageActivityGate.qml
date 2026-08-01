import QtQuick
import Md3

/// Tracks ancestor `md3PageActive` (injected by Md3PageHost) for unload-on-leave.
/// Keep chrome/shell; clear models or Loader.active when `contentActive` is false.
Item {
    id: root

    width: 0
    height: 0
    visible: false
    enabled: false

    property Item watchItem: parent
    property bool unloadWhenPageInactive: true
    property bool pageActive: true
    readonly property bool contentActive: !unloadWhenPageInactive || pageActive

    property var _pageRoot: null

    function resolve() {
        const p = Md3TreeVisibility.findPageRoot(watchItem || parent)
        if (p !== _pageRoot)
            _pageRoot = p
        _sync()
    }

    function _sync() {
        const next = _pageRoot ? !!_pageRoot.md3PageActive : true
        if (next !== pageActive)
            pageActive = next
    }

    onWatchItemChanged: Qt.callLater(resolve)
    onParentChanged: Qt.callLater(resolve)
    onUnloadWhenPageInactiveChanged: {
        if (!unloadWhenPageInactive)
            pageActive = true
        else
            Qt.callLater(resolve)
    }
    Component.onCompleted: Qt.callLater(resolve)

    Connections {
        target: root._pageRoot
        function onMd3PageActiveChanged() { root._sync() }
    }

    Timer {
        interval: 240
        running: root.unloadWhenPageInactive && root._pageRoot === null
        repeat: true
        onTriggered: root.resolve()
    }
}
