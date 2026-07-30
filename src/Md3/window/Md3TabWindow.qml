import QtQuick
import QtQuick.Window
import Md3

/// Peer window spawned by document-tab tear-off (`Md3ApplicationWindow.tearOffTab`).
/// Uses the normal title bar + tab strip (browserChrome was removed).
Md3ApplicationWindow {
    id: root

    property var catalog: []
    property var initialTabs: []
    property int initialTabIndex: 0

    width: 960
    height: 640
    title: qsTr("Tab")
    navigationRail: true
    railExpanded: false
    documentTabsEnabled: true
    documentTabsManaged: true
    documentTabsTearOff: true
    documentTabsCloseWindowWhenEmpty: true
    showTitleBar: true
    showPinButton: true
    pageCacheMode: "adaptive"
    pageCacheLimit: 3
    pageIdleTrimMs: 45000
    pagePrefetch: false
    pageWarmStart: false
    pageAsync: true
    pageSkeleton: true
    pageTransition: "fadeThrough"
    pageTransitionDuration: Md3Motion.short4
    pagePadding: 20

    destinations: root.catalog

    Component.onCompleted: {
        if (initialTabs && initialTabs.length) {
            documentTabs = initialTabs.slice()
            documentTabIndex = 0
            const cur = documentTabs[0]
            if (cur && cur.pageIndex !== undefined)
                currentIndex = cur.pageIndex
            title = cur && cur.title ? cur.title : qsTr("Tab")
        } else {
            const idx = Math.max(0, initialTabIndex)
            openTab(idx, true)
        }
        visible = true
        raise()
        requestActivate()
    }
}
