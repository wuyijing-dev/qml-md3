import QtQuick
import Md3

/// Empty / no-results placeholder: icon, title, body, optional CTA.
Item {
    id: root

    property string icon: "inbox"
    property string title: qsTr("Nothing here")
    property string body: ""
    property string actionText: ""
    property url illustration: ""
    property real maxContentWidth: 360

    signal actionClicked()

    implicitWidth: Math.min(parent ? parent.width : maxContentWidth, maxContentWidth + 48)
    implicitHeight: col.implicitHeight + 48

    Accessible.role: Accessible.StaticText
    Accessible.name: title.length ? title : qsTr("Empty state")

    Column {
        id: col
        anchors.centerIn: parent
        width: Math.min(root.width - 32, root.maxContentWidth)
        spacing: 12

        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            visible: root.illustration.toString().length > 0
            source: root.illustration
            width: 120
            height: 120
            fillMode: Image.PreserveAspectFit
            asynchronous: true
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            visible: root.illustration.toString().length === 0 && root.icon.length > 0
            width: 72
            height: 72
            radius: 36
            color: Md3Theme.colorScheme.surfaceContainerHighest

            Md3Icon {
                anchors.centerIn: parent
                icon: root.icon
                size: 36
                iconColor: Md3Theme.colorScheme.colorOnSurfaceVariant
            }
        }

        Text {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
            text: root.title
            color: Md3Theme.colorScheme.colorOnSurface
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.titleLarge.size
            font.weight: Font.Medium
        }

        Text {
            width: parent.width
            visible: root.body.length > 0
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
            text: root.body
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.bodyMedium.size
        }

        Item { width: 1; height: 4; visible: root.actionText.length > 0 }

        Md3Button {
            anchors.horizontalCenter: parent.horizontalCenter
            visible: root.actionText.length > 0
            text: root.actionText
            onClicked: root.actionClicked()
        }
    }
}
