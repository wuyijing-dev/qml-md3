import QtQuick

QtObject {
    // Generic Linux fallback when QPA is neither wayland nor xcb/x11.
    // Prefer Md3WindowPlatformWayland / Md3WindowPlatformX11 via Md3WindowCapabilities.
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
    readonly property bool systemBackdrop: true // alpha + compositor blur hints
    readonly property bool systemMenu: true
    readonly property bool immersiveDarkMode: true
    readonly property bool captionHitTest: true // QML CSD
    readonly property bool taskbarProgress: true // Unity LauncherEntry (Plasma etc.)
    readonly property bool taskbarOverlay: false
    readonly property bool peekControl: false
    readonly property bool excludeFromCapture: false
    readonly property bool jumpList: false
    readonly property bool thumbBar: false
    readonly property bool iconicThumbnail: false
    readonly property bool systemTray: true // StatusNotifier / tray portal
    readonly property bool perMonitorDpiV2: true
    readonly property bool alwaysOnTop: true
    readonly property bool thumbnailClip: false
    readonly property bool applicationRestart: false
    readonly property bool preferredAppMode: true
    readonly property bool windowCloak: false
    readonly property bool systemAccent: true
    readonly property bool idleInhibit: true // ScreenSaver / GNOME / portal
    readonly property bool systemOpen: true
    readonly property bool revealInFolder: true
    readonly property bool shareText: true
    readonly property bool vibrate: false
    readonly property bool immersiveSystemUi: false
    readonly property bool skipTaskbar: true
    readonly property bool openAtLogin: true
    readonly property bool globalShortcut: true
    readonly property bool protocolClient: true
    readonly property bool powerMonitor: true
}
