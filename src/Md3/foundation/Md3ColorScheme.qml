import QtQuick

QtObject {
    id: root

    // Brightness — scheme tokens are owned by applySeed / baseline init (no live bindings
    // that would overwrite dynamic colors).
    property bool dark: false

    // --- Primary ---
    // NOTE: Flutter role names like "onPrimary" are illegal as QML property ids
    // (parsed as signal handlers). Use colorOn* for the same Material roles.
    property color primary: "#6750A4"
    property color colorOnPrimary: "#FFFFFF"
    property color primaryContainer: "#EADDFF"
    property color colorOnPrimaryContainer: "#21005D"
    property color primaryFixed: "#EADDFF"
    property color primaryFixedDim: "#D0BCFF"
    property color colorOnPrimaryFixed: "#21005D"
    property color colorOnPrimaryFixedVariant: "#4F378B"

    // --- Secondary ---
    property color secondary: "#625B71"
    property color colorOnSecondary: "#FFFFFF"
    property color secondaryContainer: "#E8DEF8"
    property color colorOnSecondaryContainer: "#1D192B"
    property color secondaryFixed: "#E8DEF8"
    property color secondaryFixedDim: "#CCC2DC"
    property color colorOnSecondaryFixed: "#1D192B"
    property color colorOnSecondaryFixedVariant: "#4A4458"

    // --- Tertiary ---
    property color tertiary: "#7D5260"
    property color colorOnTertiary: "#FFFFFF"
    property color tertiaryContainer: "#FFD8E4"
    property color colorOnTertiaryContainer: "#31111D"
    property color tertiaryFixed: "#FFD8E4"
    property color tertiaryFixedDim: "#EFB8C8"
    property color colorOnTertiaryFixed: "#31111D"
    property color colorOnTertiaryFixedVariant: "#633B48"

    // --- Error ---
    property color error: "#B3261E"
    property color colorOnError: "#FFFFFF"
    property color errorContainer: "#F9DEDC"
    property color colorOnErrorContainer: "#410E0B"

    // --- Surface / neutral ---
    property color surface: "#FEF7FF"
    property color colorOnSurface: "#1D1B20"
    property color surfaceDim: "#DED8E1"
    property color surfaceBright: "#FEF7FF"
    property color surfaceContainerLowest: "#FFFFFF"
    property color surfaceContainerLow: "#F7F2FA"
    property color surfaceContainer: "#F3EDF7"
    property color surfaceContainerHigh: "#ECE6F0"
    property color surfaceContainerHighest: "#E6E0E9"
    property color colorOnSurfaceVariant: "#49454F"
    property color outline: "#79747E"
    property color outlineVariant: "#CAC4D0"
    property color shadow: "#000000"
    property color scrim: "#000000"
    property color inverseSurface: "#322F35"
    property color colorOnInverseSurface: "#F5EFF7"
    property color inversePrimary: "#D0BCFF"
    property color surfaceTint: "#6750A4"

    // Compatibility aliases (Flutter deprecated → mapped)
    property color background: surface
    property color colorOnBackground: colorOnSurface
    property color surfaceVariant: surfaceContainerHighest

    function withOpacity(c, a) {
        return Qt.rgba(c.r, c.g, c.b, a)
    }

    /// Cached disabled tokens — avoid Qt.rgba on every binding eval across buttons/lists.
    readonly property color disabledContentColor: Qt.rgba(colorOnSurface.r, colorOnSurface.g, colorOnSurface.b, 0.38)
    readonly property color disabledContainerColor: Qt.rgba(colorOnSurface.r, colorOnSurface.g, colorOnSurface.b, 0.12)

    function disabledContent() {
        return disabledContentColor
    }

    function disabledContainer() {
        return disabledContainerColor
    }

    /// Inactive gauge / chart track — solid roles (opacity tracks look washed out).
    /// Dark uses outlineVariant so arcs stay visible on surface *and* container cards.
    readonly property color gaugeTrack: dark ? outlineVariant : surfaceContainerHighest
    /// Filled dial face (wave / compass / knob).
    readonly property color gaugeDial: dark ? surfaceContainerHigh : surfaceContainerHighest
}
