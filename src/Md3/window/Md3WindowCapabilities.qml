pragma Singleton
import QtQuick
import Md3

QtObject {
    id: root

    /// Runtime QPA probe (wayland / xcb) for Linux display-server selection.
    readonly property Md3WindowHelper _native: Md3WindowHelper {}

    readonly property string os: Qt.platform.os
    readonly property bool isWindows: os === "windows"
    readonly property bool isMacOS: os === "osx" || os === "macos"
    readonly property bool isLinux: os === "linux"
    readonly property bool isAndroid: os === "android"
    readonly property bool isWasm: os === "wasm" || os === "emscripten"
    readonly property bool isMobile: os === "android" || os === "ios"
    /// Browser / WASM uses the mobile capability bag (system chrome, no CSD/tray).
    readonly property bool isDesktop: !isMobile && !isWasm

    /// Auto-detected on Linux via QGuiApplication::platformName().
    readonly property bool isWayland: isLinux && _native.wayland
    readonly property bool isX11: isLinux && _native.xcb

    /// "wayland" | "x11" | "android" | "windows" | "macos" | "wasm" | "ios" | "linux" | "unknown"
    readonly property string displayServer: {
        if (isAndroid)
            return "android"
        if (isWindows)
            return "windows"
        if (isMacOS)
            return "macos"
        if (isWasm)
            return "wasm"
        if (os === "ios")
            return "ios"
        if (isLinux) {
            if (_native.wayland)
                return "wayland"
            if (_native.xcb)
                return "x11"
            return "linux"
        }
        return "unknown"
    }

    // Per-platform bags as properties (QtObject has no default property for children)
    property Md3WindowPlatformWindows windows: Md3WindowPlatformWindows {}
    property Md3WindowPlatformMacOS macOS: Md3WindowPlatformMacOS {}
    property Md3WindowPlatformLinux linux: Md3WindowPlatformLinux {}
    property Md3WindowPlatformWayland wayland: Md3WindowPlatformWayland {}
    property Md3WindowPlatformX11 x11: Md3WindowPlatformX11 {}
    property Md3WindowPlatformAndroid android: Md3WindowPlatformAndroid {}
    property Md3WindowPlatformMobile mobile: Md3WindowPlatformMobile {}

    readonly property var platform: {
        if (isWindows)
            return windows
        if (isMacOS)
            return macOS
        if (isAndroid)
            return android
        if (isLinux) {
            if (_native.wayland)
                return wayland
            if (_native.xcb)
                return x11
            return linux
        }
        // wasm / ios / unknown → mobile stubs
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
    readonly property bool systemOpen: platform.systemOpen
    readonly property bool revealInFolder: platform.revealInFolder
    readonly property bool shareText: platform.shareText
    readonly property bool vibrate: platform.vibrate
    readonly property bool immersiveSystemUi: platform.immersiveSystemUi
    readonly property bool skipTaskbar: platform.skipTaskbar

    /// Electron-parity host APIs (Md3NativeShell).
    readonly property bool singleInstance: true
    readonly property bool openAtLogin: platform.openAtLogin
    readonly property bool globalShortcut: platform.globalShortcut
    readonly property bool protocolClient: platform.protocolClient
    readonly property bool powerMonitor: platform.powerMonitor
    readonly property bool notifications: platform.notifications
    readonly property bool systemBarColors: platform.systemBarColors
    readonly property bool screenOrientation: platform.screenOrientation
    readonly property bool softInput: platform.softInput
    readonly property bool nativeToast: platform.nativeToast
    readonly property bool hapticFeedback: platform.hapticFeedback
    readonly property bool openAppSettings: platform.openAppSettings
    readonly property bool shareFile: platform.shareFile
}
