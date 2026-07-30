import QtQuick
import Md3

Item {
    id: root

    property color color: Md3Theme.colorScheme.surface
    property real elevation: 0
    property real radius: Md3Theme.shape.medium
    property bool clipContent: true
    property color tintColor: Md3Theme.colorScheme.surfaceTint
    property int layoutMode: Md3ContainerBody.Fit

    implicitWidth: 48
    implicitHeight: 48

    Md3Shadow {
        anchors.fill: parent
        elevation: root.elevation
        cornerRadius: root.radius
    }

    Rectangle {
        id: fill
        anchors.fill: parent
        radius: root.radius
        color: root.color
        clip: root.clipContent

        Rectangle {
            anchors.fill: parent
            radius: root.radius
            color: root.tintColor
            opacity: Md3Theme.elevation.tintOpacity(root.elevation)
        }

        default property alias contentData: contentHost.content
        Md3ContainerBody {
            id: contentHost
            anchors.fill: parent
            layoutMode: root.layoutMode
        }
    }
}
