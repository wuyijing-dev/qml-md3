import QtQuick

QtObject {
    readonly property real none: 0
    readonly property real extraSmall: 4
    readonly property real small: 8
    readonly property real medium: 12
    readonly property real large: 16
    readonly property real extraLarge: 28
    readonly property real full: 9999

    function radius(token) {
        switch (token) {
        case "none": return none
        case "extraSmall": return extraSmall
        case "small": return small
        case "medium": return medium
        case "large": return large
        case "extraLarge": return extraLarge
        case "full": return full
        default: return medium
        }
    }
}
