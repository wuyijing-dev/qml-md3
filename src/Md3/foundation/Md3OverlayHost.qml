pragma Singleton
import QtQuick
import QtQuick.Window

/// Resolve overlay parents / popup coordinates without each control re-implementing Window.window.
/// Prefer explicit `win` (`hostWindow` / `overlayWindow`); fall back to `Window.window` of `anchor`.
QtObject {
    id: root

    function resolveWindow(win, anchor) {
        if (win)
            return win
        if (anchor) {
            try {
                const w = anchor.Window.window
                if (w)
                    return w
            } catch (e) {
            }
        }
        return null
    }

    /// Top-level contentItem for popup reparenting.
    function contentItem(win, anchor) {
        const w = resolveWindow(win, anchor)
        return (w && w.contentItem) ? w.contentItem : null
    }

    /// Map local point on `fromItem` into overlay content coordinates.
    function mapToOverlay(fromItem, x, y, win) {
        const target = contentItem(win, fromItem)
        if (!fromItem)
            return Qt.point(x || 0, y || 0)
        if (target) {
            const p = fromItem.mapToItem(target, x || 0, y || 0)
            return Qt.point(p.x, p.y)
        }
        const g = fromItem.mapToGlobal(x || 0, y || 0)
        return Qt.point(g.x, g.y)
    }

    /// Reparent `host` to fill the overlay contentItem (menus / pickers).
    function ensureHostParent(host, win, anchor, zOrder) {
        if (!host)
            return null
        const target = contentItem(win, anchor)
        if (!target)
            return null
        if (host.parent !== target) {
            host.parent = target
            host.x = 0
            host.y = 0
            host.anchors.fill = target
        }
        if (zOrder !== undefined && zOrder !== null)
            host.z = zOrder
        return target
    }
}
