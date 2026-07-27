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
    pagePadding: 20

    // Document tabs under the title bar (no browserChrome / no tear-off window)
    documentTabsEnabled: true
    documentTabsTearOff: false

    // Library performance overlay — title-bar speed button; open by default in gallery
    showPerformanceButton: true
    showPerformanceOverlay: true

    readonly property string pageRoot: "qrc:/qt/qml/Gallery/pages/"
    readonly property int windowPageIndex: 16

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
        { title: qsTr("图表"), icon: "show_chart", source: pageRoot + "ChartsPage.qml", cacheCost: 3 },
        { title: qsTr("窗口"), icon: "web_asset", source: pageRoot + "WindowPage.qml" },
        { title: qsTr("场景：登录"), icon: "login", source: pageRoot + "scenes/LoginScene.qml", cacheCost: 2.5 },
        { title: qsTr("场景：设置"), icon: "settings", source: pageRoot + "scenes/SettingsScene.qml", cacheCost: 2.5 },
        { title: qsTr("场景：列表详情"), icon: "view_sidebar", source: pageRoot + "scenes/ListDetailScene.qml", cacheCost: 2.5 }
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
            showPerformanceToggle: window.showPerformanceButton
            performanceChecked: window.showPerformanceOverlay
            onPerformanceClicked: window.showPerformanceOverlay = !window.showPerformanceOverlay

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
