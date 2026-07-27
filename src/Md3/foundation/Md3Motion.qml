pragma Singleton
import QtQuick

QtObject {
    id: root

    // Durations — M3 pacing, slowed ~1.5× for clearer motion (was Flutter-default snap).
    // When Md3Theme.reduceMotion is on, tokens collapse to ~1ms.
    readonly property int short1: _d(80)
    readonly property int short2: _d(150)
    readonly property int short3: _d(220)
    readonly property int short4: _d(300)
    readonly property int medium1: _d(380)
    readonly property int medium2: _d(450)
    readonly property int medium3: _d(520)
    readonly property int medium4: _d(600)
    readonly property int long1: _d(680)
    readonly property int long2: _d(750)
    readonly property int long3: _d(820)
    readonly property int long4: _d(900)
    readonly property int extraLong1: _d(1050)
    readonly property int extraLong2: _d(1200)
    readonly property int extraLong3: _d(1350)
    readonly property int extraLong4: _d(1500)

    function _d(ms) {
        return (Md3Theme && Md3Theme.reduceMotion) ? 1 : ms
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

    // Defaults — original emphasized / spatial (not the later “ultra snap” set)
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

    readonly property real springSnap: 4.2
    readonly property real dampingSnap: 0.58
    readonly property real massSnap: 1.0
    readonly property real epsilonSnap: 0.1

    readonly property real springSoft: 3.0
    readonly property real dampingSoft: 0.52
    readonly property real massSoft: 1.0
    readonly property real epsilonSoft: 0.35

    readonly property real springMenu: 3.8
    readonly property real dampingMenu: 0.58
    readonly property real massMenu: 1.0
    readonly property real epsilonMenu: 0.02

    // Smoothed velocities — slower settle to match longer duration tokens
    readonly property real smoothSnapVelocity: 75
    readonly property real smoothPanelVelocity: 360
    readonly property real smoothOpacityVelocity: 2.2
    readonly property real smoothOpacityFastVelocity: 3.5
    readonly property real smoothScaleVelocity: 1.3
    readonly property int smoothSnapEasing: 200
    readonly property int smoothPanelEasing: 240
    readonly property int smoothMaxEasing: 280

    // Indeterminate progress — continuous loops
    readonly property int progressTravel: 2200
    readonly property int progressSpin: 2000
    readonly property int progressSweep: 1400
    readonly property int progressWave: 2800

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
            case "state": return 150
            case "menu": return 220
            case "overlay": return 150
            case "spatial": return 600
            case "spatialSnap": return 450
            case "effects": return 300
            case "enter": return 600
            case "exit": return 300
            default: return 450
            }
        })()
        return _d(ms)
    }
}
