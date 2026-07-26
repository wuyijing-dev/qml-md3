# Application window (cross-platform chrome)

## Sources
- Electron: `titleBarStyle` / `titleBarOverlay`, `app-region`, custom title-bar actions
- WinUI 3: `AppWindow`, `TitleBar`, Win11 Snap Layouts
- Qt 6: `Window`, `startSystemMove`, `startSystemResize`, frameless flags

## Goal
Apps use **Md3ApplicationWindow** instead of a bare `Window`. Chrome (title bar, caption buttons, drag/resize, rounded frame, **Win11 snap layouts**, theme toggle) is part of the library.

## Electron feature parity

| Electron / desktop chrome | Md3 |
|---------------------------|-----|
| `frame: false` + custom title bar | `Md3ApplicationWindow` + `Md3TitleBar` |
| Drag region (`-webkit-app-region: drag`) | Title bar + Win `HTCAPTION` on title block |
| No-drag controls | Actions / caption outside drag / hit rects |
| Window controls (min / max / close) | `Md3CaptionButtons` (Win/Linux) |
| Overlay traffic lights (macOS) | `trafficLightsInset` + no client caption |
| Custom title-bar buttons | `Md3TitleBarButton` + `extraActions` |
| Pin / always-on-top | `Md3TitleBar.showPin` + `pinned` (**default on**) |
| App theme control in chrome | `showThemeToggle` + circular reveal + DWM dark mode |
| Win11 Snap Layouts (maximize hover) | `HTMAXBUTTON` via `Md3WindowHelper` |
| System menu (icon / right-click / Alt+Space) | `showSystemMenu` |
| Mica / Acrylic | `systemBackdrop` → `DWMWA_SYSTEMBACKDROP_TYPE` |
| Taskbar flash | `flashTaskbar()` |
| Double-click maximize | Title bar / HTCAPTION double-click |
| Edge resize | `startSystemResize` edges |
| Center content (tabs / search) | `centerContent` / `middleContent` slot |

## Destinations shell (built-in rail + lazy pages)

Declare `destinations` — the window owns left **NavigationRail** and **on-demand** page loading. Apps do not write rail/list/Loader layout.

```qml
Md3ApplicationWindow {
    pageSourceBase: Qt.resolvedUrl(".")  // required for relative page paths
    navigationRail: true
    railExpanded: false                  // rail has built-in Menu expand toggle
    railHeader: "App"
    pageCacheMode: "one"
    destinations: [
        { title: "Home", icon: "home", source: "pages/HomePage.qml" }
    ]
}
```

Relative `source` paths are resolved against `pageSourceBase`. Prefer absolute URLs from the app file:

```qml
destinations: [
    { title: "Home", icon: "home", source: Qt.resolvedUrl("pages/HomePage.qml") }
]
```

| API | Role |
|-----|------|
| `destinations` | `{ title\|label, icon, source\|component }` |
| `navigationRail` | Show left rail (default true) |
| `pageCacheMode` | `none` / `one` / `lru` / `all` / `adaptive` / `arc` (default **arc**) |
| `pageCacheLimit` | Max L1 Item residents (default **2**) |
| `pageIdleTrimMs` | Trim L1 toward 1 after idle (default **12s**) |
| `pagePrefetch` | ±1 neighbors into L1 (default **false**) |
| `pagePredictPrefetch` | Markov + rail hover → L2 only (default **true**) |
| `pageL2Cache` | Retain compiled `Component` after Item teardown |
| `pageL2CacheLimit` | Max L2 entries (default **24**) |
| `pageL2Warm` | Idle-compile all destinations after startup |
| `pageLeaveSnapshot` | Freeze leave page while cold target loads |
| `navigateTo(i)` / `currentIndex` | Switch page |
| `pageHost` | Access `Md3PageHost` (e.g. `currentItem`) |

**Recommended (faster + lean):** `arc` + limit 2 + L2 + predict + leaveSnapshot + l2Warm; keep `pagePrefetch` off.

Destination extras: `cacheCost` (eviction weight), `cachePin` (never L1-evict once resident).

## Page cache strategy (`Md3PageHost`)

