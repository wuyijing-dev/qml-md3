import QtQuick
import Md3

/// Adaptive navigation shell (WinUI NavigationView–inspired).
/// Modes: Auto / Left (expanded rail) / LeftCompact (collapsed rail) / Top (app bar + bottom bar).
/// Default property is page content (like Scaffold) — does not own PageHost.
Item {
    id: root

    enum PaneDisplayMode {
        Auto,
        Left,
        LeftCompact,
        Top
    }

    /// Destinations: { icon, label|title, destIndex?, pin:"bottom"|footer, badge… }
    property var destinations: []
    property alias model: root.destinations

    property int currentIndex: 0
    property int paneDisplayMode: Md3NavigationView.Auto
    property string headerLabel: ""
    property string drawerTitle: ""
    /// Used when effective mode is Left (ignored in LeftCompact).
    property bool expanded: true
    property bool showExpandToggle: true
    property bool drawerOpen: false
    property var hostWindow: null

    /// Aligned with Md3Adaptive / Material WindowSizeClass (compact < 600, medium < 840).
    property real compactBreakpoint: Md3Adaptive.navigationCompactBreakpoint
    property real expandedBreakpoint: Md3Adaptive.navigationExpandedBreakpoint

    default property alias content: contentHost.data

    signal currentIndexChangedByUser(int index)
    signal expandToggleClicked()
    signal drawerDismissed()
    signal destinationPreview(int index)

    clip: true

    readonly property int effectivePaneDisplayMode: {
        if (paneDisplayMode !== Md3NavigationView.Auto)
            return paneDisplayMode
        if (width > 0 && width < compactBreakpoint)
            return Md3NavigationView.Top
        if (width > 0 && width < expandedBreakpoint)
            return Md3NavigationView.LeftCompact
        return Md3NavigationView.Left
    }

    readonly property bool _useTop: effectivePaneDisplayMode === Md3NavigationView.Top
    readonly property bool _useRail: !_useTop
    readonly property bool _railExpanded: effectivePaneDisplayMode === Md3NavigationView.Left
                                          && expanded

    readonly property var _railModels: {
        const src = destinations || []
        const main = []
        const foot = []
        for (let i = 0; i < src.length; ++i) {
            const e = src[i] || ({})
            const entry = _entry(e, i)
            const pin = e.pin !== undefined ? e.pin : e.footer
            if (pin === true || pin === "bottom" || pin === "footer")
                foot.push(entry)
            else
                main.push(entry)
        }
        return { main: main, footer: foot }
    }

    readonly property var _barModel: {
        const src = destinations || []
        const out = []
        for (let i = 0; i < src.length; ++i) {
            const e = src[i] || ({})
            const pin = e.pin !== undefined ? e.pin : e.footer
            if (pin === true || pin === "bottom" || pin === "footer")
                continue
            out.push(_entry(e, i))
            if (out.length >= 5)
                break
        }
        return out
    }

    readonly property var _drawerModel: {
        const src = destinations || []
        const out = []
        for (let i = 0; i < src.length; ++i)
            out.push(_entry(src[i] || ({}), i))
        return out
    }

    function _entry(e, i) {
        return {
            icon: e.icon || "circle",
            label: (e.label !== undefined && e.label !== null && String(e.label).length)
                   ? String(e.label)
                   : String(e.title || ""),
            destIndex: (e.destIndex !== undefined && e.destIndex !== null) ? Number(e.destIndex) : i,
            badge: e.badge,
            badgeDot: e.badgeDot,
            badgeText: e.badgeText,
            badgeMax: e.badgeMax
        }
    }

    function openDrawer() { drawerOpen = true }
    function closeDrawer() { drawerOpen = false }

    function handleBack() {
        if (drawerOpen) {
            closeDrawer()
            return true
        }
        return false
    }

    focus: true
    Keys.onBackPressed: function (event) {
        if (handleBack())
            event.accepted = true
    }
    Keys.onPressed: function (event) {
        if (event.key === Qt.Key_Escape && handleBack())
            event.accepted = true
    }

    function _select(index) {
        if (index !== currentIndex)
            currentIndexChangedByUser(index)
        currentIndex = index
        if (drawerOpen)
            drawerOpen = false
    }

    function _destOfVisualBar(visual) {
        const src = destinations || []
        let n = 0
        for (let i = 0; i < src.length; ++i) {
            const e = src[i] || ({})
            const pin = e.pin !== undefined ? e.pin : e.footer
            if (pin === true || pin === "bottom" || pin === "footer")
                continue
            if (n === visual)
                return (e.destIndex !== undefined && e.destIndex !== null) ? Number(e.destIndex) : i
            n++
        }
        return visual
    }

    function _visualOfDest(dest) {
        const src = destinations || []
        let visual = 0
        for (let i = 0; i < src.length; ++i) {
            const e = src[i] || ({})
            const pin = e.pin !== undefined ? e.pin : e.footer
            if (pin === true || pin === "bottom" || pin === "footer")
                continue
            const d = (e.destIndex !== undefined && e.destIndex !== null) ? Number(e.destIndex) : i
            if (d === dest)
                return visual
            visual++
        }
        return 0
    }

    Rectangle {
        anchors.fill: parent
        color: Md3Theme.colorScheme.surface
        z: -1
    }

    Md3NavigationRail {
        id: rail
        visible: root._useRail
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        hostWindow: root.hostWindow
        headerLabel: root.headerLabel
        showExpandToggle: root.showExpandToggle
                              && root.effectivePaneDisplayMode === Md3NavigationView.Left
        expanded: root._railExpanded
        model: root._railModels.main
        footerModel: root._railModels.footer
        currentIndex: root.currentIndex
        onCurrentIndexChangedByUser: function (index) { root._select(index) }
        onDestinationPreview: function (index) { root.destinationPreview(index) }
        onExpandToggleClicked: {
            root.expanded = !root.expanded
            root.expandToggleClicked()
        }
    }

    Md3TopAppBar {
        id: topBar
        visible: root._useTop
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        title: root.headerLabel.length ? root.headerLabel : qsTr("Navigation")
        leadingIcon: "menu"
        showLeading: true
        onLeadingClicked: root.drawerOpen = true
    }

    Md3NavigationBar {
        id: bottomBar
        visible: root._useTop && root._barModel.length > 0
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        model: root._barModel
        currentIndex: root._visualOfDest(root.currentIndex)
        onCurrentIndexChangedByUser: function (visual) {
            root._select(root._destOfVisualBar(visual))
        }
        onDestinationPreview: function (visual) {
            root.destinationPreview(root._destOfVisualBar(visual))
        }
    }

    Item {
        id: contentHost
        anchors.left: root._useRail ? rail.right : parent.left
        anchors.right: parent.right
        anchors.top: root._useTop ? topBar.bottom : parent.top
        anchors.bottom: root._useTop ? (bottomBar.visible ? bottomBar.top : parent.bottom)
                                     : parent.bottom
        clip: true
    }

    Md3NavigationDrawer {
        id: drawer
        anchors.fill: parent
        z: 20
        title: root.drawerTitle.length ? root.drawerTitle : root.headerLabel
        model: root._drawerModel
        open: root.drawerOpen
        onOpenChanged: root.drawerOpen = open
        onCurrentIndexChangedByUser: function (index) {
            const e = (destinations && destinations[index]) || ({})
            const dest = (e.destIndex !== undefined && e.destIndex !== null) ? Number(e.destIndex) : index
            root._select(dest)
        }
        onDismissed: root.drawerDismissed()
    }
}
