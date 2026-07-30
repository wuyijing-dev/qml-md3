pragma Singleton
import QtQuick
import QtQuick.Window

/// Shared ancestor / window visibility checks (PageHost hides pages via opacity).
/// Prefer this over duplicating `while (parent)` walks in components.
QtObject {
    id: root

    /// Walk `item` and ancestors: all must be visible with opacity > 0.01.
    function isItemShown(item) {
        if (!item)
            return false
        let p = item
        while (p) {
            if (p.visible === false)
                return false
            if (p.opacity !== undefined && p.opacity < 0.01)
                return false
            p = p.parent
        }
        return true
    }

    /// Window is mapped and not minimized/hidden. Missing window → inactive.
    function isWindowActive(win) {
        if (!win)
            return false
        if (win.visibility === Window.Hidden || win.visibility === Window.Minimized)
            return false
        return true
    }

    /// Tree shown and window active.
    /// Pass explicit `win` / `hostWindow`, or `null`/`undefined` to resolve via Md3OverlayHost.
    function isSceneActive(item, win) {
        if (!isItemShown(item))
            return false
        const w = (win !== undefined && win !== null)
                ? win
                : Md3OverlayHost.resolveWindow(null, item)
        return isWindowActive(w)
    }

    /// Scene active and application not suspended/hidden (for live timers / FrameAnimation).
    function isLiveMotionScene(item, win) {
        if (!isSceneActive(item, win))
            return false
        if (Qt.application.state === Qt.ApplicationSuspended
                || Qt.application.state === Qt.ApplicationHidden)
            return false
        return true
    }
}
