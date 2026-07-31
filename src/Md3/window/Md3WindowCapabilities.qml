pragma Singleton
import QtQuick
import Md3

QtObject {
    id: root

    readonly property string os: Qt.platform.os
    readonly property bool isWindows: os === "windows"
    readonly property bool isMacOS: os === "osx" || os === "macos"
    readonly property bool isLinux: os === "linux"
    readonly property bool isWasm: os === "wasm" || os === "emscripten"
    readonly property bool isMobile: os === "android" || os === "ios"
    /// Browser / WASM uses the mobile capability bag (system chrome, no CSD/tray).
    readonly property bool isDesktop: !isMobile && !isWasm

    // Per-platform bags as properties (QtObject has no default property for children)
    property Md3WindowPlatformWindows windows: Md3WindowPlatformWindows {}
    property Md3WindowPlatformMacOS macOS: Md3WindowPlatformMacOS {}
    property Md3WindowPlatformLinux linux: Md3WindowPlatformLinux {}
    property Md3WindowPlatformMobile mobile: Md3WindowPlatformMobile {}

    readonly property var platform: {
        if (isWindows)
            return windows
        if (isMacOS)
            return macOS
        if (isLinux)
            return linux
        // wasm / android / ios / unknown → mobile stubs
        return mobile
    }

    readonly property string platformId: platform.id

    readonly property bool customChrome: platform.customChrome
    readonly property bool captionButtons: platform.captionButtons
    readonly property real trafficLightsInset: platform.trafficLightsInset
    readonly property bool systemMove: platform.systemMove
    readonly property bool systemResize: platform.systemResize
    readonly property bool doubleClickMaximize: platform.doubleClickMaximize
    readonly property real windowCornerRadius: platform.windowCornerRadius
    readonly property bool roundedCorners: platform.roundedCorners
    readonly property bool snapLayouts: platform.snapLayouts
    readonly property bool systemBackdrop: platform.systemBackdrop
    readonly property bool systemMenu: platform.systemMenu
    readonly property bool immersiveDarkMode: platform.immersiveDarkMode
    readonly property bool captionHitTest: platform.captionHitTest
    readonly property bool taskbarProgress: platform.taskbarProgress
    readonly property bool taskbarOverlay: platform.taskbarOverlay
    readonly property bool peekControl: platform.peekControl
    readonly property bool excludeFromCapture: platform.excludeFromCapture
    readonly property bool jumpList: platform.jumpList
    readonly property bool thumbBar: platform.thumbBar
    readonly property bool iconicThumbnail: platform.iconicThumbnail
    readonly property bool systemTray: platform.systemTray
    readonly property bool perMonitorDpiV2: platform.perMonitorDpiV2
    readonly property bool alwaysOnTop: platform.alwaysOnTop
    readonly property bool thumbnailClip: platform.thumbnailClip
    readonly property bool applicationRestart: platform.applicationRestart
    readonly property bool preferredAppMode: platform.preferredAppMode
    readonly property bool windowCloak: platform.windowCloak
    readonly property bool systemAccent: platform.systemAccent
    readonly property bool idleInhibit: platform.idleInhibit
}
