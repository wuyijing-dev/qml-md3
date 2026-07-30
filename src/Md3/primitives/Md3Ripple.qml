import QtQuick
import QtQuick.Effects

Item {
    id: root
    anchors.fill: parent

    property color rippleColor: Md3Theme.colorScheme.colorOnSurface
    // -1 = match parent Rectangle.radius (FAB / Button container); >=0 = explicit
    property real clipRadius: -1
    /// Per-corner override (Connected button ends). <0 falls back to resolvedClipRadius.
    property real topLeftRadius: -1
    property real topRightRadius: -1
    property real bottomLeftRadius: -1
    property real bottomRightRadius: -1
    property bool active: false
    property real originX: width / 2
    property real originY: height / 2

    /// Keep offscreen FBOs only while ink is visible / animating.
    property bool _layersArmed: false
    readonly property bool useMaskedRipple: Md3Theme.effectsRippleMasked
    readonly property bool layersNeeded: useMaskedRipple && (_layersArmed
            || ripple.running
            || interruptFade.running
            || circle.opacity > 0.01)

    readonly property real resolvedClipRadius: {
        if (clipRadius >= 0)
            return clipRadius
        if (parent && parent.radius !== undefined)
            return parent.radius
        return Math.min(width, height) / 2
    }

    readonly property real _peak: Md3Theme.effectsRipplePeak
    readonly property real _hold: Md3Theme.effectsRippleHold
    readonly property real _spread: Md3Theme.effectsRippleSpread

    function pulse(x, y) {
        if (!Md3Theme.effectsRipple) {
            _releaseLayers()
            return
        }
        originX = x
        originY = y
        _layersArmed = useMaskedRipple
        // Interrupt in-flight ink: fade from current opacity, then expand again.
        if (ripple.running || interruptFade.running) {
            ripple.stop()
            interruptFade.stop()
            interruptFade.start()
            return
        }
        circle.width = 0
        circle.opacity = 0
        ripple.start()
    }

    function _releaseLayers() {
        circle.width = 0
        circle.opacity = 0
        _layersArmed = false
    }

    // Clip expanding ink to rounded container (Qt clip is rectangular only).
    Item {
        id: inkHost
        anchors.fill: parent
        // Low tier: no MultiEffect mask FBO — rectangular clip only.
        clip: !root.useMaskedRipple
        layer.enabled: root.layersNeeded
        layer.smooth: true
        layer.effect: MultiEffect {
            maskEnabled: root.useMaskedRipple
            maskSource: maskItem
        }

        Rectangle {
            id: circle
            width: 0
            height: width
            radius: width / 2
            x: root.originX - width / 2
            y: root.originY - height / 2
            color: root.rippleColor
            opacity: 0

            SequentialAnimation {
                id: ripple
                alwaysRunToEnd: false
                ParallelAnimation {
                    NumberAnimation {
                        target: circle
                        property: "width"
                        from: 0
                        to: Math.max(root.width, root.height) * root._spread
                        duration: Md3Motion.rippleDuration
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.standardDecelerate
                    }
                    NumberAnimation {
                        target: circle
                        property: "opacity"
                        from: root._peak
                        to: root._hold
                        duration: Md3Motion.rippleDuration
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.standard
                    }
                }
                NumberAnimation {
                    target: circle
                    property: "opacity"
                    to: 0
                    duration: Md3Motion.short4
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.standard
                }
                ScriptAction { script: root._releaseLayers() }
            }

            SequentialAnimation {
                id: interruptFade
                alwaysRunToEnd: false
                NumberAnimation {
                    target: circle
                    property: "opacity"
                    to: 0
                    duration: Md3Motion.short2
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.uiExit
                }
                ScriptAction {
                    script: {
                        circle.width = 0
                        circle.opacity = 0
                        ripple.start()
                    }
                }
            }
        }
    }

    Item {
        id: maskItem
        width: root.width
        height: root.height
        layer.enabled: root.layersNeeded
        layer.smooth: true
        visible: false
        Rectangle {
            anchors.fill: parent
            readonly property real base: root.resolvedClipRadius
            topLeftRadius: root.topLeftRadius >= 0 ? root.topLeftRadius : base
            topRightRadius: root.topRightRadius >= 0 ? root.topRightRadius : base
            bottomLeftRadius: root.bottomLeftRadius >= 0 ? root.bottomLeftRadius : base
            bottomRightRadius: root.bottomRightRadius >= 0 ? root.bottomRightRadius : base
            color: "#ffffff"
        }
    }

    onActiveChanged: {
        if (active)
            pulse(originX, originY)
    }
}
