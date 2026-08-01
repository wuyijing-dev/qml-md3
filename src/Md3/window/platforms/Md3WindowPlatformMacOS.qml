import QtQuick

QtObject {
    // macOS — system traffic lights; leave leading inset; corners usually system-owned
    readonly property string id: "macos"
    readonly property bool customChrome: true
    readonly property bool captionButtons: false
    readonly property real trafficLightsInset: 78
    readonly property bool systemMove: true
    readonly property bool systemResize: true
    readonly property bool doubleClickMaximize: true
    // Frameless + client radius can fight system shadow; keep subtle
    readonly property real windowCornerRadius: 10
    readonly property bool roundedCorners: true
    readonly property bool snapLayouts: false
    readonly property bool systemBackdrop: true // translucent / vibrancy hook
    readonly property bool systemMenu: false
    readonly property bool immersiveDarkMode: true
    readonly property bool captionHitTest: false
    readonly property bool taskbarProgress: false
    readonly property bool taskbarOverlay: false
    readonly property bool peekControl: false
    readonly property bool excludeFromCapture: false
    readonly property bool jumpList: false
    readonly property bool thumbBar: false
    readonly property bool iconicThumbnail: false
    readonly property bool systemTray: false
    readonly property bool perMonitorDpiV2: false
    readonly property bool alwaysOnTop: true
    readonly property bool thumbnailClip: false
    readonly property bool applicationRestart: false
    readonly property bool preferredAppMode: true
    readonly property bool windowCloak: false
    readonly property bool systemAccent: true
    readonly property bool idleInhibit: false
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
