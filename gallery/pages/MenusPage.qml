import QtQuick
import QtQuick.Layouts
import QtQuick.Window
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
            text: "Menu bar (nested model)"
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.titleSmall.size
        }

        Md3MenuBar {
            Layout.fillWidth: true
            model: [
                {
                    text: "File",
                    items: [
                        {
                            text: "New",
                            icon: "note_add",
                            items: [
                                { text: "Document", icon: "description" },
                                { text: "Spreadsheet", icon: "table_chart" },
                                { text: "Folder", icon: "folder" }
                            ]
                        },
                        { text: "Open", icon: "folder_open" },
                        { text: "Save", icon: "save" }
                    ]
                },
                {
                    text: "Edit",
                    items: [
                        { text: "Cut", icon: "content_cut" },
                        { text: "Copy", icon: "content_copy" },
                        { text: "Paste", icon: "content_paste" }
                    ]
                },
                {
                    text: "View",
                    items: [
                        {
                            text: "Zoom",
                            icon: "search",
                            items: [
                                { text: "Zoom in", icon: "zoom_in" },
                                { text: "Zoom out", icon: "zoom_out" },
                                { text: "Reset", icon: "restart_alt" }
                            ]
                        },
                        { text: "Full screen", icon: "fullscreen" }
                    ]
                }
            ]
            onItemClicked: function (path) { console.log("menu:", path) }
        }

        Md3Button {
            id: ctxBtn
            text: "Open context menu (cascading)"
            onClicked: {
                const win = Window.window
                const target = (win && win.contentItem) ? win.contentItem : null
                const p = ctxBtn.mapToItem(target, 0, ctxBtn.height + 8)
                ctx.popup(p.x, p.y)
            }
        }

        Text {
            Layout.fillWidth: true
            wrapMode: Text.Wrap
            text: qsTr("Tip: Md3ContextMenuArea + Md3Menu enables page-level right-click menus (see Extras page).")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.bodySmall.size
            font.family: Md3Theme.typography.fontFamily
        }

        Item { Layout.fillHeight: true }
    }

    // Model-driven context menu (less glue than hand-written MenuItems)
    Md3Menu {
        id: ctx
        menuWidth: 280
        model: [
            { text: "Cut", icon: "content_cut" },
            { text: "Copy", icon: "content_copy" },
            { text: "Paste", icon: "content_paste" },
            { divider: true },
            {
                text: "Create",
                icon: "add",
                items: [
                    { text: "Document", icon: "description" },
                    { text: "Folder", icon: "folder" },
                    {
                        text: "More",
                        items: [
                            { text: "From template" },
                            { text: "From clipboard" }
                        ]
                    }
                ]
            },
            {
                text: "Share",
                icon: "share",
                items: [
                    { text: "Copy link", icon: "link" },
                    { text: "Email", icon: "mail" },
                    { text: "QR code", icon: "qr_code" }
                ]
            },
            { text: "Download", icon: "download" },
            { divider: true },
            { text: "Offline mode", selected: true, showCheck: true }
        ]
        onItemClicked: function (path) {
            console.log("menu:", path)
        }
    }
}
