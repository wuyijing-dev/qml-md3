import QtQuick
import Md3

/// WinUI-style in-page info bar — persistent until dismissed (unlike Snackbar).
Rectangle {
    id: root

    enum Severity { Informational, Success, Warning, Critical }

    property int severity: Md3InfoBar.Informational
    property string title: ""
    property string message: ""
    property string actionText: ""
    property bool showClose: true
    property bool open: true

    signal actionClicked()
    signal closed()

    visible: open
    width: parent ? parent.width : 480
    implicitHeight: Math.max(48, contentRow.implicitHeight + 20)
    height: implicitHeight
    radius: Md3Theme.shape.extraSmall
    clip: true

    readonly property color accent: {
        switch (severity) {
        case Md3InfoBar.Success: return Md3Theme.colorScheme.primary
        case Md3InfoBar.Warning: return Md3Theme.colorScheme.tertiary
        case Md3InfoBar.Critical: return Md3Theme.colorScheme.error
        default: return Md3Theme.colorScheme.secondary
        }
    }
    readonly property string defaultIcon: {
        switch (severity) {
        case Md3InfoBar.Success: return "check_circle"
        case Md3InfoBar.Warning: return "warning"
        case Md3InfoBar.Critical: return "error"
        default: return "info"
        }
    }
    property string icon: defaultIcon

    color: Md3Theme.colorScheme.withOpacity(accent, 0.12)

    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 4
        color: root.accent
    }

    Row {
        id: contentRow
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 16
        anchors.rightMargin: 8
        spacing: 12

        Md3Icon {
            anchors.verticalCenter: parent.verticalCenter
            icon: root.icon
            size: 22
            iconColor: root.accent
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            width: Math.max(60, contentRow.width - 22 - 12
                            - (root.actionText.length ? actionBtn.implicitWidth + 12 : 0)
                            - (root.showClose ? 48 : 0))
            spacing: 2

            Text {
                width: parent.width
                visible: root.title.length > 0
                text: root.title
                color: Md3Theme.colorScheme.colorOnSurface
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.typography.titleSmall.size
                font.weight: Font.DemiBold
                wrapMode: Text.Wrap
            }
            Text {
                width: parent.width
                visible: root.message.length > 0
                text: root.message
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.typography.bodyMedium.size
                wrapMode: Text.Wrap
            }
        }

        Md3Button {
            id: actionBtn
            anchors.verticalCenter: parent.verticalCenter
            visible: root.actionText.length > 0
            text: root.actionText
            variant: Md3Button.Text
            onClicked: root.actionClicked()
        }

        Md3IconButton {
            anchors.verticalCenter: parent.verticalCenter
            visible: root.showClose
            icon: "close"
            onClicked: {
                root.open = false
                root.closed()
            }
        }
    }
}
