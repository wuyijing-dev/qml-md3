import QtQuick
import QtQuick.Layouts
import Md3

Item {
    id: page

    ColumnLayout {
        anchors.fill: parent
        spacing: 20

        Text {
            text: "Menus & Options"
            color: Md3Theme.colorScheme.colorOnSurface
            font.pixelSize: Md3Theme.typography.headlineMedium.size
            font.family: Md3Theme.typography.fontFamily
        }

        Text {
            text: "Option dropdown (animated)"
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.titleSmall.size
        }

        Md3Option {
            Layout.preferredWidth: 320
            label: "Theme option"
            leadingIcon: "settings"
            model: [
                { text: "System", icon: "settings" },
                { text: "Light", icon: "visibility" },
                { text: "Dark", icon: "visibility_off" },
                { text: "High contrast", icon: "info" }
            ]
            currentIndex: 0
        }

        Md3DropdownMenu {
            Layout.preferredWidth: 320
            label: "Language"
            model: [
                { text: "English" },
                { text: "简体中文" },
                { text: "日本語" },
                { text: "Deutsch" }
            ]
        }

        Text {
            text: "Menu bar"
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.titleSmall.size
        }

        Md3MenuBar {
            Layout.fillWidth: true
            model: [
                {
                    text: "File",
                    children: [
                        { text: "New", icon: "note_add" },
                        { text: "Open", icon: "folder_open" },
                        { text: "Save", icon: "save" }
                    ]
                },
                {
                    text: "Edit",
                    children: [
                        { text: "Cut", icon: "content_cut" },
                        { text: "Copy", icon: "content_copy" },
                        { text: "Paste", icon: "content_paste" }
                    ]
                },
                {
                    text: "View",
                    children: [
                        { text: "Zoom in", icon: "zoom_in" },
                        { text: "Zoom out", icon: "zoom_out" }
                    ]
                }
            ]
        }

        Md3Button {
            id: ctxBtn
            text: "Open context menu"
            onClicked: {
                const p = ctxBtn.mapToItem(null, 0, ctxBtn.height + 8)
                ctx.popup(p.x, p.y)
            }
        }

        Item { Layout.fillHeight: true }
    }

    Md3Menu {
        id: ctx
        menuWidth: 280
        Md3MenuItem { text: "Cut"; icon: "content_cut"; onClicked: ctx.dismiss() }
        Md3MenuItem { text: "Copy"; icon: "content_copy"; onClicked: ctx.dismiss() }
        Md3MenuItem { text: "Paste"; icon: "content_paste"; onClicked: ctx.dismiss() }
        Md3MenuDivider {}
        Md3MenuItem { text: "Create"; icon: "add"; hasSubMenu: true; onClicked: ctx.dismiss() }
        Md3MenuItem { text: "Share"; icon: "share"; hasSubMenu: true; onClicked: ctx.dismiss() }
        Md3MenuItem { text: "Download"; icon: "download"; hasSubMenu: true; onClicked: ctx.dismiss() }
        Md3MenuDivider {}
        Md3MenuItem {
            text: "Offline mode"
            selected: true
            showCheck: true
            leadingCheck: true
            onClicked: ctx.dismiss()
        }
    }
}
