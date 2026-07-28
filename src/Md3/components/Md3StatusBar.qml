import QtQuick

/// Desktop status bar: message on the left, progress + trailing items on the right.
Rectangle {
    id: root

    property string text: ""
    property string leadingIcon: ""
    property real progress: -1 // <0 hidden; 0–1 determinate
    property bool indeterminateProgress: false
    property bool showProgress: progress >= 0 || indeterminateProgress
    /// Trailing widgets (Text / Icon / custom) — shown after progress on the right.
    default property alias content: trailExtras.data

    signal messageClicked()

    implicitWidth: parent ? parent.width : 480
    implicitHeight: 28
    width: parent ? parent.width : implicitWidth
    height: implicitHeight
    color: Md3Theme.colorScheme.surfaceContainer
    clip: true

    Md3Divider {
        anchors.top: parent.top
        width: parent.width
    }

    Row {
        id: leftRow
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.right: trail.left
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        spacing: 8
        height: parent.height

        Md3Icon {
            visible: root.leadingIcon.length > 0
            anchors.verticalCenter: parent.verticalCenter
            icon: root.leadingIcon
            size: 16
            iconColor: Md3Theme.colorScheme.colorOnSurfaceVariant
        }

        Text {
            id: msg
            anchors.verticalCenter: parent.verticalCenter
            width: Math.max(0, leftRow.width - (root.leadingIcon.length > 0 ? 24 : 0))
            text: root.text
            elide: Text.ElideRight
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.labelSmall.size
            MouseArea {
                anchors.fill: parent
                enabled: root.text.length > 0
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                onClicked: root.messageClicked()
            }
        }
    }

    Row {
        id: trail
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10
        height: parent.height

        Item {
            visible: root.showProgress
            width: 88
            height: parent.height
            Md3LinearProgressIndicator {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                height: 4
                indeterminate: root.indeterminateProgress
                value: root.indeterminateProgress ? 0 : Math.max(0, Math.min(1, root.progress))
            }
        }

        Text {
            visible: root.showProgress && trailExtras.children.length > 0
            anchors.verticalCenter: parent.verticalCenter
            text: "·"
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.labelSmall.size
        }

        Row {
            id: trailExtras
            spacing: 12
            height: parent.height
        }
    }
}
