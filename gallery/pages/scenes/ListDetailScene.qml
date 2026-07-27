import QtQuick
import QtQuick.Layouts
import Md3

Md3SplitView {
    id: root
    anchors.fill: parent
    splitRatio: width > 900 ? 0.32 : 0.42
    minPane1: 220
    minPane2: 280

    property string detailText: qsTr("Select an item")

    Rectangle {
        color: Md3Theme.colorScheme.surfaceContainerLow
        Column {
            anchors.fill: parent
            Md3TopAppBar {
                width: parent.width
                title: qsTr("Inbox")
                size: Md3TopAppBar.Small
                trailingIcons: ["search"]
            }
            Md3ListTile {
                width: parent.width
                title: qsTr("Welcome")
                subtitle: qsTr("Getting started with Md3")
                selected: true
                showDivider: true
                onClicked: root.detailText = qsTr("Welcome to the Md3 component library.")
            }
            Md3ListTile {
                width: parent.width
                title: qsTr("Release notes")
                subtitle: qsTr("0.1.0 foundations")
                showDivider: true
                onClicked: root.detailText = qsTr("Wave 0–7 initial surface is available in Gallery.")
            }
            Md3ListTile {
                width: parent.width
                title: qsTr("Feedback")
                subtitle: qsTr("Report fidelity gaps")
                onClicked: root.detailText = qsTr("Compare against Flutter Material 3 and m3.material.io.")
            }
        }
    }

    Rectangle {
        color: Md3Theme.colorScheme.surface
        Column {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 12
            Text {
                text: qsTr("Detail")
                color: Md3Theme.colorScheme.colorOnSurface
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.typography.headlineSmall.size
            }
            Text {
                width: parent.width
                wrapMode: Text.Wrap
                text: root.detailText
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.typography.bodyLarge.size
            }
            Text {
                width: parent.width
                wrapMode: Text.Wrap
                text: qsTr("Drag the divider to resize panes (Md3SplitView).")
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.typography.bodySmall.size
            }
        }
    }
}
