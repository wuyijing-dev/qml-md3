pragma Singleton
import QtQuick

/// Default app / window icons shipped inside the Md3 module (resources/icons).
/// Paths: qrc:/md3/icons/app-icon.png … — used when windowIcon is left empty.
QtObject {
    id: root

    readonly property url app: "qrc:/md3/icons/app-icon.png"
    readonly property url app16: "qrc:/md3/icons/app-icon-16.png"
    readonly property url app32: "qrc:/md3/icons/app-icon-32.png"
    readonly property url app48: "qrc:/md3/icons/app-icon-48.png"
    readonly property url app256: "qrc:/md3/icons/app-icon-256.png"

    /// Alias for title bar / About / taskbar primary icon.
    readonly property url window: app
}
