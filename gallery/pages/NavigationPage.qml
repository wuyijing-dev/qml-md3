import QtQuick
import Md3

Md3Page {
    id: root

    // Host = gallery content pane only; drawer stays inside this clip, not the OS window.
    Md3Surface {
        anchors.fill: parent
        radius: 0
        elevation: 0
        color: {
            const w = hostWindow()
            if (w && w.usesSystemBackdrop)
                return "transparent"
            return Md3Theme.colorScheme.surface
        }
        clipContent: true

        Flickable {
            id: flick
            anchors.fill: parent
            contentWidth: width
            contentHeight: column.implicitHeight + 24
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            Md3VStack {
                id: column
                width: flick.width
                spacing: 16

                Md3Text {
                    text: "Navigation"
                    role: Md3Text.HeadlineMedium
                }

                Md3TopAppBar {
                    width: parent.width
                    title: "Small app bar"
                    trailingIcons: [
                        { icon: "notifications", badgeText: "3" },
                        { icon: "more_vert", badgeDot: true }
                    ]
                    onLeadingClicked: drawer.open = true
                }

                Md3TabBar {
                    width: parent.width
                    height: implicitHeight
                    pageAreaHeight: 72
                    model: [
                        { text: "Tab one" },
                        { text: "Tab two" },
                        { text: "Tab three" }
                    ]
                    Item {
                        Md3Text {
                            anchors.centerIn: parent
                            text: qsTr("Page one — TabBar pages track currentIndex")
                            role: Md3Text.BodyMedium
                            tone: Md3Text.OnSurfaceVariant
                        }
                    }
                    Item {
                        Md3Text {
                            anchors.centerIn: parent
                            text: qsTr("Page two")
                            role: Md3Text.BodyMedium
                            tone: Md3Text.OnSurfaceVariant
                        }
                    }
                    Item {
                        Md3Text {
                            anchors.centerIn: parent
                            text: qsTr("Page three")
                            role: Md3Text.BodyMedium
                            tone: Md3Text.OnSurfaceVariant
                        }
                    }
                }

                Md3Text {
                    text: qsTr("Navigation rail")
                    role: Md3Text.LabelLarge
                    tone: Md3Text.OnSurfaceVariant
                }

                Md3HStack {
                    id: railRow
                    width: parent.width
                    height: 220
                    fillHeight: true
                    spacing: 12

                    Md3NavigationRail {
                        id: railDemo
                        expanded: railExpanded.checked
                        model: [
                            { icon: "home", label: "Home", badgeDot: true },
                            { icon: "search", label: "Search", badge: "12" },
                            { icon: "settings", label: "Settings" }
                        ]
                    }

                    Md3VStack {
                        width: Math.max(0, railRow.width - railDemo.width - railRow.spacing)
                        height: railRow.height
                        spacing: 8
                        Md3Switch {
                            id: railExpanded
                            text: qsTr("Expand rail")
                        }
                        Md3Text {
                            width: parent.width
                            wrapMode: Text.Wrap
                            text: qsTr("Badges on destinations: badge / badgeDot / badgeText")
                            role: Md3Text.BodySmall
                            tone: Md3Text.OnSurfaceVariant
                        }
                        Md3Spacer { expand: true }
                    }
                }

                Md3Text {
                    text: qsTr("NavigationView (Auto / Left / Compact / Top)")
                    role: Md3Text.LabelLarge
                    tone: Md3Text.OnSurfaceVariant
                }

                Md3SegmentedButton {
                    id: navViewMode
                    width: Math.min(parent.width, 420)
                    model: [
                        { text: qsTr("Auto") },
                        { text: qsTr("Left") },
                        { text: qsTr("Compact") },
                        { text: qsTr("Top") }
                    ]
                }

                Md3Surface {
                    width: parent.width
                    height: 280
                    radius: Md3Theme.shape.medium
                    elevation: 0
                    color: Md3Theme.colorScheme.surfaceContainerLow
                    clipContent: true

                    Md3NavigationView {
                        id: navViewDemo
                        anchors.fill: parent
                        anchors.margins: 1
                        paneDisplayMode: {
                            switch (navViewMode.currentIndex) {
                            case 1: return Md3NavigationView.Left
                            case 2: return Md3NavigationView.LeftCompact
                            case 3: return Md3NavigationView.Top
                            default: return Md3NavigationView.Auto
                            }
                        }
                        compactBreakpoint: 420
                        expandedBreakpoint: 560
                        headerLabel: qsTr("Mail")
                        destinations: [
                            { icon: "inbox", label: qsTr("Inbox"), badge: "3" },
                            { icon: "send", label: qsTr("Sent") },
                            { icon: "drafts", label: qsTr("Drafts") },
                            { icon: "settings", label: qsTr("Settings"), pin: "bottom" }
                        ]

                        Md3Text {
                            anchors.centerIn: parent
                            text: qsTr("NavigationView content · index %1 · mode %2")
                                  .arg(navViewDemo.currentIndex)
                                  .arg(navViewDemo.effectivePaneDisplayMode)
                            role: Md3Text.BodyMedium
                            tone: Md3Text.OnSurfaceVariant
                        }
                    }
                }

                Md3Text {
                    text: qsTr("Scaffold shell (title + navModel)")
                    role: Md3Text.LabelLarge
                    tone: Md3Text.OnSurfaceVariant
                }

                // Clipped demo host — Scaffold must not spill over siblings.
                Md3Surface {
                    width: parent.width
                    height: 220
                    radius: Md3Theme.shape.medium
                    elevation: 0
                    color: Md3Theme.colorScheme.surfaceContainerLow
                    clipContent: true

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
                        Md3Text {
                            anchors.centerIn: parent
                            text: qsTr("Scaffold content")
                            role: Md3Text.BodyMedium
                            tone: Md3Text.OnSurfaceVariant
                        }
                    }
                }

                Md3NavigationBar {
                    width: parent.width
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
