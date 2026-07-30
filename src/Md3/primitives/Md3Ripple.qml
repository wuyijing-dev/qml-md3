import QtQuick
import QtQuick.Effects
import Md3

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
    readonly property bool useInkRipple: Md3Theme.effectsRipple
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
    readonly property real _tl: topLeftRadius >= 0 ? topLeftRadius : resolvedClipRadius
    readonly property real _tr: topRightRadius >= 0 ? topRightRadius : resolvedClipRadius
    readonly property real _bl: bottomLeftRadius >= 0 ? bottomLeftRadius : resolvedClipRadius
    readonly property real _br: bottomRightRadius >= 0 ? bottomRightRadius : resolvedClipRadius

    readonly property real _peak: Md3Theme.effectsRipplePeak
    readonly property real _hold: Md3Theme.effectsRippleHold
    readonly property real _spread: Md3Theme.effectsRippleSpread

    function pulse(x, y) {
        // 流畅: rounded press flash (no MultiEffect FBO). 均衡/画质: masked ink.
        if (!useInkRipple) {
            if (Md3Theme.reduceMotion)
                return
            originX = x
            originY = y
            if (flashAnim.running)
                flashAnim.stop()
            flash.opacity = 0
            flashAnim.start()
            return
        }
        originX = x
        originY = y
        _layersArmed = useMaskedRipple
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

    // Cheap rounded feedback for Low tier — Rectangle radii, no mask FBO.
    Rectangle {
        id: flash
        anchors.fill: parent
        topLeftRadius: root._tl
        topRightRadius: root._tr
        bottomLeftRadius: root._bl
        bottomRightRadius: root._br
        color: root.rippleColor
        opacity: 0
        visible: opacity > 0.01
        z: 1

        SequentialAnimation {
            id: flashAnim
            alwaysRunToEnd: false
            NumberAnimation {
                target: flash
                property: "opacity"
                to: Math.max(0.1, root._peak * 1.15)
                duration: Md3Motion.short1
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.standard
            }
            NumberAnimation {
                target: flash
                property: "opacity"
                to: 0
                duration: Md3Motion.short4
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.standard
            }
        }
    }

    // Expanding ink — masked to rounded container on Balanced/High.
    Item {
        id: inkHost
        anchors.fill: parent
        visible: root.useInkRipple
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
            topLeftRadius: root._tl
            topRightRadius: root._tr
            bottomLeftRadius: root._bl
            bottomRightRadius: root._br
            color: "#ffffff"
        }
    }

    onActiveChanged: {
        if (active)
            pulse(originX, originY)
    }
}