| Layer | Contents | Cost |
|-------|----------|------|
| L1 | Live `Item` trees (`keepFlags`) | High RAM, instant |
| L2 | `Qt.createComponent` map | Low RAM, skip re-parse |
| Leave snap | One `ShaderEffectSource` during cold wait | Temporary texture |
| Ghost | ARC B1/B2 indices only | Negligible |

`arc` uses Adaptive Replacement Cache (T1 recent / T2 frequent + ghosts) with cost-aware victims. Rail hover emits `destinationHovered` → L2 compile.

Without `destinations`, child content uses the custom content slot (previous behavior).

## Anatomy

| Element | Role |
|---------|------|
| **Md3ApplicationWindow** | Chrome + optional destinations shell |
| **Md3WindowBody** | Left rail + page host |
| **Md3PageHost** | Lazy Loader stack (unload inactive) |
| **Md3TitleBar** | Client title bar |
| **Md3CaptionButtons** | Min / Max / Close + snap hit-test |

## Title bar API

```qml
Md3ApplicationWindow {
    title: "App"
    windowIcon: "qrc:/md3/icons/app-icon.png"  // title bar + taskbar
    // …
    titleBar: Component {
        Md3TitleBar {
            title: window.title          // single line (Win-native)
            appIcon: window.windowIcon   // 16×16
            minTitleWidth: 120           // middle controls cannot squeeze this
            // middle content…
        }
    }
}
```

Change icon at runtime: `window.windowIcon = "qrc:/…/other.png"` updates title bar and taskbar together.

Open **Window** destination in Gallery to toggle immersive dark sync, Mica/Acrylic, border color, taskbar flash, Jump List, ThumbBar, tray, iconic thumbnail, and system menu live.

## Win11 Snap Layouts + native hits

On Windows, hovering the maximize button shows the native snap flyout. Title identity (icon + title) reports `HTCAPTION` for OS drag / Aero Snap.

1. Keep thick-frame styles (`WS_THICKFRAME` | maximize / sysmenu boxes) on the frameless HWND
2. `WM_NCCALCSIZE` → full client (no native caption chrome)
3. Report maximize button rect → `setMaximizeButtonRect` → `HTMAXBUTTON`
4. Report title block → `setCaptionHitRect` → `HTCAPTION`
5. Icon click / title-bar right-click → classic system menu

## Windows DWM extras

```qml
Md3ApplicationWindow {
    syncImmersiveDarkMode: true          // default — matches Md3Theme.dark
    systemBackdrop: 0                    // UNSUITABLE — leave None; API kept for research
    nativeBorderColor: ""                // "", "default", "none", or "#RRGGBB"
    // …
}
```

| API | Role |
|-----|------|
| `syncImmersiveDarkMode` | `DWMWA_USE_IMMERSIVE_DARK_MODE` |
| `systemBackdrop` | **UNSUITABLE** — Win11 Mica/Acrylic API retained but not recommended (Qt Quick hides DWM materials); keep `0` |
| `nativeBorderColor` | `DWMWA_BORDER_COLOR` |
| `flashTaskbar()` | Taskbar attention flash |
| `setTaskbarProgress(v, state)` | `ITaskbarList3` progress (0..1) |
| `setTaskbarOverlayIcon(url)` | Taskbar button overlay badge |
| `setExcludedFromPeek` / `setDisallowPeek` | Aero Peek controls |
| `setExcludeFromCapture` | `WDA_EXCLUDEFROMCAPTURE` |
| `setJumpListTasks` / `clearJumpList` | Taskbar Jump List user tasks |
| `setThumbBarButtons` | Taskbar thumbnail toolbar (max 7) |
| `setIconicThumbnail` | Custom Alt-Tab / taskbar iconic bitmap |
| `showSystemTrayIcon` / `showTrayNotification` | Tray icon + balloon |
| `setAlwaysOnTop` | `HWND_TOPMOST` |
| `setThumbnailClip` / `setThumbnailTooltip` | Taskbar live-preview region / tip |
| `moveToMonitor` / `monitorCount` | Multi-monitor placement |
| `setPreferredAppMode` | Dark/light menus (uxtheme) |
| `registerApplicationRestart` | WER restart after crash/update |
| `setWindowCloaked` | `DWMWA_CLOAK` |
| `windowDpr` / `windowDpi` | Per-monitor DPI (manifest: PerMonitorV2) |

