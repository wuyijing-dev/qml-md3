import QtQuick
import QtQuick.Window

/// Torn-off peer window. With `documentTabsManaged` you only pass catalog + initial tabs.
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
    railHeader: qsTr("Gallery")
    documentTabsEnabled: true
    documentTabsManaged: true
    documentTabsCloseWindowWhenEmpty: true
    /// Same browser chrome as main — tab strip is the title bar (draggable).
    browserChrome: true
    pageCacheMode: "adaptive"
    pageCacheLimit: 3
    pageIdleTrimMs: 45000
    pagePrefetch: false
    pageWarmStart: false
    pageAsync: true
    pageSkeleton: true
    pageTransition: "fadeThrough"
    pageTransitionDuration: Md3Motion.short4
    showPinButton: true
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
        Qt.callLater(function () {
            if (documentTabBar && typeof documentTabBar.reportNativeHits === "function")
                documentTabBar.reportNativeHits()
        })
    }
}
