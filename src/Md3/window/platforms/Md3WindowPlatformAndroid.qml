import QtQuick

QtObject {
    // Android — system window chrome; WindowHelper: idle / FLAG_SECURE / badge
    readonly property string id: "android"
    readonly property bool customChrome: false
    readonly property bool captionButtons: false
    readonly property real trafficLightsInset: 0
    readonly property bool systemMove: false
    readonly property bool systemResize: false
    readonly property bool doubleClickMaximize: false
    readonly property real windowCornerRadius: 0
    readonly property bool roundedCorners: false
    readonly property bool snapLayouts: false
    readonly property bool systemBackdrop: false
    readonly property bool systemMenu: false
    readonly property bool immersiveDarkMode: false
    readonly property bool captionHitTest: false
    readonly property bool taskbarProgress: false
    readonly property bool taskbarOverlay: false
    readonly property bool peekControl: false
    readonly property bool excludeFromCapture: true
    readonly property bool jumpList: false
    readonly property bool thumbBar: false
    readonly property bool iconicThumbnail: false
    readonly property bool systemTray: false
    readonly property bool perMonitorDpiV2: false
    readonly property bool alwaysOnTop: true
    readonly property bool thumbnailClip: false
    readonly property bool applicationRestart: false
    readonly property bool preferredAppMode: false
    readonly property bool windowCloak: false
    readonly property bool systemAccent: false
    readonly property bool idleInhibit: true
}
