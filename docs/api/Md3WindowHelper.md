# Md3WindowHelper

- **Source:** `src/Md3/window/md3windowhelper.h`
- **QML:** `Md3WindowHelper` (`QML_ELEMENT`)
- **C++:** `#include "md3windowhelper.h"`

Native window chrome / taskbar / tray / DPI helpers used by `Md3ApplicationWindow`. Most apps use window QML properties instead of calling this directly.

## Enums

### `SystemBackdrop`

`BackdropNone`, `BackdropAuto`, `BackdropMica`, `BackdropAcrylic`, `BackdropTabbed`

### `TaskbarProgressState`

`ProgressNoProgress`, `ProgressIndeterminate`, `ProgressNormal`, `ProgressError`, `ProgressPaused`

### `TrayActivation`

`TrayUnknown`, `TrayLeftClick`, `TrayLeftDoubleClick`, `TrayRightClick`, `TrayMiddleClick`, `TrayBalloonShown`, `TrayBalloonClicked`, `TrayBalloonTimeout`

## Properties

| Name | Type | Access | Description |
|------|------|--------|-------------|
| `platformId` | `string` | readonly | Platform id string |
| `wayland` | `bool` | readonly | Running on Wayland |
| `xcb` | `bool` | readonly | Running on X11 |
| `trafficLightsInset` | `real` | readonly | macOS traffic-lights inset |
| `customChromeRecommended` | `bool` | readonly | Prefer custom title bar |
| `captionButtonsRecommended` | `bool` | readonly | Prefer in-client caption buttons |
| `snapLayoutsSupported` | `bool` | readonly | Windows snap layouts |
| `systemBackdropSupported` | `bool` | readonly | Mica/Acrylic etc. |
| `systemMenuSupported` | `bool` | readonly | Native system menu |
| `immersiveDarkModeSupported` | `bool` | readonly | Immersive dark title |
| `taskbarProgressSupported` | `bool` | readonly | Taskbar progress |
| `taskbarOverlaySupported` | `bool` | readonly | Overlay badge icon |
| `jumpListSupported` | `bool` | readonly | Jump list |
| `thumbBarSupported` | `bool` | readonly | Thumbnail toolbar |
| `iconicThumbnailSupported` | `bool` | readonly | Custom iconic thumbnail |
| `systemTraySupported` | `bool` | readonly | Tray icon |
| `perMonitorDpiV2Supported` | `bool` | readonly | Per-monitor DPI v2 |
| `alwaysOnTopSupported` | `bool` | readonly | Always-on-top |
| `thumbnailClipSupported` | `bool` | readonly | Live preview clip |
| `applicationRestartSupported` | `bool` | readonly | Register restart |
| `preferredAppModeSupported` | `bool` | readonly | Preferred app mode |
| `windowCloakSupported` | `bool` | readonly | Cloak window |
| `systemAccentSupported` | `bool` | readonly | System accent color |
| `windowCornerRadius` | `real` | readonly | Suggested corner radius |
| `roundedCornersRecommended` | `bool` | readonly | Prefer rounded corners |
| `lastNativeStatus` | `string` | readonly | Last native status message |

## Signals

| Signal | Description |
|--------|-------------|
| `thumbBarButtonClicked(int buttonId)` | Thumbnail toolbar button |
| `trayActivated(int reason)` | Tray activation (`TrayActivation`) |
| `dpiChanged(qreal devicePixelRatio, int dpi)` | DPI changed |
| `lastNativeStatusChanged()` | Status string updated |

## Methods

| Method | Description |
|--------|-------------|
| `bindWindow(window)` / `unbindWindow(window)` | Attach/detach native hooks |
| `applyCornerPreference(window, rounded)` | Rounded corner preference |
| `setMaximizeButtonRect(window, x, y, w, h)` / `clearMaximizeButtonRect(window)` | Maximize hit-test |
| `setCaptionHitRect(window, x, y, w, h)` / `clearCaptionHitRect(window)` | Caption drag region |
| `setWindowIcon(window, iconUrl)` | Window icon |
| `showSystemMenu(window, globalX, globalY)` | Native system menu |
| `setImmersiveDarkMode(window, dark)` | Immersive dark |
| `setSystemBackdrop(window, backdrop)` | `SystemBackdrop` |
| `setBorderColor(window, cssColor)` | Border color |
| `setCaptionTextColor(window, cssColor)` | Caption text color |
| `flashTaskbar(window, flash = true)` | Flash taskbar |
| `setAppUserModelId(appId)` | Windows AppUserModelID |
| `setTaskbarProgress(window, value, state)` / `clearTaskbarProgress(window)` | Progress |
| `setTaskbarOverlayIcon(window, iconUrl, description)` / `clearTaskbarOverlayIcon(window)` | Overlay |
| `setExcludedFromPeek` / `setDisallowPeek` / `setExcludeFromCapture` | Peek / capture |
| `setJumpListTasks(tasks)` / `clearJumpList()` | Jump list |
| `setThumbBarButtons(window, buttons)` / `clearThumbBarButtons(window)` | Thumb bar |
| `setForceIconicRepresentation` / `setIconicThumbnail` / `clearIconicThumbnail` | Iconic thumb |
| `setThumbnailClip` / `clearThumbnailClip` / `setThumbnailTooltip` | Live preview |
| `showSystemTrayIcon` / `hideSystemTrayIcon` / `showTrayNotification` | Tray |
| `setAlwaysOnTop(window, onTop)` | Always on top |
| `setWindowCloaked(window, cloaked)` | Cloak |
| `setPreferredAppMode(dark)` | Preferred mode |
| `monitorCount()` / `moveToMonitor(window, index)` | Multi-monitor |
| `registerApplicationRestart` / `unregisterApplicationRestart` | Restart manager |
| `raiseWindow(window)` | Raise + activate |
| `setDockBadge(count)` | Dock/taskbar badge |
| `setIdleInhibit(inhibit, reason)` | Inhibit idle (Linux) |
| `blurBehindAvailable()` / `openBlurSettings()` | Blur helpers |
| `systemAccentColor()` / `wallpaperSeedColor()` | Material You seeds |
| `devicePixelRatio(window)` / `windowDpi(window)` | DPI queries |
| `setPersistentSceneGraph(window, persistent)` | Keep SG when hidden |

Prefer the high-level APIs on [Md3ApplicationWindow](Md3ApplicationWindow.md) when possible.
