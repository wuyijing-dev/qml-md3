import QtQuick

// Built-in body: left NavigationRail + lazy Md3PageHost (used by Md3ApplicationWindow)
Item {
    id: root

    property var destinations: []
    property int currentIndex: 0
    property bool railVisible: true
    property bool railExpanded: false
    property string railHeader: ""
    property string cacheMode: "lru"
    property int cacheLimit: 4
    property int idleTrimMs: 45000
    property real contentPadding: 20
    property url sourceBase: ""
    property bool asynchronous: true
    property bool prefetchNeighbors: false
    property bool predictPrefetch: true
    property bool l2Components: true
    property int l2CacheLimit: 16
    property bool l2WarmIdle: true
    property bool leaveSnapshot: true
    property bool warmStart: false
    property bool showBusyIndicator: false
    property bool showSkeleton: true
    property string skeletonLayout: "page"
    property string pageTransition: "fade"
    property int pageTransitionDuration: Md3Motion.spatialDuration
    property alias pageHost: host
    property alias rail: rail

    signal destinationActivated(int index)
    signal railExpandRequested(bool expanded)

    function navigateTo(index) {
        if (!destinations || index < 0 || index >= destinations.length)
            return
        host.navigateTo(index)
        if (currentIndex !== host.currentIndex)
            currentIndex = host.currentIndex
        if (rail.currentIndex !== currentIndex)
            rail.currentIndex = currentIndex
        destinationActivated(currentIndex)
    }

    onCurrentIndexChanged: {
        if (host.currentIndex !== currentIndex)
            host.navigateTo(currentIndex)
        if (rail.currentIndex !== currentIndex)
            rail.currentIndex = currentIndex
    }

    readonly property var railModel: {
        const src = destinations || []
        const out = []
        for (let i = 0; i < src.length; ++i) {
            const e = src[i] || {}
            out.push({
                icon: e.icon !== undefined && e.icon !== "" ? e.icon : "circle",
                label: e.label !== undefined && e.label !== ""
                       ? e.label
                       : (e.title !== undefined ? e.title : "")
            })
        }
        return out
    }

    Row {
        anchors.fill: parent
        spacing: 0

        Md3NavigationRail {
            id: rail
            z: 2
            visible: root.railVisible && root.destinations && root.destinations.length > 0
            height: parent.height
            width: visible ? (root.railExpanded ? 256 : 80) : 0
            expanded: root.railExpanded
            headerLabel: root.railHeader
            model: root.railModel
            currentIndex: root.currentIndex
            showExpandToggle: true
            onCurrentIndexChangedByUser: function (index) {
                root.navigateTo(index)
            }
            onDestinationHovered: function (index) {
                host.prefetchHint(index)
            }
            onDestinationUnhovered: function (index) {
                host.clearPrefetchHint(index)
            }
            onExpandToggleClicked: root.railExpandRequested(!root.railExpanded)
        }

        Md3PageHost {
            id: host
            z: 1
            clip: true
            width: parent.width - rail.width
            height: parent.height
            model: root.destinations
            cacheMode: root.cacheMode
            cacheLimit: root.cacheLimit
            idleTrimMs: root.idleTrimMs
            contentPadding: root.contentPadding
            sourceBase: root.sourceBase
            asynchronous: root.asynchronous
            prefetchNeighbors: root.prefetchNeighbors
            predictPrefetch: root.predictPrefetch
            l2Components: root.l2Components
            l2CacheLimit: root.l2CacheLimit
            l2WarmIdle: root.l2WarmIdle
            leaveSnapshot: root.leaveSnapshot
            warmStart: root.warmStart
            showBusyIndicator: root.showBusyIndicator
            showSkeleton: root.showSkeleton
            skeletonLayout: root.skeletonLayout
            pageTransition: root.pageTransition
            pageTransitionDuration: root.pageTransitionDuration
        }
    }

    Component.onCompleted: {
        host.navigateTo(currentIndex)
        rail.currentIndex = currentIndex
    }
}
