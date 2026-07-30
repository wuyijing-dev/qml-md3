import QtQuick
import Md3

/// Circular avatar: image, initials, or icon fallback.
Item {
    id: root

    enum Size { ExtraSmall, Small, Medium, Large, ExtraLarge }

    property int sizePreset: Md3Avatar.Medium
    property url source: ""
    property string initials: ""
    property string icon: "person"
    property color color: Md3Theme.colorScheme.primaryContainer
    property color contentColor: Md3Theme.colorScheme.colorOnPrimaryContainer
    property string accessibleName: ""

    readonly property real pixelSize: {
        switch (sizePreset) {
        case Md3Avatar.ExtraSmall: return 24
        case Md3Avatar.Small: return 32
        case Md3Avatar.Large: return 56
        case Md3Avatar.ExtraLarge: return 72
        default: return 40
        }
    }

    implicitWidth: pixelSize
    implicitHeight: pixelSize
    width: pixelSize
    height: pixelSize

    Accessible.name: accessibleName.length ? accessibleName
                     : (initials.length ? initials : qsTr("Avatar"))
    Accessible.role: Accessible.Graphic

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: width / 2
        color: root.color
        clip: true

        Image {
            id: img
            anchors.fill: parent
            source: root.source
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            visible: status === Image.Ready
            mipmap: true
        }

        Text {
            anchors.centerIn: parent
            visible: !img.visible && root.initials.length > 0
            text: root.initials
            color: root.contentColor
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Math.round(root.pixelSize * 0.36)
            font.weight: Font.Medium
        }

        Md3Icon {
            anchors.centerIn: parent
            visible: !img.visible && root.initials.length === 0
            icon: root.icon
            size: Math.round(root.pixelSize * 0.5)
            iconColor: root.contentColor
        }
    }
}
