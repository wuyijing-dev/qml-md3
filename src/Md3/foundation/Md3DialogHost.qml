pragma Singleton
import QtQuick
import Md3

/// Imperative confirm / prompt dialogs. ``Md3ApplicationWindow`` registers a host automatically.
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

    /// options: { title, text, confirmText, dismissText, confirmTone, preferredWidth,
    ///            onConfirmed, onDismissed }
    function confirm(options) {
        if (host && typeof host.confirm === "function")
            return host.confirm(options)
        console.warn("Md3DialogHost.confirm: no host (use Md3ApplicationWindow)")
        return false
    }

    /// options: { title, text, label, placeholder, value, confirmText, dismissText,
    ///            onConfirmed(value), onDismissed }
    function prompt(options) {
        if (host && typeof host.prompt === "function")
            return host.prompt(options)
        console.warn("Md3DialogHost.prompt: no host (use Md3ApplicationWindow)")
        return false
    }
}
