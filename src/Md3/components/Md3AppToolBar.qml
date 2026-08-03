import QtQuick
import Md3

/// Compact app tool strip for `Md3ApplicationWindow.toolBar` (desktop chrome).
Rectangle {
    id: root

    enum Density { Standard, Compact }

    property int density: Md3AppToolBar.Standard
    property real barHeight: density === Md3AppToolBar.Compact
                             ? Md3Theme.controlHeight
                             : (Md3Theme.controlHeight + 8)
    property real contentSpacing: density === Md3AppToolBar.Compact
                                  ? Md3Theme.spacingXs
                                  : Md3Theme.spacingSm
    property real horizontalPadding: Md3Theme.spacingMd
    property bool showDivider: true
    /// Optional overflow control (e.g. Md3IconButton "more") pinned to the trailing edge.
    property alias trailing: trailingSlot.data
    property alias content: stack.content
    default property alias data: stack.content

    width: parent ? parent.width : 400
    height: barHeight
    color: Md3Theme.colorScheme.surfaceContainerLow

    Accessible.role: Accessible.ToolBar
    Accessible.name: qsTr("Toolbar")

    Md3HStack {
        id: stack
        anchors.left: parent.left
        anchors.right: trailingSlot.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: trailingSlot.visible ? 4 : 0
        spacing: root.contentSpacing
        leftPadding: root.horizontalPadding
        rightPadding: trailingSlot.visible ? 4 : root.horizontalPadding
        fillHeight: true
        alignment: Md3HStack.Center
    }

    Item {
        id: trailingSlot
        anchors.right: parent.right
        anchors.rightMargin: root.horizontalPadding
        anchors.verticalCenter: parent.verticalCenter
        width: children.length ? Math.max(1, childrenRect.width) : 0
        height: Math.max(1, childrenRect.height, root.barHeight - 8)
        visible: children.length > 0
    }

    Md3Divider {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        visible: root.showDivider
    }
}
