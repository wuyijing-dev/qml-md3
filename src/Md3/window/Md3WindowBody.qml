import QtQuick
import Md3

// Built-in body: left NavigationRail + lazy Md3PageHost (used by Md3ApplicationWindow)
Item {
    id: root

    property var destinations: []
    property int currentIndex: 0
    property bool railVisible: true
    property bool railExpanded: false
    property string railHeader: ""
    property string cacheMode: "arc"
    property int cacheLimit: 1
    property int idleTrimMs: 4000
    property real contentPadding: 20
    property url sourceBase: ""
    property bool asynchronous: false
    property bool prefetchNeighbors: false
    property bool predictPrefetch: false
    property bool l2Components: true
    property int l2CacheLimit: 1
    property bool l2WarmIdle: false
    property bool leaveSnapshot: false
    property bool warmStart: false
    property bool showBusyIndicator: false
    property bool showSkeleton: false
    property string skeletonLayout: "page"
    property string pageTransition: "fade"
    property int pageTransitionDuration: 100
    property alias pageHost: host
    property alias rail: rail

    readonly property bool canGoBack: host.canGoBack
    readonly property int navDepth: host.navDepth
    readonly property var routeParams: host.routeParams
    readonly property int railHighlightIndex: host.sectionRootIndex >= 0
            ? host.sectionRootIndex : host.currentIndex

    signal destinationActivated(int index)
    signal railExpandRequested(bool expanded)

    function navigateTo(index, opts) {
        if (!destinations || index < 0 || index >= destinations.length)
            return
        host.navigateTo(index, opts)
        if (currentIndex !== host.currentIndex)
            currentIndex = host.currentIndex
        _syncRailHighlight()
        destinationActivated(currentIndex)
    }

    function pushRoute(index, params, opts) {
        if (!destinations || index < 0 || index >= destinations.length)
            return false
        const ok = host.pushRoute(index, params, opts)
        if (currentIndex !== host.currentIndex)
            currentIndex = host.currentIndex
        _syncRailHighlight()
        destinationActivated(currentIndex)
        return ok
    }

    function goBack(opts) {
        const ok = host.goBack(opts)
        if (!ok)
            return false
        if (currentIndex !== host.currentIndex)
            currentIndex = host.currentIndex
        _syncRailHighlight()
        destinationActivated(currentIndex)
        return true
    }

    function replaceRoute(index, params, opts) {
        if (!destinations || index < 0 || index >= destinations.length)
            return false
        const ok = host.replaceRoute(index, params, opts)
        if (currentIndex !== host.currentIndex)
            currentIndex = host.currentIndex
        _syncRailHighlight()
        destinationActivated(currentIndex)
        return ok
    }

    function _syncRailHighlight() {
        const hi = railHighlightIndex
        if (rail.currentIndex !== hi)
            rail.currentIndex = hi
    }

    onCurrentIndexChanged: {
        if (host.currentIndex !== currentIndex)
            host.navigateTo(currentIndex)
        _syncRailHighlight()
    }

    function _railEntry(e, destIndex) {
        return {
            icon: e.icon !== undefined && e.icon !== "" ? e.icon : "circle",
            label: e.label !== undefined && e.label !== ""
                   ? e.label
                   : (e.title !== undefined ? e.title : ""),
            destIndex: destIndex
        }
    }

    function _isPinnedBottom(e) {
        if (!e)
            return false
        if (e.footer === true)
            return true
        const pin = e.pin !== undefined ? String(e.pin).toLowerCase() : ""
        return pin === "bottom" || pin === "footer"
    }

    readonly property var railModel: {
        const src = destinations || []
        const out = []
        for (let i = 0; i < src.length; ++i) {
            const e = src[i] || {}
            if (_isPinnedBottom(e))
                continue
            out.push(_railEntry(e, i))
        }
        return out
    }

    readonly property var railFooterModel: {
        const src = destinations || []
        const out = []
        for (let i = 0; i < src.length; ++i) {
            const e = src[i] || {}
            if (!_isPinnedBottom(e))
                continue
            out.push(_railEntry(e, i))
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
            footerModel: root.railFooterModel
            currentIndex: root.railHighlightIndex
            showExpandToggle: true
            onCurrentIndexChangedByUser: function (index) {
                root.navigateTo(index)
            }
            onDestinationHovered: function (index) {
                // Mirror rail: never queue L2 compile while the rail is flicking/dragging.
                if (rail.scrolling)
                    return
                host.prefetchHint(index)
            }
            onDestinationUnhovered: function (index) {
                host.clearPrefetchHint(index)
            }
            onScrollingChanged: {
                if (scrolling)
                    host.clearAllPrefetchHints()
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
