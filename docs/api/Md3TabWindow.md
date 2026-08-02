# Md3TabWindow

Peer window spawned by document-tab tear-off (`Md3ApplicationWindow.tearOffTab`). Uses the normal title bar + tab strip (browserChrome was removed).

- **Source:** `src/Md3/window/Md3TabWindow.qml`
- **Extends:** `Md3ApplicationWindow`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 3 | 0 | 0 | 0 |

## Import

```qml
import Md3
```

## Inheritance

[`Md3TabWindow`](Md3TabWindow.md) → [`Md3ApplicationWindow`](Md3ApplicationWindow.md)

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `catalog` | `var` | `[]` | read/write | `Md3TabWindow` | Catalog. |
| `initialTabs` | `var` | `[]` | read/write | `Md3TabWindow` | Initial Tabs. |
| `initialTabIndex` | `int` | `0` | read/write | `Md3TabWindow` | Initial Tab Index. |
| `customChrome` | `bool` | `Md3WindowCapabilities.customChrome` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Custom Chrome. |
| `showTitleBar` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Show Title Bar. |
| `adaptiveChrome` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | When true (default), chrome follows MD3 size class + mobile/desktop policy (Md3Adaptive). |
| `widthClass` | `int` | `Md3Adaptive.widthClassFor(width)` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Width Class. |
| `heightClass` | `int` | `Md3Adaptive.heightClassFor(height)` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Height Class. |
| `deviceClass` | `int` | `Md3Adaptive.deviceClassFor(width, height)` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Device Class. |
| `windowAppearance` | `int` | `Md3Adaptive.windowAppearanceFor(width, height)` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Window Appearance. |
| `widthClassName` | `string` | `Md3Adaptive.widthClassName(widthClass)` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Width Class Name. |
| `deviceClassName` | `string` | `Md3Adaptive.deviceClassName(deviceClass)` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Device Class Name. |
| `windowAppearanceName` | `string` | `Md3Adaptive.windowAppearanceName(windowAppearance)` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Window Appearance Name. |
| `useCustomChrome` | `bool` | `{…}` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Effective CSD flag after adaptive policy (use this instead of raw customChrome for chrome layout). |
| `preferCompactTitleBar` | `bool` | `adaptiveChrome` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Prefer Compact Title Bar. |
| `preferCaptionButtons` | `bool` | `adaptiveChrome` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Prefer Caption Buttons. |
| `preferNavigationBar` | `bool` | `Md3Adaptive.preferNavigationBar(width, height)` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Prefer Navigation Bar. |
| `preferNavigationRail` | `bool` | `Md3Adaptive.preferNavigationRail(width, height)` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Prefer Navigation Rail. |
| `roundedCorners` | `bool` | `Md3WindowCapabilities.roundedCorners` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Rounded Corners. |
| `cornerRadius` | `real` | `Md3WindowCapabilities.windowCornerRadius` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Corner radius. |
| `showWindowBorder` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Show Window Border. |
| `titleBarItem` | `alias` | `titleBarLoader.item` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Title Bar Item. |
| `overlay` | `alias` | `overlayHost.data` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Overlay. |
| `overlayItem` | `alias` | `overlayHost` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Overlay Item. |
| `snackbarHostItem` | `alias` | `snackbarHost` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Snackbar Host Item. |
| `titleBar` | `Component` | `null` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Title Bar. |
| `windowIcon` | `url` | `Md3AppIcons.window` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | App icon for title bar + taskbar / Alt-Tab (qrc or file URL). Default: Md3 bundled icon (resources/icons → qrc:/md3/icons/…). |
| `syncImmersiveDarkMode` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Sync DWM immersive dark mode with Md3Theme.dark (Windows) |
| `systemBackdrop` | `int` | `0` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | UNSUITABLE FOR PRODUCTION — kept for future research only. Qt Quick composition typically hides DWM Mica/Acrylic; prefer 0 (solid MD3 surface). 0=None 1=Auto 2=Mica 3=Acrylic 4=Tabbed |
| `nativeBorderColor` | `string` | `""` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | DWM border color ("#RRGGBB", "none", "default", or "") |
| `usesSystemBackdrop` | `bool` | `systemBackdrop > 0` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Uses System Backdrop. |
| `backdropTint` | `real` | `0.08` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | UNSUITABLE — wash over system backdrop; unused when systemBackdrop is 0. |
| `backdropContentTint` | `real` | `0.18` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Backdrop Content Tint. |
| `backdropTitleTint` | `real` | `0.06` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Backdrop Title Tint. |
| `showPinButton` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Title-bar pin (always-on-top). On by default. |
| `pinned` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Pinned. |
| `showAboutButton` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Title-bar About (info) button → modeless About dialog |
| `aboutAppName` | `string` | `""` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | About App Name. |
| `aboutVersion` | `string` | `""` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | About Version. |
| `aboutOrganization` | `string` | `""` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | About Organization. |
| `aboutText` | `string` | `""` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | About Text. |
| `aboutIcon` | `url` | `""` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | About Icon. |
| `aboutContent` | `Component` | `null` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | About Content. |
| `aboutDialogHeight` | `real` | `420` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | About dialog height (taller when shipping changelog in aboutContent). |
| `aboutDialogWidth` | `real` | `420` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | About Dialog Width. |
| `themeRevealEnabled` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Circular reveal when toggling light/dark (Material-style wipe from click) |
| `themeRevealBusy` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Theme Reveal Busy. |
| `themeRevealDuration` | `int` | `Md3Motion.long2` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Theme Reveal Duration. |
| `themeRevealEasing` | `var` | `Md3Motion.emphasized` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Theme Reveal Easing. |
| `defaultShowFocusRings` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Fallback for `a11y/showFocusRings` when QSettings has no value yet. Mouse-first desktop apps often set `false`; keyboard-first / Gallery leave default `true`. |
| `destinations` | `var` | `[]` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | When non-empty, window hosts left rail + on-demand pages (no manual layout needed). |
| `currentIndex` | `int` | `0` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Current index. |
| `navigationRail` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Navigation Rail. |
| `railExpanded` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Rail Expanded. |
| `railHeader` | `string` | `""` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Rail Header. |
| `pageCacheMode` | `string` | `"arc"` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | "none" \| "one" \| "lru" \| "all" \| "adaptive" \| "arc" Library default: arc + L1=1 + tiny L2 (snappy, low RSS). Override only if needed. |
| `pageCacheLimit` | `int` | `1` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Page Cache Limit. |
| `pageIdleTrimMs` | `int` | `4000` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Page Idle Trim Ms. |
| `pagePadding` | `real` | `Md3Theme.pagePadding` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Page Padding. |
| `pagePrefetch` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Page Prefetch. |
| `pagePrefetchL1` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | With pagePrefetch: inflate neighbor L1 Items. False = warm neighbor Components (L2) only. |
| `pagePredictPrefetch` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Page Predict Prefetch. |
| `pageL2Cache` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Page L2Cache. |
| `pageL2CacheLimit` | `int` | `1` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Page L2Cache Limit. |
| `pageL2Warm` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Idle L2 warm-all: pace-compile every destination Component (no live Item RSS). |
| `pageLeaveSnapshot` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Page Leave Snapshot. |
| `pageAsync` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Page Async. |
| `pageWarmStart` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Page Warm Start. |
| `pageSourceBase` | `url` | `""` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Page Source Base. |
| `pageSourcePreferHotReload` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | When hotReload is on and the agent finds a disk `pages/` tree, use it as sourceBase. |
| `pageNavWarm` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | After first show: raise L1/L2 + neighbor prefetch (Gallery-style snappy shell). |
| `pageNavWarmDelayMs` | `int` | `80` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Page Nav Warm Delay Ms. |
| `pageNavWarmCacheLimit` | `int` | `6` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Page Nav Warm Cache Limit. |
| `pageNavWarmL2CacheLimit` | `int` | `-1` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | -1 → max(32, destinations.length) |
| `pageNavWarmPrefetch` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Page Nav Warm Prefetch. |
| `pageTransition` | `string` | `"fade"` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Page Transition. |
| `pageTransitionDuration` | `int` | `Md3Motion.medium2` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | 350ms — iOS push-like |
| `pageSkeleton` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Page Skeleton. |
| `pageHost` | `alias` | `windowBody.pageHost` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Page Host. |
| `shellRail` | `alias` | `windowBody.rail` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Shell Rail. |
| `progressiveContent` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Within-page progressive sections (Md3DeferredSection). Default on. |
| `resolvedPageSourceBase` | `url` | `{…}` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Effective pages root for PageHost (hot-reload disk path or `pageSourceBase`). |
| `persistSession` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Persist geometry / theme / shell via Md3AppSettings (QSettings). |
| `settingsOrganization` | `string` | `"QML_MD3"` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Settings Organization. |
| `settingsApplication` | `string` | `"Md3"` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Settings Application. |
| `sessionSaveDebounceMs` | `int` | `400` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Coalesce geometry/theme writes so title-bar drag does not hit QSettings every move tick. |
| `hotReload` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Dev hot-reload of QML sources (file watcher + clearComponentCache). |
| `hotReloadAgent` | `alias` | `hotReloadInst` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Hot Reload Agent. |
| `showPerformanceButton` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Built-in performance overlay (title-bar speed button + floating panel). |
| `showPerformanceOverlay` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Show Performance Overlay. |
| `performanceDetached` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Optional: pop the panel into its own non-modal window. |
| `performanceMonitor` | `alias` | `perfMonitor` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Performance Monitor. |
| `performancePanel` | `alias` | `perfPanel` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Performance Panel. |
| `shellInfoBarOpen` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Persistent shell banner under the chrome (offline / sync) — not a Snackbar. |
| `shellInfoBarTitle` | `string` | `""` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Shell Info Bar Title. |
| `shellInfoBarMessage` | `string` | `""` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Shell Info Bar Message. |
| `shellInfoBarActionText` | `string` | `""` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Shell Info Bar Action Text. |
| `shellInfoBarSeverity` | `int` | `0` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Shell Info Bar Severity. |
| `documentTabsEnabled` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Show Win11-style tab strip under the title bar. |
| `documentTabsManaged` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Auto-handle activate / close / add / reorder / tear-off + sync with currentIndex. |
| `documentTabsCloseWindowWhenEmpty` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Close this window when the last tab is closed (typical for torn-off windows). |
| `documentTabs` | `var` | `[]` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Document Tabs. |
| `documentTabIndex` | `int` | `0` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Document Tab Index. |
| `documentTabsClosable` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Document Tabs Closable. |
| `documentTabsTearOff` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Drag a tab outside the window to spawn a peer `Md3TabWindow`. |
| `documentTabsShowAdd` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Document Tabs Show Add. |
| `unifiedTitleChrome` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Paint title bar + document tabs as one chrome strip (same surfaceContainer). |
| `documentTabBar` | `alias` | `docTabBar` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Document Tab Bar. |
| `toolBar` | `alias` | `toolBarSlot.data` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | App-top tool strip between tabs/titlebar and content. |
| `toolBarItem` | `alias` | `toolBarSlot` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Tool Bar Item. |
| `toolBarHeight` | `real` | `toolBarSlot.visible ? toolBarSlot.height : 0` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Tool Bar Height. |
| `statusBar` | `alias` | `statusBarSlot.data` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | App-bottom status strip (e.g. Md3StatusBar). Spans full content width. |
| `statusBarItem` | `alias` | `statusBarSlot` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Status Bar Item. |
| `statusBarHeight` | `real` | `statusBarSlot.visible ? statusBarSlot.height : 0` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Status Bar Height. |
| `usesDestinations` | `bool` | `destinations && destinations.length > 0` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Uses Destinations. |
| `showTitleBackButton` | `bool` | `navigationRail && usesDestinations` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Title-bar back when navigation rail + destinations shell are active. |
| `canGoBack` | `bool` | `usesDestinations && windowBody.canGoBack` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Can Go Back. |
| `navDepth` | `int` | `usesDestinations ? windowBody.navDepth : 0` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Nav Depth. |
| `routeParams` | `var` | `{…}` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Route Params. |
| `chromeStripColor` | `color` | `{…}` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Chrome Strip Color. |
| `layoutMode` | `int` | `Md3ContainerBody.Fit` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Layout Mode. |
| `content` | `alias` | `customContent.content` | default read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Content. |
| `isMaximizedLike` | `bool` | `visibility === Window.Maximized` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Is Maximized Like. |
| `effectiveRadius` | `real` | `{…}` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Effective Radius. |
| `usesSystemCorners` | `bool` | `Md3WindowCapabilities.systemCorners` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | OS clips the window frame (Win DWM / macOS layer) — skip MultiEffect chrome FBO. |
| `useTransparentFrame` | `bool` | `useCustomChrome && effectiveRadius > 0` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Use Transparent Frame. |
| `chromeMaskActive` | `bool` | `effectiveRadius > 0` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Client mask FBO only when the OS cannot clip the silhouette. |
| `windowNative` | `alias` | `windowHelper` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Access native helper (signals: thumbBarButtonClicked, trayActivated, dpiChanged). |
| `chromeTop` | `real` | `chromeHost.height` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Chrome Top. |
| `edge` | `real` | `6` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Edge. |
| `canResize` | `bool` | `useCustomChrome && Md3WindowCapabilities.systemResize` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Can Resize. |
| `chromeTopReserve` | `real` | `(showTitleBar && useCustomChrome) ? chromeHost.height : 0` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Keep QML resize grips off the title-bar caption strip (min/max/close). |
| `chromeRightReserve` | `real` | `{…}` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Chrome Right Reserve. |
| `themeRevealCx` | `real` | `0` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Theme Reveal Cx. |
| `themeRevealCy` | `real` | `0` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Theme Reveal Cy. |
| `themeRevealRadius` | `real` | `0` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Theme Reveal Radius. |
| `windowDpr` | `real` | `windowHelper.devicePixelRatio(root)` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Window Dpr. |
| `windowDpi` | `int` | `windowHelper.windowDpi(root)` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Window Dpi. |
| `monitorCount` | `int` | `windowHelper.monitorCount()` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Monitor Count. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `shellInfoBarActionClicked()` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Emitted when shell Info Bar Action Clicked. |
| `documentTabActivated(int index)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Emitted when document Tab Activated. |
| `documentTabCloseRequested(int index)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Emitted when document Tab Close Requested. |
| `documentTabAddRequested()` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Emitted when document Tab Add Requested. |
| `documentTabMoved(int from, int to)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Emitted when document Tab Moved. |
| `documentTabTearOff(int index, real globalX, real globalY)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Emitted when document Tab Tear Off. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `showShellInfoBar(message, options)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Show the window shell InfoBar. |
| `dismissShellInfoBar()` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Dismiss the window shell InfoBar. |
| `navigateTo(index, opts)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Navigate To. |
| `pushRoute(index, params, opts)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Push Route. |
| `goBack(opts)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Go Back. |
| `replaceRoute(index, params, opts)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Replace Route. |
| `showStatusMessage(message, timeout)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Show Status Message. |
| `documentTabMeta(pageIndex)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Document Tab Meta. |
| `openTab(pageIndex, asNew)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Open Tab. |
| `addTab(pageIndex)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Add Tab. |
| `closeTab(index)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Close Tab. |
| `moveTab(from, to)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Move Tab. |
| `activateTab(index)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Activate Tab. |
| `tearOffTab(index, globalX, globalY)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Drag-out: remove tab from this window and open it in a new `Md3TabWindow`. |
| `toggleThemeAt(x, y)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Toggle theme with circular reveal from a point in chrome / contentItem coords. |
| `toggleThemeFrom(item)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Toggle theme revealing from the center of `item` (mapped into the window chrome). |
| `openAbout()` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Open modeless About dialog (also used by Md3TitleBar info button). |
| `applyPageNavWarm()` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Raise L1/L2 caches after shell paint (`pageNavWarm`). |
| `showSnackbar(message, options)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Enqueue a snackbar on the window host. options: { actionText, dualLine, durationMs, id, priority } |
| `showToast(message, options)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Toast. options: { severity, durationMs, position, id } |
| `restoreSession()` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Restore Session. |
| `saveSession()` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Save Session. |
| `reloadCurrentPage()` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Reload Current Page. |
| `toCssColor(c)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Hex helper for Gallery / apps (accepts color or string). |
| `setNativeBorderColor(c)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Set Native Border Color. |
| `setSystemBackdropMode(mode)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | UNSUITABLE FOR PRODUCTION — API retained; Gallery no longer exposes it. |
| `flashTaskbar(flash)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Flash the Windows taskbar button (attention). |
| `setTaskbarProgress(value, state)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Set Taskbar Progress. |
| `clearTaskbarProgress()` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Clear Taskbar Progress. |
| `setTaskbarOverlayIcon(iconUrl, description)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Set Taskbar Overlay Icon. |
| `clearTaskbarOverlayIcon()` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Clear Taskbar Overlay Icon. |
| `setExcludedFromPeek(excluded)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Set Excluded From Peek. |
| `setDisallowPeek(disallow)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Set Disallow Peek. |
| `setExcludeFromCapture(exclude)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Set Exclude From Capture. |
| `setJumpListTasks(tasks)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Set Jump List Tasks. |
| `clearJumpList()` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Clear Jump List. |
| `setThumbBarButtons(buttons)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Set Thumb Bar Buttons. |
| `clearThumbBarButtons()` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Clear Thumb Bar Buttons. |
| `setForceIconicRepresentation(enabled)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Set Force Iconic Representation. |
| `setIconicThumbnail(imageUrl)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Set Iconic Thumbnail. |
| `clearIconicThumbnail()` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Clear Iconic Thumbnail. |
| `showSystemTrayIcon(iconUrl, tooltip)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Show System Tray Icon. |
| `hideSystemTrayIcon()` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Hide System Tray Icon. |
| `showTrayNotification(titleText, body, timeoutMs)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Show Tray Notification. |
| `cursorScreenPos()` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Cursor Screen Pos. |
| `setAlwaysOnTop(onTop)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Set Always On Top. |
| `raiseWindow()` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Raise Window. |
| `setDockBadge(count)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Set Dock Badge. |
| `setIdleInhibit(inhibit, reason)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Set Idle Inhibit. |
| `openUrl(url)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Open Url. |
| `revealInFolder(pathOrUrl)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Reveal In Folder. |
| `beep()` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Beep. |
| `centerOnScreen()` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Center On Screen. |
| `setWindowOpacity(opacity)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Set Window Opacity. |
| `setVisibleInTaskbar(visible)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Set Visible In Taskbar. |
| `minimizeWindow()` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Minimize Window. |
| `maximizeWindow()` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Maximize Window. |
| `restoreWindow()` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Restore Window. |
| `setFullScreen(fullScreen)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Set Full Screen. |
| `systemColorSchemeDark()` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | System Color Scheme Dark. |
| `shareText(text, title)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Share Text. |
| `vibrate(durationMs)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Vibrate. |
| `setImmersiveSystemUi(immersive)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Set Immersive System Ui. |
| `requestAttention(on)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Request Attention. |
| `openBlurSettings()` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Open Blur Settings. |
| `setWindowCloaked(cloaked)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Set Window Cloaked. |
| `setPreferredAppMode(dark)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Set Preferred App Mode. |
| `moveToMonitor(index)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Move To Monitor. |
| `setThumbnailClip(x, y, w, h)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Set Thumbnail Clip. |
| `clearThumbnailClip()` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Clear Thumbnail Clip. |
| `setThumbnailTooltip(text)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Set Thumbnail Tooltip. |
| `registerApplicationRestart(args)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Register Application Restart. |
| `unregisterApplicationRestart()` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Unregister Application Restart. |
| `requestSingleInstanceLock(id)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Request Single Instance Lock. |
| `setOpenAtLoginEnabled(enabled, openAsHidden)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Set Open At Login Enabled. |
| `registerGlobalShortcut(id, accelerator)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Register Global Shortcut. |
| `unregisterGlobalShortcut(id)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Unregister Global Shortcut. |
| `setAsDefaultProtocolClient(scheme, path, args)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Set As Default Protocol Client. |
| `removeAsDefaultProtocolClient(scheme)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Remove As Default Protocol Client. |
| `getPath(name)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Get Path. |
| `setSystemBarColors(statusCss, navCss, lightIcons)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Set System Bar Colors. |
| `setScreenOrientation(mode)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Set Screen Orientation. |
| `showSoftInput()` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Show Soft Input. |
| `hideSoftInput()` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Hide Soft Input. |
| `setSoftInputAdjustResize(enable)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Set Soft Input Adjust Resize. |
| `openAppSettings()` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Open App Settings. |
| `nativeToast(message, durationMs)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Native Toast. |
| `hapticFeedback(kind)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Haptic Feedback. |
| `requestIgnoreBatteryOptimizations()` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Request Ignore Battery Optimizations. |
| `shareFile(fileUrl, mimeType, titleText)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Share File. |
| `copyToClipboard(text)` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Copy To Clipboard. |
| `clipboardText()` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Clipboard Text. |
| `openNotificationSettings()` | `—` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Open Notification Settings. |

## Example

```qml
import Md3

Md3TabWindow {
    catalog: []
    initialTabs: []
    initialTabIndex: 0
    customChrome: Md3WindowCapabilities.customChrome
    showTitleBar: true
    adaptiveChrome: true
}
```
