import QtQuick

Rectangle {
    id: root

    property string text: ""
    property string leadingIcon: "info"
    property string primaryAction: ""
    property string secondaryAction: ""
    property bool open: true

    signal primaryClicked()
    signal secondaryClicked()
    signal closed()

    visible: open
    width: parent ? parent.width : 400
    height: Math.max(68, col.implicitHeight + 16)
    color: Md3Theme.colorScheme.surfaceContainer

    Row {
        id: col
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        Md3Icon {
            icon: root.leadingIcon
            size: 24
            iconColor: Md3Theme.colorScheme.primary
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            width: parent.width - 200
            text: root.text
            wrapMode: Text.Wrap
            color: Md3Theme.colorScheme.colorOnSurface
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.bodyMedium.size
            anchors.verticalCenter: parent.verticalCenter
        }

        Md3Button {
            visible: root.secondaryAction.length > 0
            text: root.secondaryAction
            variant: Md3Button.Text
            anchors.verticalCenter: parent.verticalCenter
            onClicked: root.secondaryClicked()
        }
        Md3Button {
            visible: root.primaryAction.length > 0
            text: root.primaryAction
            variant: Md3Button.Text
            anchors.verticalCenter: parent.verticalCenter
            onClicked: root.primaryClicked()
        }
        Md3IconButton {
            icon: "close"
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                root.open = false
                root.closed()
            }
        }
    }
}
