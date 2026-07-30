pragma Singleton
import QtQuick
import Md3

/// Shared Material Icons font faces — one FontLoader pair for the whole app (not per Md3Icon).
QtObject {
    id: root

    readonly property url filledSource: "qrc:/md3/fonts/resources/fonts/MaterialIcons-Regular.ttf"
    readonly property url outlinedSource: "qrc:/md3/fonts/resources/fonts/MaterialIconsOutlined-Regular.otf"

    // QtObject has no default property — keep loaders as explicit properties.
    readonly property FontLoader filledLoader: FontLoader {
        source: root.filledSource
    }
    readonly property FontLoader outlinedLoader: FontLoader {
        source: root.outlinedSource
    }

    readonly property bool filledReady: filledLoader.status === FontLoader.Ready
    readonly property bool outlinedReady: outlinedLoader.status === FontLoader.Ready

    readonly property string filledFamily: filledReady ? filledLoader.name : Md3Theme.typography.iconFontFamily
    readonly property string outlinedFamily: outlinedReady ? outlinedLoader.name : Md3Theme.typography.iconFontFamilyOutlined

    function familyFor(variant) {
        if (String(variant || "") === "outlined")
            return outlinedFamily
        return filledFamily
    }
}
