pragma Singleton
import QtQuick

QtObject {
    id: root

    /// Global duration multiplier. 1 = Material/Flutter original pacing.
    property real durationScale: 1.0

    /// Explicit binding — do not hide Md3Theme.reduceMotion only inside _scaled()
    /// (some QML engines won't re-eval token props when the flag flips).
    readonly property bool reduced: Md3Theme ? Md3Theme.reduceMotion : false

    // Base durations × durationScale (or 1ms when reduced).
    // Do not scale by effectsLevel — 流畅 turns off ripples, not page/UI transitions.
    readonly property int short1: _scaled(50)
    readonly property int short2: _scaled(100)
    readonly property int short3: _scaled(150)
    readonly property int short4: _scaled(200)
    readonly property int medium1: _scaled(250)
    readonly property int medium2: _scaled(300)
    readonly property int medium3: _scaled(350)
    readonly property int medium4: _scaled(400)
    readonly property int long1: _scaled(450)
    readonly property int long2: _scaled(500)
    readonly property int long3: _scaled(550)
    readonly property int long4: _scaled(600)
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

    // Original M3 / Flutter easings
    readonly property var emphasized: [0.2, 0.0, 0.0, 1.0]
    readonly property var emphasizedDecelerate: [0.05, 0.7, 0.1, 1.0]
    readonly property var emphasizedAccelerate: [0.3, 0.0, 0.8, 0.15]
    readonly property var standard: [0.2, 0.0, 0.0, 1.0]
    readonly property var standardDecelerate: [0.0, 0.0, 0.0, 1.0]
    readonly property var standardAccelerate: [0.3, 0.0, 1.0, 1.0]
    readonly property var legacy: [0.4, 0.0, 0.2, 1.0]
    readonly property var legacyDecelerate: [0.0, 0.0, 0.2, 1.0]
    readonly property var legacyAccelerate: [0.4, 0.0, 1.0, 1.0]

    readonly property var spatialFast: [0.42, 1.67, 0.21, 0.90]
    readonly property var spatialDefault: [0.38, 1.21, 0.22, 1.00]
    readonly property var spatialSlow: [0.39, 1.29, 0.35, 0.98]
    readonly property var effectsFast: [0.31, 0.94, 0.34, 1.00]
    readonly property var effectsDefault: [0.34, 0.80, 0.34, 1.00]
    readonly property var effectsSlow: [0.34, 0.88, 0.34, 1.00]
    readonly property var snapOut: [0.0, 0.0, 0.2, 1.0]

    readonly property var ui: emphasized
    readonly property var uiEnter: emphasizedDecelerate
    readonly property var uiExit: emphasizedAccelerate
    readonly property var uiSpatial: spatialDefault
    readonly property var uiSpatialSnap: spatialFast
    readonly property var uiEffects: effectsDefault
    readonly property var uiEffectsSnap: effectsFast

    readonly property int uiDuration: medium2
    readonly property int spatialDuration: medium4
    readonly property int spatialSnapDuration: medium2
    readonly property int effectsDuration: short4
    readonly property int menuDuration: short3
    readonly property int overlayDuration: short2
    readonly property int rippleDuration: medium2
    readonly property int stateDuration: short2

    readonly property real springSnap: 5.0
    readonly property real dampingSnap: 0.55
    readonly property real massSnap: 1.0
    readonly property real epsilonSnap: 0.1

    readonly property real springSoft: 3.5
    readonly property real dampingSoft: 0.5
    readonly property real massSoft: 1.0
    readonly property real epsilonSoft: 0.35

    readonly property real springMenu: 4.5
    readonly property real dampingMenu: 0.55
    readonly property real massMenu: 1.0
    readonly property real epsilonMenu: 0.02

    // Smoothed velocities — original 200–400ms feel
    readonly property real smoothSnapVelocity: 110 / Math.max(0.5, durationScale)
    readonly property real smoothPanelVelocity: 520 / Math.max(0.5, durationScale)
    readonly property real smoothOpacityVelocity: 3.0 / Math.max(0.5, durationScale)
    readonly property real smoothOpacityFastVelocity: 5.0 / Math.max(0.5, durationScale)
    readonly property real smoothScaleVelocity: 1.8 / Math.max(0.5, durationScale)
    readonly property int smoothSnapEasing: _scaled(140)
    readonly property int smoothPanelEasing: _scaled(160)
    readonly property int smoothMaxEasing: _scaled(180)

    readonly property int progressTravel: _scaled(1800)
    readonly property int progressSpin: _scaled(1600)
    readonly property int progressSweep: _scaled(1100)
    readonly property int progressWave: _scaled(2400)

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
            animation.mass = massSnap
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
            case "ripple": return 300
            case "state": return 100
            case "menu": return 150
            case "overlay": return 100
            case "spatial": return 400
            case "spatialSnap": return 300
            case "effects": return 200
            case "enter": return 400
            case "exit": return 200
            default: return 300
            }
        })()
        return _scaled(ms)
    }
}
