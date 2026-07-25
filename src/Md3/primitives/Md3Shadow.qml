import QtQuick
import QtQuick.Effects

Item {
    id: root

    property real elevation: 0
    property real cornerRadius: 0
    property color shadowColor: Md3Theme.colorScheme.shadow

    visible: elevation > 0
    z: -1

    // Soft ambient — separates surface from background
    Item {
        id: ambientHost
        anchors.fill: parent
        anchors.topMargin: Md3Theme.elevation.ambientY(root.elevation)
        anchors.margins: -6
        opacity: Md3Theme.elevation.ambientOpacity(root.elevation)
        layer.enabled: true
        layer.smooth: true
        layer.effect: MultiEffect {
            blurEnabled: true
            blur: Md3Theme.elevation.ambientBlur(root.elevation)
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
        anchors.topMargin: Md3Theme.elevation.keyY(root.elevation)
        anchors.margins: -3
        opacity: Md3Theme.elevation.keyOpacity(root.elevation)
        layer.enabled: true
        layer.smooth: true
        layer.effect: MultiEffect {
            blurEnabled: true
            blur: Md3Theme.elevation.keyBlur(root.elevation)
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
        NumberAnimation {
            duration: Md3Motion.short4
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Md3Motion.standard
        }
    }
}
