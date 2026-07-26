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

    readonly property real resolvedClipRadius: {
        if (clipRadius >= 0)
            return clipRadius
        if (parent && parent.radius !== undefined)
            return parent.radius
        return Math.min(width, height) / 2
    }

    function pulse(x, y) {
        originX = x
        originY = y
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

    // Clip expanding ink to rounded container (Qt clip is rectangular only).
    Item {
        id: inkHost
        anchors.fill: parent
        layer.enabled: true
        layer.smooth: true
        layer.effect: MultiEffect {
            maskEnabled: true
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
                        to: Math.max(root.width, root.height) * 2.2
                        duration: Md3Motion.rippleDuration
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.standardDecelerate
                    }
                    NumberAnimation {
                        target: circle
                        property: "opacity"
                        from: 0.16
                        to: 0.08
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
                ScriptAction { script: circle.width = 0 }
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
        layer.enabled: true
        layer.smooth: true
        visible: false
        Rectangle {
            anchors.fill: parent
            // Match container corner exactly (FAB is rounded-rect, not a circle).
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
