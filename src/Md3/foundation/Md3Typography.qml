import QtQuick

QtObject {
    id: root
    readonly property string fontFamily: "HarmonyOS Sans SC"
    readonly property string fontFamilyFallback: {
        if (Qt.platform.os === "windows")
            return "Segoe UI"
        if (Qt.platform.os === "osx" || Qt.platform.os === "macos")
            return "PingFang SC"
        return "Noto Sans CJK SC"
    }
    // Bundled locally under resources/fonts (Material Icons + Outlined)
    readonly property string iconFontFamily: "Material Icons"
    readonly property string iconFontFamilyOutlined: "Material Icons Outlined"
    readonly property string iconFontFamilyFallback: "Segoe MDL2 Assets"

    readonly property var displayLarge: ({ size: 57, weight: Font.Normal, letterSpacing: -0.25, lineHeight: 64 })
    readonly property var displayMedium: ({ size: 45, weight: Font.Normal, letterSpacing: 0, lineHeight: 52 })
    readonly property var displaySmall: ({ size: 36, weight: Font.Normal, letterSpacing: 0, lineHeight: 44 })
    readonly property var headlineLarge: ({ size: 32, weight: Font.Normal, letterSpacing: 0, lineHeight: 40 })
    readonly property var headlineMedium: ({ size: 28, weight: Font.Normal, letterSpacing: 0, lineHeight: 36 })
    readonly property var headlineSmall: ({ size: 24, weight: Font.Normal, letterSpacing: 0, lineHeight: 36 })
    readonly property var titleLarge: ({ size: 22, weight: Font.Normal, letterSpacing: 0, lineHeight: 28 })
    readonly property var titleMedium: ({ size: 16, weight: Font.Medium, letterSpacing: 0.15, lineHeight: 24 })
    readonly property var titleSmall: ({ size: 14, weight: Font.Medium, letterSpacing: 0.1, lineHeight: 20 })
    readonly property var bodyLarge: ({ size: 16, weight: Font.Normal, letterSpacing: 0.5, lineHeight: 24 })
    readonly property var bodyMedium: ({ size: 14, weight: Font.Normal, letterSpacing: 0.25, lineHeight: 20 })
    readonly property var bodySmall: ({ size: 12, weight: Font.Normal, letterSpacing: 0.4, lineHeight: 16 })
    readonly property var labelLarge: ({ size: 14, weight: Font.Medium, letterSpacing: 0.1, lineHeight: 20 })
    readonly property var labelMedium: ({ size: 12, weight: Font.Medium, letterSpacing: 0.5, lineHeight: 16 })
    readonly property var labelSmall: ({ size: 11, weight: Font.Medium, letterSpacing: 0.5, lineHeight: 16 })

    function applyUiFont(textItem) {
        textItem.font.family = fontFamily
        textItem.font.hintingPreference = Font.PreferNoHinting
        textItem.renderType = Text.QtRendering
    }

    function applyTo(textItem, role) {
        const t = root[role] || bodyMedium
        applyUiFont(textItem)
        textItem.font.pixelSize = t.size
        textItem.font.weight = t.weight
        textItem.font.letterSpacing = t.letterSpacing
        textItem.lineHeightMode = Text.FixedHeight
        textItem.lineHeight = t.lineHeight
    }
}
