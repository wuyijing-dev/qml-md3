import QtQuick
import QtQuick.Layouts
import Md3

Flickable {
    id: root
    contentWidth: width
    contentHeight: column.height
    clip: true

    ColumnLayout {
        id: column
        width: root.width
        spacing: 20

        Text {
            text: "Common buttons"
            color: Md3Theme.colorScheme.colorOnSurface
            font.pixelSize: Md3Theme.typography.headlineMedium.size
            font.family: Md3Theme.typography.fontFamily
        }

        Text {
            text: "Variants"
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.titleSmall.size
        }

        Flow {
            Layout.fillWidth: true
            spacing: 12
            Md3Button { text: "Filled"; variant: Md3Button.Filled; icon: "add" }
            Md3Button { text: "Tonal"; variant: Md3Button.FilledTonal }
            Md3Button { text: "Elevated"; variant: Md3Button.Elevated }
            Md3Button { text: "Outlined"; variant: Md3Button.Outlined }
            Md3Button { text: "Text"; variant: Md3Button.Text }
            Md3Button { text: "Disabled"; enabled: false }
        }

        Text {
            text: "Icon buttons"
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.titleSmall.size
        }

        Row {
            spacing: 8
            Md3IconButton { variant: Md3IconButton.Standard; icon: "settings" }
            Md3IconButton { variant: Md3IconButton.Filled; icon: "favorite" }
            Md3IconButton { variant: Md3IconButton.FilledTonal; icon: "edit" }
            Md3IconButton { variant: Md3IconButton.Outlined; icon: "search" }
            Md3IconButton { enabled: false; icon: "delete" }
        }

        Text {
            text: "Toggle icon buttons"
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.titleSmall.size
        }

        Row {
            spacing: 8
            Md3ToggleIconButton { variant: Md3ToggleIconButton.Standard; icon: "favorite"; checked: true }
            Md3ToggleIconButton { variant: Md3ToggleIconButton.Filled; icon: "bookmark" }
            Md3ToggleIconButton { variant: Md3ToggleIconButton.FilledTonal; icon: "star" }
            Md3ToggleIconButton { variant: Md3ToggleIconButton.Outlined; icon: "visibility" }
            Md3ToggleIconButton { enabled: false; icon: "favorite"; checked: true }
        }

        Text {
            text: "Split button"
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.titleSmall.size
        }

        Flow {
            Layout.fillWidth: true
            spacing: 12
            Md3SplitButton {
                text: "Save"
                icon: "save"
                variant: Md3SplitButton.Filled
                menuModel: [
                    { text: "Save as", icon: "save" },
                    { text: "Save all", icon: "done_all" },
                    { text: "Export", icon: "upload" }
                ]
            }
            Md3SplitButton {
                text: "Share"
                icon: "share"
                variant: Md3SplitButton.FilledTonal
                menuModel: [
                    { text: "Copy link" },
                    { text: "Email" },
                    { text: "Message" }
                ]
            }
            Md3SplitButton {
                text: "Open"
                variant: Md3SplitButton.Outlined
                menuModel: [
                    { text: "Open recent" },
                    { text: "Browse files" }
                ]
            }
        }

        Text {
            text: "Standard button group"
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.titleSmall.size
        }

        Md3ButtonGroup {
            layout: Md3ButtonGroup.Standard
            variant: Md3ButtonGroup.Outlined
            model: [
                { text: "Cut", icon: "content_cut" },
                { text: "Copy", icon: "content_copy" },
                { text: "Paste", icon: "content_paste" }
            ]
        }

        Text {
            text: "Connected button group"
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.titleSmall.size
        }

        Md3ButtonGroup {
            id: connectedGroup
            layout: Md3ButtonGroup.Connected
            currentIndex: 0
            model: [
                { text: "Left", icon: "format_align_left" },
                { text: "Center", icon: "format_align_center" },
                { text: "Right", icon: "format_align_right" }
            ]
            onClicked: function (index) { currentIndex = index }
        }

        Text {
            text: "Segmented button"
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.titleSmall.size
        }

        Md3SegmentedButton {
            model: [
                { text: "Day", icon: "schedule" },
                { text: "Week" },
                { text: "Month", enabled: false }
            ]
        }

        Md3SegmentedButton {
            multiSelect: true
            selectedIndices: [0]
            model: [
                { text: "News" },
                { text: "Maps" },
                { text: "Music" }
            ]
        }
    }
}
