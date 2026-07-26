import QtQuick

QtObject {
    // Linux X11 / Wayland — CSD + Qt-backed native affordances
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
    // Soft translucent surface for compositor blur (Mutter/KWin rules)
    readonly property bool systemBackdrop: true
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
}
