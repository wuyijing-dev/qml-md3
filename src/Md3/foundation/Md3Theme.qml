pragma Singleton
import QtQuick

QtObject {
    id: root

    property bool dark: false
    property color seed: "#6750A4"
    property real textScale: 1.0
    property bool highContrast: false
    /// Prefer near-instant motion for vestibular / a11y preferences.
    property bool reduceMotion: false
    /// Within-page progressive load (Md3DeferredSection). Default on; set false to load everything immediately.
    property bool progressiveContent: true

    property Md3ColorScheme colorScheme: Md3ColorScheme { }
    property Md3DynamicScheme dynamicScheme: Md3DynamicScheme { }
    property Md3Typography typography: Md3Typography {}
    property Md3Shape shape: Md3Shape {}
    property Md3Elevation elevation: Md3Elevation {}
    property Md3StateLayer stateLayer: Md3StateLayer {}

    /// Outline role — stronger in high-contrast mode.
    readonly property color accessibleOutline: highContrast
            ? colorScheme.colorOnSurface
            : colorScheme.outline

    /// Rebuild the full MD3 role set from seed + dark (Material You–style).
    function applySeed(c) {
        seed = Qt.color(c)
        dynamicScheme.applyTo(colorScheme, seed, dark)
        if (highContrast)
            _boostContrast()
    }

    function _boostContrast() {
        // Push surfaces apart for WCAG-friendly chrome without rebuilding the whole palette.
        colorScheme.outline = colorScheme.colorOnSurface
        colorScheme.outlineVariant = colorScheme.withOpacity(colorScheme.colorOnSurface, 0.7)
    }

    function toggleDark() {
        dark = !dark
    }

    function scaled(px) {
        return px * textScale
    }

    onDarkChanged: applySeed(seed)
    onHighContrastChanged: applySeed(seed)

    Component.onCompleted: applySeed(seed)
}
