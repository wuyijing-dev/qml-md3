pragma Singleton
import QtQuick
import Md3

/// Material 3–aligned window size classes + desktop/mobile chrome policy.
/// Breakpoints match common MD3 / Material WindowSizeClass widths (dp ≈ logical px).
QtObject {
    id: root

    // --- Width breakpoints (inclusive max for each class except ExtraLarge) ---
    readonly property real compactMax: 599
    readonly property real mediumMax: 839
    readonly property real expandedMax: 1199
    readonly property real largeMax: 1599

    // Height (optional; navigation often uses width only)
    readonly property real heightCompactMax: 479
    readonly property real heightMediumMax: 899

    enum WidthClass {
        Compact = 0,
        Medium = 1,
        Expanded = 2,
        Large = 3,
        ExtraLarge = 4
    }

    enum HeightClass {
        Compact = 0,
        Medium = 1,
        Expanded = 2
    }

    enum DeviceClass {
        Phone = 0,
        Tablet = 1,
        Desktop = 2,
        Tv = 3
    }

    enum WindowAppearance {
        /// System title bar / no CSD (mobile OS, WASM, or forced)
        System = 0,
        /// Custom chrome with compact title bar
        CompactChrome = 1,
        /// Full desktop CSD (caption buttons, snap, etc. when capable)
        DesktopChrome = 2
    }

    function widthClassFor(w) {
        const x = Math.max(0, Number(w) || 0)
        if (x <= compactMax)
            return Md3Adaptive.WidthClass.Compact
        if (x <= mediumMax)
            return Md3Adaptive.WidthClass.Medium
        if (x <= expandedMax)
            return Md3Adaptive.WidthClass.Expanded
        if (x <= largeMax)
            return Md3Adaptive.WidthClass.Large
        return Md3Adaptive.WidthClass.ExtraLarge
    }

    function heightClassFor(h) {
        const y = Math.max(0, Number(h) || 0)
        if (y <= heightCompactMax)
            return Md3Adaptive.HeightClass.Compact
        if (y <= heightMediumMax)
            return Md3Adaptive.HeightClass.Medium
        return Md3Adaptive.HeightClass.Expanded
    }

    function widthClassName(wc) {
        switch (wc) {
        case Md3Adaptive.WidthClass.Compact: return "compact"
        case Md3Adaptive.WidthClass.Medium: return "medium"
        case Md3Adaptive.WidthClass.Large: return "large"
        case Md3Adaptive.WidthClass.ExtraLarge: return "extraLarge"
        default: return "expanded"
        }
    }

    function deviceClassFor(w, h) {
        // OS first: phones/tablets report mobile even when window is wide (desktop-mode).
        if (Md3WindowCapabilities.isWasm)
            return Md3Adaptive.DeviceClass.Desktop
        if (Md3WindowCapabilities.isMobile) {
            const wc = widthClassFor(w)
            if (wc >= Md3Adaptive.WidthClass.Expanded)
                return Md3Adaptive.DeviceClass.Tablet
            return Md3Adaptive.DeviceClass.Phone
        }
        const wc = widthClassFor(w)
        const hc = heightClassFor(h)
        // Very large short windows → treat as TV/kiosk-ish desktop
        if (wc >= Md3Adaptive.WidthClass.ExtraLarge && hc <= Md3Adaptive.HeightClass.Compact)
            return Md3Adaptive.DeviceClass.Tv
        if (wc <= Md3Adaptive.WidthClass.Compact)
            return Md3Adaptive.DeviceClass.Phone
        if (wc <= Md3Adaptive.WidthClass.Medium)
            return Md3Adaptive.DeviceClass.Tablet
        return Md3Adaptive.DeviceClass.Desktop
    }

    function deviceClassName(dc) {
        switch (dc) {
        case Md3Adaptive.DeviceClass.Phone: return "phone"
        case Md3Adaptive.DeviceClass.Tablet: return "tablet"
        case Md3Adaptive.DeviceClass.Tv: return "tv"
        default: return "desktop"
        }
    }

    /// Recommended window chrome appearance for this size + platform.
    function windowAppearanceFor(w, h) {
        if (!Md3WindowCapabilities.customChrome)
            return Md3Adaptive.WindowAppearance.System
        if (Md3WindowCapabilities.isMobile || Md3WindowCapabilities.isWasm)
            return Md3Adaptive.WindowAppearance.System
        const dc = deviceClassFor(w, h)
        const wc = widthClassFor(w)
        if (dc === Md3Adaptive.DeviceClass.Phone
                || wc === Md3Adaptive.WidthClass.Compact)
            return Md3Adaptive.WindowAppearance.CompactChrome
        if (dc === Md3Adaptive.DeviceClass.Tablet
                || wc === Md3Adaptive.WidthClass.Medium)
            return Md3Adaptive.WindowAppearance.CompactChrome
        return Md3Adaptive.WindowAppearance.DesktopChrome
    }

    function windowAppearanceName(a) {
        switch (a) {
        case Md3Adaptive.WindowAppearance.System: return "system"
        case Md3Adaptive.WindowAppearance.CompactChrome: return "compactChrome"
        default: return "desktopChrome"
        }
    }

    /// Whether frameless / CSD should be active.
    function useCustomChrome(w, h) {
        const a = windowAppearanceFor(w, h)
        return a === Md3Adaptive.WindowAppearance.CompactChrome
                || a === Md3Adaptive.WindowAppearance.DesktopChrome
    }

    function preferCompactTitleBar(w, h) {
        const a = windowAppearanceFor(w, h)
        return a === Md3Adaptive.WindowAppearance.CompactChrome
                || widthClassFor(w) <= Md3Adaptive.WidthClass.Medium
    }

    function preferCaptionButtons(w, h) {
        // CSD always needs in-client captions when the platform expects them.
        // CompactChrome only densifies the bar; System appearance uses OS chrome instead.
        if (!Md3WindowCapabilities.captionButtons)
            return false
        return useCustomChrome(w, h)
    }

    /// Navigation density hint for shells (rail vs bar).
    function preferNavigationBar(w, h) {
        const dc = deviceClassFor(w, h)
        return dc === Md3Adaptive.DeviceClass.Phone
                || widthClassFor(w) === Md3Adaptive.WidthClass.Compact
    }

    function preferNavigationRail(w, h) {
        return !preferNavigationBar(w, h)
    }

    /// Same thresholds as Md3NavigationView Auto mode.
    readonly property real navigationCompactBreakpoint: 600
    readonly property real navigationExpandedBreakpoint: 840

    /// Optional Window used to read Qt 6.9+ `safeAreaMargins` (falls back when unset).
    property var safeAreaWindow: null

    function _platformSafeBottom() {
        const os = Qt.platform.os
        if (os === "android" || os === "ios")
            return 20
        return 0
    }

    function _platformSafeTop() {
        const os = Qt.platform.os
        if (os === "ios")
            return 12
        return 0
    }

    /// Resolve insets from a Window (Qt 6.9+ `safeAreaMargins`) with platform fallback.
    function safeInsetsFor(win) {
        const fallback = { top: _platformSafeTop(), bottom: _platformSafeBottom(), left: 0, right: 0 }
        if (!Md3QtCompat || !Md3QtCompat.atLeast69 || !win)
            return fallback
        try {
            const m = win.safeAreaMargins
            if (!m)
                return fallback
            return {
                top: Math.max(0, Number(m.top !== undefined ? m.top : 0)),
                bottom: Math.max(0, Number(m.bottom !== undefined ? m.bottom : 0)),
                left: Math.max(0, Number(m.left !== undefined ? m.left : 0)),
                right: Math.max(0, Number(m.right !== undefined ? m.right : 0))
            }
        } catch (e) {
            return fallback
        }
    }

    /// Home-indicator / gesture-bar padding. On Qt 6.9+ uses Window.safeAreaMargins when
    /// `safeAreaWindow` is set; otherwise platform fallback (6.5 baseline).
    readonly property real safeBottomInset: {
        if (safeAreaWindow)
            return safeInsetsFor(safeAreaWindow).bottom
        return _platformSafeBottom()
    }
    readonly property real safeTopInset: {
        if (safeAreaWindow)
            return safeInsetsFor(safeAreaWindow).top
        return _platformSafeTop()
    }
    readonly property real safeLeftInset: {
        if (safeAreaWindow)
            return safeInsetsFor(safeAreaWindow).left
        return 0
    }
    readonly property real safeRightInset: {
        if (safeAreaWindow)
            return safeInsetsFor(safeAreaWindow).right
        return 0
    }
}
