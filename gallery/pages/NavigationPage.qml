import QtQuick
import QtQuick.Layouts
import Md3

Item {
    id: root

    // Host = gallery content pane only; drawer stays inside this clip, not the OS window.
    Rectangle {
        anchors.fill: parent
        color: Md3Theme.colorScheme.surface
        clip: true

        ColumnLayout {
            anchors.fill: parent
            spacing: 12
            Text {
                text: "Navigation"
                color: Md3Theme.colorScheme.colorOnSurface
                font.pixelSize: Md3Theme.typography.headlineMedium.size
            }
            Md3TopAppBar {
                Layout.fillWidth: true
                title: "Small app bar"
                trailingIcons: ["search", "more_vert"]
                onLeadingClicked: drawer.open = true
            }
            Md3TabBar {
                Layout.fillWidth: true
                model: ["Tab one", "Tab two", "Tab three"]
            }
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Md3NavigationRail {
                    Layout.fillHeight: true
                    expanded: railExpanded.checked
                    model: [
                        { icon: "home", label: "Home" },
                        { icon: "search", label: "Search" },
                        { icon: "settings", label: "Settings" }
                    ]
                }
                ColumnLayout {
                    Layout.fillWidth: true
                    Md3Switch {
                        id: railExpanded
                        accessibleName: "Expand rail"
                    }
                    Text {
                        text: "Toggle rail expanded"
                        color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    }
                    Item { Layout.fillHeight: true }
                }
            }
            Md3NavigationBar {
                Layout.fillWidth: true
                model: [
                    { icon: "home", label: "Home" },
                    { icon: "favorite", label: "Fav" },
                    { icon: "settings", label: "Settings" }
                ]
            }
        }

        Md3NavigationDrawer {
            id: drawer
            anchors.fill: parent
            title: "Mail"
            model: [
                { icon: "home", label: "Inbox" },
                { icon: "edit", label: "Outbox" },
                { icon: "favorite", label: "Favorites" }
            ]
        }
    }
}
