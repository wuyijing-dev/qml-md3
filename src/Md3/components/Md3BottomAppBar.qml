import QtQuick
import Md3

Rectangle {
    id: root

    property var actions: [] // icon names
    property bool showFab: false

    signal actionClicked(int index)
    signal fabClicked()

    Accessible.role: Accessible.ToolBar
    Accessible.name: qsTr("Bottom app bar")

    width: parent ? parent.width : 360
    height: 80
    color: Md3Theme.colorScheme.surfaceContainer

    Row {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 4
        spacing: 4
        Repeater {
            model: root.actions
            Md3IconButton {
                required property int index
                required property var modelData
                icon: typeof modelData === "string" ? modelData : modelData.icon
                onClicked: root.actionClicked(index)
            }
        }
    }

    Md3Fab {
        visible: root.showFab
        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.verticalCenter: parent.verticalCenter
        size: Md3Fab.Regular
        onClicked: root.fabClicked()
    }
}
