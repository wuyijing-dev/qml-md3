import QtQuick
import QtQuick.Layouts
import Md3

RowLayout {
    anchors.fill: parent
    spacing: 0

    Rectangle {
        Layout.preferredWidth: parent.width > 800 ? 320 : parent.width
        Layout.fillHeight: true
        color: Md3Theme.colorScheme.surfaceContainerLow
        Column {
            anchors.fill: parent
            Md3TopAppBar {
                width: parent.width
                title: "Inbox"
                size: Md3TopAppBar.Small
                trailingIcons: ["search"]
            }
            Md3ListTile {
                width: parent.width
                title: "Welcome"
                subtitle: "Getting started with Md3"
                selected: true
                showDivider: true
                onClicked: detail.text = "Welcome to the Md3 component library."
            }
            Md3ListTile {
                width: parent.width
                title: "Release notes"
                subtitle: "0.1.0 foundations"
                showDivider: true
                onClicked: detail.text = "Wave 0–7 initial surface is available in Gallery."
            }
            Md3ListTile {
                width: parent.width
                title: "Feedback"
                subtitle: "Report fidelity gaps"
                onClicked: detail.text = "Compare against Flutter Material 3 and m3.material.io."
            }
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: Md3Theme.colorScheme.surface
        visible: parent.width > 800
        Column {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 12
            Text {
                text: "Detail"
                color: Md3Theme.colorScheme.colorOnSurface
                font.pixelSize: Md3Theme.typography.headlineSmall.size
            }
            Text {
                id: detail
                width: parent.width
                wrapMode: Text.Wrap
                text: "Select an item"
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.bodyLarge.size
            }
        }
    }
}
