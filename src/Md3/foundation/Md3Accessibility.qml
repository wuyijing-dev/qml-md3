pragma Singleton
import QtQuick

/// Library-wide accessibility preferences and helpers.
QtObject {
    id: root

    /// Prefer reduced / near-zero motion (mirrors Md3Theme.reduceMotion).
    property bool reduceMotion: Md3Theme.reduceMotion
    onReduceMotionChanged: {
        if (Md3Theme.reduceMotion !== reduceMotion)
            Md3Theme.reduceMotion = reduceMotion
    }

    /// Stronger outlines / surfaces (mirrors Md3Theme.highContrast).
    property bool highContrast: Md3Theme.highContrast
    onHighContrastChanged: {
        if (Md3Theme.highContrast !== highContrast)
            Md3Theme.highContrast = highContrast
    }

    /// Always show keyboard focus rings when true.
    property bool showFocusRings: true

    /// Extra text scale convenience (delegates to Md3Theme.textScale).
    property real textScale: Md3Theme.textScale
    onTextScaleChanged: {
        if (Math.abs(Md3Theme.textScale - textScale) > 0.001)
            Md3Theme.textScale = textScale
    }

    property string _announceText: ""
    property int _announceSerial: 0

    /// Screen-reader live message (read via Accessible on the gallery/window live region).
    readonly property string liveMessage: _announceText
    readonly property int liveSerial: _announceSerial

    function announce(message) {
        const msg = String(message || "")
        if (!msg.length)
            return
        _announceText = ""
        _announceSerial++
        Qt.callLater(function () {
            root._announceText = msg
            root._announceSerial++
        })
    }

    function syncFromTheme() {
        reduceMotion = Md3Theme.reduceMotion
        highContrast = Md3Theme.highContrast
        textScale = Md3Theme.textScale
    }

    function applyToTheme() {
        Md3Theme.reduceMotion = reduceMotion
        Md3Theme.highContrast = highContrast
        Md3Theme.textScale = textScale
    }

    // QtObject has no default property — keep Connections as an explicit property.
    readonly property Connections _themeSync: Connections {
        target: Md3Theme
        function onReduceMotionChanged() { root.reduceMotion = Md3Theme.reduceMotion }
        function onHighContrastChanged() { root.highContrast = Md3Theme.highContrast }
        function onTextScaleChanged() { root.textScale = Md3Theme.textScale }
    }
}
