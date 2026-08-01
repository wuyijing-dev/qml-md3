import QtQuick

QtObject {
    // X11 (xcb) — CSD + FreeDesktop; KeepAbove / forceActiveWindow via KF when available.
    readonly property string id: "x11"
    readonly property bool customChrome: true
    readonly property bool captionButtons: true
    readonly property real trafficLightsInset: 0
    readonly property bool systemMove: true
    readonly property bool systemResize: true
    readonly property bool doubleClickMaximize: true
    readonly property real windowCornerRadius: 12
    readonly property bool roundedCorners: true
    readonly property bool systemCorners: false
    readonly property bool snapLayouts: false
    readonly property bool systemBackdrop: true // KWin blur atom / KF when available
    readonly property bool systemMenu: true
    readonly property bool immersiveDarkMode: true
    readonly property bool captionHitTest: true // QML CSD
    readonly property bool taskbarProgress: true // Unity LauncherEntry / Plasma
    readonly property bool taskbarOverlay: false
    readonly property bool peekControl: false
    readonly property bool excludeFromCapture: false
    readonly property bool jumpList: false
    readonly property bool thumbBar: false
    readonly property bool iconicThumbnail: false
    readonly property bool systemTray: true // StatusNotifier / XEmbed tray
    readonly property bool perMonitorDpiV2: true // XRandR / Qt screen DPI
    readonly property bool alwaysOnTop: true // KX11Extras KeepAbove when available
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
    readonly property bool notifications: false
    readonly property bool systemBarColors: false
    readonly property bool screenOrientation: false
    readonly property bool softInput: false
    readonly property bool nativeToast: false
    readonly property bool hapticFeedback: false
    readonly property bool openAppSettings: false
    readonly property bool shareFile: false
}