### Source layout (Windows native)

| File | Role |
|------|------|
| `md3windowhelper.*` | QML API, bind, hit-test rects, DPI queries |
| `md3win_p.*` | Shared Win helpers + native event filter |
| `md3winchrome.cpp` | DWM chrome / peek / capture / AOT / monitors |
| `md3winicons.cpp` | `WM_SETICON` multi-size icons |
| `md3wintaskbar.cpp` | Taskbar / Jump List / ThumbBar / iconic |
| `md3wintray.cpp` | `Shell_NotifyIcon` tray |

Taskbar / Alt-Tab icon: set `windowIcon` (multi-size PNGs under `qrc:/md3/icons/`). On Windows the helper also sends `WM_SETICON`; the Gallery exe embeds `resources/app.rc` (`app-icon.ico` + DPI manifest).

Capability: `Md3WindowCapabilities.snapLayouts` / `captionHitTest` / `systemMenu` / `immersiveDarkMode` / `systemBackdrop` / `taskbarProgress` / `taskbarOverlay` / `peekControl` / `excludeFromCapture` / `jumpList` / `thumbBar` / `iconicThumbnail` / `systemTray` / `perMonitorDpiV2` (Windows).

## Capability matrix

| Capability | Windows | macOS | Linux | Mobile |
|------------|---------|-------|-------|--------|
| `customChrome` | yes | yes | yes | no |
| `captionButtons` | yes | no | yes | no |
| `trafficLightsInset` | 0 | 78 | 0 | 0 |
| `windowCornerRadius` | 12 | 10 | 12 | 0 |
| `roundedCorners` | yes | yes | yes | no |
| `systemMove` / resize | yes | yes | yes | no |
| `snapLayouts` | **yes** | — | — | — |
| `captionHitTest` | **yes** | — | **yes** (CSD) | — |
| `systemMenu` | **yes** | — | **yes** | — |
| `immersiveDarkMode` | **yes** | **yes** | **yes** | — |
| `systemBackdrop` | **yes** | soft | soft (alpha/blur hint) | — |
| `taskbarProgress` | **yes** | — | **yes** (LauncherEntry) | — |
| `taskbarOverlay` / peek / capture | **yes** | — | — | — |
| `jumpList` / `thumbBar` / iconic | **yes** | — | — | — |
| `systemTray` | **yes** | — | **yes** (SNI) | — |
| `alwaysOnTop` / accent | **yes** | partial | **yes** | — |
| `perMonitorDpi` / fractional scale | **yes** | — | **yes** | — |
| Dock badge / idle inhibit | badge | badge | **yes** | — |

Linux notes: Wayland taskbar icon comes from the `.desktop` file (`QGuiApplication::setDesktopFileName`); see `resources/linux/appQML_MD3.desktop`.

Radius is **0 while maximized/fullscreen**.

## Relationship to Scaffold / TopAppBar
- **TitleBar** = OS window chrome
- **Md3TopAppBar** / **Md3Scaffold** = in-app navigation
- Stack: TitleBar → optional TopAppBar → body

## Metrics

| Token | Typical |
|-------|---------|
| TitleBar height | 48 (32 compact) |
| Caption hit | 46 × bar height |
| Title-bar action | 40 × bar height |
| Resize edge | 6 |
| Corner radius | platform `windowCornerRadius` |

## A11y
Caption + theme + custom actions: named buttons. Title readable as window name.

## Gallery checklist
- [x] Gallery uses `Md3ApplicationWindow`
- [x] Default theme toggle on title bar
- [ ] Drag / double-click maximize / caption / Win11 snap flyout
- [ ] Restored window rounded; maximized square
- [x] Window page lists per-platform bags

## Out of scope (later)
Mica/Acrylic/vibrancy, dedicated mobile shell, Linux tiling DE snap UI
