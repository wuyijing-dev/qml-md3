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

    /// Global visual-effects budget for device adaptation.
    /// 0 = Low (流畅), 1 = Balanced (均衡), 2 = High (画质).
    property int effectsLevel: 1
    /// Extra intensity on interaction ink / state layers (0.35–1.35). Multiplies tier defaults.
    property real effectsIntensity: 1.0

    readonly property bool effectsLow: effectsLevel <= 0
    readonly property bool effectsHigh: effectsLevel >= 2
    /// Chart Catmull smoothing (expensive on pan settle).
    readonly property bool effectsChartSmooth: effectsLevel >= 2 && !reduceMotion
    /// Chart pan inertia after drag release.
    readonly property bool effectsChartInertia: effectsLevel >= 1 && !reduceMotion
    /// Live chart / wave continuous animation.
    readonly property bool effectsLiveMotion: effectsLevel >= 1 && !reduceMotion
    /// 0 = display refresh; >0 caps live charts / wave.
    readonly property int effectsLiveFps: effectsLevel >= 2 ? 0 : (effectsLevel >= 1 ? 30 : 12)
    /// Soft dual-blur elevation shadows (MultiEffect FBOs).
    readonly property bool effectsShadows: effectsLevel >= 1
    /// Max elevation applied when shadows are on (High keeps full).
    readonly property real effectsMaxElevation: effectsLevel >= 2 ? 12 : (effectsLevel >= 1 ? 3 : 0)
    /// Liquid-glass quality hint: 0 low / 1 mid / 2 high.
    readonly property int effectsGlassQuality: Math.max(0, Math.min(2, effectsLevel))
    /// Prefer short/no page transitions on Low.
    readonly property bool effectsPageMotion: effectsLevel >= 1 && !reduceMotion

    /// Ripple ink enabled (off when reduceMotion).
    readonly property bool effectsRipple: !reduceMotion
    /// Rounded MultiEffect mask for ripple (skip on 流畅 to avoid FBO cost).
    readonly property bool effectsRippleMasked: effectsLevel >= 1 && effectsRipple
    /// Peak / hold opacity for ripple circle.
    readonly property real effectsRipplePeak: {
        const base = effectsLevel >= 2 ? 0.18 : (effectsLevel >= 1 ? 0.14 : 0.09)
        return Math.max(0.02, Math.min(0.35, base * effectsIntensity))
    }
    readonly property real effectsRippleHold: effectsRipplePeak * 0.5
    /// Expand factor for ripple diameter (smaller on Low).
    readonly property real effectsRippleSpread: effectsLevel >= 2 ? 2.2 : (effectsLevel >= 1 ? 2.0 : 1.6)
    /// Hover / press state-layer strength.
    readonly property real effectsStateIntensity: {
        const base = effectsLevel >= 2 ? 1.0 : (effectsLevel >= 1 ? 0.75 : 0.45)
        return Math.max(0.2, Math.min(1.4, base * effectsIntensity))
    }
    /// Scales Md3Motion durations (on top of durationScale / reduceMotion).
    readonly property real effectsMotionFactor: effectsLevel >= 2 ? 1.0
            : (effectsLevel >= 1 ? 0.9 : 0.7)

    function setEffectsLevel(level) {
        effectsLevel = Math.max(0, Math.min(2, Math.round(Number(level))))
    }

    function setEffectsIntensity(v) {
        effectsIntensity = Math.max(0.35, Math.min(1.35, Number(v)))
    }

    function effectsLevelLabel() {
        if (effectsLevel <= 0)
            return qsTr("流畅")
        if (effectsLevel >= 2)
            return qsTr("画质")
        return qsTr("均衡")
    }

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
