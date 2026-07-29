import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import Md3

Item {
    id: root

    // Host = gallery content pane only; drawer stays inside this clip, not the OS window.
    Rectangle {
        anchors.fill: parent
        color: {
            const w = Window.window
            if (w && w.usesSystemBackdrop)
                return "transparent"
            return Md3Theme.colorScheme.surface
        }
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
                trailingIcons: [
                    { icon: "notifications", badgeText: "3" },
                    { icon: "more_vert", badgeDot: true }
                ]
                onLeadingClicked: drawer.open = true
            }
            Md3TabBar {
                Layout.fillWidth: true
                Layout.preferredHeight: 160
                model: [
                    { text: "Tab one" },
                    { text: "Tab two" },
                    { text: "Tab three" }
                ]
                Item {
                    Text {
                        anchors.centerIn: parent
                        text: qsTr("Page one — TabBar pages track currentIndex")
                        color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    }
                }
                Item {
                    Text {
                        anchors.centerIn: parent
                        text: qsTr("Page two")
                        color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    }
                }
                Item {
                    Text {
                        anchors.centerIn: parent
                        text: qsTr("Page three")
                        color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    }
                }
            }
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Md3NavigationRail {
                    Layout.fillHeight: true
                    expanded: railExpanded.checked
                    model: [
                        { icon: "home", label: "Home", badgeDot: true },
                        { icon: "search", label: "Search", badge: "12" },
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
                    Text {
                        text: qsTr("Scaffold shell (title + navModel)")
                        color: Md3Theme.colorScheme.colorOnSurfaceVariant
                        font.pixelSize: Md3Theme.typography.labelLarge.size
                    }
                    Md3Scaffold {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 200
                        title: qsTr("Inbox")
                        trailingIcons: [{ icon: "search" }, { icon: "more_vert" }]
                        navModel: [
                            { icon: "mail", label: qsTr("Mail"), badge: "2" },
                            { icon: "chat", label: qsTr("Chat"), badgeDot: true },
                            { icon: "person", label: qsTr("Profile") }
                        ]
                        drawerTitle: qsTr("Mail")
                        drawerModel: [
                            { icon: "inbox", label: qsTr("Inbox"), badge: "8" },
                            { icon: "send", label: qsTr("Sent") }
                        ]
                        Text {
                            anchors.centerIn: parent
                            text: qsTr("Scaffold content")
                            color: Md3Theme.colorScheme.colorOnSurfaceVariant
                        }
                    }
                    Item { Layout.fillHeight: true }
                }
            }
            Md3NavigationBar {
                Layout.fillWidth: true
                model: [
                    { icon: "home", label: "Home", badgeDot: true },
                    { icon: "favorite", label: "Fav", badge: "9" },
                    { icon: "settings", label: "Settings" }
                ]
            }
        }

        Md3NavigationDrawer {
            id: drawer
            anchors.fill: parent
            title: "Mail"
            model: [
                { icon: "home", label: "Inbox", badge: "5" },
                { icon: "edit", label: "Outbox" },
                { icon: "favorite", label: "Favorites", badgeDot: true }
            ]
        }
    }
}
