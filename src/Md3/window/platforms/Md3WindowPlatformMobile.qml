import QtQuick

QtObject {
    // iOS / WASM / generic mobile — system window chrome (see Md3WindowPlatformAndroid for Android)
    readonly property string id: "mobile"
    readonly property bool customChrome: false
    readonly property bool captionButtons: false
    readonly property real trafficLightsInset: 0
    readonly property bool systemMove: false
    readonly property bool systemResize: false
    readonly property bool doubleClickMaximize: false
    readonly property real windowCornerRadius: 0
    readonly property bool roundedCorners: false
    readonly property bool systemCorners: false
    readonly property bool snapLayouts: false
    readonly property bool systemBackdrop: false
    readonly property bool systemMenu: false
    readonly property bool immersiveDarkMode: false
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
    readonly property bool alwaysOnTop: false
    readonly property bool thumbnailClip: false
    readonly property bool applicationRestart: false
    readonly property bool preferredAppMode: false
    readonly property bool windowCloak: false
    readonly property bool systemAccent: false
    readonly property bool idleInhibit: false
    readonly property bool systemOpen: true
    readonly property bool revealInFolder: false
    readonly property bool shareText: true
    readonly property bool vibrate: false
    readonly property bool immersiveSystemUi: false
    readonly property bool skipTaskbar: false
    readonly property bool openAtLogin: false
    readonly property bool globalShortcut: false
    readonly property bool protocolClient: false
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
