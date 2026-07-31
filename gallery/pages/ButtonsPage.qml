import QtQuick
import Md3

Flickable {
    id: root
    contentWidth: width
    contentHeight: column.height
    clip: true

    Md3VStack {
        id: column
        width: root.width
        spacing: 20

        Md3Text {
            text: "Common buttons"
            role: Md3Text.HeadlineMedium
        }

        Md3Text {
            text: "Variants"
            role: Md3Text.TitleSmall
            tone: Md3Text.OnSurfaceVariant
        }

        Md3FlowLayout {
            width: parent.width
            spacing: 12
            Md3Button { text: "Filled"; variant: Md3Button.Filled; icon: "add" }
            Md3Button { text: "Tonal"; variant: Md3Button.FilledTonal }
            Md3Button { text: "Elevated"; variant: Md3Button.Elevated }
            Md3Button { text: "Outlined"; variant: Md3Button.Outlined }
            Md3Button { text: "Text"; variant: Md3Button.Text }
            Md3Button { text: "Disabled"; enabled: false }
        }

        Md3Text {
            text: "Icon buttons"
            role: Md3Text.TitleSmall
            tone: Md3Text.OnSurfaceVariant
        }

        Md3HStack {
            spacing: 8
            Md3IconButton { variant: Md3IconButton.Standard; icon: "settings" }
            Md3IconButton { variant: Md3IconButton.Filled; icon: "favorite" }
            Md3IconButton { variant: Md3IconButton.FilledTonal; icon: "edit" }
            Md3IconButton { variant: Md3IconButton.Outlined; icon: "search" }
            Md3IconButton { enabled: false; icon: "delete" }
        }

        Md3Text {
            text: "Toggle icon buttons"
            role: Md3Text.TitleSmall
            tone: Md3Text.OnSurfaceVariant
        }

        Md3HStack {
            spacing: 8
            Md3ToggleIconButton { variant: Md3ToggleIconButton.Standard; icon: "favorite"; checked: true }
            Md3ToggleIconButton { variant: Md3ToggleIconButton.Filled; icon: "bookmark" }
            Md3ToggleIconButton { variant: Md3ToggleIconButton.FilledTonal; icon: "star" }
            Md3ToggleIconButton { variant: Md3ToggleIconButton.Outlined; icon: "visibility" }
            Md3ToggleIconButton { enabled: false; icon: "favorite"; checked: true }
        }

        Md3Text {
            text: "Toggle buttons"
            role: Md3Text.TitleSmall
            tone: Md3Text.OnSurfaceVariant
        }

        Md3FlowLayout {
            width: parent.width
            spacing: 12
            Md3ToggleButton { text: "Filled"; icon: "format_bold"; checked: true }
            Md3ToggleButton { text: "Outlined"; variant: Md3ToggleButton.Outlined; icon: "format_italic" }
            Md3ToggleButton { text: "Off"; variant: Md3ToggleButton.Outlined }
            Md3ToggleButton { text: "Disabled"; enabled: false; checked: true }
        }

        Md3Text {
            text: "Drop-down button"
            role: Md3Text.TitleSmall
            tone: Md3Text.OnSurfaceVariant
        }

        Md3FlowLayout {
            width: parent.width
            spacing: 12
            Md3DropDownButton {
                text: "New"
                icon: "add"
                menuModel: [
                    { text: "Document", icon: "description" },
                    { text: "Folder", icon: "folder" },
                    { text: "Shortcut", icon: "link" }
                ]
            }
            Md3DropDownButton {
                text: "Export"
                variant: Md3DropDownButton.Outlined
                menuModel: [
                    { text: "PDF" },
                    { text: "CSV" },
                    { text: "JSON" }
                ]
            }
            Md3DropDownButton {
                text: "More"
                variant: Md3DropDownButton.Text
                menuModel: [
                    { text: "Details" },
                    { text: "Help" }
                ]
            }
        }

        Md3Text {
            text: "Hyperlink"
            role: Md3Text.TitleSmall
            tone: Md3Text.OnSurfaceVariant
        }

        Md3HStack {
            spacing: 16
            Md3Hyperlink { text: "Learn more" }
            Md3Hyperlink {
                text: "Material Design 3"
                url: "https://m3.material.io/"
            }
            Md3Hyperlink { text: "Disabled"; enabled: false }
        }

        Md3Text {
            text: "Command bar"
            role: Md3Text.TitleSmall
            tone: Md3Text.OnSurfaceVariant
        }

        Md3CommandBar {
            width: parent.width
            overflowModel: [
                { text: "Share", icon: "share" },
                { text: "Print", icon: "print" },
                { text: "Settings", icon: "settings" }
            ]
            Md3AppBarButton { icon: "save"; text: "Save"; label: "Save" }
            Md3AppBarButton { icon: "undo"; text: "Undo"; label: "Undo" }
            Md3AppBarButton { icon: "redo"; text: "Redo"; label: "Redo" }
            Md3AppBarToggleButton { icon: "grid_view"; text: "Grid"; label: "Grid"; checked: true }
            Md3AppBarToggleButton { icon: "view_list"; text: "List"; label: "List" }
        }

        Md3Text {
            text: "Split button"
            role: Md3Text.TitleSmall
            tone: Md3Text.OnSurfaceVariant
        }

        Md3FlowLayout {
            width: parent.width
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

        Md3Text {
            text: "Standard button group"
            role: Md3Text.TitleSmall
            tone: Md3Text.OnSurfaceVariant
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

        Md3Text {
            text: "Connected button group"
            role: Md3Text.TitleSmall
            tone: Md3Text.OnSurfaceVariant
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
        }

        Md3Text {
            text: "Segmented button"
            role: Md3Text.TitleSmall
            tone: Md3Text.OnSurfaceVariant
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
