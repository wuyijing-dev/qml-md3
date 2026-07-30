import QtQuick
import Md3

Rectangle {
    id: root
    anchors.fill: parent
    color: overlayColor
    opacity: layerOpacity
    visible: layerOpacity > 0

    property color overlayColor: Md3Theme.colorScheme.colorOnSurface
    property bool hovered: false
    property bool focused: false
    property bool pressed: false
    property bool dragged: false
    property bool controlEnabled: true

    readonly property real layerOpacity: {
        if (!controlEnabled)
            return 0
        const v = Md3Theme.stateLayer.opacityFor(hovered, focused, pressed, dragged)
        return (v === undefined || v === null) ? 0 : v
    }

    // Original button/state pacing (~100ms)
    Behavior on opacity {
        NumberAnimation {
            duration: Md3Motion.stateDuration
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Md3Motion.standard
        }
    }
}
