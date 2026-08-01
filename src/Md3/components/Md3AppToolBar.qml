import QtQuick
import Md3

/// Compact app tool strip for `Md3ApplicationWindow.toolBar` (desktop chrome).
Rectangle {
    id: root

    property real barHeight: Md3Theme.controlHeight + 8
    property real contentSpacing: Md3Theme.spacingSm
    property real horizontalPadding: Md3Theme.spacingMd
    property bool showDivider: true
    property alias content: stack.content
    default property alias data: stack.content

    width: parent ? parent.width : 400
    height: barHeight
    color: Md3Theme.colorScheme.surfaceContainerLow

    Accessible.role: Accessible.ToolBar
    Accessible.name: qsTr("Toolbar")

    Md3HStack {
        id: stack
        anchors.fill: parent
        spacing: root.contentSpacing
        leftPadding: root.horizontalPadding
        rightPadding: root.horizontalPadding
        fillHeight: true
        alignment: Md3HStack.Center
    }

    Md3Divider {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        visible: root.showDivider
    }
}
