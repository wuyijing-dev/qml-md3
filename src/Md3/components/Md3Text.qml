import QtQuick

Text {
    id: root

    enum Role {
        DisplayLarge,
        DisplayMedium,
        DisplaySmall,
        HeadlineLarge,
        HeadlineMedium,
        HeadlineSmall,
        TitleLarge,
        TitleMedium,
        TitleSmall,
        BodyLarge,
        BodyMedium,
        BodySmall,
        LabelLarge,
        LabelMedium,
        LabelSmall
    }

    enum Tone {
        OnSurface,
        OnSurfaceVariant,
        Primary,
        Secondary,
        Tertiary,
        Error,
        Custom
    }

    property int role: Md3Text.BodyMedium
    property int tone: Md3Text.OnSurface
    property color customColor: Md3Theme.colorScheme.colorOnSurface
    property bool monospace: false

    function _typeForRole() {
        switch (role) {
        case Md3Text.DisplayLarge: return Md3Theme.typography.displayLarge
        case Md3Text.DisplayMedium: return Md3Theme.typography.displayMedium
        case Md3Text.DisplaySmall: return Md3Theme.typography.displaySmall
        case Md3Text.HeadlineLarge: return Md3Theme.typography.headlineLarge
        case Md3Text.HeadlineMedium: return Md3Theme.typography.headlineMedium
        case Md3Text.HeadlineSmall: return Md3Theme.typography.headlineSmall
        case Md3Text.TitleLarge: return Md3Theme.typography.titleLarge
        case Md3Text.TitleMedium: return Md3Theme.typography.titleMedium
        case Md3Text.TitleSmall: return Md3Theme.typography.titleSmall
        case Md3Text.BodyLarge: return Md3Theme.typography.bodyLarge
        case Md3Text.BodySmall: return Md3Theme.typography.bodySmall
        case Md3Text.LabelLarge: return Md3Theme.typography.labelLarge
        case Md3Text.LabelMedium: return Md3Theme.typography.labelMedium
        case Md3Text.LabelSmall: return Md3Theme.typography.labelSmall
        case Md3Text.BodyMedium:
        default:
            return Md3Theme.typography.bodyMedium
        }
    }

    color: {
        switch (tone) {
        case Md3Text.Primary: return Md3Theme.colorScheme.primary
        case Md3Text.Secondary: return Md3Theme.colorScheme.secondary
        case Md3Text.Tertiary: return Md3Theme.colorScheme.tertiary
        case Md3Text.Error: return Md3Theme.colorScheme.error
        case Md3Text.OnSurfaceVariant: return Md3Theme.colorScheme.colorOnSurfaceVariant
        case Md3Text.Custom: return customColor
        case Md3Text.OnSurface:
        default:
            return Md3Theme.colorScheme.colorOnSurface
        }
    }

    readonly property var _type: _typeForRole()
    font.family: monospace ? "Consolas" : Md3Theme.typography.fontFamily
    font.pixelSize: _type.size
    font.weight: _type.weight
    font.letterSpacing: _type.letterSpacing
}
