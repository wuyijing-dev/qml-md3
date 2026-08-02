# Md3WindowHelper

Native window chrome / taskbar / tray / DPI.

- **Source:** `src/Md3/window/md3windowhelper.h`
- **Extends:** `QObject`
- **Kind:** C++ / QML_ELEMENT (generated from header)

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 28 | 0 | 77 | 3 |

## Import

```qml
import Md3
```

## Enums

### `Md3WindowHelper.SystemBackdrop`

`Md3WindowHelper.BackdropNone`, `Md3WindowHelper.BackdropAuto`, `Md3WindowHelper.BackdropMica`, `Md3WindowHelper.BackdropAcrylic`, `Md3WindowHelper.BackdropTabbed`

### `Md3WindowHelper.TaskbarProgressState`

`Md3WindowHelper.ProgressNoProgress`, `Md3WindowHelper.ProgressIndeterminate`, `Md3WindowHelper.ProgressNormal`, `Md3WindowHelper.ProgressError`, `Md3WindowHelper.ProgressPaused`

### `Md3WindowHelper.TrayActivation`

`Md3WindowHelper.TrayUnknown`, `Md3WindowHelper.TrayLeftClick`, `Md3WindowHelper.TrayLeftDoubleClick`, `Md3WindowHelper.TrayRightClick`, `Md3WindowHelper.TrayMiddleClick`, `Md3WindowHelper.TrayBalloonShown`, `Md3WindowHelper.TrayBalloonClicked`, `Md3WindowHelper.TrayBalloonTimeout`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `platformId` | `string` | `—` | readonly | `Md3WindowHelper` | Constant |
| `wayland` | `bool` | `—` | readonly | `Md3WindowHelper` | Constant |
| `xcb` | `bool` | `—` | readonly | `Md3WindowHelper` | Constant |
| `displayServer` | `string` | `—` | readonly | `Md3WindowHelper` | Constant |
| `trafficLightsInset` | `real` | `—` | readonly | `Md3WindowHelper` | Constant |
| `customChromeRecommended` | `bool` | `—` | readonly | `Md3WindowHelper` | Constant |
| `captionButtonsRecommended` | `bool` | `—` | readonly | `Md3WindowHelper` | Constant |
| `snapLayoutsSupported` | `bool` | `—` | readonly | `Md3WindowHelper` | Constant |
| `systemBackdropSupported` | `bool` | `—` | readonly | `Md3WindowHelper` | Constant |
| `systemMenuSupported` | `bool` | `—` | readonly | `Md3WindowHelper` | Constant |
| `immersiveDarkModeSupported` | `bool` | `—` | readonly | `Md3WindowHelper` | Constant |
| `taskbarProgressSupported` | `bool` | `—` | readonly | `Md3WindowHelper` | Constant |
| `taskbarOverlaySupported` | `bool` | `—` | readonly | `Md3WindowHelper` | Constant |
| `jumpListSupported` | `bool` | `—` | readonly | `Md3WindowHelper` | Constant |
| `thumbBarSupported` | `bool` | `—` | readonly | `Md3WindowHelper` | Constant |
| `iconicThumbnailSupported` | `bool` | `—` | readonly | `Md3WindowHelper` | Constant |
| `systemTraySupported` | `bool` | `—` | readonly | `Md3WindowHelper` | Constant |
| `perMonitorDpiV2Supported` | `bool` | `—` | readonly | `Md3WindowHelper` | Constant |
| `alwaysOnTopSupported` | `bool` | `—` | readonly | `Md3WindowHelper` | Constant |
| `thumbnailClipSupported` | `bool` | `—` | readonly | `Md3WindowHelper` | Constant |
| `applicationRestartSupported` | `bool` | `—` | readonly | `Md3WindowHelper` | Constant |
| `preferredAppModeSupported` | `bool` | `—` | readonly | `Md3WindowHelper` | Constant |
| `windowCloakSupported` | `bool` | `—` | readonly | `Md3WindowHelper` | Constant |
| `systemAccentSupported` | `bool` | `—` | readonly | `Md3WindowHelper` | Constant |
| `windowCornerRadius` | `real` | `—` | readonly | `Md3WindowHelper` | Constant |
| `roundedCornersRecommended` | `bool` | `—` | readonly | `Md3WindowHelper` | Constant |
| `systemCornersSupported` | `bool` | `—` | readonly | `Md3WindowHelper` | Constant |
| `lastNativeStatus` | `string` | `—` | readonly | `Md3WindowHelper` | Notify: `lastNativeStatusChanged` |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `bindWindow(QObject *window)` | `void` | `Md3WindowHelper` | Bind Window. |
| `unbindWindow(QObject *window)` | `void` | `Md3WindowHelper` | Unbind Window. |
| `applyCornerPreference(QObject *window, bool rounded)` | `void` | `Md3WindowHelper` | Apply Corner Preference. |
| `setMaximizeButtonRect(QObject *window, qreal x, qreal y, qreal w, qreal h)` | `void` | `Md3WindowHelper` | Set Maximize Button Rect. |
| `clearMaximizeButtonRect(QObject *window)` | `void` | `Md3WindowHelper` | Clear Maximize Button Rect. |
| `setSnapMaximizeRect(QObject *window, qreal x, qreal y, qreal w, qreal h)` | `void` | `Md3WindowHelper` | Set Snap Maximize Rect. |
| `clearSnapMaximizeRect(QObject *window)` | `void` | `Md3WindowHelper` | Clear Snap Maximize Rect. |
| `setSnapLayoutsArmed(QObject *window, bool armed)` | `void` | `Md3WindowHelper` | Set Snap Layouts Armed. |
| `setCaptionHitRect(QObject *window, qreal x, qreal y, qreal w, qreal h)` | `void` | `Md3WindowHelper` | Set Caption Hit Rect. |
| `clearCaptionHitRect(QObject *window)` | `void` | `Md3WindowHelper` | Clear Caption Hit Rect. |
| `setWindowIcon(QObject *window, const QUrl &iconUrl)` | `bool` | `Md3WindowHelper` | Set Window Icon. |
| `showSystemMenu(QObject *window, qreal globalX, qreal globalY)` | `void` | `Md3WindowHelper` | Show System Menu. |
| `setImmersiveDarkMode(QObject *window, bool dark)` | `void` | `Md3WindowHelper` | Set Immersive Dark Mode. |
| `setSystemBackdrop(QObject *window, int backdrop)` | `void` | `Md3WindowHelper` | Set System Backdrop. |
| `setBorderColor(QObject *window, const QString &cssColor)` | `void` | `Md3WindowHelper` | Set Border Color. |
| `setCaptionTextColor(QObject *window, const QString &cssColor)` | `void` | `Md3WindowHelper` | Set Caption Text Color. |
| `flashTaskbar(QObject *window, bool flash = true)` | `void` | `Md3WindowHelper` | Flash Taskbar. |
| `setAppUserModelId(const QString &appId)` | `bool` | `Md3WindowHelper` | Set App User Model Id. |
| `setTaskbarProgress(QObject *window, qreal value, int state = ProgressNormal)` | `void` | `Md3WindowHelper` | Set Taskbar Progress. |
| `clearTaskbarProgress(QObject *window)` | `void` | `Md3WindowHelper` | Clear Taskbar Progress. |
| `clearTaskbarOverlayIcon(QObject *window)` | `void` | `Md3WindowHelper` | Clear Taskbar Overlay Icon. |
| `setExcludedFromPeek(QObject *window, bool excluded)` | `void` | `Md3WindowHelper` | Set Excluded From Peek. |
| `setDisallowPeek(QObject *window, bool disallow)` | `void` | `Md3WindowHelper` | Set Disallow Peek. |
| `setExcludeFromCapture(QObject *window, bool exclude)` | `void` | `Md3WindowHelper` | Set Exclude From Capture. |
| `setJumpListTasks(const QVariantList &tasks)` | `bool` | `Md3WindowHelper` | Set Jump List Tasks. |
| `clearJumpList()` | `void` | `Md3WindowHelper` | Clear Jump List. |
| `setThumbBarButtons(QObject *window, const QVariantList &buttons)` | `bool` | `Md3WindowHelper` | Set Thumb Bar Buttons. |
| `clearThumbBarButtons(QObject *window)` | `void` | `Md3WindowHelper` | Clear Thumb Bar Buttons. |
| `setForceIconicRepresentation(QObject *window, bool enabled)` | `void` | `Md3WindowHelper` | Set Force Iconic Representation. |
| `setIconicThumbnail(QObject *window, const QUrl &imageUrl)` | `bool` | `Md3WindowHelper` | Set Iconic Thumbnail. |
| `clearIconicThumbnail(QObject *window)` | `void` | `Md3WindowHelper` | Clear Iconic Thumbnail. |
| `setThumbnailClip(QObject *window, qreal x, qreal y, qreal w, qreal h)` | `void` | `Md3WindowHelper` | Set Thumbnail Clip. |
| `clearThumbnailClip(QObject *window)` | `void` | `Md3WindowHelper` | Clear Thumbnail Clip. |
| `setThumbnailTooltip(QObject *window, const QString &text)` | `void` | `Md3WindowHelper` | Set Thumbnail Tooltip. |
| `hideSystemTrayIcon()` | `void` | `Md3WindowHelper` | Hide System Tray Icon. |
| `showTrayNotification(const QString &title, const QString &body, int timeoutMs = 5000)` | `bool` | `Md3WindowHelper` | Show Tray Notification. |
| `cursorScreenPos()` | `QPointF` | `Md3WindowHelper` | Cursor Screen Pos. |
| `setAlwaysOnTop(QObject *window, bool onTop)` | `void` | `Md3WindowHelper` | Set Always On Top. |
| `setWindowCloaked(QObject *window, bool cloaked)` | `void` | `Md3WindowHelper` | Set Window Cloaked. |
| `setPreferredAppMode(bool dark)` | `void` | `Md3WindowHelper` | Set Preferred App Mode. |
| `monitorCount()` | `int` | `Md3WindowHelper` | Monitor Count. |
| `moveToMonitor(QObject *window, int monitorIndex)` | `bool` | `Md3WindowHelper` | Move To Monitor. |
| `unregisterApplicationRestart()` | `void` | `Md3WindowHelper` | Unregister Application Restart. |
| `raiseWindow(QObject *window)` | `void` | `Md3WindowHelper` | Raise Window. |
| `setDockBadge(int count)` | `bool` | `Md3WindowHelper` | Set Dock Badge. |
| `blurBehindAvailable()` | `bool` | `Md3WindowHelper` | Blur Behind Available. |
| `openBlurSettings()` | `bool` | `Md3WindowHelper` | Open Blur Settings. |
| `systemAccentColor()` | `string` | `Md3WindowHelper` | System Accent Color. |
| `wallpaperSeedColor()` | `string` | `Md3WindowHelper` | Wallpaper Seed Color. |
| `devicePixelRatio(QObject *window)` | `real` | `Md3WindowHelper` | Device Pixel Ratio. |
| `windowDpi(QObject *window)` | `int` | `Md3WindowHelper` | Window Dpi. |
| `setPersistentSceneGraph(QObject *window, bool persistent)` | `void` | `Md3WindowHelper` | Set Persistent Scene Graph. |
| `openUrl(const QUrl &url)` | `bool` | `Md3WindowHelper` | Open Url. |
| `revealInFolder(const QUrl &pathOrUrl)` | `bool` | `Md3WindowHelper` | Reveal In Folder. |
| `beep()` | `void` | `Md3WindowHelper` | Beep. |
| `centerOnScreen(QObject *window)` | `bool` | `Md3WindowHelper` | Center On Screen. |
| `setWindowOpacity(QObject *window, qreal opacity)` | `bool` | `Md3WindowHelper` | Set Window Opacity. |
| `setVisibleInTaskbar(QObject *window, bool visible)` | `bool` | `Md3WindowHelper` | Set Visible In Taskbar. |
| `minimizeWindow(QObject *window)` | `void` | `Md3WindowHelper` | Minimize Window. |
| `maximizeWindow(QObject *window)` | `void` | `Md3WindowHelper` | Maximize Window. |
| `restoreWindow(QObject *window)` | `void` | `Md3WindowHelper` | Restore Window. |
| `setFullScreen(QObject *window, bool fullScreen)` | `void` | `Md3WindowHelper` | Set Full Screen. |
| `systemColorSchemeDark()` | `bool` | `Md3WindowHelper` | System Color Scheme Dark. |
| `vibrate(int durationMs = 40)` | `bool` | `Md3WindowHelper` | Vibrate. |
| `setImmersiveSystemUi(bool immersive)` | `bool` | `Md3WindowHelper` | Set Immersive System Ui. |
| `requestAttention(QObject *window, bool on = true)` | `void` | `Md3WindowHelper` | Request Attention. |
| `setScreenOrientation(const QString &mode)` | `bool` | `Md3WindowHelper` | Set Screen Orientation. |
| `showSoftInput()` | `bool` | `Md3WindowHelper` | Show Soft Input. |
| `hideSoftInput()` | `bool` | `Md3WindowHelper` | Hide Soft Input. |
| `setSoftInputAdjustResize(bool adjustResize)` | `bool` | `Md3WindowHelper` | Set Soft Input Adjust Resize. |
| `openAppSettings()` | `bool` | `Md3WindowHelper` | Open App Settings. |
| `nativeToast(const QString &message, int durationMs = 2000)` | `bool` | `Md3WindowHelper` | Native Toast. |
| `hapticFeedback(int kind = 0)` | `bool` | `Md3WindowHelper` | Haptic Feedback. |
| `requestIgnoreBatteryOptimizations()` | `bool` | `Md3WindowHelper` | Request Ignore Battery Optimizations. |
| `copyToClipboard(const QString &text)` | `bool` | `Md3WindowHelper` | Copy To Clipboard. |
| `clipboardText()` | `string` | `Md3WindowHelper` | Clipboard Text. |
| `openNotificationSettings()` | `bool` | `Md3WindowHelper` | Open Notification Settings. |

## Example

```qml
import Md3

// C++ / host type — typically used from QML as `Md3WindowHelper { }`
Md3WindowHelper {
    // see properties / methods above
}
```
