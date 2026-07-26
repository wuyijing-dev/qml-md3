import QtQuick
import QtQuick.Window
import Md3

Md3ApplicationWindow {
    id: window
    width: 1180
    height: 760
    title: qsTr("Md3 图库")
    windowIcon: "qrc:/md3/icons/app-icon.png"
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
    // WinUI3-like Frame navigation (low memory + smooth enter)
    pageCacheMode: "adaptive"
    pageCacheLimit: 3
    pageIdleTrimMs: 20000
    pagePrefetch: true
    pageWarmStart: false
    pageAsync: true
    pagePadding: 20
    pageSkeleton: false
    pageTransition: "fade"
    pageTransitionDuration: 280

    // Document tabs under the title bar (no browserChrome / no tear-off window)
    documentTabsEnabled: true
    documentTabsTearOff: false

    property bool showPerformancePanel: true
    readonly property string pageRoot: "qrc:/qt/qml/Gallery/gallery/pages/"
    readonly property int windowPageIndex: 16
    readonly property bool perfSampling: showPerformancePanel
                                         && visible
                                         && visibility !== Window.Minimized
                                         && visibility !== Window.Hidden

    destinations: [
        { title: qsTr("令牌"), icon: "palette", source: pageRoot + "TokensPage.qml" },
        { title: qsTr("按钮"), icon: "smart_button", source: pageRoot + "ButtonsPage.qml" },
        { title: qsTr("FAB"), icon: "add_circle", source: pageRoot + "FabPage.qml" },
        { title: qsTr("选择"), icon: "check_box", source: pageRoot + "SelectionPage.qml" },
        { title: qsTr("文本框"), icon: "edit", source: pageRoot + "TextFieldsPage.qml" },
        { title: qsTr("芯片"), icon: "label", source: pageRoot + "ChipsPage.qml" },
        { title: qsTr("容器"), icon: "dashboard", source: pageRoot + "ContainmentPage.qml" },
        { title: qsTr("反馈"), icon: "chat", source: pageRoot + "CommunicationPage.qml" },
        { title: qsTr("导航"), icon: "menu", source: pageRoot + "NavigationPage.qml" },
        { title: qsTr("菜单"), icon: "more_vert", source: pageRoot + "MenusPage.qml" },
        { title: qsTr("选择器"), icon: "calendar_month", source: pageRoot + "PickersPage.qml" },
        { title: qsTr("搜索"), icon: "search", source: pageRoot + "SearchPage.qml" },
        { title: qsTr("扩展"), icon: "extension", source: pageRoot + "ExtrasPage.qml" },
        { title: qsTr("动效"), icon: "animation", source: pageRoot + "MotionPage.qml" },
        { title: qsTr("主题"), icon: "contrast", source: pageRoot + "ThemePage.qml" },
        { title: qsTr("图表"), icon: "show_chart", source: pageRoot + "ChartsPage.qml" },
        { title: qsTr("窗口"), icon: "web_asset", source: pageRoot + "WindowPage.qml" },
        { title: qsTr("场景：登录"), icon: "login", source: pageRoot + "scenes/LoginScene.qml" },
        { title: qsTr("场景：设置"), icon: "settings", source: pageRoot + "scenes/SettingsScene.qml" },
        { title: qsTr("场景：列表详情"), icon: "view_sidebar", source: pageRoot + "scenes/ListDetailScene.qml" }
    ]

    PerformanceMonitor {
        id: perfMonitor
        active: window.perfSampling
    }

    PerformancePanel {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 16
        anchors.bottomMargin: 16
        z: 100000
        visible: window.showPerformancePanel
        compact: true
        expanded: false
        monitor: perfMonitor
    }

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

            trailingContent: [
                Md3TitleBarButton {
                    icon: "tab"
                    buttonWidth: 36
                    buttonHeight: 28
                    iconSize: 14
                    accessibleName: qsTr("新建标签")
                    onClicked: window.addTab(window.currentIndex)
                },
                Md3TitleBarButton {
                    icon: "speed"
                    buttonWidth: 36
                    buttonHeight: 28
                    iconSize: 14
                    checked: window.showPerformancePanel
                    accessibleName: qsTr("Performance monitor")
                    onClicked: window.showPerformancePanel = !window.showPerformancePanel
                },
                Md3TitleBarButton {
                    icon: "info"
                    buttonWidth: 36
                    buttonHeight: 28
                    iconSize: 14
                    accessibleName: qsTr("窗口页面")
                    onClicked: window.openTab(window.windowPageIndex, false)
                }
            ]
        }
    }
}
