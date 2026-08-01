import QtQuick
import QtQuick.Window
import Md3

Md3ApplicationWindow {
    id: window
    width: 1180
    height: 760
    title: qsTr("Md3 图库")
    roundedCorners: true
    cornerRadius: Md3WindowCapabilities.windowCornerRadius
    syncImmersiveDarkMode: true
    systemBackdrop: 0
    nativeBorderColor: ""

    // Relative destination sources resolve against this (hot-reload overrides via library).
    pageSourceBase: Qt.resolvedUrl("./pages/")
    navigationRail: true
    railExpanded: false
    railHeader: qsTr("组件图库")
    pagePadding: Md3Theme.pagePadding
    // Seamless open + restrained L1: L2 warm for revisit; unload DeferredSection off-display.
    pageSkeleton: false
    pageAsync: false
    pageCacheLimit: 3
    pageL2CacheLimit: 32
    pagePrefetch: true
    pagePrefetchL1: false
    pagePredictPrefetch: false
    pageWarmStart: false
    pageL2Warm: true
    pageIdleTrimMs: 45000
    pageLeaveSnapshot: false
    pageNavWarm: true
    pageNavWarmCacheLimit: 3
    // Short fade (keep sync/warm Profile F loading — not the same as pageTransition none).
    pageTransition: "fade"
    pageTransitionDuration: Md3Motion.medium2
    persistSession: true
    settingsOrganization: "QML_MD3"
    settingsApplication: "Gallery"
    hotReload: false

    documentTabsEnabled: true
    documentTabsTearOff: true

    showPerformanceButton: true
    showPerformanceOverlay: false
    showAboutButton: true
    aboutVersion: "1.0.0"
    aboutOrganization: "Md3"
    aboutText: qsTr("Material Design 3 组件图库 — 演示窗口、导航与控件。")
    aboutIcon: windowIcon

    Md3TrayHost {
        hostWindow: window
        Md3MenuItem {
            text: qsTr("显示主窗口")
            icon: "open_in_new"
            onClicked: window.raiseWindow()
        }
        Md3MenuItem {
            text: qsTr("图库通知")
            icon: "notifications"
            onClicked: window.showTrayNotification(qsTr("Md3 图库"), qsTr("来自托盘菜单"), 4000)
        }
        Md3MenuDivider {}
        Md3MenuItem {
            text: qsTr("退出")
            icon: "logout"
            onClicked: Qt.quit()
        }
    }

    property int galleryTableSelection: 0
    property bool galleryTableLoading: false
    property string galleryTreeSelection: ""

    statusBar: Md3StatusBar {
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
        Md3Text {
            visible: window.galleryTreeSelection.length > 0
            text: window.galleryTreeSelection
            role: Md3Text.LabelSmall
            tone: Md3Text.OnSurfaceVariant
        }
        Md3Text {
            text: "UTF-8"
            role: Md3Text.LabelSmall
            tone: Md3Text.OnSurfaceVariant
        }
    }

    toolBar: Md3AppToolBar {
        Md3IconButton {
            icon: "home"
            accessibleName: qsTr("Tokens")
            onClicked: window.navigateTo(0)
        }
        Md3IconButton {
            icon: "menu"
            accessibleName: qsTr("Navigation demo")
            onClicked: {
                for (let i = 0; i < window.destinations.length; ++i) {
                    if (window.destinations[i].source === "NavigationPage.qml") {
                        window.navigateTo(i)
                        return
                    }
                }
            }
        }
        Md3Divider {
            width: 1
            height: 20
        }
        Md3Text {
            text: qsTr("AppToolBar · TitleBar middle chips above")
            role: Md3Text.LabelMedium
            tone: Md3Text.OnSurfaceVariant
        }
        Md3Spacer { expand: true }
        Md3IconButton {
            icon: "tab"
            accessibleName: qsTr("Add document tab")
            onClicked: window.addTab(window.currentIndex)
        }
        Md3IconButton {
            icon: "open_in_new"
            accessibleName: qsTr("Tear off current tab")
            enabled: window.documentTabs && window.documentTabs.length > 1
            onClicked: {
                const cx = window.x + window.width / 2
                const cy = window.y + 80
                window.tearOffTab(window.documentTabIndex, cx, cy)
            }
        }
    }

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
        // Decorative reduceMotion is restored by ApplicationWindow.restoreSession (default off).
        if (!Md3AppSettings.value("tour/completed", false))
            Qt.callLater(function () { window.startTour() })
    }

    destinations: [
        { title: qsTr("令牌"), icon: "palette", source: "TokensPage.qml",
          skeletonLayout: "page" },
        { title: qsTr("按钮"), icon: "smart_button", source: "ButtonsPage.qml",
          skeletonBones: [
              { variant: "text", width: 0.35, height: 22 },
              { variant: "rounded", width: 1, height: 48 },
              { variant: "rounded", width: 0.55, height: 40 },
              { variant: "rounded", width: 0.4, height: 40 },
              { variant: "rounded", width: 0.7, height: 56 }
          ] },
        { title: qsTr("FAB"), icon: "add_circle", source: "FabPage.qml",
          skeletonBones: [
              { variant: "text", width: 0.3, height: 20 },
              { variant: "circular", width: 56, height: 56 },
              { variant: "rounded", width: 0.45, height: 56 }
          ] },
        { title: qsTr("选择"), icon: "check_box", source: "SelectionPage.qml",
          skeletonLayout: "list" },
        { title: qsTr("文本框"), icon: "edit", source: "TextFieldsPage.qml",
          skeletonBones: [
              { variant: "text", width: 0.28, height: 20 },
              { variant: "rounded", width: 0.7, height: 56 },
              { variant: "rounded", width: 0.7, height: 56 },
              { variant: "rounded", width: 0.7, height: 56 }
          ] },
        { title: qsTr("芯片"), icon: "label", source: "ChipsPage.qml",
          skeletonBones: [
              { variant: "text", width: 0.25, height: 18 },
              { variant: "rounded", width: 0.22, height: 32 },
              { variant: "rounded", width: 0.28, height: 32 },
              { variant: "rounded", width: 0.2, height: 32 }
          ] },
        { title: qsTr("容器"), icon: "dashboard", source: "ContainmentPage.qml",
          skeletonLayout: "cards" },
        { title: qsTr("反馈"), icon: "chat", source: "CommunicationPage.qml",
          skeletonLayout: "page" },
        { title: qsTr("模式"), icon: "design_services", source: "PatternsPage.qml",
          skeletonLayout: "page" },
        { title: qsTr("导航"), icon: "menu", source: "NavigationPage.qml",
          skeletonLayout: "list" },
        { title: qsTr("菜单"), icon: "more_vert", source: "MenusPage.qml",
          skeletonLayout: "list" },
        { title: qsTr("选择器"), icon: "calendar_month", source: "PickersPage.qml",
          skeletonBones: [
              { variant: "text", width: 0.3, height: 20 },
              { variant: "rounded", width: 0.55, height: 280 }
          ] },
        { title: qsTr("搜索"), icon: "search", source: "SearchPage.qml",
          skeletonBones: [
              { variant: "rounded", width: 1, height: 56 },
              { variant: "text", width: 0.8, height: 14 },
              { variant: "text", width: 0.65, height: 14 },
              { variant: "text", width: 0.7, height: 14 }
          ] },
        { title: qsTr("桌面模式"), icon: "folder_managed", source: "DesktopPatternsPage.qml",
          skeletonLayout: "page" },
        { title: qsTr("扩展"), icon: "extension", source: "ExtrasPage.qml",
          skeletonLayout: "page" },
        { title: qsTr("动效"), icon: "animation", source: "MotionPage.qml",
          skeletonLayout: "cards" },
        { title: qsTr("主题"), icon: "contrast", source: "ThemePage.qml",
          skeletonLayout: "page" },
        { title: qsTr("无障碍"), icon: "accessibility_new", source: "AccessibilityPage.qml",
          skeletonLayout: "page" },
        { title: qsTr("图表"), icon: "show_chart", source: "ChartsPage.qml", cacheCost: 3,
          skeletonBones: [
              { variant: "text", width: 0.3, height: 22 },
              { variant: "rounded", width: 1, height: 200 },
              { variant: "rounded", width: 1, height: 160 }
          ] },
        { title: qsTr("场景：登录"), icon: "login", source: "scenes/LoginScene.qml", cacheCost: 2.5,
          skeletonBones: [
              { variant: "circular", width: 64, height: 64 },
              { variant: "rounded", width: 0.7, height: 56 },
              { variant: "rounded", width: 0.7, height: 56 },
              { variant: "rounded", width: 0.45, height: 48 }
          ] },
        { title: qsTr("场景：列表详情"), icon: "view_sidebar", source: "scenes/ListDetailScene.qml", cacheCost: 2.5,
          skeletonLayout: "list" },
        { title: qsTr("场景：列表打开"), icon: "list_alt", source: "scenes/LaunchListScene.qml", cacheCost: 2.5,
          skeletonLayout: "list" },
        { title: qsTr("场景：列表详情页"), icon: "description", source: "scenes/LaunchDetailScene.qml", cacheCost: 2.5,
          skeletonLayout: "page" },
        { title: qsTr("场景：设置"), icon: "settings", source: "scenes/SettingsScene.qml", cacheCost: 2.5, pin: "bottom",
          skeletonLayout: "list" },
        { title: qsTr("窗口"), icon: "web_asset", source: "WindowPage.qml", pin: "bottom",
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
            unifiedChrome: window.unifiedTitleChrome
            showBackButton: window.showTitleBackButton
            backEnabled: window.canGoBack
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
