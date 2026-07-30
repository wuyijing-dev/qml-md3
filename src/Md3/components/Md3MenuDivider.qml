import QtQuick
import Md3

Item {
    id: root
    height: 17 // 8 + 1 + 8
    width: parent ? parent.width : 200

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        height: 1
        color: Md3Theme.colorScheme.outlineVariant
    }
}
