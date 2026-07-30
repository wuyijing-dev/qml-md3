import QtQuick
import Md3

Md3SplitView {
    id: root
    anchors.fill: parent
    splitRatio: width > 900 ? 0.32 : 0.42
    minPane1: 220
    minPane2: 280

    property string detailText: qsTr("Select an item")

    Md3Surface {
        radius: 0
        elevation: 0
        color: Md3Theme.colorScheme.surfaceContainerLow
        Md3VStack {
            anchors.fill: parent
            spacing: 0
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
                subtitle: qsTr("1.0.0 stable release")
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

    Md3Surface {
        radius: 0
        elevation: 0
        color: Md3Theme.colorScheme.surface
        Md3VStack {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 12
            Md3Text {
                text: qsTr("Detail")
                role: Md3Text.HeadlineSmall
            }
            Md3Text {
                width: parent.width
                wrapMode: Text.Wrap
                text: root.detailText
                role: Md3Text.BodyLarge
                tone: Md3Text.OnSurfaceVariant
            }
            Md3Text {
                width: parent.width
                wrapMode: Text.Wrap
                text: qsTr("Drag the divider to resize panes (Md3SplitView).")
                role: Md3Text.BodySmall
                tone: Md3Text.OnSurfaceVariant
            }
        }
    }
}
