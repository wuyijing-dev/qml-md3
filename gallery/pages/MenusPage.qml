import QtQuick
import Md3

Md3Page {
    id: page

    Md3VStack {
        anchors.fill: parent
        width: parent.width
        spacing: 20

        Md3Text {
            text: "Menus & Options"
            role: Md3Text.HeadlineMedium
        }

        Md3Text {
            width: parent.width
            wrapMode: Text.Wrap
            text: qsTr("Keyboard: ↑↓ highlight · Enter/Space activate · Esc dismiss · → submenu · ← close submenu. Tables/trees: arrows · Home/End · PageUp/Down · focus ring when focused.")
            role: Md3Text.BodySmall
            tone: Md3Text.OnSurfaceVariant
        }

        Md3Text {
            text: "Option dropdown (animated)"
            role: Md3Text.TitleSmall
            tone: Md3Text.OnSurfaceVariant
        }

        Md3Option {
            width: 320
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
            width: 320
            label: "Language"
            model: [
                { text: "English" },
                { text: "简体中文" },
                { text: "日本語" },
                { text: "Deutsch" }
            ]
        }

        Md3Text {
            text: "Menu bar (nested model)"
            role: Md3Text.TitleSmall
            tone: Md3Text.OnSurfaceVariant
        }

        Md3MenuBar {
            width: parent.width
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
                const p = Md3OverlayHost.mapToOverlay(ctxBtn, 0, ctxBtn.height + 8)
                ctx.popup(p.x, p.y)
            }
        }

        Md3Text {
            width: parent.width
            wrapMode: Text.Wrap
            text: qsTr("Tip: Md3ContextMenuArea + Md3Menu enables page-level right-click menus (see Extras page).")
            role: Md3Text.BodySmall
            tone: Md3Text.OnSurfaceVariant
        }

        Md3Spacer { expand: true }
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
