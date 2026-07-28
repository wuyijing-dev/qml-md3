import QtQuick

/// Desktop status bar: message on the left, optional progress, trailing status items.
Rectangle {
    id: root

    property string text: ""
    property string leadingIcon: ""
    property real progress: -1 // <0 hidden; 0–1 determinate; NaN-safe
    property bool indeterminateProgress: false
    property bool showProgress: progress >= 0 || indeterminateProgress
    /// Trailing widgets (Text / Icon / custom).
    default property alias content: trail.data

    signal messageClicked()

    implicitWidth: parent ? parent.width : 480
    implicitHeight: 28
    width: implicitWidth
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
            width: Math.max(0, leftRow.width
                            - (root.leadingIcon.length > 0 ? 24 : 0)
                            - (root.showProgress ? 108 : 0))
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

        Item {
            visible: root.showProgress
            width: 100
            height: parent.height
            Md3LinearProgressIndicator {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                height: 4
                indeterminate: root.indeterminateProgress
                value: root.indeterminateProgress ? 0 : Math.max(0, Math.min(1, root.progress))
            }
        }
    }

    Row {
        id: trail
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        spacing: 12
        height: parent.height
    }
}
