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
    /// Live chart / wave continuous animation (all tiers; FPS capped on lower tiers).
    readonly property bool effectsLiveMotion: !reduceMotion
    /// 0 = display refresh; >0 caps live charts / wave.
    readonly property int effectsLiveFps: effectsLevel >= 2 ? 0 : (effectsLevel >= 1 ? 24 : 15)
    /// Soft dual-blur elevation shadows (MultiEffect FBOs).
    readonly property bool effectsShadows: effectsLevel >= 1
    /// Max elevation applied when shadows are on (High keeps full).
    readonly property real effectsMaxElevation: effectsLevel >= 2 ? 12 : (effectsLevel >= 1 ? 3 : 0)
    /// Liquid-glass quality hint: 0 low / 1 mid / 2 high.
    readonly property int effectsGlassQuality: Math.max(0, Math.min(2, effectsLevel))
    /// Prefer page / overlay transitions (identical across effects tiers; only reduceMotion kills them).
    readonly property bool effectsPageMotion: !reduceMotion

    /// Ripple ink — always on for click feedback (unless reduceMotion). Tier only changes cost/strength.
    readonly property bool effectsRipple: !reduceMotion
    /// Rounded MultiEffect mask for ripple (均衡/画质). 流畅 uses cheap rectangular clip.
    readonly property bool effectsRippleMasked: effectsLevel >= 1 && effectsRipple
    /// Peak / hold opacity for ripple circle.
    readonly property real effectsRipplePeak: {
        // 流畅 still needs a visible press flash; High is strongest.
        const base = effectsLevel >= 2 ? 0.18 : (effectsLevel >= 1 ? 0.14 : 0.12)
        return Math.max(0.04, Math.min(0.35, base * effectsIntensity))
    }
    readonly property real effectsRippleHold: effectsRipplePeak * 0.5
    /// Expand factor for ripple diameter (slightly smaller on 流畅 = cheaper paint).
    readonly property real effectsRippleSpread: effectsLevel >= 2 ? 2.2 : (effectsLevel >= 1 ? 2.0 : 1.7)
    /// Hover / press state-layer strength — keep press readable on 流畅.
    readonly property real effectsStateIntensity: {
        const base = effectsLevel >= 2 ? 1.0 : (effectsLevel >= 1 ? 0.85 : 0.8)
        return Math.max(0.35, Math.min(1.4, base * effectsIntensity))
    }

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
