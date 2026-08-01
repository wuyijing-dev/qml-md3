import QtQuick
import Md3

/// MD3 skeleton bone — low-cost opacity pulse (avoids continuous sheen transforms).
Item {
    id: root

    enum Variant { Text, Circular, Rounded, Rectangular }

    property int variant: Md3Skeleton.Rounded
    property bool active: true
    property real boneHeight: variant === Md3Skeleton.Text ? 12 : height
    property color baseColor: Md3Theme.colorScheme.surfaceContainerHighest
    property real pulseOpacity: 0.7

    implicitWidth: variant === Md3Skeleton.Circular ? 40 : 160
    implicitHeight: variant === Md3Skeleton.Circular ? 40
                    : (variant === Md3Skeleton.Text ? boneHeight : 48)
    width: implicitWidth
    height: implicitHeight

    readonly property real _radius: {
        switch (variant) {
        case Md3Skeleton.Circular: return Math.min(width, height) / 2
        case Md3Skeleton.Text: return height / 2
        case Md3Skeleton.Rectangular: return Md3Theme.shape.extraSmall
        default: return Md3Theme.shape.small
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: root._radius
        color: root.baseColor
        opacity: root.active ? root.pulseOpacity : 1.0
    }

    SequentialAnimation {
        running: root.active && root.visible && !Md3Theme.reduceMotion
        loops: Animation.Infinite
        NumberAnimation {
            target: root
            property: "pulseOpacity"
            from: 0.45
            to: 0.9
            duration: Md3Motion.essential(1100)
            easing.type: Easing.InOutSine
        }
        NumberAnimation {
            target: root
            property: "pulseOpacity"
            from: 0.9
            to: 0.45
            duration: Md3Motion.essential(1100)
            easing.type: Easing.InOutSine
        }
    }
}
