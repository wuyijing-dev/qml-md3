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

        Flickable {
            id: flick
            anchors.fill: parent
            contentWidth: width
            contentHeight: column.implicitHeight + 24
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            ColumnLayout {
                id: column
                width: flick.width
                spacing: 16

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
                    Layout.preferredHeight: implicitHeight
                    pageAreaHeight: 72
                    model: [
                        { text: "Tab one" },
                        { text: "Tab two" },
                        { text: "Tab three" }
                    ]
                    Rectangle {
                        color: "transparent"
                        Text {
                            anchors.centerIn: parent
                            text: qsTr("Page one — TabBar pages track currentIndex")
                            color: Md3Theme.colorScheme.colorOnSurfaceVariant
                        }
                    }
                    Rectangle {
                        color: "transparent"
                        Text {
                            anchors.centerIn: parent
                            text: qsTr("Page two")
                            color: Md3Theme.colorScheme.colorOnSurfaceVariant
                        }
                    }
                    Rectangle {
                        color: "transparent"
                        Text {
                            anchors.centerIn: parent
                            text: qsTr("Page three")
                            color: Md3Theme.colorScheme.colorOnSurfaceVariant
                        }
                    }
                }

                Text {
                    text: qsTr("Navigation rail")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.labelLarge.size
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 220
                    spacing: 12

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
                        Layout.fillHeight: true
                        spacing: 8
                        Md3Switch {
                            id: railExpanded
                            text: qsTr("Expand rail")
                        }
                        Text {
                            Layout.fillWidth: true
                            wrapMode: Text.Wrap
                            text: qsTr("Badges on destinations: badge / badgeDot / badgeText")
                            color: Md3Theme.colorScheme.colorOnSurfaceVariant
                            font.pixelSize: Md3Theme.typography.bodySmall.size
                        }
                        Item { Layout.fillHeight: true }
                    }
                }

                Text {
                    text: qsTr("Scaffold shell (title + navModel)")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.labelLarge.size
                }

                // Clipped demo host — Scaffold must not spill over siblings.
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 220
                    radius: Md3Theme.shape.medium
                    color: Md3Theme.colorScheme.surfaceContainerLow
                    border.color: Md3Theme.colorScheme.outlineVariant
                    border.width: 1
                    clip: true

                    Md3Scaffold {
                        anchors.fill: parent
                        anchors.margins: 1
                        title: qsTr("Inbox")
                        trailingIcons: [{ icon: "search" }, { icon: "more_vert" }]
                        navModel: [
                            { icon: "mail", label: qsTr("Mail"), badge: "2" },
                            { icon: "chat", label: qsTr("Chat"), badgeDot: true },
                            { icon: "person", label: qsTr("Profile") }
                        ]
                        // No drawerModel here — page-level drawer demos the overlay.
                        Text {
                            anchors.centerIn: parent
                            text: qsTr("Scaffold content")
                            color: Md3Theme.colorScheme.colorOnSurfaceVariant
                        }
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
