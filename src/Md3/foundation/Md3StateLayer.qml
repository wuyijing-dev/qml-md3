import QtQuick

QtObject {
    id: root

    // M3 / Flutter state-layer opacities
    readonly property real hover: 0.08
    readonly property real focus: 0.12
    readonly property real pressed: 0.12
    readonly property real dragged: 0.16

    function opacityFor(isHovered, isFocused, isPressed, isDragged) {
        if (isDragged)
            return root.dragged
        if (isPressed)
            return root.pressed
        if (isFocused)
            return root.focus
        if (isHovered)
            return root.hover
        return 0
    }
}
