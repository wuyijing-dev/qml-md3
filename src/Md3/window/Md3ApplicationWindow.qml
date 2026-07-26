import QtQuick
import QtQuick.Window
import QtQuick.Effects

Window {
    id: root

    property bool customChrome: Md3WindowCapabilities.customChrome
    property bool showTitleBar: true
    property bool roundedCorners: Md3WindowCapabilities.roundedCorners
    // Platform default; set 0 to disable client rounding
    property real cornerRadius: Md3WindowCapabilities.windowCornerRadius
    property bool showWindowBorder: true
    property alias titleBarItem: titleBarLoader.item
    property alias overlay: overlayHost.data
    property alias overlayItem: overlayHost
    property Component titleBar: null
    /// App icon for title bar + taskbar / Alt-Tab (qrc or file URL)
    property url windowIcon: ""
    /// Sync DWM immersive dark mode with Md3Theme.dark (Windows)
    property bool syncImmersiveDarkMode: true
    /// Win11 system backdrop: 0=None 1=Auto 2=Mica 3=Acrylic 4=Tabbed
    property int systemBackdrop: 0
    /// DWM border color ("#RRGGBB", "none", "default", or "")
    property string nativeBorderColor: ""
    readonly property bool usesSystemBackdrop: systemBackdrop > 0
    /// How much MD3 surface tints over Mica (0=pure wallpaper blur, 1=solid).
    /// Keep low — Fluent apps are mostly material with light tint.
    property real backdropTint: 0.06
    property real backdropContentTint: 0.12
    property real backdropTitleTint: 0.05
    /// Title-bar pin (always-on-top). On by default.
    property bool showPinButton: true
    property bool pinned: false

    /// Circular reveal when toggling light/dark (Material-style wipe from click)
    property bool themeRevealEnabled: true
    property bool themeRevealBusy: false
    property int themeRevealDuration: Md3Motion.long2
    property var themeRevealEasing: Md3Motion.emphasized

    // --- Built-in destinations shell (rail + lazy pages) ---
    /// When non-empty, window hosts left rail + on-demand pages (no manual layout needed).
    property var destinations: []
    property int currentIndex: 0
    property bool navigationRail: true
    property bool railExpanded: false
    property string railHeader: ""
    /// "none" | "one" | "lru" | "all" | "adaptive"
    /// adaptive: keep up to pageCacheLimit while navigating; trim to 1 after idle
    property string pageCacheMode: "lru"
    property int pageCacheLimit: 4
    /// Idle time before adaptive mode drops to a single resident page
    property int pageIdleTrimMs: 45000
    property real pagePadding: 20
    property bool pagePrefetch: false
    property bool pageAsync: true
    /// Background-warm all destinations (off by default — competes with UI)
    property bool pageWarmStart: false
    /// Resolve relative destination sources against this URL (Gallery: Qt.resolvedUrl("."))
    property url pageSourceBase: ""
    /// "none" | "fade" | "slide" | "slideUp" | "fadeThrough" | "scale"
    property string pageTransition: "fadeThrough"
    property int pageTransitionDuration: Md3Motion.spatialDuration
    /// Show Md3SkeletonPane while a destination loads
    property bool pageSkeleton: true
    property alias pageHost: windowBody.pageHost

    // --- Document tabs (Explorer / browser style) ---
    /// Show the Win11-style tab strip under the title bar.
    property bool documentTabsEnabled: false
    /// Browser-like chrome: tab strip replaces the title bar (tabs + caption only).
    property bool browserChrome: false
    /// Auto-handle activate / close / add / reorder / tear-off + keep tabs in sync with
    /// `currentIndex` / destinations. Turn off only if you want fully custom handlers.
    property bool documentTabsManaged: true
    /// Close this window when the last tab is closed (typical for torn-off windows).
    property bool documentTabsCloseWindowWhenEmpty: false
    property var documentTabs: []
    property int documentTabIndex: 0
    property bool documentTabsClosable: true
    property bool documentTabsTearOff: true
    property bool documentTabsShowAdd: true
    property alias documentTabBar: docTabBar
    property alias documentTabActions: docTabBar.windowActions
    property bool _docTabSyncing: false

    signal documentTabActivated(int index)
    signal documentTabCloseRequested(int index)
    signal documentTabAddRequested()
    signal documentTabMoved(int from, int to)
    signal documentTabTearOff(int index, real globalX, real globalY)

    readonly property bool usesDestinations: destinations && destinations.length > 0

    default property alias content: customContent.data

    function navigateTo(index) {
        if (usesDestinations)
            windowBody.navigateTo(index)
        else
            currentIndex = index
    }

    /// Build a tab model entry from a destinations index.
    function documentTabMeta(pageIndex) {
        const d = destinations && destinations[pageIndex]
        return {
            title: d && d.title !== undefined ? d.title : qsTr("Tab"),
            icon: d && d.icon !== undefined ? d.icon : "web_asset",
            pageIndex: pageIndex
        }
    }

    /// Open `pageIndex` in the current tab (`asNew=false`) or a new tab (`asNew=true`).
    function openTab(pageIndex, asNew) {
        if (!usesDestinations || pageIndex < 0 || pageIndex >= destinations.length)
            return
        _docTabSyncing = true
        const tabs = (documentTabs || []).slice()
        if (asNew || !tabs.length) {
            tabs.push(documentTabMeta(pageIndex))
            documentTabs = tabs
            documentTabIndex = tabs.length - 1
        } else {
            const i = Math.max(0, Math.min(documentTabIndex, tabs.length - 1))
            tabs[i] = documentTabMeta(pageIndex)
            documentTabs = tabs
            documentTabIndex = i
        }
        if (currentIndex !== pageIndex)
            navigateTo(pageIndex)
        title = documentTabs[documentTabIndex].title
        _docTabSyncing = false
    }

    function addTab(pageIndex) {
        openTab(pageIndex !== undefined ? pageIndex : currentIndex, true)
    }

    function closeTab(index) {
        if (index === undefined)
            index = documentTabIndex
        if (!documentTabs || index < 0 || index >= documentTabs.length)
            return
        if (documentTabs.length <= 1) {
            if (documentTabsCloseWindowWhenEmpty)
                close()
            return
        }
        _docTabSyncing = true
        const tabs = documentTabs.slice()
        const was = documentTabIndex
        tabs.splice(index, 1)
        documentTabs = tabs
        let next = was
        if (index < was)
            next = was - 1
        else if (index === was)
            next = Math.min(was, tabs.length - 1)
        documentTabIndex = Math.max(0, Math.min(next, tabs.length - 1))
        const t = tabs[documentTabIndex]
        if (t && t.pageIndex !== undefined)
            navigateTo(t.pageIndex)
        title = t ? t.title : root.title
        _docTabSyncing = false
    }

    function moveTab(from, to) {
        if (!documentTabs || from === to || from < 0 || to < 0
                || from >= documentTabs.length || to >= documentTabs.length)
            return
        const tabs = documentTabs.slice()
        const item = tabs.splice(from, 1)[0]
        tabs.splice(to, 0, item)
        documentTabs = tabs
        if (documentTabIndex === from)
            documentTabIndex = to
        else if (from < documentTabIndex && to >= documentTabIndex)
            documentTabIndex--
        else if (from > documentTabIndex && to <= documentTabIndex)
            documentTabIndex++
    }

    function activateTab(index) {
        if (!documentTabs || index < 0 || index >= documentTabs.length)
            return
        _docTabSyncing = true
        documentTabIndex = index
        const t = documentTabs[index]
        if (t && t.pageIndex !== undefined && currentIndex !== t.pageIndex)
            navigateTo(t.pageIndex)
        if (t && t.title)
            title = t.title
        _docTabSyncing = false
    }

    function tearOffTab(index, globalX, globalY) {
        if (!documentTabs || documentTabs.length <= 1
                || index < 0 || index >= documentTabs.length)
            return
        _docTabSyncing = true
        const tabs = documentTabs.slice()
        const torn = tabs.splice(index, 1)[0]
        documentTabs = tabs
        documentTabIndex = Math.max(0, Math.min(
            documentTabIndex === index
                ? (index > 0 ? index - 1 : 0)
                : (documentTabIndex > index ? documentTabIndex - 1 : documentTabIndex),
            tabs.length - 1))
        const t = tabs[documentTabIndex]
        if (t && t.pageIndex !== undefined)
            navigateTo(t.pageIndex)
        if (t && t.title)
            title = t.title
        _docTabSyncing = false

        const url = Qt.resolvedUrl("Md3TabWindow.qml")
        const comp = Qt.createComponent(url)
        function spawn() {
            const w = comp.createObject(null, {
                catalog: root.destinations,
                initialTabs: [torn],
                x: Math.max(0, (globalX !== undefined ? globalX : root.x + 48) - 96),
                y: Math.max(0, (globalY !== undefined ? globalY : root.y + 48) - 20),
                width: Math.min(960, root.width),
                height: Math.min(640, root.height),
                windowIcon: root.windowIcon,
                pageSourceBase: root.pageSourceBase,
                systemBackdrop: root.systemBackdrop,
                cornerRadius: root.cornerRadius,
                browserChrome: true,
                documentTabsCloseWindowWhenEmpty: true
            })
            if (!w)
                console.warn("Md3ApplicationWindow: tear-off createObject failed")
        }
        if (comp.status === Component.Ready)
            spawn()
        else if (comp.status === Component.Error)
            console.warn("Md3ApplicationWindow tear-off:", comp.errorString())
        else
            comp.statusChanged.connect(function () {
                if (comp.status === Component.Ready)
                    spawn()
                else if (comp.status === Component.Error)
                    console.warn("Md3ApplicationWindow tear-off:", comp.errorString())
            })
    }

    function _managedSyncTabFromPage() {
        if (_docTabSyncing || !documentTabsManaged || !documentTabsEnabled)
            return
        if (!documentTabs || documentTabs.length === 0)
            return
        _docTabSyncing = true
        const tabs = documentTabs.slice()
        const i = Math.max(0, Math.min(documentTabIndex, tabs.length - 1))
        tabs[i] = documentTabMeta(currentIndex)
        documentTabs = tabs
        documentTabIndex = i
        title = tabs[i].title
        _docTabSyncing = false
    }

    function _ensureManagedTabs() {
        if (!documentTabsEnabled || !documentTabsManaged || !usesDestinations)
            return
        if (documentTabs && documentTabs.length > 0)
            return
        documentTabs = [documentTabMeta(currentIndex)]
        documentTabIndex = 0
        title = documentTabs[0].title
    }

    onCurrentIndexChanged: {
        if (usesDestinations && windowBody.currentIndex !== currentIndex)
            windowBody.currentIndex = currentIndex
        _managedSyncTabFromPage()
    }

    onBrowserChromeChanged: {
        if (browserChrome) {
            documentTabsEnabled = true
            if (documentTabsManaged)
                Qt.callLater(_ensureManagedTabs)
        }
    }

    onDocumentTabsEnabledChanged: {
        if (documentTabsEnabled)
            Qt.callLater(_ensureManagedTabs)
    }

    readonly property bool isMaximizedLike: visibility === Window.Maximized
                                            || visibility === Window.FullScreen
    readonly property real effectiveRadius: {
        if (!customChrome || !roundedCorners || isMaximizedLike)
            return 0
        return Math.max(0, cornerRadius)
    }
    readonly property bool useTransparentFrame: customChrome && Md3WindowCapabilities.customChrome
                                                 && effectiveRadius > 0

    // Always transparent with custom chrome so DWM materials / rounded corners can show
    color: (customChrome && Md3WindowCapabilities.customChrome) || usesSystemBackdrop
           ? "transparent" : Md3Theme.colorScheme.surface
    visible: true

    flags: {
        let f = Qt.Window
        if (root.customChrome && Md3WindowCapabilities.customChrome)
            f |= Qt.FramelessWindowHint
        return f
    }

    Md3WindowHelper {
        id: windowHelper
    }
    /// Access native helper (signals: thumbBarButtonClicked, trayActivated, dpiChanged).
    readonly property alias windowNative: windowHelper

    readonly property real chromeTop: {
        if (root.browserChrome && docTabBar.visible)
            return docTabBar.height
        if (showTitleBar && customChrome && !root.browserChrome)
            return titleBarLoader.height
        return 0
    }
    readonly property real edge: 6
    readonly property bool canResize: customChrome && Md3WindowCapabilities.systemResize
                                      && !isMaximizedLike

    function _themeRevealMaxRadius(ox, oy) {
        const w = chrome.width
        const h = chrome.height
        return Math.max(Math.hypot(ox, oy),
                        Math.hypot(w - ox, oy),
                        Math.hypot(ox, h - oy),
                        Math.hypot(w - ox, h - oy))
    }

    /// Toggle theme with circular reveal from a point in chrome / contentItem coords.
    function toggleThemeAt(x, y) {
        if (!themeRevealEnabled || themeRevealBusy || chrome.width < 1 || chrome.height < 1) {
            Md3Theme.toggleDark()
            return
        }
        themeRevealBusy = true
        const ox = Math.max(0, Math.min(chrome.width, x))
        const oy = Math.max(0, Math.min(chrome.height, y))
        const targetR = _themeRevealMaxRadius(ox, oy) + 2
        chrome.grabToImage(function (result) {
            if (!result) {
                Md3Theme.toggleDark()
                themeRevealBusy = false
                return
            }
            themeRevealSnap.source = result.url
            themeRevealCx = ox
            themeRevealCy = oy
            themeRevealRadius = 0
            themeRevealLayer.visible = true
            Md3Theme.toggleDark()
            themeRevealAnim.to = targetR
            themeRevealAnim.restart()
        })
    }

    /// Toggle theme revealing from the center of `item` (mapped into the window chrome).
    function toggleThemeFrom(item) {
        if (!item) {
            toggleThemeAt(chrome.width / 2, chrome.height / 2)
            return
        }
        const p = item.mapToItem(chrome, item.width / 2, item.height / 2)
        toggleThemeAt(p.x, p.y)
    }

    property real themeRevealCx: 0
    property real themeRevealCy: 0
    property real themeRevealRadius: 0

    Component.onCompleted: {
        windowHelper.bindWindow(root)
        windowHelper.applyCornerPreference(root, root.effectiveRadius > 0)
        _applyWindowIcon()
        _syncWinNative()
        _ensureManagedTabs()
    }

    onWindowIconChanged: _applyWindowIcon()
    onEffectiveRadiusChanged: windowHelper.applyCornerPreference(root, effectiveRadius > 0)
    onVisibilityChanged: function () {
        windowHelper.applyCornerPreference(root, effectiveRadius > 0)
        // Drop persistent scene graph while minimized — reclaim GPU/CPU memory
        const save = root.visibility === Window.Minimized
                     || root.visibility === Window.Hidden
        windowHelper.setPersistentSceneGraph(root, !save)
        if (root.visibility !== Window.Hidden)
            Qt.callLater(function () {
                root._applyWindowIcon()
                root._syncWinNative()
            })
    }
    onVisibleChanged: {
        if (visible)
            Qt.callLater(function () {
                root._applyWindowIcon()
                root._syncWinNative()
            })
    }
    onSystemBackdropChanged: _syncWinNative()
    onNativeBorderColorChanged: _syncWinNative()
    onSyncImmersiveDarkModeChanged: _syncWinNative()

    Connections {
        target: Md3Theme
        function onDarkChanged() { root._syncWinNative() }
    }

    function _applyWindowIcon() {
        if (!windowIcon || windowIcon.toString().length === 0)
            return
        windowHelper.setWindowIcon(root, windowIcon)
        if (titleBarLoader.item && titleBarLoader.item.appIcon !== undefined)
            titleBarLoader.item.appIcon = windowIcon
    }

    function _syncWinNative() {
        if (!windowHelper)
            return
        // Ensure HWND exists before DWM calls
        if (!root.visible)
            return
        if (syncImmersiveDarkMode && windowHelper.immersiveDarkModeSupported)
            windowHelper.setImmersiveDarkMode(root, Md3Theme.dark)
        if (windowHelper.preferredAppModeSupported)
            windowHelper.setPreferredAppMode(Md3Theme.dark)
        if (windowHelper.systemBackdropSupported)
            windowHelper.setSystemBackdrop(root, systemBackdrop)
        if (windowHelper.platformId === "windows")
            windowHelper.setBorderColor(root, nativeBorderColor.length > 0 ? nativeBorderColor : "default")
    }

    /// Hex helper for Gallery / apps (accepts color or string).
    function toCssColor(c) {
        if (c === undefined || c === null || c === "")
            return ""
        if (typeof c === "string") {
            if (c === "none" || c === "default")
                return c
            return c
        }
        const col = Qt.color(c)
        const r = Math.round(col.r * 255)
        const g = Math.round(col.g * 255)
        const b = Math.round(col.b * 255)
        const hx = (n) => ("0" + n.toString(16)).slice(-2)
        return "#" + hx(r) + hx(g) + hx(b)
    }

    function setNativeBorderColor(c) {
        nativeBorderColor = toCssColor(c)
        _syncWinNative()
    }

    function setSystemBackdropMode(mode) {
        const turningOn = mode > 0 && systemBackdrop <= 0
        systemBackdrop = mode
        if (mode > 0) {
            // Linux：半透明要看得见模糊，遮罩略高
            if (Md3WindowCapabilities.isLinux) {
                backdropTint = 0.12
                backdropContentTint = 0.28
                backdropTitleTint = 0.08
            } else if (Md3WindowCapabilities.isWindows && turningOn) {
                // Fluent：刚打开材质时用低色调，避免内容层把云母/亚克力盖成实心
                backdropTint = 0.06
                backdropContentTint = 0.12
                backdropTitleTint = 0.05
            }
        }
        // Let Window.color binding flip to transparent before DWM attributes.
        Qt.callLater(function () { root._syncWinNative() })
    }

    /// Flash the Windows taskbar button (attention).
    function flashTaskbar(flash) {
        if (flash === undefined)
            flash = true
        windowHelper.flashTaskbar(root, flash)
    }

    function setTaskbarProgress(value, state) {
        if (state === undefined)
            state = Md3WindowHelper.ProgressNormal
        windowHelper.setTaskbarProgress(root, value, state)
    }

    function clearTaskbarProgress() {
        windowHelper.clearTaskbarProgress(root)
    }

    function setTaskbarOverlayIcon(iconUrl, description) {
        return windowHelper.setTaskbarOverlayIcon(root, iconUrl, description || "")
    }

    function clearTaskbarOverlayIcon() {
        windowHelper.clearTaskbarOverlayIcon(root)
    }

    function setExcludedFromPeek(excluded) {
        windowHelper.setExcludedFromPeek(root, !!excluded)
    }

    function setDisallowPeek(disallow) {
        windowHelper.setDisallowPeek(root, !!disallow)
    }

    function setExcludeFromCapture(exclude) {
        windowHelper.setExcludeFromCapture(root, !!exclude)
    }

    function setJumpListTasks(tasks) {
        return windowHelper.setJumpListTasks(tasks)
    }

    function clearJumpList() {
        windowHelper.clearJumpList()
    }

    function setThumbBarButtons(buttons) {
        return windowHelper.setThumbBarButtons(root, buttons)
    }

    function clearThumbBarButtons() {
        windowHelper.clearThumbBarButtons(root)
    }

    function setForceIconicRepresentation(enabled) {
        windowHelper.setForceIconicRepresentation(root, !!enabled)
    }

    function setIconicThumbnail(imageUrl) {
        return windowHelper.setIconicThumbnail(root, imageUrl)
    }

    function clearIconicThumbnail() {
        windowHelper.clearIconicThumbnail(root)
    }

    function showSystemTrayIcon(iconUrl, tooltip) {
        return windowHelper.showSystemTrayIcon(root, iconUrl, tooltip || title)
    }

    function hideSystemTrayIcon() {
        windowHelper.hideSystemTrayIcon()
    }

    function showTrayNotification(titleText, body, timeoutMs) {
        return windowHelper.showTrayNotification(titleText, body,
                                                 timeoutMs === undefined ? 5000 : timeoutMs)
    }

    function setAlwaysOnTop(onTop) {
        root.pinned = !!onTop
        windowHelper.setAlwaysOnTop(root, root.pinned)
    }

    function raiseWindow() {
        windowHelper.raiseWindow(root)
    }

    function setDockBadge(count) {
        return windowHelper.setDockBadge(count === undefined ? 0 : count)
    }

    function setIdleInhibit(inhibit, reason) {
        return windowHelper.setIdleInhibit(!!inhibit, reason || "")
    }

    function openBlurSettings() {
        return windowHelper.openBlurSettings()
    }

    onPinnedChanged: {
        if (windowHelper.alwaysOnTopSupported)
            windowHelper.setAlwaysOnTop(root, root.pinned)
    }

    function setWindowCloaked(cloaked) {
        windowHelper.setWindowCloaked(root, !!cloaked)
    }

    function setPreferredAppMode(dark) {
        windowHelper.setPreferredAppMode(!!dark)
    }

    function moveToMonitor(index) {
        return windowHelper.moveToMonitor(root, index)
    }

    function setThumbnailClip(x, y, w, h) {
        windowHelper.setThumbnailClip(root, x, y, w, h)
    }

    function clearThumbnailClip() {
        windowHelper.clearThumbnailClip(root)
    }

    function setThumbnailTooltip(text) {
        windowHelper.setThumbnailTooltip(root, text || "")
    }

    function registerApplicationRestart(args) {
        return windowHelper.registerApplicationRestart(args || "")
    }

    function unregisterApplicationRestart() {
        windowHelper.unregisterApplicationRestart()
    }

    readonly property real windowDpr: windowHelper.devicePixelRatio(root)
    readonly property int windowDpi: windowHelper.windowDpi(root)
    readonly property int monitorCount: windowHelper.monitorCount()

    // --- Rounded frame shell ---
    Item {
        id: shell
        anchors.fill: parent
        z: 0

        Item {
            id: chrome
            anchors.fill: parent

            // MultiEffect offscreen FBO is opaque to DWM — never enable under backdrop.
            // Prefer DWM rounded corners whenever possible.
            layer.enabled: root.effectiveRadius > 0 && !root.usesSystemBackdrop
            layer.smooth: true
            layer.effect: MultiEffect {
                maskEnabled: true
                maskSource: chromeMask
            }

            Rectangle {
                id: fill
                anchors.fill: parent
                radius: root.usesSystemBackdrop ? 0 : root.effectiveRadius
                color: root.usesSystemBackdrop
                       ? Qt.alpha(Md3Theme.colorScheme.surface, root.backdropTint)
                       : (root.customChrome ? Qt.alpha(Md3Theme.colorScheme.surface, 0.98)
                                            : Md3Theme.colorScheme.surface)
                // When backdrop is on, don't paint opaque over Mica in empty areas
                visible: !root.usesSystemBackdrop || root.backdropTint > 0.001
            }

            // Visible edge along the rounded boundary (skip under backdrop — DWM draws frame)
            Rectangle {
                anchors.fill: parent
                radius: root.effectiveRadius
                color: "transparent"
                border.width: root.showWindowBorder && root.effectiveRadius > 0 && !root.usesSystemBackdrop ? 1 : 0
                border.color: Md3Theme.colorScheme.outlineVariant
                z: 50
            }

            Loader {
                id: titleBarLoader
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                active: root.showTitleBar && root.customChrome && !root.browserChrome
                height: active && item ? item.height : 0
                z: 100
                sourceComponent: root.titleBar !== null ? root.titleBar : defaultTitleBar
                onLoaded: {
                    if (item) {
                        if (item.targetWindow !== undefined)
                            item.targetWindow = root
                        if (item.windowHelper !== undefined)
                            item.windowHelper = windowHelper
                        if (item.cornerRadius !== undefined)
                            item.cornerRadius = Qt.binding(function () { return root.effectiveRadius })
                        if (item.title !== undefined && root.title.length > 0
                                && (!item.title || item.title.length === 0))
                            item.title = root.title
                        if (item.appIcon !== undefined && root.windowIcon.toString().length > 0)
                            item.appIcon = Qt.binding(function () { return root.windowIcon })
                    }
                }
            }

            Component {
                id: defaultTitleBar
                Md3TitleBar {
                    title: root.title
                    appIcon: root.windowIcon
                    showAppIcon: true
                    showPin: root.showPinButton
                    pinned: root.pinned
                    targetWindow: root
                    windowHelper: windowHelper
                    cornerRadius: root.effectiveRadius
                    preferredHeight: 28
                    barHeight: 28
                    leadingInset: windowHelper.trafficLightsInset > 0
                                  ? windowHelper.trafficLightsInset
                                  : Md3WindowCapabilities.trafficLightsInset
                    onPinToggled: function (onTop) { root.pinned = onTop }
                }
            }

            Md3DocumentTabBar {
                id: docTabBar
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: root.browserChrome ? parent.top : titleBarLoader.bottom
                z: 90
                visible: root.documentTabsEnabled || root.browserChrome
                height: visible ? implicitHeight : 0
                model: root.documentTabs
                currentIndex: root.documentTabIndex
                closable: root.documentTabsClosable
                tearOffEnabled: root.documentTabsTearOff
                showAddButton: root.documentTabsShowAdd
                showWindowControls: root.browserChrome && root.customChrome
                targetWindow: root
                windowHelper: windowHelper
                cornerRadius: root.effectiveRadius
                onCurrentIndexChanged: {
                    if (root.documentTabIndex !== currentIndex)
                        root.documentTabIndex = currentIndex
                }
                onTabActivated: function (index) {
                    if (root.documentTabsManaged)
                        root.activateTab(index)
                    root.documentTabActivated(index)
                }
                onTabCloseRequested: function (index) {
                    if (root.documentTabsManaged)
                        root.closeTab(index)
                    root.documentTabCloseRequested(index)
                }
                onTabAddRequested: {
                    if (root.documentTabsManaged)
                        root.addTab(root.currentIndex)
                    root.documentTabAddRequested()
                }
                onTabMoved: function (from, to) {
                    if (root.documentTabsManaged)
                        root.moveTab(from, to)
                    root.documentTabMoved(from, to)
                }
                onTabTearOff: function (index, gx, gy) {
                    if (root.documentTabsManaged)
                        root.tearOffTab(index, gx, gy)
                    root.documentTabTearOff(index, gx, gy)
                }
            }

            Item {
                id: contentHost
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: docTabBar.visible ? docTabBar.bottom : titleBarLoader.bottom
                anchors.bottom: parent.bottom
                clip: true
                z: 0

                Md3WindowBody {
                    id: windowBody
                    anchors.fill: parent
                    visible: root.usesDestinations
                    enabled: visible
                    destinations: root.destinations
                    currentIndex: root.currentIndex
                    railVisible: root.navigationRail
                    railExpanded: root.railExpanded
                    railHeader: root.railHeader
                    cacheMode: root.pageCacheMode
                    cacheLimit: root.pageCacheLimit
                    idleTrimMs: root.pageIdleTrimMs
                    contentPadding: root.pagePadding
                    sourceBase: root.pageSourceBase
                    asynchronous: root.pageAsync
                    prefetchNeighbors: root.pagePrefetch
                    warmStart: root.pageWarmStart
                    showBusyIndicator: false
                    showSkeleton: root.pageSkeleton
                    pageTransition: root.pageTransition
                    pageTransitionDuration: root.pageTransitionDuration
                    onDestinationActivated: function (index) {
                        if (root.currentIndex !== index)
                            root.currentIndex = index
                    }
                    onRailExpandRequested: function (expanded) {
                        root.railExpanded = expanded
                    }
                    onCurrentIndexChanged: {
                        if (root.currentIndex !== windowBody.currentIndex)
                            root.currentIndex = windowBody.currentIndex
                    }
                }

                Item {
                    id: customContent
                    anchors.fill: parent
                    visible: !root.usesDestinations
                    enabled: visible
                }
            }

            Item {
                id: overlayHost
                anchors.fill: parent
                z: 1000
            }

            // Old-theme snapshot: circular hole expands → new theme shows through
            Image {
                id: themeRevealSnap
                anchors.fill: parent
                visible: false
                asynchronous: false
                cache: false
                fillMode: Image.Stretch
                z: 5000
            }

            Item {
                id: themeRevealMask
                width: chrome.width
                height: chrome.height
                visible: false
                layer.enabled: true
                layer.smooth: true
                Rectangle {
                    width: Math.max(0.01, root.themeRevealRadius * 2)
                    height: Math.max(0.01, root.themeRevealRadius * 2)
                    radius: Math.max(0.005, root.themeRevealRadius)
                    x: root.themeRevealCx - width / 2
                    y: root.themeRevealCy - height / 2
                    color: "#ffffff"
                }
            }

            MultiEffect {
                id: themeRevealLayer
                anchors.fill: parent
                z: 5001
                visible: false
                source: themeRevealSnap
                maskEnabled: true
                maskSource: themeRevealMask
                maskInverted: true
                maskSpreadAtMax: 0.02
            }

            NumberAnimation {
                id: themeRevealAnim
                target: root
                property: "themeRevealRadius"
                duration: root.themeRevealDuration
                easing.type: Easing.BezierSpline
                // Spatial non-linear ease: fast expansion, soft settle (not linear radius)
                easing.bezierCurve: root.themeRevealEasing
                onFinished: {
                    themeRevealLayer.visible = false
                    themeRevealSnap.source = ""
                    themeRevealRadius = 0
                    root.themeRevealBusy = false
                }
            }
        }

        Item {
            id: chromeMask
            width: chrome.width
            height: chrome.height
            layer.enabled: true
            visible: false
            Rectangle {
                anchors.fill: parent
                radius: root.effectiveRadius
                color: "#ffffff"
            }
        }
    }

    component ResizeEdge: MouseArea {
        property int edges: 0
        enabled: root.canResize
        hoverEnabled: true
        z: 200
        onPressed: root.startSystemResize(edges)
    }

    ResizeEdge {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: root.edge
        edges: Qt.LeftEdge
        cursorShape: Qt.SizeHorCursor
    }
    ResizeEdge {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: root.edge
        edges: Qt.RightEdge
        cursorShape: Qt.SizeHorCursor
    }
    ResizeEdge {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: root.edge
        edges: Qt.TopEdge
        cursorShape: Qt.SizeVerCursor
        z: 300
    }
    ResizeEdge {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: root.edge
        edges: Qt.BottomEdge
        cursorShape: Qt.SizeVerCursor
    }
    ResizeEdge {
        anchors.left: parent.left
        anchors.top: parent.top
        width: root.edge * 2
        height: root.edge * 2
        edges: Qt.LeftEdge | Qt.TopEdge
        cursorShape: Qt.SizeFDiagCursor
    }
    ResizeEdge {
        anchors.right: parent.right
        anchors.top: parent.top
        width: root.edge * 2
        height: root.edge * 2
        edges: Qt.RightEdge | Qt.TopEdge
        cursorShape: Qt.SizeBDiagCursor
    }
    ResizeEdge {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: root.edge * 2
        height: root.edge * 2
        edges: Qt.LeftEdge | Qt.BottomEdge
        cursorShape: Qt.SizeBDiagCursor
    }
    ResizeEdge {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: root.edge * 2
        height: root.edge * 2
        edges: Qt.RightEdge | Qt.BottomEdge
        cursorShape: Qt.SizeFDiagCursor
    }
}
