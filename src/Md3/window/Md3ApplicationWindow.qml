import QtQuick
import QtQuick.Window
import QtQuick.Effects
import Md3

Window {
    id: root

    property bool customChrome: Md3WindowCapabilities.customChrome
    property bool showTitleBar: true
    /// When true (default), chrome follows MD3 size class + mobile/desktop policy (Md3Adaptive).
    property bool adaptiveChrome: true
    readonly property int widthClass: Md3Adaptive.widthClassFor(width)
    readonly property int heightClass: Md3Adaptive.heightClassFor(height)
    readonly property int deviceClass: Md3Adaptive.deviceClassFor(width, height)
    readonly property int windowAppearance: Md3Adaptive.windowAppearanceFor(width, height)
    readonly property string widthClassName: Md3Adaptive.widthClassName(widthClass)
    readonly property string deviceClassName: Md3Adaptive.deviceClassName(deviceClass)
    readonly property string windowAppearanceName: Md3Adaptive.windowAppearanceName(windowAppearance)
    /// Effective CSD flag after adaptive policy (use this instead of raw customChrome for chrome layout).
    readonly property bool useCustomChrome: {
        if (!customChrome)
            return false
        if (!adaptiveChrome)
            return Md3WindowCapabilities.customChrome
        return Md3Adaptive.useCustomChrome(width, height)
    }
    readonly property bool preferCompactTitleBar: adaptiveChrome
                                                  && Md3Adaptive.preferCompactTitleBar(width, height)
    readonly property bool preferCaptionButtons: adaptiveChrome
                                                 ? Md3Adaptive.preferCaptionButtons(width, height)
                                                 : Md3WindowCapabilities.captionButtons
    readonly property bool preferNavigationBar: Md3Adaptive.preferNavigationBar(width, height)
    readonly property bool preferNavigationRail: Md3Adaptive.preferNavigationRail(width, height)
    property bool roundedCorners: Md3WindowCapabilities.roundedCorners
    // Platform default; set 0 to disable client rounding
    property real cornerRadius: Md3WindowCapabilities.windowCornerRadius
    property bool showWindowBorder: true
    property alias titleBarItem: titleBarLoader.item
    property alias overlay: overlayHost.data
    property alias overlayItem: overlayHost
    property alias snackbarHostItem: snackbarHost
    property Component titleBar: null
    /// App icon for title bar + taskbar / Alt-Tab (qrc or file URL).
    /// Default: Md3 bundled icon (resources/icons → qrc:/md3/icons/…).
    property url windowIcon: Md3AppIcons.window
    /// Sync DWM immersive dark mode with Md3Theme.dark (Windows)
    property bool syncImmersiveDarkMode: true
    /// UNSUITABLE FOR PRODUCTION — kept for future research only.
    /// Qt Quick composition typically hides DWM Mica/Acrylic; prefer 0 (solid MD3 surface).
    /// 0=None 1=Auto 2=Mica 3=Acrylic 4=Tabbed
    property int systemBackdrop: 0
    /// DWM border color ("#RRGGBB", "none", "default", or "")
    property string nativeBorderColor: ""
    readonly property bool usesSystemBackdrop: systemBackdrop > 0
    /// UNSUITABLE — wash over system backdrop; unused when systemBackdrop is 0.
    property real backdropTint: 0.08
    property real backdropContentTint: 0.18
    property real backdropTitleTint: 0.06
    /// Title-bar pin (always-on-top). On by default.
    property bool showPinButton: true
    property bool pinned: false
    /// Title-bar About (info) button → modeless About dialog
    property bool showAboutButton: true
    property string aboutAppName: ""
    property string aboutVersion: ""
    property string aboutOrganization: ""
    property string aboutText: ""
    property url aboutIcon: ""
    property Component aboutContent: null

    /// Circular reveal when toggling light/dark (Material-style wipe from click)
    property bool themeRevealEnabled: true
    property bool themeRevealBusy: false
    property int themeRevealDuration: Md3Motion.long2
    property var themeRevealEasing: Md3Motion.emphasized

    /// Fallback for `a11y/showFocusRings` when QSettings has no value yet.
    /// Mouse-first desktop apps often set `false`; keyboard-first / Gallery leave default `true`.
    property bool defaultShowFocusRings: true

    /// QSettings often returns REG_SZ "true"/"false" — never use !! on strings ("false" is truthy).
    function _settingsBool(key, fallback) {
        const v = Md3AppSettings.value(key, fallback)
        if (v === undefined || v === null)
            return !!fallback
        if (typeof v === "boolean")
            return v
        if (typeof v === "number")
            return v !== 0
        const s = String(v).trim().toLowerCase()
        if (s === "true" || s === "1" || s === "yes" || s === "on")
            return true
        if (s === "false" || s === "0" || s === "no" || s === "off" || s === "")
            return false
        return !!fallback
    }

    // --- Built-in destinations shell (rail + lazy pages) ---
    /// When non-empty, window hosts left rail + on-demand pages (no manual layout needed).
    property var destinations: []
    property int currentIndex: 0
    property bool navigationRail: true
    property bool railExpanded: false
    property string railHeader: ""
    /// "none" | "one" | "lru" | "all" | "adaptive" | "arc"
    /// Library default: arc + L1=1 + tiny L2 (snappy, low RSS). Override only if needed.
    property string pageCacheMode: "arc"
    property int pageCacheLimit: 1
    property int pageIdleTrimMs: 4000
    property real pagePadding: Md3Theme.pagePadding
    Behavior on pagePadding {
        enabled: !Md3Theme.reduceMotion
        NumberAnimation {
            duration: Md3Motion.medium2
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Md3Motion.standard
        }
    }
    property bool pagePrefetch: false
    /// With pagePrefetch: inflate neighbor L1 Items. False = warm neighbor Components (L2) only.
    property bool pagePrefetchL1: true
    property bool pagePredictPrefetch: false
    property bool pageL2Cache: true
    property int pageL2CacheLimit: 1
    /// Idle L2 warm-all: pace-compile every destination Component (no live Item RSS).
    property bool pageL2Warm: false
    property bool pageLeaveSnapshot: false
    property bool pageAsync: false
    property bool pageWarmStart: false
    property url pageSourceBase: ""
    /// When hotReload is on and the agent finds a disk `pages/` tree, use it as sourceBase.
    property bool pageSourcePreferHotReload: true
    /// After first show: raise L1/L2 + neighbor prefetch (Gallery-style snappy shell).
    property bool pageNavWarm: false
    property int pageNavWarmDelayMs: 80
    property int pageNavWarmCacheLimit: 6
    /// -1 → max(32, destinations.length)
    property int pageNavWarmL2CacheLimit: -1
    property bool pageNavWarmPrefetch: true
    property bool _pageNavWarmDone: false
    property string pageTransition: "fade"
    property int pageTransitionDuration: Md3Motion.medium2  // 350ms — iOS push-like
    property bool pageSkeleton: false
    property alias pageHost: windowBody.pageHost
    property alias shellRail: windowBody.rail
    /// Within-page progressive sections (Md3DeferredSection). Default on.
    property bool progressiveContent: true

    /// Effective pages root for PageHost (hot-reload disk path or `pageSourceBase`).
    readonly property url resolvedPageSourceBase: {
        if (pageSourcePreferHotReload && hotReload && hotReloadAgent) {
            const d = String(hotReloadAgent.galleryPagesDir || "").trim()
            if (d.length > 0) {
                let p = d.replace(/\\/g, "/")
                if (!p.endsWith("/"))
                    p += "/"
                if (p.indexOf("file:") === 0)
                    return p
                return (p.charAt(0) === "/" ? "file://" : "file:///") + p
            }
        }
        return pageSourceBase
    }

    /// Persist geometry / theme / shell via Md3AppSettings (QSettings).
    property bool persistSession: false
    property string settingsOrganization: "QML_MD3"
    property string settingsApplication: "Md3"
    property bool _sessionRestored: false
    property bool _sessionSaveScheduled: false
    /// Coalesce geometry/theme writes so title-bar drag does not hit QSettings every move tick.
    property int sessionSaveDebounceMs: 400

    /// Dev hot-reload of QML sources (file watcher + clearComponentCache).
    property bool hotReload: false
    property alias hotReloadAgent: hotReloadInst

    /// Built-in performance overlay (title-bar speed button + floating panel).
    property bool showPerformanceButton: true
    property bool showPerformanceOverlay: false
    /// Optional: pop the panel into its own non-modal window.
    property bool performanceDetached: false
    property alias performanceMonitor: perfMonitor
    property alias performancePanel: perfPanel

    /// Persistent shell banner under the chrome (offline / sync) — not a Snackbar.
    property bool shellInfoBarOpen: false
    property string shellInfoBarTitle: ""
    property string shellInfoBarMessage: ""
    property string shellInfoBarActionText: ""
    property int shellInfoBarSeverity: 0
    signal shellInfoBarActionClicked()

    function showShellInfoBar(message, options) {
        const opts = options || {}
        shellInfoBarMessage = String(message || "")
        shellInfoBarTitle = opts.title !== undefined ? String(opts.title) : ""
        shellInfoBarActionText = opts.actionText !== undefined ? String(opts.actionText) : ""
        shellInfoBarSeverity = opts.severity !== undefined ? Number(opts.severity) : 0
        shellInfoBarOpen = true
    }

    function dismissShellInfoBar() {
        shellInfoBarOpen = false
    }

    // --- Document tabs (under title bar; drag out → Md3TabWindow) ---
    /// Show Win11-style tab strip under the title bar.
    property bool documentTabsEnabled: false
    /// Auto-handle activate / close / add / reorder / tear-off + sync with currentIndex.
    property bool documentTabsManaged: true
    /// Close this window when the last tab is closed (typical for torn-off windows).
    property bool documentTabsCloseWindowWhenEmpty: false
    property var documentTabs: []
    property int documentTabIndex: 0
    property bool documentTabsClosable: true
    /// Drag a tab outside the window to spawn a peer `Md3TabWindow`.
    property bool documentTabsTearOff: true
    property bool documentTabsShowAdd: true
    /// Paint title bar + document tabs as one chrome strip (same surfaceContainer).
    property bool unifiedTitleChrome: true
    property alias documentTabBar: docTabBar
    property bool _docTabSyncing: false
    /// Keep tear-off windows alive (createObject parent is null).
    property var _tornWindows: []

    /// App-top tool strip between tabs/titlebar and content.
    property alias toolBar: toolBarSlot.data
    property alias toolBarItem: toolBarSlot
    readonly property real toolBarHeight: toolBarSlot.visible ? toolBarSlot.height : 0

    /// App-bottom status strip (e.g. Md3StatusBar). Spans full content width.
    property alias statusBar: statusBarSlot.data
    property alias statusBarItem: statusBarSlot
    readonly property real statusBarHeight: statusBarSlot.visible ? statusBarSlot.height : 0

    signal documentTabActivated(int index)
    signal documentTabCloseRequested(int index)
    signal documentTabAddRequested()
    signal documentTabMoved(int from, int to)
    signal documentTabTearOff(int index, real globalX, real globalY)

    readonly property bool usesDestinations: destinations && destinations.length > 0
    /// Title-bar back when navigation rail + destinations shell are active.
    property bool showTitleBackButton: navigationRail && usesDestinations
    readonly property bool canGoBack: usesDestinations && windowBody.canGoBack
    readonly property int navDepth: usesDestinations ? windowBody.navDepth : 0
    readonly property var routeParams: usesDestinations ? windowBody.routeParams : ({})
    readonly property color chromeStripColor: {
        const base = Md3Theme.colorScheme.surfaceContainer
        if (usesSystemBackdrop) {
            const t = backdropTitleTint !== undefined ? backdropTitleTint : 0.06
            return Qt.alpha(base, t)
        }
        return base
    }

    property int layoutMode: Md3ContainerBody.Fit
    default property alias content: customContent.content

    function navigateTo(index, opts) {
        if (usesDestinations)
            windowBody.navigateTo(index, opts)
        else
            currentIndex = index
    }

    function pushRoute(index, params, opts) {
        if (!usesDestinations)
            return false
        return windowBody.pushRoute(index, params, opts)
    }

    function goBack(opts) {
        if (!usesDestinations)
            return false
        return windowBody.goBack(opts)
    }

    function replaceRoute(index, params, opts) {
        if (!usesDestinations)
            return false
        return windowBody.replaceRoute(index, params, opts)
    }

    function showStatusMessage(message, timeout) {
        const kids = statusBarSlot.children
        for (let i = 0; i < kids.length; ++i) {
            const c = kids[i]
            if (c && typeof c.showMessage === "function") {
                c.showMessage(message, timeout)
                return
            }
        }
    }

    function documentTabMeta(pageIndex) {
        const d = destinations && destinations[pageIndex]
        return {
            title: d && d.title !== undefined ? d.title : qsTr("Tab"),
            icon: d && d.icon !== undefined ? d.icon : "web_asset",
            pageIndex: pageIndex
        }
    }

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

    /// Drag-out: remove tab from this window and open it in a new `Md3TabWindow`.
    function tearOffTab(index, globalX, globalY) {
        if (!documentTabsTearOff)
            return
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

        const gx = globalX !== undefined ? globalX : root.x + 48
        const gy = globalY !== undefined ? globalY : root.y + 48

        const comp = Qt.createComponent(Qt.resolvedUrl("Md3TabWindow.qml"))
        function spawn() {
            const w = comp.createObject(null, {
                catalog: root.destinations,
                initialTabs: [torn],
                x: Math.max(0, gx - 96),
                y: Math.max(0, gy - 20),
                width: Math.min(960, root.width),
                height: Math.min(640, root.height),
                windowIcon: root.windowIcon,
                pageSourceBase: root.resolvedPageSourceBase,
                systemBackdrop: root.systemBackdrop,
                cornerRadius: root.cornerRadius,
                railHeader: root.railHeader,
                navigationRail: root.navigationRail,
                documentTabsCloseWindowWhenEmpty: true,
                documentTabsTearOff: true
            })
            if (!w) {
                console.warn("Md3ApplicationWindow: tear-off createObject failed")
                return
            }
            const kept = (root._tornWindows || []).slice()
            kept.push(w)
            root._tornWindows = kept
            w.closing.connect(function () {
                const next = []
                const list = root._tornWindows || []
                for (let i = 0; i < list.length; ++i) {
                    if (list[i] !== w)
                        next.push(list[i])
                }
                root._tornWindows = next
            })
        }
        if (comp.status === Component.Ready) {
            spawn()
        } else if (comp.status === Component.Error) {
            console.warn("Md3ApplicationWindow tear-off:", comp.errorString())
        } else {
            comp.statusChanged.connect(function () {
                if (comp.status === Component.Ready)
                    spawn()
                else if (comp.status === Component.Error)
                    console.warn("Md3ApplicationWindow tear-off:", comp.errorString())
            })
        }

        documentTabTearOff(index, gx, gy)
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
        _scheduleSessionSave()
    }

    onDocumentTabsEnabledChanged: {
        if (documentTabsEnabled)
            Qt.callLater(_ensureManagedTabs)
    }

    readonly property bool isMaximizedLike: visibility === Window.Maximized
                                            || visibility === Window.FullScreen
    readonly property real effectiveRadius: {
        if (!useCustomChrome || !roundedCorners || isMaximizedLike)
            return 0
        return Math.max(0, cornerRadius)
    }
    /// OS clips the window frame (Win DWM / macOS layer) — skip MultiEffect chrome FBO.
    readonly property bool usesSystemCorners: Md3WindowCapabilities.systemCorners
            && roundedCorners && useCustomChrome && !isMaximizedLike
    readonly property bool useTransparentFrame: useCustomChrome && effectiveRadius > 0
    /// Client mask FBO only when the OS cannot clip the silhouette.
    readonly property bool chromeMaskActive: effectiveRadius > 0
            && !usesSystemBackdrop && !usesSystemCorners

    // Always transparent with custom chrome so DWM materials / rounded corners can show
    color: useCustomChrome || usesSystemBackdrop
           ? "transparent" : Md3Theme.colorScheme.surface
    visible: true

    flags: {
        let f = Qt.Window
        if (root.useCustomChrome)
            f |= Qt.FramelessWindowHint
        return f
    }

    Md3WindowHelper {
        id: windowHelper
    }
    /// Access native helper (signals: thumbBarButtonClicked, trayActivated, dpiChanged).
    readonly property alias windowNative: windowHelper

    readonly property real chromeTop: chromeHost.height
    readonly property real edge: 6
    readonly property bool canResize: useCustomChrome && Md3WindowCapabilities.systemResize
                                      && !isMaximizedLike
    /// Keep QML resize grips off the title-bar caption strip (min/max/close).
    readonly property real chromeTopReserve: (showTitleBar && useCustomChrome) ? chromeHost.height : 0
    readonly property real chromeRightReserve: {
        if (!showTitleBar || !useCustomChrome)
            return 0
        const tb = titleBarLoader.item
        if (tb && tb.rightChromeWidth !== undefined)
            return Math.max(tb.rightChromeWidth + 8, edge * 2)
        return 160
    }

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
        if (!themeRevealEnabled || themeRevealBusy || Md3Theme.reduceMotion
                || chrome.width < 1 || chrome.height < 1) {
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

    function _resolvedAboutName() {
        if (aboutAppName.length > 0)
            return aboutAppName
        if (Qt.application.displayName && Qt.application.displayName.length > 0)
            return Qt.application.displayName
        if (Qt.application.name && Qt.application.name.length > 0)
            return Qt.application.name
        return root.title.length > 0 ? root.title : qsTr("Application")
    }

    function _resolvedAboutVersion() {
        if (aboutVersion.length > 0)
            return aboutVersion
        return (Qt.application.version && Qt.application.version.length > 0)
                ? Qt.application.version : ""
    }

    function _resolvedAboutOrganization() {
        if (aboutOrganization.length > 0)
            return aboutOrganization
        return (Qt.application.organization && Qt.application.organization.length > 0)
                ? Qt.application.organization : ""
    }

    /// Open modeless About dialog (also used by Md3TitleBar info button).
    function openAbout() {
        aboutDialog.openDialog(root)
    }

    /// Raise L1/L2 caches after shell paint (`pageNavWarm`).
    function applyPageNavWarm() {
        if (root._pageNavWarmDone || !root.pageNavWarm)
            return
        root._pageNavWarmDone = true
        root.pageCacheLimit = root.pageNavWarmCacheLimit
        root.pageL2CacheLimit = root.pageNavWarmL2CacheLimit >= 0
                ? root.pageNavWarmL2CacheLimit
                : Math.max(32, (root.destinations || []).length)
        root.pagePrefetch = root.pageNavWarmPrefetch
        root.pageL2Warm = true
    }

    function _schedulePageNavWarm() {
        if (!root.pageNavWarm || root._pageNavWarmDone || pageNavWarmTimer.running)
            return
        pageNavWarmTimer.start()
    }

    Timer {
        id: pageNavWarmTimer
        interval: root.pageNavWarmDelayMs
        repeat: false
        onTriggered: root.applyPageNavWarm()
    }

    /// Enqueue a snackbar on the window host. options: { actionText, dualLine, durationMs, id, priority }
    function showSnackbar(message, options) {
        return snackbarHost.show(message, options)
    }

    /// Toast. options: { severity, durationMs, position, id }
    function showToast(message, options) {
        return toastHost.show(message, options)
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
        Md3Theme.progressiveContent = root.progressiveContent
        Md3AppSettings.organization = root.settingsOrganization
        Md3AppSettings.application = root.settingsApplication
        if (Md3Adaptive)
            Md3Adaptive.safeAreaWindow = root
        if (root.persistSession)
            root.restoreSession()
        root._configureHotReload()
        root._schedulePageNavWarm()
    }

    onClosing: function (close) {
        if (root.persistSession) {
            sessionSaveTimer.stop()
            root._sessionSaveScheduled = false
            root.saveSession()
        }
    }

    onProgressiveContentChanged: Md3Theme.progressiveContent = progressiveContent
    onPersistSessionChanged: {
        if (persistSession && !_sessionRestored)
            restoreSession()
    }
    onHotReloadChanged: _configureHotReload()
    onSettingsOrganizationChanged: Md3AppSettings.organization = settingsOrganization
    onSettingsApplicationChanged: Md3AppSettings.application = settingsApplication

    onXChanged: _scheduleSessionSave()
    onYChanged: _scheduleSessionSave()
    onWidthChanged: _scheduleSessionSave()
    onHeightChanged: _scheduleSessionSave()
    onRailExpandedChanged: _scheduleSessionSave()

    Timer {
        id: sessionSaveTimer
        interval: Math.max(50, root.sessionSaveDebounceMs)
        repeat: false
        onTriggered: {
            root._sessionSaveScheduled = false
            root.saveSession()
        }
    }

    Connections {
        target: Md3Theme
        function onDarkChanged() {
            root._syncWinNative()
            root._scheduleSessionSave()
        }
        function onSeedChanged() { root._scheduleSessionSave() }
        function onReduceMotionChanged() { root._scheduleSessionSave() }
        function onHighContrastChanged() { root._scheduleSessionSave() }
        function onTextScaleChanged() { root._scheduleSessionSave() }
        function onEffectsLevelChanged() { root._scheduleSessionSave() }
        function onEffectsIntensityChanged() { root._scheduleSessionSave() }
    }

    Connections {
        target: Md3Accessibility
        function onShowFocusRingsChanged() { root._scheduleSessionSave() }
    }

    function restoreSession() {
        Md3AppSettings.organization = settingsOrganization
        Md3AppSettings.application = settingsApplication
        const gx = Number(Md3AppSettings.value("window/x", x))
        const gy = Number(Md3AppSettings.value("window/y", y))
        const gw = Number(Md3AppSettings.value("window/width", width))
        const gh = Number(Md3AppSettings.value("window/height", height))
        if (gw >= minimumWidth && gh >= minimumHeight) {
            width = gw
            height = gh
        }
        if (isFinite(gx) && isFinite(gy)) {
            x = gx
            y = gy
        }
        const dark = _settingsBool("theme/dark", Md3Theme.dark)
        const seed = Md3AppSettings.value("theme/seed", Md3Theme.seed)
        Md3Theme.dark = dark
        if (seed !== undefined && String(seed).length > 0)
            Md3Theme.applySeed(seed)
        Md3Theme.reduceMotion = _settingsBool("a11y/reduceMotion", false)
        Md3Theme.highContrast = _settingsBool("a11y/highContrast", Md3Theme.highContrast)
        Md3Theme.textScale = Number(Md3AppSettings.value("a11y/textScale", Md3Theme.textScale))
        const fx = Number(Md3AppSettings.value("perf/effectsLevel", Md3Theme.effectsLevel))
        if (isFinite(fx))
            Md3Theme.setEffectsLevel(fx)
        const fxi = Number(Md3AppSettings.value("perf/effectsIntensity", Md3Theme.effectsIntensity))
        if (isFinite(fxi))
            Md3Theme.setEffectsIntensity(fxi)
        Md3Accessibility.showFocusRings = _settingsBool("a11y/showFocusRings", root.defaultShowFocusRings)
        // One-shot: older Gallery builds could leave reduceMotion stuck ON (all motion ≈1ms).
        if (!_settingsBool("a11y/reduceMotionMigrated", false)) {
            Md3Theme.reduceMotion = false
            Md3AppSettings.setValue("a11y/reduceMotion", false)
            Md3AppSettings.setValue("a11y/reduceMotionMigrated", true)
            Md3AppSettings.sync()
        }
        if (Md3Theme.reduceMotion) {
            console.info("Md3: reduceMotion ON — decorative motion is near-instant; "
                         + "loaders/progress keep essential timing (Theme → 减弱动效)")
        }
        railExpanded = _settingsBool("shell/railExpanded", railExpanded)
        const page = Number(Md3AppSettings.value("shell/pageIndex", currentIndex))
        if (usesDestinations && page >= 0 && page < destinations.length)
            currentIndex = page
        _sessionRestored = true
    }

    function saveSession() {
        if (!persistSession)
            return
        Md3AppSettings.organization = settingsOrganization
        Md3AppSettings.application = settingsApplication
        Md3AppSettings.setValue("window/x", x)
        Md3AppSettings.setValue("window/y", y)
        Md3AppSettings.setValue("window/width", width)
        Md3AppSettings.setValue("window/height", height)
        Md3AppSettings.setValue("theme/dark", Md3Theme.dark)
        Md3AppSettings.setValue("theme/seed", String(Md3Theme.seed))
        Md3AppSettings.setValue("a11y/reduceMotion", Md3Theme.reduceMotion)
        Md3AppSettings.setValue("a11y/highContrast", Md3Theme.highContrast)
        Md3AppSettings.setValue("a11y/textScale", Md3Theme.textScale)
        Md3AppSettings.setValue("perf/effectsLevel", Md3Theme.effectsLevel)
        Md3AppSettings.setValue("perf/effectsIntensity", Md3Theme.effectsIntensity)
        Md3AppSettings.setValue("a11y/showFocusRings", Md3Accessibility.showFocusRings)
        Md3AppSettings.setValue("shell/railExpanded", railExpanded)
        Md3AppSettings.setValue("shell/pageIndex", currentIndex)
        Md3AppSettings.sync()
    }

    function _scheduleSessionSave() {
        if (!persistSession || !_sessionRestored)
            return
        _sessionSaveScheduled = true
        sessionSaveTimer.restart()
    }

    function _configureHotReload() {
        hotReloadInst.enabled = !!hotReload
        if (!hotReloadInst.enabled) {
            for (let i = 0; i < Qt.application.arguments.length; ++i) {
                const a = Qt.application.arguments[i]
                if (a === "--hot-reload" || a === "-hot-reload") {
                    hotReloadInst.enabled = true
                    break
                }
            }
        }
        hotReloadInst.rediscoverSourceTrees()
    }

    function reloadCurrentPage() {
        if (pageHost && pageHost.reloadCurrent)
            pageHost.reloadCurrent()
    }

    onShowPerformanceOverlayChanged: {
        if (!showPerformanceOverlay) {
            elementPicker.picking = false
            if (performanceDetached) {
                performanceDetached = false
                if (perfDialog.visible)
                    perfDialog.closeDialog()
            }
        } else if (performanceDetached && !perfDialog.visible) {
            perfDialog.openDialog(root)
        }
    }

    onPerformanceDetachedChanged: {
        if (performanceDetached && showPerformanceOverlay) {
            if (!perfDialog.visible)
                perfDialog.openDialog(root)
        } else if (!performanceDetached && perfDialog.visible) {
            perfDialog.closeDialog()
        }
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
        if (visible) {
            root._schedulePageNavWarm()
            Qt.callLater(function () {
                root._applyWindowIcon()
                root._syncWinNative()
            })
        }
    }
    onSystemBackdropChanged: _syncWinNative()
    onNativeBorderColorChanged: _syncWinNative()
    onSyncImmersiveDarkModeChanged: _syncWinNative()

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

    /// UNSUITABLE FOR PRODUCTION — API retained; Gallery no longer exposes it.
    function setSystemBackdropMode(mode) {
        systemBackdrop = mode
        if (Md3WindowCapabilities.isLinux && mode > 0) {
            backdropTint = 0.12
            backdropContentTint = 0.28
            backdropTitleTint = 0.08
        } else if (Md3WindowCapabilities.isWindows && mode > 0) {
            backdropTint = 0.08
            backdropContentTint = 0.18
            backdropTitleTint = 0.06
        }
        _syncWinNative()
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

    function cursorScreenPos() {
        return windowHelper.cursorScreenPos()
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

    function openUrl(url) {
        return windowHelper.openUrl(url)
    }

    function revealInFolder(pathOrUrl) {
        return windowHelper.revealInFolder(pathOrUrl)
    }

    function beep() {
        windowHelper.beep()
    }

    function centerOnScreen() {
        return windowHelper.centerOnScreen(root)
    }

    function setWindowOpacity(opacity) {
        return windowHelper.setWindowOpacity(root, opacity)
    }

    function setVisibleInTaskbar(visible) {
        return windowHelper.setVisibleInTaskbar(root, !!visible)
    }

    function minimizeWindow() {
        windowHelper.minimizeWindow(root)
    }

    function maximizeWindow() {
        windowHelper.maximizeWindow(root)
    }

    function restoreWindow() {
        windowHelper.restoreWindow(root)
    }

    function setFullScreen(fullScreen) {
        windowHelper.setFullScreen(root, !!fullScreen)
    }

    function systemColorSchemeDark() {
        return windowHelper.systemColorSchemeDark()
    }

    function shareText(text, title) {
        return windowHelper.shareText(text || "", title || "")
    }

    function vibrate(durationMs) {
        return windowHelper.vibrate(durationMs === undefined ? 40 : durationMs)
    }

    function setImmersiveSystemUi(immersive) {
        return windowHelper.setImmersiveSystemUi(!!immersive)
    }

    function requestAttention(on) {
        windowHelper.requestAttention(root, on === undefined ? true : !!on)
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

    // --- Electron-parity host (Md3NativeShell) ---
    function requestSingleInstanceLock(id) {
        return Md3NativeShell.requestSingleInstanceLock(id || "")
    }
    function setOpenAtLoginEnabled(enabled, openAsHidden) {
        return Md3NativeShell.setOpenAtLoginEnabled(!!enabled, !!openAsHidden)
    }
    function registerGlobalShortcut(id, accelerator) {
        return Md3NativeShell.registerGlobalShortcut(id, accelerator)
    }
    function unregisterGlobalShortcut(id) {
        return Md3NativeShell.unregisterGlobalShortcut(id)
    }
    function setAsDefaultProtocolClient(scheme, path, args) {
        return Md3NativeShell.setAsDefaultProtocolClient(scheme || "", path || "", args || [])
    }
    function removeAsDefaultProtocolClient(scheme) {
        return Md3NativeShell.removeAsDefaultProtocolClient(scheme || "")
    }
    function getPath(name) {
        return Md3NativeShell.getPath(name || "")
    }

    // --- Android extras ---
    function setSystemBarColors(statusCss, navCss, lightIcons) {
        return windowHelper.setSystemBarColors(statusCss || "", navCss || "", !!lightIcons)
    }
    function setScreenOrientation(mode) {
        return windowHelper.setScreenOrientation(mode || "unspecified")
    }
    function showSoftInput() { return windowHelper.showSoftInput() }
    function hideSoftInput() { return windowHelper.hideSoftInput() }
    function setSoftInputAdjustResize(enable) {
        return windowHelper.setSoftInputAdjustResize(!!enable)
    }
    function openAppSettings() { return windowHelper.openAppSettings() }
    function nativeToast(message, durationMs) {
        return windowHelper.nativeToast(message || "", durationMs === undefined ? 2000 : durationMs)
    }
    function hapticFeedback(kind) {
        return windowHelper.hapticFeedback(kind === undefined ? 0 : kind)
    }
    function requestIgnoreBatteryOptimizations() {
        return windowHelper.requestIgnoreBatteryOptimizations()
    }
    function shareFile(fileUrl, mimeType, titleText) {
        return windowHelper.shareFile(fileUrl, mimeType || "", titleText || "")
    }
    function copyToClipboard(text) {
        return windowHelper.copyToClipboard(text || "")
    }
    function clipboardText() {
        return windowHelper.clipboardText()
    }
    function openNotificationSettings() {
        return windowHelper.openNotificationSettings()
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

            // MultiEffect offscreen FBO is opaque to DWM — never enable under backdrop
            // or when the OS already clips corners (Win DWM / macOS layer).
            layer.enabled: root.chromeMaskActive
            layer.smooth: true
            layer.effect: MultiEffect {
                maskEnabled: true
                maskSource: chromeMask
            }

            Rectangle {
                id: fill
                anchors.fill: parent
                radius: (root.usesSystemBackdrop || root.usesSystemCorners) ? 0 : root.effectiveRadius
                color: root.usesSystemBackdrop
                       ? Qt.alpha(Md3Theme.colorScheme.surface, root.backdropTint)
                       : (root.useCustomChrome ? Qt.alpha(Md3Theme.colorScheme.surface, 0.98)
                                            : Md3Theme.colorScheme.surface)
                // Full-window wash stacks with PageHost — keep it off unless tint > 0.
                visible: !root.usesSystemBackdrop || root.backdropTint > 0.001
            }

            // Visible edge along the rounded boundary (skip under backdrop — DWM draws frame)
            Rectangle {
                anchors.fill: parent
                radius: root.usesSystemCorners ? 0 : root.effectiveRadius
                color: "transparent"
                border.width: root.showWindowBorder && root.effectiveRadius > 0 && !root.usesSystemBackdrop && !root.usesSystemCorners ? 1 : 0
                border.color: Md3Theme.colorScheme.outlineVariant
                z: 50
            }

            Item {
                id: chromeHost
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: (titleBarLoader.active ? titleBarLoader.height : 0)
                        + (docTabBar.visible ? docTabBar.height : 0)
                z: 100

                Rectangle {
                    anchors.fill: parent
                    visible: root.unifiedTitleChrome
                    color: root.chromeStripColor
                    topLeftRadius: root.effectiveRadius
                    topRightRadius: root.effectiveRadius
                }

                Loader {
                    id: titleBarLoader
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    active: root.showTitleBar && root.useCustomChrome
                    height: active && item ? item.height : 0
                    sourceComponent: root.titleBar !== null ? root.titleBar : defaultTitleBar
                    onLoaded: {
                        if (!item)
                            return
                        if (item.targetWindow !== undefined)
                            item.targetWindow = root
                        if (item.windowHelper !== undefined)
                            item.windowHelper = root.windowNative
                        if (item.cornerRadius !== undefined)
                            item.cornerRadius = Qt.binding(function () { return root.effectiveRadius })
                        if (item.compact !== undefined)
                            item.compact = Qt.binding(function () { return root.preferCompactTitleBar })
                        if (item.showCaptionButtons !== undefined)
                            item.showCaptionButtons = Qt.binding(function () { return root.preferCaptionButtons })
                        if (item.title !== undefined && root.title.length > 0
                                && (!item.title || item.title.length === 0))
                            item.title = root.title
                        if (item.appIcon !== undefined && root.windowIcon.toString().length > 0)
                            item.appIcon = Qt.binding(function () { return root.windowIcon })
                        if (item.performanceChecked !== undefined && item.showPerformanceToggle)
                            item.performanceChecked = Qt.binding(function () {
                                return root.showPerformanceOverlay
                            })
                        if (item.unifiedChrome !== undefined)
                            item.unifiedChrome = Qt.binding(function () {
                                return root.unifiedTitleChrome
                            })
                        if (item.showBackButton !== undefined)
                            item.showBackButton = Qt.binding(function () {
                                return root.showTitleBackButton
                            })
                        if (item.backEnabled !== undefined)
                            item.backEnabled = Qt.binding(function () {
                                return root.canGoBack
                            })
                    }
                }

                Connections {
                    target: titleBarLoader.item
                    enabled: titleBarLoader.item !== null
                    function onBackClicked() { root.goBack() }
                }

                Component {
                    id: defaultTitleBar
                    Md3TitleBar {
                        title: root.title
                        appIcon: root.windowIcon
                        showAppIcon: true
                        showPin: root.showPinButton
                        pinned: root.pinned
                        showPerformanceToggle: root.showPerformanceButton
                        performanceChecked: root.showPerformanceOverlay
                        showAboutButton: root.showAboutButton
                        aboutAppName: root.aboutAppName
                        aboutVersion: root.aboutVersion
                        aboutOrganization: root.aboutOrganization
                        aboutText: root.aboutText
                        aboutIcon: root.aboutIcon
                        aboutContent: root.aboutContent
                        targetWindow: root
                        windowHelper: root.windowNative
                        cornerRadius: root.effectiveRadius
                        compact: root.preferCompactTitleBar
                        showCaptionButtons: root.preferCaptionButtons
                        preferredHeight: 28
                        barHeight: compact ? compactHeight : 28
                        unifiedChrome: root.unifiedTitleChrome
                        showBackButton: root.showTitleBackButton
                        backEnabled: root.canGoBack
                        leadingInset: root.windowNative.trafficLightsInset > 0
                                      ? root.windowNative.trafficLightsInset
                                      : Md3WindowCapabilities.trafficLightsInset
                        onPinToggled: function (onTop) { root.pinned = onTop }
                        onPerformanceClicked: root.showPerformanceOverlay = !root.showPerformanceOverlay
                    }
                }

                Md3DocumentTabBar {
                    id: docTabBar
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: titleBarLoader.bottom
                    visible: root.documentTabsEnabled
                    height: visible ? implicitHeight : 0
                    unifiedWithTitleBar: root.unifiedTitleChrome
                    hostWindow: root
                    model: root.documentTabs
                    currentIndex: root.documentTabIndex
                    closable: root.documentTabsClosable
                    tearOffEnabled: root.documentTabsTearOff
                    showAddButton: root.documentTabsShowAdd
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
                        else
                            root.documentTabTearOff(index, gx, gy)
                    }
                }
            }

            Item {
                id: contentHost
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: chromeHost.bottom
                anchors.bottom: parent.bottom
                clip: true
                z: 0
                focus: true

                Column {
                    id: toolBarSlot
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    width: parent.width
                    z: 3
                    visible: height > 0
                }

                Md3InfoBar {
                    id: shellInfoBar
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: toolBarSlot.bottom
                    anchors.leftMargin: root.pagePadding
                    anchors.rightMargin: root.pagePadding
                    anchors.topMargin: open ? 8 : 0
                    z: 4
                    open: root.shellInfoBarOpen
                    title: root.shellInfoBarTitle
                    message: root.shellInfoBarMessage
                    actionText: root.shellInfoBarActionText
                    severity: root.shellInfoBarSeverity
                    height: open ? implicitHeight : 0
                    opacity: open ? 1 : 0
                    Behavior on height {
                        enabled: !Md3Theme.reduceMotion
                        NumberAnimation {
                            duration: Md3Motion.spatialDuration
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: Md3Motion.emphasized
                        }
                    }
                    onClosed: root.shellInfoBarOpen = false
                    onActionClicked: root.shellInfoBarActionClicked()
                }

                Keys.onBackPressed: function (event) {
                    if (root.canGoBack) {
                        root.goBack()
                        event.accepted = true
                    }
                }
                Keys.onPressed: function (event) {
                    if (event.key === Qt.Key_Escape && root.canGoBack) {
                        root.goBack()
                        event.accepted = true
                    }
                }

                Md3WindowBody {
                    id: windowBody
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: shellInfoBar.bottom
                    anchors.bottom: statusBarSlot.top
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
                    sourceBase: root.resolvedPageSourceBase
                    asynchronous: root.pageAsync
                    prefetchNeighbors: root.pagePrefetch
                    prefetchNeighborsL1: root.pagePrefetchL1
                    predictPrefetch: root.pagePredictPrefetch
                    l2Components: root.pageL2Cache
                    l2CacheLimit: root.pageL2CacheLimit
                    l2WarmIdle: root.pageL2Warm
                    leaveSnapshot: root.pageLeaveSnapshot
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

                Md3ContainerBody {
                    id: customContent
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: toolBarSlot.bottom
                    anchors.bottom: statusBarSlot.top
                    visible: !root.usesDestinations
                    enabled: visible
                    layoutMode: root.layoutMode
                }

                Column {
                    id: statusBarSlot
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    width: parent.width
                    z: 3
                    visible: height > 0
                }
            }

            Item {
                id: overlayHost
                anchors.fill: parent
                z: 1000
            }

            Md3SnackbarHost {
                id: snackbarHost
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                dodgeBottom: root.statusBarHeight
                             + (perfDockHost.wantVisible ? (perfPanel.height + 28) : 0)
                z: 1200
            }

            Md3ToastHost {
                id: toastHost
                anchors.fill: parent
                dodgeBottom: root.statusBarHeight
                             + (perfDockHost.wantVisible ? (perfPanel.height + 28) : 0)
                z: 1300
            }

            Connections {
                target: snackbarHost
                function onActionTriggered(snackId, actionText) {
                    if (String(snackId) === "undo-delete")
                        root.showToast(qsTr("Restored"), { severity: Md3Toast.Success })
                }
            }

            Connections {
                target: root
                function onShellInfoBarActionClicked() {
                    root.dismissShellInfoBar()
                }
            }

            // Screen-reader live region for Md3Accessibility.announce*()
            Text {
                id: a11yLiveRegion
                width: 1
                height: 1
                opacity: 0
                Accessible.role: Accessible.StaticText
                Accessible.name: Md3Accessibility.liveMessage
                Accessible.ignored: Md3Accessibility.liveMessage.length === 0
                // Force ATT re-read when serial bumps (esp. assertive errors).
                property int _bump: Md3Accessibility.liveSerial
            }

            Md3HotReload {
                id: hotReloadInst
                onReloadRequested: function (path) {
                    hotReloadInst.clearComponentCache(root)
                    root.reloadCurrentPage()
                }
            }

            Md3PerformanceMonitor {
                id: perfMonitor
                active: root.showPerformanceOverlay
                         && root.visible
                         && root.visibility !== Window.Minimized
                         && root.visibility !== Window.Hidden
                historySize: 24
                sampleIntervalMs: 1000
                Component.onCompleted: bindWindow(root)
            }

            // Docked floating panel (animated pop-in)
            Item {
                id: perfDockHost
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.rightMargin: 16
                anchors.bottomMargin: 8 + root.statusBarHeight
                width: perfPanel.width
                height: perfPanel.height
                z: 100000
                visible: opacity > 0.01
                opacity: 0
                scale: 0.92
                transformOrigin: Item.BottomRight

                readonly property bool wantVisible: root.showPerformanceOverlay && !root.performanceDetached

                states: State {
                    name: "shown"
                    when: perfDockHost.wantVisible
                    PropertyChanges {
                        target: perfDockHost
                        opacity: 1
                        scale: 1
                        anchors.bottomMargin: 16 + root.statusBarHeight
                    }
                }
                transitions: [
                    Transition {
                        from: ""
                        to: "shown"
                        NumberAnimation {
                            properties: "opacity,scale,anchors.bottomMargin"
                            duration: Md3Motion.medium2
                            easing.bezierCurve: Md3Motion.emphasizedDecelerate
                        }
                    },
                    Transition {
                        from: "shown"
                        to: ""
                        NumberAnimation {
                            properties: "opacity,scale,anchors.bottomMargin"
                            duration: Md3Motion.short4
                            easing.bezierCurve: Md3Motion.emphasizedAccelerate
                        }
                    }
                ]

                Md3PerformancePanel {
                    id: perfPanel
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    compact: true
                    expanded: true
                    detached: false
                    monitor: perfMonitor
                    picking: elementPicker.picking
                    selectedInfo: elementPicker.selectedInfo
                    onPickToggleRequested: elementPicker.picking = !elementPicker.picking
                    onDetachRequested: {
                        root.performanceDetached = true
                        if (!perfDialog.visible)
                            perfDialog.openDialog(root)
                    }
                }
            }

            // Optional independent non-modal window
            Md3DialogWindow {
                id: aboutDialog
                title: qsTr("关于")
                width: 420
                height: 320
                minimumWidth: 320
                minimumHeight: 240
                dialogModality: Qt.NonModal
                showStandardButtons: true
                showDismiss: false
                confirmText: qsTr("关闭")
                showThemeToggle: false
                showMinimizeButton: false
                showMaximizeButton: false
                showPinButton: true
                owner: root
                windowIcon: root.aboutIcon.toString().length > 0 ? root.aboutIcon : root.windowIcon
                onConfirmed: aboutDialog.closeDialog()

                Column {
                    anchors.fill: parent
                    spacing: 14

                    Row {
                        spacing: 14
                        width: parent.width

                        Item {
                            width: 56
                            height: 56
                            visible: (root.aboutIcon.toString().length > 0
                                      || root.windowIcon.toString().length > 0)
                            Image {
                                anchors.fill: parent
                                source: root.aboutIcon.toString().length > 0
                                        ? root.aboutIcon : root.windowIcon
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                mipmap: true
                            }
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 4
                            width: parent.width - ((root.aboutIcon.toString().length > 0
                                                   || root.windowIcon.toString().length > 0) ? 70 : 0)

                            Text {
                                width: parent.width
                                text: root._resolvedAboutName()
                                color: Md3Theme.colorScheme.colorOnSurface
                                font.family: Md3Theme.typography.fontFamily
                                font.pixelSize: Md3Theme.typography.titleMedium.size
                                font.weight: Font.Medium
                                wrapMode: Text.Wrap
                            }
                            Text {
                                visible: root._resolvedAboutVersion().length > 0
                                text: qsTr("版本 %1").arg(root._resolvedAboutVersion())
                                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                                font.family: Md3Theme.typography.fontFamily
                                font.pixelSize: Md3Theme.typography.bodyMedium.size
                            }
                            Text {
                                visible: root._resolvedAboutOrganization().length > 0
                                text: root._resolvedAboutOrganization()
                                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                                font.family: Md3Theme.typography.fontFamily
                                font.pixelSize: Md3Theme.typography.bodySmall.size
                            }
                        }
                    }

                    Md3Divider {
                        width: parent.width
                    }

                    Loader {
                        width: parent.width
                        active: root.aboutContent !== null
                        sourceComponent: root.aboutContent
                    }

                    Text {
                        visible: root.aboutContent === null
                        width: parent.width
                        wrapMode: Text.Wrap
                        text: root.aboutText.length > 0
                              ? root.aboutText
                              : qsTr("基于 Md3（Material Design 3）组件库构建。")
                        color: Md3Theme.colorScheme.colorOnSurfaceVariant
                        font.family: Md3Theme.typography.fontFamily
                        font.pixelSize: Md3Theme.typography.bodyMedium.size
                    }
                }
            }

            Md3DialogWindow {
                id: perfDialog
                title: qsTr("Performance")
                width: 360
                height: 520
                minimumWidth: 300
                minimumHeight: 280
                dialogModality: Qt.NonModal
                showStandardButtons: false
                showThemeToggle: false
                showMinimizeButton: true
                showMaximizeButton: false
                owner: root
                windowIcon: root.windowIcon

                onClosed: {
                    if (root.performanceDetached)
                        root.performanceDetached = false
                }

                Md3PerformancePanel {
                    id: perfDialogPanel
                    anchors.fill: parent
                    anchors.margins: 8
                    fillHeight: true
                    compact: false
                    expanded: true
                    detached: true
                    monitor: perfMonitor
                    picking: elementPicker.picking
                    selectedInfo: elementPicker.selectedInfo
                    opacity: 0
                    scale: 0.94
                    transformOrigin: Item.Center

                    Connections {
                        target: perfDialog
                        function onOpened() {
                            perfDialogPanel.opacity = 1
                            perfDialogPanel.scale = 1
                        }
                        function onClosed() {
                            perfDialogPanel.opacity = 0
                            perfDialogPanel.scale = 0.94
                        }
                    }
                    Behavior on opacity {
                        NumberAnimation {
                            duration: Md3Motion.medium2
                            easing.bezierCurve: Md3Motion.emphasizedDecelerate
                        }
                    }
                    Behavior on scale {
                        NumberAnimation {
                            duration: Md3Motion.medium2
                            easing.bezierCurve: Md3Motion.emphasizedDecelerate
                        }
                    }

                    onPickToggleRequested: {
                        root.raise()
                        root.requestActivate()
                        elementPicker.picking = !elementPicker.picking
                    }
                    onDockRequested: {
                        root.performanceDetached = false
                        if (perfDialog.visible)
                            perfDialog.closeDialog()
                    }
                }
            }

            Md3ElementPicker {
                id: elementPicker
                anchors.fill: parent
                z: 100001
                // Only search page/content tree — never the picker / dock chrome themselves.
                pickRoot: contentHost
                excludeItem: null
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
                layer.enabled: themeRevealLayer.visible || root.themeRevealBusy
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
            // Independent of chrome.layer.enabled — avoids MultiEffect t2 “no texture provider”
            // while the mask FBO is still coming up in the same frame as the chrome layer.
            layer.enabled: root.chromeMaskActive
            layer.smooth: true
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
        anchors.topMargin: root.chromeTopReserve
        anchors.bottom: parent.bottom
        width: root.edge
        edges: Qt.LeftEdge
        cursorShape: Qt.SizeHorCursor
    }
    ResizeEdge {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: root.chromeTopReserve
        anchors.bottom: parent.bottom
        width: root.edge
        edges: Qt.RightEdge
        cursorShape: Qt.SizeHorCursor
    }
    ResizeEdge {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: root.chromeRightReserve
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
        // With a custom title bar, the OS/QML caption strip owns the top-right;
        // keep the diagonal grip below chrome so close/maximize stay clickable.
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: root.chromeTopReserve > 0 ? Math.max(0, root.chromeTopReserve - root.edge) : 0
        width: root.edge * 2
        height: root.edge * 2
        enabled: root.canResize && root.chromeTopReserve === 0
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
