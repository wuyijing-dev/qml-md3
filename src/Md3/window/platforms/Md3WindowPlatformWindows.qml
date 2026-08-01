import QtQuick

QtObject {
    // Windows desktop capabilities (Win10/11 client chrome)
    readonly property string id: "windows"
    readonly property bool customChrome: true
    readonly property bool captionButtons: true
    readonly property real trafficLightsInset: 0
    readonly property bool systemMove: true
    readonly property bool systemResize: true
    readonly property bool doubleClickMaximize: true
    // Win11-style rounded frame when restored; 0 when maximized
    readonly property real windowCornerRadius: 12
    readonly property bool roundedCorners: true
    // Delayed HTMAXBUTTON: short hover keeps QML cursor/click; ~380ms arms Win11 snap flyout.
    readonly property bool snapLayouts: true
    readonly property bool systemBackdrop: true // Mica / Acrylic / Tabbed (Win11+)
    readonly property bool systemMenu: true
    readonly property bool immersiveDarkMode: true
    readonly property bool captionHitTest: true // HTCAPTION drag region
    readonly property bool taskbarProgress: true // ITaskbarList3
    readonly property bool taskbarOverlay: true
    readonly property bool peekControl: true
    readonly property bool excludeFromCapture: true
    readonly property bool jumpList: true
    readonly property bool thumbBar: true
    readonly property bool iconicThumbnail: true
    readonly property bool systemTray: true
    readonly property bool perMonitorDpiV2: true
    readonly property bool alwaysOnTop: true
    readonly property bool thumbnailClip: true
    readonly property bool applicationRestart: true
    readonly property bool preferredAppMode: true
    readonly property bool windowCloak: true
    readonly property bool systemAccent: true
    readonly property bool idleInhibit: true // SetThreadExecutionState
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
