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
                    text: qsTr("TabBar fillHeight (IDE page host)")
                    role: Md3Text.LabelLarge
                    tone: Md3Text.OnSurfaceVariant
                }
                Item {
                    width: parent.width
                    height: 160
                    Md3TabBar {
                        anchors.fill: parent
                        fillHeight: true
                        model: [
                            { text: qsTr("Changes") },
                            { text: qsTr("History") }
                        ]
                        Rectangle {
                            color: Md3Theme.colorScheme.surfaceContainerLow
                            Md3Text {
                                anchors.centerIn: parent
                                text: qsTr("fillHeight page — eats remaining height")
                                role: Md3Text.BodyMedium
                            }
                        }
                        Rectangle {
                            color: Md3Theme.colorScheme.surfaceContainerHigh
                            Md3Text {
                                anchors.centerIn: parent
                                text: qsTr("History page")
                                role: Md3Text.BodyMedium
                            }
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

                    Md3DeferredSection {
                        anchors.fill: parent
                        preferredHeight: 278
                        delayMs: 24
                        asynchronous: true
                        sourceComponent: Component {
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

                Md3Text {
                    text: qsTr("Mobile shell — PullToRefresh + SwipeReveal + BottomAppBar")
                    role: Md3Text.LabelLarge
                    tone: Md3Text.OnSurfaceVariant
                }

                Md3Surface {
                    width: parent.width
                    height: 420
                    radius: Md3Theme.shape.medium
                    elevation: 0
                    color: Md3Theme.colorScheme.surfaceContainerLow
                    clipContent: true

                    Column {
                        anchors.fill: parent
                        anchors.margins: 1
                        spacing: 0

                        Md3TopAppBar {
                            width: parent.width
                            title: qsTr("Messages")
                            size: Md3TopAppBar.Small
                            trailingIcons: [{ icon: "search" }]
                        }

                        Item {
                            width: parent.width
                            height: parent.height - Md3Theme.appBarHeight - Md3Theme.bottomBarHeight

                            Flickable {
                                id: mobileFlick
                                anchors.fill: parent
                                contentWidth: width
                                contentHeight: mobileList.implicitHeight + 24
                                clip: true
                                boundsBehavior: Flickable.DragAndOvershootBounds

                                Column {
                                    id: mobileList
                                    width: mobileFlick.width
                                    spacing: 0

                                    Repeater {
                                        model: [
                                            { title: qsTr("Alex"), subtitle: qsTr("Swipe either side") },
                                            { title: qsTr("Blake"), subtitle: qsTr("Pull list down to refresh") },
                                            { title: qsTr("Casey"), subtitle: qsTr("Bottom bar actions + FAB") },
                                            { title: qsTr("Drew"), subtitle: qsTr("Exclusive open swipe") },
                                            { title: qsTr("Ellis"), subtitle: qsTr("Use Refresh if mouse-only") }
                                        ]
                                        Md3SwipeReveal {
                                            required property var modelData
                                            width: mobileList.width
                                            height: 64
                                            panelColor: Md3Theme.colorScheme.surface
                                            leadingActions: [
                                                { icon: "call", label: qsTr("Call") }
                                            ]
                                            trailingActions: [
                                                { icon: "archive", label: qsTr("Archive") },
                                                { icon: "delete", label: qsTr("Delete"), destructive: true }
                                            ]
                                            onActionTriggered: function (i, leading) {
                                                mobileStatus.text = qsTr("%1 · %2 #%3")
                                                    .arg(modelData.title)
                                                    .arg(leading ? qsTr("leading") : qsTr("trailing"))
                                                    .arg(i)
                                            }
                                            Md3ListTile {
                                                anchors.fill: parent
                                                title: modelData.title
                                                subtitle: modelData.subtitle
                                                leadingIcon: "person"
                                                showDivider: true
                                            }
                                        }
                                    }
                                }
                            }

                            Md3PullToRefresh {
                                id: mobilePtr
                                flickable: mobileFlick
                                showManualRefresh: true
                                onRefreshRequested: mobileRefreshTimer.start()
                            }

                            Timer {
                                id: mobileRefreshTimer
                                interval: 900
                                onTriggered: {
                                    mobileStatus.text = qsTr("Inbox refreshed")
                                    mobilePtr.endRefresh()
                                }
                            }

                            Md3Text {
                                id: mobileStatus
                                anchors.left: parent.left
                                anchors.bottom: parent.bottom
                                anchors.margins: 8
                                text: qsTr("Ready")
                                role: Md3Text.LabelSmall
                                tone: Md3Text.OnSurfaceVariant
                            }
                        }

                        Md3BottomAppBar {
                            width: parent.width
                            // Demo home-indicator inset (Md3Adaptive.safeBottomInset on device).
                            height: implicitHeight + Md3Adaptive.safeBottomInset
                            showFab: true
                            actions: ["menu", "search", "more_vert"]
                            onActionClicked: function (i) {
                                mobileStatus.text = qsTr("Bottom action %1").arg(i)
                            }
                            onFabClicked: mobileStatus.text = qsTr("Compose FAB")
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
