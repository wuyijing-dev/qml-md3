import QtQuick
import QtQuick.Window
import Md3

Md3ApplicationWindow {
    id: window
    width: 1180
    height: 760
    title: qsTr("Md3 图库")
    // windowIcon defaults to Md3AppIcons.window (bundled in the Md3 module)
    roundedCorners: true
    cornerRadius: Md3WindowCapabilities.windowCornerRadius
    syncImmersiveDarkMode: true
    // Backdrop (Mica/Acrylic) marked unsuitable — keep disabled.
    systemBackdrop: 0
    nativeBorderColor: ""

    pageSourceBase: Qt.resolvedUrl("./")
    navigationRail: true
    railExpanded: false
    railHeader: qsTr("组件图库")
    pagePadding: 20
    pageSkeleton: true
    // Perf: keep library low-RSS defaults (arc, L1=1). For instant revisits see docs/performance.md
    // pageCacheLimit: 6; pagePrefetch: true; pageTransition: "none"
    persistSession: true
    settingsOrganization: "QML_MD3"
    settingsApplication: "Gallery"
    // Hot-reload clears QML caches and slows cold open — enable only while iterating QML.
    hotReload: false

    // Document tabs under the title bar (no browserChrome / no tear-off window)
    documentTabsEnabled: true
    documentTabsTearOff: false

    // Library performance overlay — title-bar speed button; off by default (saves sampling RSS)
    showPerformanceButton: true
    showPerformanceOverlay: false
    showAboutButton: true
    aboutVersion: "1.0.0"
    aboutOrganization: "Md3"
    aboutText: qsTr("Material Design 3 组件图库 — 演示窗口、导航与控件。")
    aboutIcon: windowIcon

    property int galleryTableSelection: 0
    property bool galleryTableLoading: false
    property string galleryTreeSelection: ""

    toolBar: Rectangle {
        height: 44
        color: Md3Theme.colorScheme.surfaceContainerLow

        Md3Divider {
            anchors.bottom: parent.bottom
            width: parent.width
        }

        Row {
            anchors.fill: parent
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            spacing: 8

            Md3Button {
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Back")
                variant: Md3Button.Text
                enabled: window.canGoBack
                onClicked: window.goBack()
            }
            Md3Button {
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Reload")
                variant: Md3Button.Text
                onClicked: window.reloadCurrentPage()
            }
            Md3TextField {
                anchors.verticalCenter: parent.verticalCenter
                width: 320
                label: qsTr("Quick path")
                placeholderText: qsTr("Jump to desktop patterns")
                onAccepted: {
                    const t = text.trim().toLowerCase()
                    if (t.indexOf("desktop") >= 0)
                        window.openTab(12, false)
                }
            }
        }
    }

    statusBar: Md3StatusBar {
        id: appStatusBar
        text: {
            const d = window.destinations && window.destinations[window.currentIndex]
            return d && d.title ? qsTr("Page: %1").arg(d.title) : qsTr("Ready")
        }
        centerText: window.galleryTableLoading
                      ? qsTr("Loading table…")
                      : (window.galleryTableSelection > 0
                         ? qsTr("%1 selected in table").arg(window.galleryTableSelection) : "")
        leadingIcon: window.galleryTableLoading ? "hourglass_empty" : "info"
        progress: -1
        Text {
            visible: window.galleryTreeSelection.length > 0
            text: window.galleryTreeSelection
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.labelSmall.size
        }
        Text {
            text: "UTF-8"
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.labelSmall.size
        }
    }

    // Dev: optional Md3HotReload gallery/pages path; else disk next to Main, else qrc.
    property string pageRoot: {
        if (hotReload && hotReloadAgent
                && hotReloadAgent.galleryPagesDir
                && String(hotReloadAgent.galleryPagesDir).length > 0) {
            let p = String(hotReloadAgent.galleryPagesDir).replace(/\\/g, "/")
            if (!p.endsWith("/"))
                p += "/"
            if (p.indexOf("file:") === 0)
                return p
            return (p.charAt(0) === "/" ? "file://" : "file:///") + p
        }
        const local = String(Qt.resolvedUrl("./pages/"))
        if (local.indexOf("qrc:") === 0)
            return "qrc:/qt/qml/Gallery/pages/"
        return local
    }
    property int windowPageIndex: 22

    overlay: [
        Md3Tour {
            id: galleryTour
            anchors.fill: parent
            steps: [
                {
                    target: window.shellRail,
                    title: qsTr("导航栏"),
                    body: qsTr("在左侧切换组件页面；底部固定了设置与窗口入口。"),
                    placement: "right"
                },
                {
                    target: window.titleBarItem,
                    title: qsTr("标题栏"),
                    body: qsTr("可切换明暗主题、打开性能面板；Ctrl+K 打开命令面板。"),
                    placement: "bottom"
                },
                {
                    target: window.pageHost,
                    title: qsTr("内容区"),
                    body: qsTr("页面按需加载；开启骨架屏时可看到目标页轮廓。保存窗口位置与主题到本地配置。"),
                    placement: "top"
                }
            ]
            onFinished: Md3AppSettings.setValue("tour/completed", true)
            onSkipped: Md3AppSettings.setValue("tour/completed", true)
        },
        Md3CommandPalette {
            id: commandPalette
            anchors.fill: parent
            placeholder: qsTr("跳转到页面、Tour、主题…")
            model: window._commandItems
            onActivated: function (item) {
                if (!item || !item.action)
                    return
                item.action()
            }
        }
    ]

    Shortcut {
        sequence: "Ctrl+K"
        context: Qt.ApplicationShortcut
        onActivated: commandPalette.open = !commandPalette.open
    }

    readonly property var _commandItems: {
        const items = []
        const dest = destinations || []
        for (let i = 0; i < dest.length; ++i) {
            const d = dest[i]
            const idx = i
            items.push({
                title: d.title,
                subtitle: qsTr("打开页面"),
                icon: d.icon || "chevron_right",
                action: function () { window.openTab(idx, false) }
            })
        }
        items.push({
            title: qsTr("开始引导 Tour"),
            subtitle: qsTr("重放产品引导"),
            icon: "tour",
            action: function () { window.startTour() }
        })
        items.push({
            title: qsTr("切换明暗主题"),
            subtitle: qsTr("带圆形揭示"),
            icon: "contrast",
            action: function () { window.toggleThemeFrom(window.titleBarItem) }
        })
        items.push({
            title: qsTr("性能面板"),
            subtitle: window.showPerformanceOverlay ? qsTr("隐藏") : qsTr("显示"),
            icon: "speed",
            action: function () { window.showPerformanceOverlay = !window.showPerformanceOverlay }
        })
        items.push({
            title: qsTr("显示 Snackbar"),
            subtitle: qsTr("测试通知队列"),
            icon: "notifications",
            action: function () {
                window.showSnackbar(qsTr("来自命令面板"), { actionText: qsTr("好的") })
            }
        })
        return items
    }

    function startTour() {
        galleryTour.start(0)
    }

    Component.onCompleted: {
        Md3AppSettings.organization = settingsOrganization
        Md3AppSettings.application = settingsApplication
        // Session restore can leave a11y/reduceMotion=true, which collapses every
        // Md3Motion token to ~1ms (ripples/switch/page transitions look instant).
        Qt.callLater(function () {
            if (Md3Theme.reduceMotion) {
                console.warn("Md3 Gallery: clearing stuck reduceMotion (was collapsing all motion to ~1ms)")
                Md3Theme.reduceMotion = false
            }
            Md3AppSettings.setValue("a11y/reduceMotion", false)
            Md3AppSettings.sync()
        })
        if (!Md3AppSettings.value("tour/completed", false))
            Qt.callLater(function () { window.startTour() })
    }

    destinations: [
        { title: qsTr("令牌"), icon: "palette", source: pageRoot + "TokensPage.qml",
          skeletonLayout: "page" },
        { title: qsTr("按钮"), icon: "smart_button", source: pageRoot + "ButtonsPage.qml",
          skeletonBones: [
              { variant: "text", width: 0.35, height: 22 },
              { variant: "rounded", width: 1, height: 48 },
              { variant: "rounded", width: 0.55, height: 40 },
              { variant: "rounded", width: 0.4, height: 40 },
              { variant: "rounded", width: 0.7, height: 56 }
          ] },
        { title: qsTr("FAB"), icon: "add_circle", source: pageRoot + "FabPage.qml",
          skeletonBones: [
              { variant: "text", width: 0.3, height: 20 },
              { variant: "circular", width: 56, height: 56 },
              { variant: "rounded", width: 0.45, height: 56 }
          ] },
        { title: qsTr("选择"), icon: "check_box", source: pageRoot + "SelectionPage.qml",
          skeletonLayout: "list" },
        { title: qsTr("文本框"), icon: "edit", source: pageRoot + "TextFieldsPage.qml",
          skeletonBones: [
              { variant: "text", width: 0.28, height: 20 },
              { variant: "rounded", width: 0.7, height: 56 },
              { variant: "rounded", width: 0.7, height: 56 },
              { variant: "rounded", width: 0.7, height: 56 }
          ] },
        { title: qsTr("芯片"), icon: "label", source: pageRoot + "ChipsPage.qml",
          skeletonBones: [
              { variant: "text", width: 0.25, height: 18 },
              { variant: "rounded", width: 0.22, height: 32 },
              { variant: "rounded", width: 0.28, height: 32 },
              { variant: "rounded", width: 0.2, height: 32 }
          ] },
        { title: qsTr("容器"), icon: "dashboard", source: pageRoot + "ContainmentPage.qml",
          skeletonLayout: "cards" },
        { title: qsTr("液态玻璃"), icon: "water_drop", source: pageRoot + "LiquidGlassFusionPage.qml",
          skeletonLayout: "page" },
        { title: qsTr("反馈"), icon: "chat", source: pageRoot + "CommunicationPage.qml",
          skeletonLayout: "page" },
        { title: qsTr("导航"), icon: "menu", source: pageRoot + "NavigationPage.qml",
          skeletonLayout: "list" },
        { title: qsTr("菜单"), icon: "more_vert", source: pageRoot + "MenusPage.qml",
          skeletonLayout: "list" },
        { title: qsTr("选择器"), icon: "calendar_month", source: pageRoot + "PickersPage.qml",
          skeletonBones: [
              { variant: "text", width: 0.3, height: 20 },
              { variant: "rounded", width: 0.55, height: 280 }
          ] },
        { title: qsTr("搜索"), icon: "search", source: pageRoot + "SearchPage.qml",
          skeletonBones: [
              { variant: "rounded", width: 1, height: 56 },
              { variant: "text", width: 0.8, height: 14 },
              { variant: "text", width: 0.65, height: 14 },
              { variant: "text", width: 0.7, height: 14 }
          ] },
        { title: qsTr("桌面模式"), icon: "folder_managed", source: pageRoot + "DesktopPatternsPage.qml",
          skeletonLayout: "page" },
        { title: qsTr("扩展"), icon: "extension", source: pageRoot + "ExtrasPage.qml",
          skeletonLayout: "page" },
        { title: qsTr("动效"), icon: "animation", source: pageRoot + "MotionPage.qml",
          skeletonLayout: "cards" },
        { title: qsTr("主题"), icon: "contrast", source: pageRoot + "ThemePage.qml",
          skeletonLayout: "page" },
        { title: qsTr("图表"), icon: "show_chart", source: pageRoot + "ChartsPage.qml", cacheCost: 3,
          skeletonBones: [
              { variant: "text", width: 0.3, height: 22 },
              { variant: "rounded", width: 1, height: 200 },
              { variant: "rounded", width: 1, height: 160 }
          ] },
        { title: qsTr("场景：登录"), icon: "login", source: pageRoot + "scenes/LoginScene.qml", cacheCost: 2.5,
          skeletonBones: [
              { variant: "circular", width: 64, height: 64 },
              { variant: "rounded", width: 0.7, height: 56 },
              { variant: "rounded", width: 0.7, height: 56 },
              { variant: "rounded", width: 0.45, height: 48 }
          ] },
        { title: qsTr("场景：列表详情"), icon: "view_sidebar", source: pageRoot + "scenes/ListDetailScene.qml", cacheCost: 2.5,
          skeletonLayout: "list" },
        { title: qsTr("场景：列表打开"), icon: "list_alt", source: pageRoot + "scenes/LaunchListScene.qml", cacheCost: 2.5,
          skeletonLayout: "list" },
        { title: qsTr("场景：列表详情页"), icon: "description", source: pageRoot + "scenes/LaunchDetailScene.qml", cacheCost: 2.5,
          skeletonLayout: "page" },
        // Pinned to rail footer
        { title: qsTr("场景：设置"), icon: "settings", source: pageRoot + "scenes/SettingsScene.qml", cacheCost: 2.5, pin: "bottom",
          skeletonLayout: "list" },
        { title: qsTr("窗口"), icon: "web_asset", source: pageRoot + "WindowPage.qml", pin: "bottom",
          skeletonLayout: "page" }
    ]

    titleBar: Component {
        Md3TitleBar {
            title: window.title
            appIcon: window.windowIcon
            showAppIcon: true
            preferredHeight: 28
            barHeight: 28
            responsiveMode: 0
            collapseWidth: 960
            minTitleWidth: 100
            maxTitleWidth: 200
            showThemeToggle: true
            showTourButton: true
            showAboutButton: window.showAboutButton
            showPerformanceToggle: window.showPerformanceButton
            performanceChecked: window.showPerformanceOverlay
            onPerformanceClicked: window.showPerformanceOverlay = !window.showPerformanceOverlay
            onTourClicked: window.startTour()

            Md3ChipGroup {
                selectionMode: Md3ChipGroup.Single
                currentIndex: 0
                chipHeight: 22
                iconSize: 14
                fontSize: 11
                spacing: 4
                model: [
                    { text: "Docs", icon: "description" },
                    { text: "API", icon: "code" },
                    { text: "Samples", icon: "science" }
                ]
            }
            Md3ButtonGroup {
                layout: Md3ButtonGroup.Connected
                variant: Md3ButtonGroup.Outlined
                currentIndex: 0
                buttonHeight: 22
                iconSize: 14
                fontSize: 11
                model: [
                    { text: "Light", icon: "light_mode" },
                    { text: "Dark", icon: "dark_mode" }
                ]
                onClicked: function (index) {
                    if ((index === 1) !== Md3Theme.dark)
                        window.toggleThemeFrom(this)
                }
            }
        }
    }
}
