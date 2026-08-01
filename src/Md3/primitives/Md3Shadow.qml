import QtQuick
import QtQuick.Effects
import Md3

Item {
    id: root

    property real elevation: 0
    property real cornerRadius: 0
    property color shadowColor: Md3Theme.colorScheme.shadow
    readonly property real _elev: {
        if (!Md3Theme.effectsShadows || elevation <= 0)
            return 0
        return Math.min(elevation, Md3Theme.effectsMaxElevation)
    }
    /// Dual-blur MultiEffect is expensive; Balanced keeps blur, Low skips shadows entirely.
    readonly property bool _useBlur: _elev > 0 && Md3Theme.effectsShadows
    readonly property bool _layersOn: _useBlur && visible

    visible: _elev > 0
    z: -1

    // Soft ambient — separates surface from background
    Item {
        id: ambientHost
        anchors.fill: parent
        anchors.topMargin: Md3Theme.elevation.ambientY(root._elev)
        anchors.margins: -6
        opacity: Md3Theme.elevation.ambientOpacity(root._elev)
        visible: root._useBlur
        layer.enabled: root._layersOn
        layer.smooth: true
        layer.effect: MultiEffect {
            blurEnabled: true
            blur: Md3Theme.elevation.ambientBlur(root._elev)
            blurMax: 48
            blurMultiplier: 1.0
        }

        Rectangle {
            anchors.fill: parent
            anchors.margins: 6
            radius: root.cornerRadius
            color: root.shadowColor
        }
    }

    // Key / contact — directional depth under the FAB
    Item {
        id: keyHost
        anchors.fill: parent
        anchors.topMargin: Md3Theme.elevation.keyY(root._elev)
        anchors.margins: -3
        opacity: Md3Theme.elevation.keyOpacity(root._elev)
        visible: root._useBlur
        layer.enabled: root._layersOn
        layer.smooth: true
        layer.effect: MultiEffect {
            blurEnabled: true
            blur: Md3Theme.elevation.keyBlur(root._elev)
            blurMax: 32
            blurMultiplier: 0.9
        }

        Rectangle {
            anchors.fill: parent
            anchors.margins: 3
            radius: root.cornerRadius
            color: root.shadowColor
        }
    }

    Behavior on elevation {
        enabled: !Md3Theme.reduceMotion && Md3Theme.effectsLiveMotion
        NumberAnimation {
            duration: Md3Motion.short4
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Md3Motion.standard
        }
    }
}
