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
    pageTransition: "slide"
    pageTransitionDuration: 450

    // Browser-style chrome: tabs replace the title bar
    documentTabsEnabled: true
    browserChrome: true

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

    documentTabActions: Component {
        Row {
            spacing: 0
            Md3TitleBarButton {
                icon: Md3Theme.dark ? "light_mode" : "dark_mode"
                buttonWidth: 36
                buttonHeight: 28
                iconSize: 14
                accessibleName: Md3Theme.dark ? qsTr("浅色") : qsTr("深色")
                onClicked: window.toggleThemeFrom(this)
            }
            Md3TitleBarButton {
                icon: "speed"
                buttonWidth: 36
                buttonHeight: 28
                iconSize: 14
                checked: window.showPerformancePanel
                accessibleName: qsTr("Performance monitor")
                onClicked: window.showPerformancePanel = !window.showPerformancePanel
            }
            Md3TitleBarButton {
                icon: "tab"
                buttonWidth: 36
                buttonHeight: 28
                iconSize: 14
                accessibleName: qsTr("New tab")
                onClicked: window.addTab(window.currentIndex)
            }
            Md3TitleBarButton {
                icon: "info"
                buttonWidth: 36
                buttonHeight: 28
                iconSize: 14
                accessibleName: qsTr("窗口页面")
                onClicked: window.openTab(window.windowPageIndex, false)
            }
        }
    }

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
}
