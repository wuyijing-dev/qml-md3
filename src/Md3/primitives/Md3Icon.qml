import QtQuick

Text {
    id: root

    property string icon: "circle"
    property int size: 24
    property color iconColor: Md3Theme.colorScheme.colorOnSurface
    // "filled" (default; reliable TTF ligatures) | "outlined"
    property string variant: "filled"

    text: ligatureFor(icon)
    color: iconColor
    font.pixelSize: size
    // Prefer filled Material Icons (TTF ligatures are reliable in Qt);
    // Outlined OTF is optional via variant: "outlined".
    font.family: variant === "outlined"
                 ? Md3Theme.typography.iconFontFamilyOutlined
                 : Md3Theme.typography.iconFontFamily
    font.weight: Font.Normal
    font.hintingPreference: Font.PreferFullHinting
    renderType: Text.QtRendering
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    width: size
    height: size

    // Material Icons / Outlined use ligature names as the glyph text.
    function ligatureFor(name) {
        switch (name) {
        case "circle": return "circle"
        case "menu": return "menu"
        case "close": return "close"
        case "check": return "check"
        case "add": return "add"
        case "edit": return "edit"
        case "delete": return "delete"
        case "search": return "search"
        case "settings": return "settings"
        case "home": return "home"
        case "person": return "person"
        case "favorite": return "favorite"
        case "star": return "star"
        case "arrow_back": return "arrow_back"
        case "arrow_forward": return "arrow_forward"
        case "more_vert": return "more_vert"
        case "info": return "info"
        case "warning": return "warning"
        case "visibility": return "visibility"
        case "visibility_off": return "visibility_off"
        case "calendar": return "calendar_today"
        case "schedule": return "schedule"
        case "expand_more": return "expand_more"
        case "expand_less": return "expand_less"
        case "chevron_right": return "chevron_right"
        case "chevron_left": return "chevron_left"
        case "radio_checked": return "radio_button_checked"
        case "radio_unchecked": return "radio_button_unchecked"
        case "check_box": return "check_box"
        case "check_box_outline": return "check_box_outline_blank"
        default: return name.length ? name : "circle"
        }
    }
}
