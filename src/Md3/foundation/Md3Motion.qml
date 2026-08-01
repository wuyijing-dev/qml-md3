pragma Singleton
import QtQuick
import Md3

/// Motion tokens aligned with **iOS / UIKit / Core Animation**.
/// Curves: CAMediaTimingFunction Default / EaseIn / EaseOut / EaseInEaseOut.
/// Durations: common UIKit intervals (0.25 / 0.35 / 0.5 s).
/// Springs: SwiftUI-style dampingFraction ≈ 0.82–0.88 (mapped to Qt SpringAnimation).
QtObject {
    id: root

    /// Global duration multiplier. 1 = iOS baseline pacing.
    property real durationScale: 1.0

    /// Explicit binding — do not hide Md3Theme.reduceMotion only inside _scaled()
    /// (some QML engines won't re-eval token props when the flag flips).
    readonly property bool reduced: Md3Theme ? Md3Theme.reduceMotion : false

    // --- Durations (ms) — UIKit / HIG common intervals ---
    // 0.1 / 0.15 / 0.2 / 0.25 / 0.3 / 0.35 / 0.4 / 0.45 / 0.5 / …
    readonly property int short1: _scaled(100)
    readonly property int short2: _scaled(150)
    readonly property int short3: _scaled(200)
    readonly property int short4: _scaled(250)   // UIView default-ish (0.25s)
    readonly property int medium1: _scaled(300)
    readonly property int medium2: _scaled(350)  // push / most UI
    readonly property int medium3: _scaled(400)
    readonly property int medium4: _scaled(450)
    readonly property int long1: _scaled(500)    // modal / sheet
    readonly property int long2: _scaled(550)
    readonly property int long3: _scaled(600)
    readonly property int long4: _scaled(650)
    readonly property int extraLong1: _scaled(700)
    readonly property int extraLong2: _scaled(800)
    readonly property int extraLong3: _scaled(900)
    readonly property int extraLong4: _scaled(1000)

    function _scaled(ms) {
        if (root.reduced)
            return 1
        const s = durationScale > 0.05 ? durationScale : 1
        return Math.max(1, Math.round(ms * s))
    }

    /// Durations for loaders / progress / live indicators — never collapsed by reduceMotion.
    function essential(ms) {
        const s = durationScale > 0.05 ? durationScale : 1
        return Math.max(1, Math.round(ms * s))
    }

    // --- CAMediaTimingFunction (Core Animation) ---
    // Default ≈ (0.25, 0.1, 0.25, 1.0)
    // EaseIn  ≈ (0.42, 0.0, 1.0, 1.0)
    // EaseOut ≈ (0.0, 0.0, 0.58, 1.0)
    // EaseInEaseOut ≈ (0.42, 0.0, 0.58, 1.0)
    readonly property var iosDefault: [0.25, 0.1, 0.25, 1.0]
    readonly property var iosEaseIn: [0.42, 0.0, 1.0, 1.0]
    readonly property var iosEaseOut: [0.0, 0.0, 0.58, 1.0]
    readonly property var iosEaseInOut: [0.42, 0.0, 0.58, 1.0]
    /// Sheet / card settle — iOS-like decelerate with slight anticipation
    readonly property var iosSheet: [0.32, 0.72, 0.0, 1.0]
    /// Snappy interactive settle (control chrome, toggles)
    readonly property var iosSnap: [0.2, 0.9, 0.1, 1.0]

    // Public aliases (historical Material names → iOS curves so call sites stay valid)
    readonly property var emphasized: iosDefault
    readonly property var emphasizedDecelerate: iosEaseOut
    readonly property var emphasizedAccelerate: iosEaseIn
    readonly property var standard: iosDefault
    readonly property var standardDecelerate: iosEaseOut
    readonly property var standardAccelerate: iosEaseIn
    readonly property var legacy: iosEaseInOut
    readonly property var legacyDecelerate: iosEaseOut
    readonly property var legacyAccelerate: iosEaseIn

    readonly property var spatialFast: iosSnap
    readonly property var spatialDefault: iosSheet
    readonly property var spatialSlow: iosEaseOut
    readonly property var effectsFast: iosEaseOut
    readonly property var effectsDefault: iosDefault
    readonly property var effectsSlow: iosEaseInOut
    readonly property var snapOut: iosEaseOut

    readonly property var ui: iosDefault
    readonly property var uiEnter: iosEaseOut
    readonly property var uiExit: iosEaseIn
    readonly property var uiSpatial: iosSheet
    readonly property var uiSpatialSnap: iosSnap
    readonly property var uiEffects: iosDefault
    readonly property var uiEffectsSnap: iosEaseOut

    // Semantic durations (iOS)
    readonly property int uiDuration: medium2          // 350
    readonly property int spatialDuration: long1       // 500 sheet / panel
    readonly property int spatialSnapDuration: medium2 // 350
    readonly property int effectsDuration: short4      // 250
    readonly property int menuDuration: short4         // 250
    readonly property int overlayDuration: short4      // 250 scrim
    readonly property int rippleDuration: short4       // 250 press
    readonly property int stateDuration: short3        // 200 hover/press chrome

    // Springs — dampingFraction ≈ SwiftUI 0.82–0.88 (less Material bounce)
    readonly property real springSnap: 4.2
    readonly property real dampingSnap: 0.86
    readonly property real massSnap: 1.0
    readonly property real epsilonSnap: 0.08

    readonly property real springSoft: 2.8
    readonly property real dampingSoft: 0.82
    readonly property real massSoft: 1.0
    readonly property real epsilonSoft: 0.25

    readonly property real springMenu: 3.6
    readonly property real dampingMenu: 0.88
    readonly property real massMenu: 1.0
    readonly property real epsilonMenu: 0.02

    // Smoothed velocities — paced for ~250–500ms iOS feel
    readonly property real smoothSnapVelocity: 90 / Math.max(0.5, durationScale)
    readonly property real smoothPanelVelocity: 420 / Math.max(0.5, durationScale)
    readonly property real smoothOpacityVelocity: 2.6 / Math.max(0.5, durationScale)
    readonly property real smoothOpacityFastVelocity: 4.0 / Math.max(0.5, durationScale)
    readonly property real smoothScaleVelocity: 1.5 / Math.max(0.5, durationScale)
    readonly property int smoothSnapEasing: _scaled(160)
    readonly property int smoothPanelEasing: _scaled(200)
    readonly property int smoothMaxEasing: _scaled(250)

    readonly property int progressTravel: essential(1800)
    readonly property int progressSpin: essential(1600)
    readonly property int progressSweep: essential(1100)
    readonly property int progressWave: essential(2400)

    function curve(token) {
        const p = root[token]
        return p !== undefined ? p : uiSpatial
    }

    function apply(animation, token) {
        animation.easing.type = Easing.BezierSpline
        animation.easing.bezierCurve = curve(token || "uiSpatial")
    }

    function applySpring(animation, kind) {
        switch (kind) {
        case "soft":
            animation.spring = springSoft
            animation.damping = dampingSoft
            animation.mass = massSoft
            animation.epsilon = epsilonSoft
            break
        case "menu":
            animation.spring = springMenu
            animation.damping = dampingMenu
            animation.mass = massMenu
            animation.epsilon = epsilonMenu
            break
        default:
            animation.spring = springSnap
            animation.damping = dampingSnap
            animation.mass = massSnap
            animation.epsilon = epsilonSnap
            break
        }
    }

    function durationFor(kind) {
        const ms = (function () {
            switch (kind) {
            case "ripple": return 250
            case "state": return 200
            case "menu": return 250
            case "overlay": return 250
            case "spatial": return 500
            case "spatialSnap": return 350
            case "effects": return 250
            case "enter": return 350
            case "exit": return 250
            default: return 350
            }
        })()
        return _scaled(ms)
    }
}
