import QtQuick

Rectangle {
    id: root

    property string text: ""
    property string leadingIcon: "info"
    property string primaryAction: ""
    property string secondaryAction: ""
    property bool showClose: true
    property bool open: true

    signal primaryClicked()
    signal secondaryClicked()
    signal closed()

    visible: open
    width: parent ? parent.width : 400
    implicitHeight: Math.max(68, Math.max(leadIcon.height, message.implicitHeight, actions.implicitHeight) + 32)
    height: implicitHeight
    color: Md3Theme.colorScheme.surfaceContainer
    clip: true

    Md3Icon {
        id: leadIcon
        anchors.left: parent.left
        anchors.leftMargin: 16
        anchors.verticalCenter: parent.verticalCenter
        icon: root.leadingIcon
        size: 24
        iconColor: Md3Theme.colorScheme.primary
    }

    Row {
        id: actions
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0

        Md3Button {
            visible: root.secondaryAction.length > 0
            text: root.secondaryAction
            variant: Md3Button.Text
            onClicked: root.secondaryClicked()
        }
        Md3Button {
            visible: root.primaryAction.length > 0
            text: root.primaryAction
            variant: Md3Button.Text
            onClicked: root.primaryClicked()
        }
        Md3IconButton {
            visible: root.showClose
            icon: "close"
            onClicked: {
                root.open = false
                root.closed()
            }
        }
    }

    Text {
        id: message
        anchors.left: leadIcon.right
        anchors.leftMargin: 16
        anchors.right: actions.left
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        text: root.text
        wrapMode: Text.Wrap
        maximumLineCount: 3
        elide: Text.ElideRight
        color: Md3Theme.colorScheme.colorOnSurface
        font.family: Md3Theme.typography.fontFamily
        font.pixelSize: Md3Theme.typography.bodyMedium.size
    }
}
