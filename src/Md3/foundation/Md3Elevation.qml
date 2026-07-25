import QtQuick

QtObject {
    // Flutter-like elevation levels (dp) + surface tint strength
    readonly property real level0: 0
    readonly property real level1: 1
    readonly property real level2: 3
    readonly property real level3: 6
    readonly property real level4: 8
    readonly property real level5: 12

    function tintOpacity(level) {
        if (level <= 0)
            return 0
        if (level <= 1)
            return 0.05
        if (level <= 3)
            return 0.08
        if (level <= 6)
            return 0.11
        if (level <= 8)
            return 0.12
        return 0.14
    }

    // Key shadow — tighter, darker, stronger Y (contact / direction)
    function keyY(level) {
        if (level <= 0) return 0
        if (level <= 1) return 1
        if (level <= 3) return 2
        if (level <= 6) return 4
        if (level <= 8) return 6
        return 8
    }

    function keyBlur(level) {
        // MultiEffect.blur is 0..1; map dp blur into that range
        if (level <= 0) return 0
        if (level <= 1) return 0.35
        if (level <= 3) return 0.45
        if (level <= 6) return 0.55
        if (level <= 8) return 0.65
        return 0.75
    }

    function keyOpacity(level) {
        if (level <= 0) return 0
        if (level <= 1) return 0.18
        if (level <= 3) return 0.22
        if (level <= 6) return 0.28
        if (level <= 8) return 0.32
        return 0.36
    }

    // Ambient shadow — softer, wider, lifts the surface from the page
    function ambientY(level) {
        if (level <= 0) return 0
        if (level <= 1) return 1
        if (level <= 3) return 1
        if (level <= 6) return 2
        if (level <= 8) return 3
        return 4
    }

    function ambientBlur(level) {
        if (level <= 0) return 0
        if (level <= 1) return 0.5
        if (level <= 3) return 0.65
        if (level <= 6) return 0.8
        if (level <= 8) return 0.9
        return 1.0
    }

    function ambientOpacity(level) {
        if (level <= 0) return 0
        if (level <= 1) return 0.08
        if (level <= 3) return 0.10
        if (level <= 6) return 0.14
        if (level <= 8) return 0.16
        return 0.18
    }

    // Back-compat aliases used by older call sites
    function shadowY(level) { return keyY(level) }
    function shadowBlur(level) { return keyBlur(level) }
    function shadowOpacity(level) { return keyOpacity(level) }
}
