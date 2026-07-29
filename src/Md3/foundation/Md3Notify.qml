pragma Singleton
import QtQuick

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

    /// Top-center short toast. options: { severity, durationMs }
    /// severity: Md3Toast.Default | Success | Warning | Error (or 0–3)
    function toast(message, options) {
        if (toastHost && typeof toastHost.show === "function")
            return toastHost.show(message, options)
        console.warn("Md3Notify.toast: no Md3ToastHost registered (use Md3ApplicationWindow or place Md3ToastHost)")
        return ""
    }

    function dismissAll() {
        if (host && typeof host.dismissAll === "function")
            host.dismissAll()
        if (toastHost && typeof toastHost.dismissAll === "function")
            toastHost.dismissAll()
    }
}
