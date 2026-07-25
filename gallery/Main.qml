import QtQuick
import QtQuick.Window
import Md3

Md3ApplicationWindow {
    id: window
    width: 1180
    height: 760
    title: qsTr("Md3 Gallery")
    windowIcon: "qrc:/md3/icons/app-icon.png"
    roundedCorners: true
    cornerRadius: Md3WindowCapabilities.windowCornerRadius
    syncImmersiveDarkMode: true
    systemBackdrop: 0
    nativeBorderColor: ""

    pageSourceBase: Qt.resolvedUrl("./")
    navigationRail: true
    railExpanded: false
    railHeader: qsTr("Gallery")
    // Keep only the current page resident — closest to a single-page Electron shell
    pageCacheMode: "one"
    pageCacheLimit: 1
    pagePrefetch: false
    pageWarmStart: false
    pageAsync: true
    pagePadding: 20
    pageSkeleton: true
    pageTransition: "fadeThrough"
    pageTransitionDuration: Md3Motion.spatialDuration

    property bool showPerformancePanel: true

    readonly property string pageRoot: "qrc:/qt/qml/Gallery/gallery/pages/"
    readonly property int windowPageIndex: 16
    readonly property bool perfSampling: showPerformancePanel
                                         && visible
                                         && visibility !== Window.Minimized
                                         && visibility !== Window.Hidden

    destinations: [
        { title: "Tokens", icon: "palette", source: pageRoot + "TokensPage.qml" },
        { title: "Buttons", icon: "smart_button", source: pageRoot + "ButtonsPage.qml" },
        { title: "FAB", icon: "add_circle", source: pageRoot + "FabPage.qml" },
        { title: "Selection", icon: "check_box", source: pageRoot + "SelectionPage.qml" },
        { title: "Text fields", icon: "edit", source: pageRoot + "TextFieldsPage.qml" },
        { title: "Chips", icon: "label", source: pageRoot + "ChipsPage.qml" },
        { title: "Containment", icon: "dashboard", source: pageRoot + "ContainmentPage.qml" },
        { title: "Communication", icon: "chat", source: pageRoot + "CommunicationPage.qml" },
        { title: "Navigation", icon: "menu", source: pageRoot + "NavigationPage.qml" },
        { title: "Menus", icon: "more_vert", source: pageRoot + "MenusPage.qml" },
        { title: "Pickers", icon: "calendar_month", source: pageRoot + "PickersPage.qml" },
        { title: "Search", icon: "search", source: pageRoot + "SearchPage.qml" },
        { title: "Extras", icon: "extension", source: pageRoot + "ExtrasPage.qml" },
        { title: "Motion", icon: "animation", source: pageRoot + "MotionPage.qml" },
        { title: "Theme", icon: "contrast", source: pageRoot + "ThemePage.qml" },
        { title: "Charts", icon: "show_chart", source: pageRoot + "ChartsPage.qml" },
        { title: "Window", icon: "web_asset", source: pageRoot + "WindowPage.qml" },
        { title: "Scene: Login", icon: "login", source: pageRoot + "scenes/LoginScene.qml" },
        { title: "Scene: Settings", icon: "settings", source: pageRoot + "scenes/SettingsScene.qml" },
        { title: "Scene: List-Detail", icon: "view_sidebar", source: pageRoot + "scenes/ListDetailScene.qml" }
    ]

    PerformanceMonitor {
        id: perfMonitor
        historySize: 16
        sampleIntervalMs: 1000
        active: window.perfSampling
        Component.onCompleted: bindWindow(window)
    }

    PerformancePanel {
        id: perfPanel
        // contentItem avoids chrome / rounded-mask clipping of overlayHost
        parent: window.contentItem
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 16
        anchors.bottomMargin: 16
        z: 100000
        visible: window.showPerformancePanel
        compact: true
        expanded: true
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
                    accessibleName: qsTr("Window page")
                    onClicked: window.navigateTo(window.windowPageIndex)
                }
            ]
        }
    }
}
