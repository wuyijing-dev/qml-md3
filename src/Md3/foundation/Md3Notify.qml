pragma Singleton
import QtQuick

/// App-wide notify helpers. Md3SnackbarHost / Md3ApplicationWindow register automatically.
QtObject {
    id: root

    property var host: null

    function registerHost(h) {
        if (h)
            host = h
    }

    function unregisterHost(h) {
        if (host === h)
            host = null
    }

    /// Show a snackbar. options: { actionText, dualLine, durationMs, id, priority }
    /// Higher `priority` is shown before lower ones still waiting in the queue.
    function snackbar(message, options) {
        if (host && typeof host.show === "function")
            return host.show(message, options)
        console.warn("Md3Notify.snackbar: no Md3SnackbarHost registered (use Md3ApplicationWindow or place Md3SnackbarHost)")
        return ""
    }

    function dismissAll() {
        if (host && typeof host.dismissAll === "function")
            host.dismissAll()
    }
}
