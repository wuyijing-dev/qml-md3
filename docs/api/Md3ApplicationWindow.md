# Md3ApplicationWindow

- **Source:** `src/Md3/window/Md3ApplicationWindow.qml`
- **Extends:** `Window`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 133 | 6 | 93 | 0 |

_Also inherits Qt Quick `Window` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `customChrome` | `bool` | `Md3WindowCapabilities.customChrome` | read/write | `Md3ApplicationWindow` | Custom Chrome. |
| `showTitleBar` | `bool` | `true` | read/write | `Md3ApplicationWindow` | Show Title Bar. |
| `adaptiveChrome` | `bool` | `true` | read/write | `Md3ApplicationWindow` | When true (default), chrome follows MD3 size class + mobile/desktop policy (Md3Adaptive). |
| `widthClass` | `int` | `Md3Adaptive.widthClassFor(width)` | readonly | `Md3ApplicationWindow` | Width Class. |
| `heightClass` | `int` | `Md3Adaptive.heightClassFor(height)` | readonly | `Md3ApplicationWindow` | Height Class. |
| `deviceClass` | `int` | `Md3Adaptive.deviceClassFor(width, height)` | readonly | `Md3ApplicationWindow` | Device Class. |
| `windowAppearance` | `int` | `Md3Adaptive.windowAppearanceFor(width, height)` | readonly | `Md3ApplicationWindow` | Window Appearance. |
| `widthClassName` | `string` | `Md3Adaptive.widthClassName(widthClass)` | readonly | `Md3ApplicationWindow` | Width Class Name. |
| `deviceClassName` | `string` | `Md3Adaptive.deviceClassName(deviceClass)` | readonly | `Md3ApplicationWindow` | Device Class Name. |
| `windowAppearanceName` | `string` | `Md3Adaptive.windowAppearanceName(windowAppearance)` | readonly | `Md3ApplicationWindow` | Window Appearance Name. |
| `useCustomChrome` | `bool` | `{…}` | readonly | `Md3ApplicationWindow` | Effective CSD flag after adaptive policy (use this instead of raw customChrome for chrome layout). |
| `preferCompactTitleBar` | `bool` | `adaptiveChrome` | readonly | `Md3ApplicationWindow` | Prefer Compact Title Bar. |
| `preferCaptionButtons` | `bool` | `adaptiveChrome` | readonly | `Md3ApplicationWindow` | Prefer Caption Buttons. |
| `preferNavigationBar` | `bool` | `Md3Adaptive.preferNavigationBar(width, height)` | readonly | `Md3ApplicationWindow` | Prefer Navigation Bar. |
| `preferNavigationRail` | `bool` | `Md3Adaptive.preferNavigationRail(width, height)` | readonly | `Md3ApplicationWindow` | Prefer Navigation Rail. |
| `roundedCorners` | `bool` | `Md3WindowCapabilities.roundedCorners` | read/write | `Md3ApplicationWindow` | Rounded Corners. |
| `cornerRadius` | `real` | `Md3WindowCapabilities.windowCornerRadius` | read/write | `Md3ApplicationWindow` | Corner radius. |
| `showWindowBorder` | `bool` | `true` | read/write | `Md3ApplicationWindow` | Show Window Border. |
| `titleBarItem` | `alias` | `titleBarLoader.item` | read/write | `Md3ApplicationWindow` | Title Bar Item. |
| `overlay` | `alias` | `overlayHost.data` | read/write | `Md3ApplicationWindow` | Overlay. |
| `overlayItem` | `alias` | `overlayHost` | read/write | `Md3ApplicationWindow` | Overlay Item. |
| `snackbarHostItem` | `alias` | `snackbarHost` | read/write | `Md3ApplicationWindow` | Snackbar Host Item. |
| `titleBar` | `Component` | `null` | read/write | `Md3ApplicationWindow` | Title Bar. |
| `windowIcon` | `url` | `Md3AppIcons.window` | read/write | `Md3ApplicationWindow` | App icon for title bar + taskbar / Alt-Tab (qrc or file URL). Default: Md3 bundled icon (resources/icons → qrc:/md3/icons/…). |
| `syncImmersiveDarkMode` | `bool` | `true` | read/write | `Md3ApplicationWindow` | Sync DWM immersive dark mode with Md3Theme.dark (Windows) |
| `systemBackdrop` | `int` | `0` | read/write | `Md3ApplicationWindow` | UNSUITABLE FOR PRODUCTION — kept for future research only. Qt Quick composition typically hides DWM Mica/Acrylic; prefer 0 (solid MD3 surface). 0=None 1=Auto 2=Mica 3=Acrylic 4=Tabbed |
| `nativeBorderColor` | `string` | `""` | read/write | `Md3ApplicationWindow` | DWM border color ("#RRGGBB", "none", "default", or "") |
| `usesSystemBackdrop` | `bool` | `systemBackdrop > 0` | readonly | `Md3ApplicationWindow` | Uses System Backdrop. |
| `backdropTint` | `real` | `0.08` | read/write | `Md3ApplicationWindow` | UNSUITABLE — wash over system backdrop; unused when systemBackdrop is 0. |
| `backdropContentTint` | `real` | `0.18` | read/write | `Md3ApplicationWindow` | Backdrop Content Tint. |
| `backdropTitleTint` | `real` | `0.06` | read/write | `Md3ApplicationWindow` | Backdrop Title Tint. |
| `showPinButton` | `bool` | `true` | read/write | `Md3ApplicationWindow` | Title-bar pin (always-on-top). On by default. |
| `pinned` | `bool` | `false` | read/write | `Md3ApplicationWindow` | Pinned. |
| `showAboutButton` | `bool` | `true` | read/write | `Md3ApplicationWindow` | Title-bar About (info) button → modeless About dialog |
| `aboutAppName` | `string` | `""` | read/write | `Md3ApplicationWindow` | About App Name. |
| `aboutVersion` | `string` | `""` | read/write | `Md3ApplicationWindow` | About Version. |
| `aboutOrganization` | `string` | `""` | read/write | `Md3ApplicationWindow` | About Organization. |
| `aboutText` | `string` | `""` | read/write | `Md3ApplicationWindow` | About Text. |
| `aboutIcon` | `url` | `""` | read/write | `Md3ApplicationWindow` | About Icon. |
| `aboutContent` | `Component` | `null` | read/write | `Md3ApplicationWindow` | About Content. |
| `themeRevealEnabled` | `bool` | `true` | read/write | `Md3ApplicationWindow` | Circular reveal when toggling light/dark (Material-style wipe from click) |
| `themeRevealBusy` | `bool` | `false` | read/write | `Md3ApplicationWindow` | Theme Reveal Busy. |
| `themeRevealDuration` | `int` | `Md3Motion.long2` | read/write | `Md3ApplicationWindow` | Theme Reveal Duration. |
| `themeRevealEasing` | `var` | `Md3Motion.emphasized` | read/write | `Md3ApplicationWindow` | Theme Reveal Easing. |
| `destinations` | `var` | `[]` | read/write | `Md3ApplicationWindow` | When non-empty, window hosts left rail + on-demand pages (no manual layout needed). |
| `currentIndex` | `int` | `0` | read/write | `Md3ApplicationWindow` | Current index. |
| `navigationRail` | `bool` | `true` | read/write | `Md3ApplicationWindow` | Navigation Rail. |
| `railExpanded` | `bool` | `false` | read/write | `Md3ApplicationWindow` | Rail Expanded. |
| `railHeader` | `string` | `""` | read/write | `Md3ApplicationWindow` | Rail Header. |
| `pageCacheMode` | `string` | `"arc"` | read/write | `Md3ApplicationWindow` | "none" \| "one" \| "lru" \| "all" \| "adaptive" \| "arc" Library default: arc + L1=1 + tiny L2 (snappy, low RSS). Override only if needed. |
| `pageCacheLimit` | `int` | `1` | read/write | `Md3ApplicationWindow` | Page Cache Limit. |
| `pageIdleTrimMs` | `int` | `4000` | read/write | `Md3ApplicationWindow` | Page Idle Trim Ms. |
| `pagePadding` | `real` | `Md3Theme.pagePadding` | read/write | `Md3ApplicationWindow` | Page Padding. |
| `pagePrefetch` | `bool` | `false` | read/write | `Md3ApplicationWindow` | Page Prefetch. |
| `pagePrefetchL1` | `bool` | `true` | read/write | `Md3ApplicationWindow` | With pagePrefetch: inflate neighbor L1 Items. False = warm neighbor Components (L2) only. |
| `pagePredictPrefetch` | `bool` | `false` | read/write | `Md3ApplicationWindow` | Page Predict Prefetch. |
| `pageL2Cache` | `bool` | `true` | read/write | `Md3ApplicationWindow` | Page L2Cache. |
| `pageL2CacheLimit` | `int` | `1` | read/write | `Md3ApplicationWindow` | Page L2Cache Limit. |
| `pageL2Warm` | `bool` | `false` | read/write | `Md3ApplicationWindow` | Idle L2 warm-all: pace-compile every destination Component (no live Item RSS). |
| `pageLeaveSnapshot` | `bool` | `false` | read/write | `Md3ApplicationWindow` | Page Leave Snapshot. |
| `pageAsync` | `bool` | `false` | read/write | `Md3ApplicationWindow` | Page Async. |
| `pageWarmStart` | `bool` | `false` | read/write | `Md3ApplicationWindow` | Page Warm Start. |
| `pageSourceBase` | `url` | `""` | read/write | `Md3ApplicationWindow` | Page Source Base. |
| `pageSourcePreferHotReload` | `bool` | `true` | read/write | `Md3ApplicationWindow` | When hotReload is on and the agent finds a disk `pages/` tree, use it as sourceBase. |
| `pageNavWarm` | `bool` | `false` | read/write | `Md3ApplicationWindow` | After first show: raise L1/L2 + neighbor prefetch (Gallery-style snappy shell). |
| `pageNavWarmDelayMs` | `int` | `80` | read/write | `Md3ApplicationWindow` | Page Nav Warm Delay Ms. |
| `pageNavWarmCacheLimit` | `int` | `6` | read/write | `Md3ApplicationWindow` | Page Nav Warm Cache Limit. |
| `pageNavWarmL2CacheLimit` | `int` | `-1` | read/write | `Md3ApplicationWindow` | -1 → max(32, destinations.length) |
| `pageNavWarmPrefetch` | `bool` | `true` | read/write | `Md3ApplicationWindow` | Page Nav Warm Prefetch. |
| `pageTransition` | `string` | `"fade"` | read/write | `Md3ApplicationWindow` | Page Transition. |
| `pageTransitionDuration` | `int` | `Md3Motion.medium2` | read/write | `Md3ApplicationWindow` | 350ms — iOS push-like |
| `pageSkeleton` | `bool` | `false` | read/write | `Md3ApplicationWindow` | Page Skeleton. |
| `pageHost` | `alias` | `windowBody.pageHost` | read/write | `Md3ApplicationWindow` | Page Host. |
| `shellRail` | `alias` | `windowBody.rail` | read/write | `Md3ApplicationWindow` | Shell Rail. |
| `progressiveContent` | `bool` | `true` | read/write | `Md3ApplicationWindow` | Within-page progressive sections (Md3DeferredSection). Default on. |
| `resolvedPageSourceBase` | `url` | `{…}` | readonly | `Md3ApplicationWindow` | Effective pages root for PageHost (hot-reload disk path or `pageSourceBase`). |
| `persistSession` | `bool` | `false` | read/write | `Md3ApplicationWindow` | Persist geometry / theme / shell via Md3AppSettings (QSettings). |
| `settingsOrganization` | `string` | `"QML_MD3"` | read/write | `Md3ApplicationWindow` | Settings Organization. |
| `settingsApplication` | `string` | `"Md3"` | read/write | `Md3ApplicationWindow` | Settings Application. |
| `sessionSaveDebounceMs` | `int` | `400` | read/write | `Md3ApplicationWindow` | Coalesce geometry/theme writes so title-bar drag does not hit QSettings every move tick. |
| `hotReload` | `bool` | `false` | read/write | `Md3ApplicationWindow` | Dev hot-reload of QML sources (file watcher + clearComponentCache). |
| `hotReloadAgent` | `alias` | `hotReloadInst` | read/write | `Md3ApplicationWindow` | Hot Reload Agent. |
| `showPerformanceButton` | `bool` | `true` | read/write | `Md3ApplicationWindow` | Built-in performance overlay (title-bar speed button + floating panel). |
| `showPerformanceOverlay` | `bool` | `false` | read/write | `Md3ApplicationWindow` | Show Performance Overlay. |
| `performanceDetached` | `bool` | `false` | read/write | `Md3ApplicationWindow` | Optional: pop the panel into its own non-modal window. |
| `performanceMonitor` | `alias` | `perfMonitor` | read/write | `Md3ApplicationWindow` | Performance Monitor. |
| `performancePanel` | `alias` | `perfPanel` | read/write | `Md3ApplicationWindow` | Performance Panel. |
| `shellInfoBarOpen` | `bool` | `false` | read/write | `Md3ApplicationWindow` | Persistent shell banner under the chrome (offline / sync) — not a Snackbar. |
| `shellInfoBarTitle` | `string` | `""` | read/write | `Md3ApplicationWindow` | Shell Info Bar Title. |
| `shellInfoBarMessage` | `string` | `""` | read/write | `Md3ApplicationWindow` | Shell Info Bar Message. |
| `shellInfoBarActionText` | `string` | `""` | read/write | `Md3ApplicationWindow` | Shell Info Bar Action Text. |
| `shellInfoBarSeverity` | `int` | `0` | read/write | `Md3ApplicationWindow` | Shell Info Bar Severity. |
| `documentTabsEnabled` | `bool` | `false` | read/write | `Md3ApplicationWindow` | Show Win11-style tab strip under the title bar. |
| `documentTabsManaged` | `bool` | `true` | read/write | `Md3ApplicationWindow` | Auto-handle activate / close / add / reorder / tear-off + sync with currentIndex. |
| `documentTabsCloseWindowWhenEmpty` | `bool` | `false` | read/write | `Md3ApplicationWindow` | Close this window when the last tab is closed (typical for torn-off windows). |
| `documentTabs` | `var` | `[]` | read/write | `Md3ApplicationWindow` | Document Tabs. |
| `documentTabIndex` | `int` | `0` | read/write | `Md3ApplicationWindow` | Document Tab Index. |
| `documentTabsClosable` | `bool` | `true` | read/write | `Md3ApplicationWindow` | Document Tabs Closable. |
| `documentTabsTearOff` | `bool` | `true` | read/write | `Md3ApplicationWindow` | Drag a tab outside the window to spawn a peer `Md3TabWindow`. |
| `documentTabsShowAdd` | `bool` | `true` | read/write | `Md3ApplicationWindow` | Document Tabs Show Add. |
| `unifiedTitleChrome` | `bool` | `true` | read/write | `Md3ApplicationWindow` | Paint title bar + document tabs as one chrome strip (same surfaceContainer). |
| `documentTabBar` | `alias` | `docTabBar` | read/write | `Md3ApplicationWindow` | Document Tab Bar. |
| `toolBar` | `alias` | `toolBarSlot.data` | read/write | `Md3ApplicationWindow` | App-top tool strip between tabs/titlebar and content. |
| `toolBarItem` | `alias` | `toolBarSlot` | read/write | `Md3ApplicationWindow` | Tool Bar Item. |
| `toolBarHeight` | `real` | `toolBarSlot.visible ? toolBarSlot.height : 0` | readonly | `Md3ApplicationWindow` | Tool Bar Height. |
| `statusBar` | `alias` | `statusBarSlot.data` | read/write | `Md3ApplicationWindow` | App-bottom status strip (e.g. Md3StatusBar). Spans full content width. |
| `statusBarItem` | `alias` | `statusBarSlot` | read/write | `Md3ApplicationWindow` | Status Bar Item. |
| `statusBarHeight` | `real` | `statusBarSlot.visible ? statusBarSlot.height : 0` | readonly | `Md3ApplicationWindow` | Status Bar Height. |
| `usesDestinations` | `bool` | `destinations && destinations.length > 0` | readonly | `Md3ApplicationWindow` | Uses Destinations. |
| `showTitleBackButton` | `bool` | `navigationRail && usesDestinations` | read/write | `Md3ApplicationWindow` | Title-bar back when navigation rail + destinations shell are active. |
| `canGoBack` | `bool` | `usesDestinations && windowBody.canGoBack` | readonly | `Md3ApplicationWindow` | Can Go Back. |
| `navDepth` | `int` | `usesDestinations ? windowBody.navDepth : 0` | readonly | `Md3ApplicationWindow` | Nav Depth. |
| `routeParams` | `var` | `{…}` | readonly | `Md3ApplicationWindow` | Route Params. |
| `chromeStripColor` | `color` | `{…}` | readonly | `Md3ApplicationWindow` | Chrome Strip Color. |
| `layoutMode` | `int` | `Md3ContainerBody.Fit` | read/write | `Md3ApplicationWindow` | Layout Mode. |
| `content` | `alias` | `customContent.content` | default read/write | `Md3ApplicationWindow` | Content. |
| `isMaximizedLike` | `bool` | `visibility === Window.Maximized` | readonly | `Md3ApplicationWindow` | Is Maximized Like. |
| `effectiveRadius` | `real` | `{…}` | readonly | `Md3ApplicationWindow` | Effective Radius. |
| `usesSystemCorners` | `bool` | `Md3WindowCapabilities.systemCorners` | readonly | `Md3ApplicationWindow` | OS clips the window frame (Win DWM / macOS layer) — skip MultiEffect chrome FBO. |
| `useTransparentFrame` | `bool` | `useCustomChrome && effectiveRadius > 0` | readonly | `Md3ApplicationWindow` | Use Transparent Frame. |
| `chromeMaskActive` | `bool` | `effectiveRadius > 0` | readonly | `Md3ApplicationWindow` | Client mask FBO only when the OS cannot clip the silhouette. |
| `windowNative` | `alias` | `windowHelper` | read/write | `Md3ApplicationWindow` | Access native helper (signals: thumbBarButtonClicked, trayActivated, dpiChanged). |
| `chromeTop` | `real` | `chromeHost.height` | readonly | `Md3ApplicationWindow` | Chrome Top. |
| `edge` | `real` | `6` | readonly | `Md3ApplicationWindow` | Edge. |
| `canResize` | `bool` | `useCustomChrome && Md3WindowCapabilities.systemResize` | readonly | `Md3ApplicationWindow` | Can Resize. |
| `chromeTopReserve` | `real` | `(showTitleBar && useCustomChrome) ? chromeHost.height : 0` | readonly | `Md3ApplicationWindow` | Keep QML resize grips off the title-bar caption strip (min/max/close). |
| `chromeRightReserve` | `real` | `{…}` | readonly | `Md3ApplicationWindow` | Chrome Right Reserve. |
| `themeRevealCx` | `real` | `0` | read/write | `Md3ApplicationWindow` | Theme Reveal Cx. |
| `themeRevealCy` | `real` | `0` | read/write | `Md3ApplicationWindow` | Theme Reveal Cy. |
| `themeRevealRadius` | `real` | `0` | read/write | `Md3ApplicationWindow` | Theme Reveal Radius. |
| `windowDpr` | `real` | `windowHelper.devicePixelRatio(root)` | readonly | `Md3ApplicationWindow` | Window Dpr. |
| `windowDpi` | `int` | `windowHelper.windowDpi(root)` | readonly | `Md3ApplicationWindow` | Window Dpi. |
| `monitorCount` | `int` | `windowHelper.monitorCount()` | readonly | `Md3ApplicationWindow` | Monitor Count. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `shellInfoBarActionClicked()` | `Md3ApplicationWindow` | Emitted when shell Info Bar Action Clicked. |
| `documentTabActivated(int index)` | `Md3ApplicationWindow` | Emitted when document Tab Activated. |
| `documentTabCloseRequested(int index)` | `Md3ApplicationWindow` | Emitted when document Tab Close Requested. |
| `documentTabAddRequested()` | `Md3ApplicationWindow` | Emitted when document Tab Add Requested. |
| `documentTabMoved(int from, int to)` | `Md3ApplicationWindow` | Emitted when document Tab Moved. |
| `documentTabTearOff(int index, real globalX, real globalY)` | `Md3ApplicationWindow` | Emitted when document Tab Tear Off. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `showShellInfoBar(message, options)` | `—` | `Md3ApplicationWindow` | Show the window shell InfoBar. |
| `dismissShellInfoBar()` | `—` | `Md3ApplicationWindow` | Dismiss the window shell InfoBar. |
| `navigateTo(index, opts)` | `—` | `Md3ApplicationWindow` | Navigate To. |
| `pushRoute(index, params, opts)` | `—` | `Md3ApplicationWindow` | Push Route. |
| `goBack(opts)` | `—` | `Md3ApplicationWindow` | Go Back. |
| `replaceRoute(index, params, opts)` | `—` | `Md3ApplicationWindow` | Replace Route. |
| `showStatusMessage(message, timeout)` | `—` | `Md3ApplicationWindow` | Show Status Message. |
| `documentTabMeta(pageIndex)` | `—` | `Md3ApplicationWindow` | Document Tab Meta. |
| `openTab(pageIndex, asNew)` | `—` | `Md3ApplicationWindow` | Open Tab. |
| `addTab(pageIndex)` | `—` | `Md3ApplicationWindow` | Add Tab. |
| `closeTab(index)` | `—` | `Md3ApplicationWindow` | Close Tab. |
| `moveTab(from, to)` | `—` | `Md3ApplicationWindow` | Move Tab. |
| `activateTab(index)` | `—` | `Md3ApplicationWindow` | Activate Tab. |
| `tearOffTab(index, globalX, globalY)` | `—` | `Md3ApplicationWindow` | Drag-out: remove tab from this window and open it in a new `Md3TabWindow`. |
| `toggleThemeAt(x, y)` | `—` | `Md3ApplicationWindow` | Toggle theme with circular reveal from a point in chrome / contentItem coords. |
| `toggleThemeFrom(item)` | `—` | `Md3ApplicationWindow` | Toggle theme revealing from the center of `item` (mapped into the window chrome). |
| `openAbout()` | `—` | `Md3ApplicationWindow` | Open modeless About dialog (also used by Md3TitleBar info button). |
| `applyPageNavWarm()` | `—` | `Md3ApplicationWindow` | Raise L1/L2 caches after shell paint (`pageNavWarm`). |
| `showSnackbar(message, options)` | `—` | `Md3ApplicationWindow` | Enqueue a snackbar on the window host. options: { actionText, dualLine, durationMs, id, priority } |
| `showToast(message, options)` | `—` | `Md3ApplicationWindow` | Toast. options: { severity, durationMs, position, id } |
| `restoreSession()` | `—` | `Md3ApplicationWindow` | Restore Session. |
| `saveSession()` | `—` | `Md3ApplicationWindow` | Save Session. |
| `reloadCurrentPage()` | `—` | `Md3ApplicationWindow` | Reload Current Page. |
| `toCssColor(c)` | `—` | `Md3ApplicationWindow` | Hex helper for Gallery / apps (accepts color or string). |
| `setNativeBorderColor(c)` | `—` | `Md3ApplicationWindow` | Set Native Border Color. |
| `setSystemBackdropMode(mode)` | `—` | `Md3ApplicationWindow` | UNSUITABLE FOR PRODUCTION — API retained; Gallery no longer exposes it. |
| `flashTaskbar(flash)` | `—` | `Md3ApplicationWindow` | Flash the Windows taskbar button (attention). |
| `setTaskbarProgress(value, state)` | `—` | `Md3ApplicationWindow` | Set Taskbar Progress. |
| `clearTaskbarProgress()` | `—` | `Md3ApplicationWindow` | Clear Taskbar Progress. |
| `setTaskbarOverlayIcon(iconUrl, description)` | `—` | `Md3ApplicationWindow` | Set Taskbar Overlay Icon. |
| `clearTaskbarOverlayIcon()` | `—` | `Md3ApplicationWindow` | Clear Taskbar Overlay Icon. |
| `setExcludedFromPeek(excluded)` | `—` | `Md3ApplicationWindow` | Set Excluded From Peek. |
| `setDisallowPeek(disallow)` | `—` | `Md3ApplicationWindow` | Set Disallow Peek. |
| `setExcludeFromCapture(exclude)` | `—` | `Md3ApplicationWindow` | Set Exclude From Capture. |
| `setJumpListTasks(tasks)` | `—` | `Md3ApplicationWindow` | Set Jump List Tasks. |
| `clearJumpList()` | `—` | `Md3ApplicationWindow` | Clear Jump List. |
| `setThumbBarButtons(buttons)` | `—` | `Md3ApplicationWindow` | Set Thumb Bar Buttons. |
| `clearThumbBarButtons()` | `—` | `Md3ApplicationWindow` | Clear Thumb Bar Buttons. |
| `setForceIconicRepresentation(enabled)` | `—` | `Md3ApplicationWindow` | Set Force Iconic Representation. |
| `setIconicThumbnail(imageUrl)` | `—` | `Md3ApplicationWindow` | Set Iconic Thumbnail. |
| `clearIconicThumbnail()` | `—` | `Md3ApplicationWindow` | Clear Iconic Thumbnail. |
| `showSystemTrayIcon(iconUrl, tooltip)` | `—` | `Md3ApplicationWindow` | Show System Tray Icon. |
| `hideSystemTrayIcon()` | `—` | `Md3ApplicationWindow` | Hide System Tray Icon. |
| `showTrayNotification(titleText, body, timeoutMs)` | `—` | `Md3ApplicationWindow` | Show Tray Notification. |
| `cursorScreenPos()` | `—` | `Md3ApplicationWindow` | Cursor Screen Pos. |
| `setAlwaysOnTop(onTop)` | `—` | `Md3ApplicationWindow` | Set Always On Top. |
| `raiseWindow()` | `—` | `Md3ApplicationWindow` | Raise Window. |
| `setDockBadge(count)` | `—` | `Md3ApplicationWindow` | Set Dock Badge. |
| `setIdleInhibit(inhibit, reason)` | `—` | `Md3ApplicationWindow` | Set Idle Inhibit. |
| `openUrl(url)` | `—` | `Md3ApplicationWindow` | Open Url. |
| `revealInFolder(pathOrUrl)` | `—` | `Md3ApplicationWindow` | Reveal In Folder. |
| `beep()` | `—` | `Md3ApplicationWindow` | Beep. |
| `centerOnScreen()` | `—` | `Md3ApplicationWindow` | Center On Screen. |
| `setWindowOpacity(opacity)` | `—` | `Md3ApplicationWindow` | Set Window Opacity. |
| `setVisibleInTaskbar(visible)` | `—` | `Md3ApplicationWindow` | Set Visible In Taskbar. |
| `minimizeWindow()` | `—` | `Md3ApplicationWindow` | Minimize Window. |
| `maximizeWindow()` | `—` | `Md3ApplicationWindow` | Maximize Window. |
| `restoreWindow()` | `—` | `Md3ApplicationWindow` | Restore Window. |
| `setFullScreen(fullScreen)` | `—` | `Md3ApplicationWindow` | Set Full Screen. |
| `systemColorSchemeDark()` | `—` | `Md3ApplicationWindow` | System Color Scheme Dark. |
| `shareText(text, title)` | `—` | `Md3ApplicationWindow` | Share Text. |
| `vibrate(durationMs)` | `—` | `Md3ApplicationWindow` | Vibrate. |
| `setImmersiveSystemUi(immersive)` | `—` | `Md3ApplicationWindow` | Set Immersive System Ui. |
| `requestAttention(on)` | `—` | `Md3ApplicationWindow` | Request Attention. |
| `openBlurSettings()` | `—` | `Md3ApplicationWindow` | Open Blur Settings. |
| `setWindowCloaked(cloaked)` | `—` | `Md3ApplicationWindow` | Set Window Cloaked. |
| `setPreferredAppMode(dark)` | `—` | `Md3ApplicationWindow` | Set Preferred App Mode. |
| `moveToMonitor(index)` | `—` | `Md3ApplicationWindow` | Move To Monitor. |
| `setThumbnailClip(x, y, w, h)` | `—` | `Md3ApplicationWindow` | Set Thumbnail Clip. |
| `clearThumbnailClip()` | `—` | `Md3ApplicationWindow` | Clear Thumbnail Clip. |
| `setThumbnailTooltip(text)` | `—` | `Md3ApplicationWindow` | Set Thumbnail Tooltip. |
| `registerApplicationRestart(args)` | `—` | `Md3ApplicationWindow` | Register Application Restart. |
| `unregisterApplicationRestart()` | `—` | `Md3ApplicationWindow` | Unregister Application Restart. |
| `requestSingleInstanceLock(id)` | `—` | `Md3ApplicationWindow` | Request Single Instance Lock. |
| `setOpenAtLoginEnabled(enabled, openAsHidden)` | `—` | `Md3ApplicationWindow` | Set Open At Login Enabled. |
| `registerGlobalShortcut(id, accelerator)` | `—` | `Md3ApplicationWindow` | Register Global Shortcut. |
| `unregisterGlobalShortcut(id)` | `—` | `Md3ApplicationWindow` | Unregister Global Shortcut. |
| `setAsDefaultProtocolClient(scheme, path, args)` | `—` | `Md3ApplicationWindow` | Set As Default Protocol Client. |
| `removeAsDefaultProtocolClient(scheme)` | `—` | `Md3ApplicationWindow` | Remove As Default Protocol Client. |
| `getPath(name)` | `—` | `Md3ApplicationWindow` | Get Path. |
| `setSystemBarColors(statusCss, navCss, lightIcons)` | `—` | `Md3ApplicationWindow` | Set System Bar Colors. |
| `setScreenOrientation(mode)` | `—` | `Md3ApplicationWindow` | Set Screen Orientation. |
| `showSoftInput()` | `—` | `Md3ApplicationWindow` | Show Soft Input. |
| `hideSoftInput()` | `—` | `Md3ApplicationWindow` | Hide Soft Input. |
| `setSoftInputAdjustResize(enable)` | `—` | `Md3ApplicationWindow` | Set Soft Input Adjust Resize. |
| `openAppSettings()` | `—` | `Md3ApplicationWindow` | Open App Settings. |
| `nativeToast(message, durationMs)` | `—` | `Md3ApplicationWindow` | Native Toast. |
| `hapticFeedback(kind)` | `—` | `Md3ApplicationWindow` | Haptic Feedback. |
| `requestIgnoreBatteryOptimizations()` | `—` | `Md3ApplicationWindow` | Request Ignore Battery Optimizations. |
| `shareFile(fileUrl, mimeType, titleText)` | `—` | `Md3ApplicationWindow` | Share File. |
| `copyToClipboard(text)` | `—` | `Md3ApplicationWindow` | Copy To Clipboard. |
| `clipboardText()` | `—` | `Md3ApplicationWindow` | Clipboard Text. |
| `openNotificationSettings()` | `—` | `Md3ApplicationWindow` | Open Notification Settings. |

## Example

```qml
import Md3

Md3ApplicationWindow {
    customChrome: Md3WindowCapabilities.customChrome
    showTitleBar: true
    adaptiveChrome: true
    roundedCorners: Md3WindowCapabilities.roundedCorners
    cornerRadius: Md3WindowCapabilities.windowCornerRadius
    showWindowBorder: true
}
```
