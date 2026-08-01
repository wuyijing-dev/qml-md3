import QtQuick
import Md3

/// Desktop command strip with primary actions and a secondary overflow menu
/// (WinUI CommandBar PrimaryCommands / SecondaryCommands).
Rectangle {
    id: root

    property real barHeight: 48
    property real contentSpacing: 4
    property real horizontalPadding: 8
    property bool showDivider: true
    /// Secondary / overflow items: [{ text, icon?, enabled? }, ...]
    property var overflowModel: []
    /// Optional explicit Window for overflow menu overlay.
    property var overlayWindow: null
    property string accessibleName: qsTr("Command bar")

    property alias content: primaryStack.content
    default property alias data: primaryStack.content

    readonly property bool overflowOpen: overflowMenu.open
    readonly property bool hasOverflow: overflowModel.length > 0

    signal overflowItemClicked(int index)

    width: parent ? parent.width : 400
    height: barHeight
    color: Md3Theme.colorScheme.surfaceContainerLow
    // FocusScope child owns tab cycle; bar itself is not a tab stop.
    activeFocusOnTab: false

    Accessible.role: Accessible.ToolBar
    Accessible.name: accessibleName

    function openOverflow() {
        if (!hasOverflow)
            return
        const p = Md3OverlayHost.mapToOverlay(overflowBtn, 0, overflowBtn.height + 4, root.overlayWindow)
        overflowMenu.menuWidth = Math.max(168, overflowBtn.width)
        if (overflowMenu.overlayWindow !== undefined)
            overflowMenu.overlayWindow = root.overlayWindow
        overflowMenu.popup(p.x, p.y)
    }

    function dismissOverflow() {
        overflowMenu.dismiss()
    }

    FocusScope {
        id: barFocus
        anchors.fill: parent
        focus: true

        Md3HStack {
            id: row
            anchors.fill: parent
            spacing: root.contentSpacing
            leftPadding: root.horizontalPadding
            rightPadding: root.horizontalPadding
            fillHeight: true
            alignment: Md3HStack.Center

            Md3HStack {
                id: primaryStack
                spacing: root.contentSpacing
                fillHeight: true
                alignment: Md3HStack.Center
            }

            Md3Spacer { expand: true }

            Md3AppBarButton {
                id: overflowBtn
                visible: root.hasOverflow
                icon: "more_horiz"
                label: qsTr("More")
                layout: Md3AppBarButton.IconOnly
                accessibleName: qsTr("More commands")
                activeFocusOnTab: visible && enabled
                onClicked: {
                    if (overflowMenu.open)
                        root.dismissOverflow()
                    else
                        root.openOverflow()
                }
                Keys.onReturnPressed: function (event) {
                    clicked()
                    event.accepted = true
                }
                Keys.onEnterPressed: function (event) {
                    clicked()
                    event.accepted = true
                }
                Keys.onSpacePressed: function (event) {
                    clicked()
                    event.accepted = true
                }
            }
        }
    }

    Md3Divider {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        visible: root.showDivider
    }

    Md3Menu {
        id: overflowMenu
        modal: true

        Repeater {
            model: root.overflowModel
            Md3MenuItem {
                required property int index
                required property var modelData
                width: Math.max(overflowMenu.menuWidth, 168)
                text: modelData.text !== undefined ? modelData.text : String(modelData)
                icon: modelData.icon !== undefined ? modelData.icon : ""
                enabled: modelData.enabled !== false
                onClicked: {
                    root.overflowItemClicked(index)
                    overflowMenu.dismiss()
                }
            }
        }
    }
}
