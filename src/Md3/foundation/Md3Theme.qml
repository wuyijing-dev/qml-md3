pragma Singleton
import QtQuick

QtObject {
    id: root

    property bool dark: false
    property color seed: "#6750A4"
    property real textScale: 1.0
    property bool highContrast: false

    property Md3ColorScheme colorScheme: Md3ColorScheme { }
    property Md3DynamicScheme dynamicScheme: Md3DynamicScheme { }
    property Md3Typography typography: Md3Typography {}
    property Md3Shape shape: Md3Shape {}
    property Md3Elevation elevation: Md3Elevation {}
    property Md3StateLayer stateLayer: Md3StateLayer {}

    /// Rebuild the full MD3 role set from seed + dark (Material You–style).
    function applySeed(c) {
        seed = Qt.color(c)
        dynamicScheme.applyTo(colorScheme, seed, dark)
    }

    function toggleDark() {
        dark = !dark
    }

    function scaled(px) {
        return px * textScale
    }

    onDarkChanged: applySeed(seed)

    Component.onCompleted: applySeed(seed)
}
