import QtQuick
import QtQuick.Layouts
import Md3

Item {
    id: root

    Flickable {
        anchors.fill: parent
        contentWidth: width
        contentHeight: column.height
        clip: true
        ColumnLayout {
            id: column
            width: root.width
            spacing: 16
            Text {
                text: "Containment"
                color: Md3Theme.colorScheme.colorOnSurface
                font.pixelSize: Md3Theme.typography.headlineMedium.size
            }
            RowLayout {
                spacing: 12
                Md3Card {
                    variant: Md3Card.Elevated
                    Layout.preferredWidth: 180
                    Layout.preferredHeight: 100
                    Text { text: "Elevated"; color: Md3Theme.colorScheme.colorOnSurface }
                }
                Md3Card {
                    variant: Md3Card.Filled
                    Layout.preferredWidth: 180
                    Layout.preferredHeight: 100
                    Text { text: "Filled"; color: Md3Theme.colorScheme.colorOnSurface }
                }
                Md3Card {
                    variant: Md3Card.Outlined
                    Layout.preferredWidth: 180
                    Layout.preferredHeight: 100
                    Text { text: "Outlined"; color: Md3Theme.colorScheme.colorOnSurface }
                }
            }
            Column {
                Layout.fillWidth: true
                width: root.width
                Md3ListTile { width: parent.width; title: "One line"; leadingIcon: "person"; trailingIcon: "chevron_right"; showDivider: true }
                Md3ListTile { width: parent.width; title: "Two line"; subtitle: "Supporting"; leadingIcon: "settings"; showDivider: true }
                Md3ListTile { width: parent.width; title: "Three line"; subtitle: "Subtitle"; supportingText: "Extra supporting text."; leadingIcon: "info" }
            }
            Md3Button { text: "Open dialog"; onClicked: dlg.open = true }
            Md3Button { text: "Open bottom sheet"; variant: Md3Button.Outlined; onClicked: sheet.open = true }
        }
    }

    Md3Dialog {
        id: dlg
        anchors.fill: parent
        title: "Dialog"
        text: "This is a Material 3 dialog."
    }
    Md3BottomSheet {
        id: sheet
        anchors.fill: parent
        Text {
            text: "Bottom sheet content"
            color: Md3Theme.colorScheme.colorOnSurface
            padding: 8
        }
    }
}
