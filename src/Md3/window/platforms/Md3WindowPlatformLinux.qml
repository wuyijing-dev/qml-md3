import QtQuick

QtObject {
    // Linux X11 / Wayland — CSD + desktop-shell natives (Unity/Plasma/SNI/FDO)
    readonly property string id: "linux"
    readonly property bool customChrome: true
    readonly property bool captionButtons: true
    readonly property real trafficLightsInset: 0
    readonly property bool systemMove: true
    readonly property bool systemResize: true
    readonly property bool doubleClickMaximize: true
    readonly property real windowCornerRadius: 12
    readonly property bool roundedCorners: true
    readonly property bool snapLayouts: false
    // Soft translucent + compositor blur hints (KWin / custom rules)
    readonly property bool systemBackdrop: true
    readonly property bool systemMenu: true // QMenu CSD system menu
    readonly property bool immersiveDarkMode: true
    readonly property bool captionHitTest: true // QML CSD drag region
    readonly property bool taskbarProgress: true // Unity LauncherEntry
    readonly property bool taskbarOverlay: true // dock count badge
    readonly property bool peekControl: false
    readonly property bool excludeFromCapture: false
    readonly property bool jumpList: false
    readonly property bool thumbBar: false
    readonly property bool iconicThumbnail: false
    readonly property bool systemTray: true // SNI / QSystemTrayIcon
    readonly property bool perMonitorDpiV2: true // Wayland fractional scale via Qt
    readonly property bool alwaysOnTop: true
    readonly property bool thumbnailClip: false
    readonly property bool applicationRestart: true // MD3_RESTART_ARGS hint
    readonly property bool preferredAppMode: true
    readonly property bool windowCloak: true // opacity cloak
    readonly property bool systemAccent: true
}
