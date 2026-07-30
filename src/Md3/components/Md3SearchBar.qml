import QtQuick
import Md3

Item {
    id: root

    property alias text: input.text
    property string placeholderText: qsTr("Search")
    // Use Item.enabled (do not redeclare)
    /// When set, click / focus opens this Md3SearchView (forwards `text`).
    property var searchView: null

    signal accepted(string text)
    signal clicked()

    function openSearchView() {
        if (!searchView)
            return
        if (searchView.text !== undefined)
            searchView.text = text
        searchView.open = true
    }

    width: parent ? Math.min(parent.width, 720) : 360
    height: 56

    Accessible.role: Accessible.EditableText
    Accessible.name: placeholderText.length ? placeholderText : qsTr("Search bar")

    Rectangle {
        anchors.fill: parent
        radius: Md3Theme.shape.full
        color: Md3Theme.colorScheme.surfaceContainerHigh
        clip: true

        Md3StateOverlay {
            overlayColor: Md3Theme.colorScheme.colorOnSurface
            hovered: mouse.containsMouse
            pressed: mouse.pressed
            controlEnabled: root.enabled
            radius: parent.radius
        }

        Row {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            spacing: 12

            Md3Icon {
                icon: "search"
                size: 24
                iconColor: Md3Theme.colorScheme.colorOnSurfaceVariant
                anchors.verticalCenter: parent.verticalCenter
            }

            TextInput {
                id: input
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 72
                enabled: root.enabled
                color: Md3Theme.colorScheme.colorOnSurface
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.typography.bodyLarge.size
                onAccepted: root.accepted(text)
            }
        }
    }

    Text {
        anchors.left: parent.left
        anchors.leftMargin: 52
        anchors.verticalCenter: parent.verticalCenter
        text: root.placeholderText
        visible: input.text.length === 0 && !input.activeFocus
        color: Md3Theme.colorScheme.colorOnSurfaceVariant
        font: input.font
        opacity: 0.7
        z: 1
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        z: -1
        onClicked: {
            input.forceActiveFocus()
            root.openSearchView()
            root.clicked()
        }
    }
}
