import QtQuick

QtObject {
    id: root

    // M3 / Flutter state-layer opacities
    readonly property real hover: 0.08
    readonly property real focus: 0.12
    readonly property real pressed: 0.12
    readonly property real dragged: 0.16

    function opacityFor(isHovered, isFocused, isPressed, isDragged) {
        let v = 0
        if (isDragged)
            v = root.dragged
        else if (isPressed)
            v = root.pressed
        else if (isFocused)
            v = root.focus
        else if (isHovered)
            v = root.hover
        else
            return 0
        const scale = (Md3Theme && Md3Theme.effectsStateIntensity > 0)
                      ? Md3Theme.effectsStateIntensity : 1
        return Math.max(0, Math.min(0.4, v * scale))
    }
}
