pragma Singleton
import QtQuick
import Md3

/// App-wide notify helpers. Hosts register from Md3ApplicationWindow automatically.
QtObject {
    id: root

    property var host: null
    property var toastHost: null

    function registerHost(h) {
        if (h)
            host = h
    }

    function unregisterHost(h) {
        if (host === h)
            host = null
    }

    function registerToastHost(h) {
        if (h)
            toastHost = h
    }

    function unregisterToastHost(h) {
        if (toastHost === h)
            toastHost = null
    }

    /// Bottom snackbar queue. options: { actionText, dualLine, durationMs, id, priority }
    function snackbar(message, options) {
        if (host && typeof host.show === "function")
            return host.show(message, options)
        console.warn("Md3Notify.snackbar: no Md3SnackbarHost registered (use Md3ApplicationWindow or place Md3SnackbarHost)")
        return ""
    }

    /// Toast. options: { severity, durationMs, position, id }
    /// position: Md3ToastHost.TopCenter|TopRight|TopLeft|BottomRight|BottomLeft
    ///   or string "topCenter" / "topRight" / "topLeft" / "bottomRight" / "bottomLeft"
    /// severity: Md3Toast.Default | Success | Warning | Error (or 0–3)
    function toast(message, options) {
        if (toastHost && typeof toastHost.show === "function")
            return toastHost.show(message, options)
        console.warn("Md3Notify.toast: no Md3ToastHost registered (use Md3ApplicationWindow or place Md3ToastHost)")
        return ""
    }

    /// Copy text then toast. options: { feedback?, severity?, durationMs?, id? }
    /// feedback defaults to qsTr("Copied"). Set feedback: "" to skip toast.
    function copy(text, options) {
        const opts = options || {}
        const value = text === undefined || text === null ? "" : String(text)
        let ok = false
        function tryCopy(node) {
            let p = node
            while (p) {
                if (typeof p.copyToClipboard === "function") {
                    ok = !!p.copyToClipboard(value)
                    return true
                }
                p = p.parent
            }
            return false
        }
        if (!tryCopy(toastHost))
            tryCopy(host)
        if (!ok)
            console.warn("Md3Notify.copy: no clipboard API (use Md3ApplicationWindow)")
        const feedback = opts.feedback !== undefined ? String(opts.feedback) : qsTr("Copied")
        if (ok && feedback.length) {
            toast(feedback, {
                severity: opts.severity !== undefined ? opts.severity : 1,
                durationMs: opts.durationMs,
                id: opts.id !== undefined ? opts.id : "clipboard-copy"
            })
        }
        return ok
    }

    function dismissAll() {
        if (host && typeof host.dismissAll === "function")
            host.dismissAll()
        if (toastHost && typeof toastHost.dismissAll === "function")
            toastHost.dismissAll()
    }
}
