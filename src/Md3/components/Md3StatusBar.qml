import QtQuick

/// Desktop status bar — left / center / right zones, transient messages.
Rectangle {
    id: root

    property string text: ""
    property string centerText: ""
    property string leadingIcon: ""
    property real progress: -1
    property bool indeterminateProgress: false
    property bool showProgress: progress >= 0 || indeterminateProgress
  property string _transientText: ""
  property bool _showTransient: false

    default property alias leftContent: leftExtra.data
    property alias centerContent: centerRow.data
    property alias rightContent: trailExtras.data

    signal messageClicked()

    implicitWidth: parent ? parent.width : 480
    implicitHeight: 28
    width: parent ? parent.width : implicitWidth
    height: implicitHeight
    color: Md3Theme.colorScheme.surfaceContainer
    clip: true

    function showMessage(message, timeout) {
        const ms = (timeout !== undefined && timeout > 0) ? timeout : 4000
        _transientText = message
        _showTransient = true
        transientTimer.interval = ms
        transientTimer.restart()
    }

    function clearMessage() {
        transientTimer.stop()
        _showTransient = false
        _transientText = ""
    }

    readonly property string displayText: _showTransient && _transientText.length
            ? _transientText : text

    Md3Divider {
        anchors.top: parent.top
        width: parent.width
    }

    Timer {
        id: transientTimer
        repeat: false
        onTriggered: root.clearMessage()
    }

    Row {
        id: leftRow
        anchors.left: parent.left
        anchors.leftMargin: 12
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
            width: Math.min(
                       Math.max(80, root.width * 0.34),
                       Math.max(80, centerSlot.x - leftRow.x - leftRow.width - 16))
            text: root.displayText
            elide: Text.ElideRight
            color: root._showTransient ? Md3Theme.colorScheme.primary
                                       : Md3Theme.colorScheme.colorOnSurfaceVariant
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.labelSmall.size
            MouseArea {
                anchors.fill: parent
                enabled: root.displayText.length > 0
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                onClicked: root.messageClicked()
            }
        }

        Row {
            id: leftExtra
            spacing: 8
            height: parent.height
        }
    }

    Item {
        id: centerSlot
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: Math.min(parent.width * 0.38, Math.max(80, centerRow.implicitWidth))
        height: parent.height
        clip: true

        Row {
            id: centerRow
            anchors.centerIn: parent
            spacing: 8
            height: parent.height

            Text {
                visible: root.centerText.length > 0
                anchors.verticalCenter: parent.verticalCenter
                text: root.centerText
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.typography.labelSmall.size
                elide: Text.ElideRight
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
