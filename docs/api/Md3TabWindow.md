# Md3TabWindow

Peer window spawned by document-tab tear-off (`Md3ApplicationWindow.tearOffTab`). Uses the normal title bar + tab strip (browserChrome was removed).

- **Source:** `src/Md3/window/Md3TabWindow.qml`
- **Extends:** `Md3ApplicationWindow`

## Import

```qml
import Md3
```

## Inheritance

[`Md3TabWindow`](Md3TabWindow.md) → [`Md3ApplicationWindow`](Md3ApplicationWindow.md)

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `catalog` | `var` | `[]` | read/write | `Md3TabWindow` | — |
| `initialTabs` | `var` | `[]` | read/write | `Md3TabWindow` | — |
| `initialTabIndex` | `int` | `0` | read/write | `Md3TabWindow` | — |
| `customChrome` | `bool` | `Md3WindowCapabilities.customChrome` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `showTitleBar` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `roundedCorners` | `bool` | `Md3WindowCapabilities.roundedCorners` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `cornerRadius` | `real` | `Md3WindowCapabilities.windowCornerRadius` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `showWindowBorder` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `titleBarItem` | `alias` | `titleBarLoader.item` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Alias → `titleBarLoader.item` |
| `overlay` | `alias` | `overlayHost.data` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Alias → `overlayHost.data` |
| `overlayItem` | `alias` | `overlayHost` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Alias → `overlayHost` |
| `snackbarHostItem` | `alias` | `snackbarHost` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Alias → `snackbarHost` |
| `titleBar` | `Component` | `null` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `windowIcon` | `url` | `Md3AppIcons.window` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | App icon for title bar + taskbar / Alt-Tab (qrc or file URL). Default: Md3 bundled icon (resources/icons → qrc:/md3/icons/…). |
| `syncImmersiveDarkMode` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Sync DWM immersive dark mode with Md3Theme.dark (Windows) |
| `systemBackdrop` | `int` | `0` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | UNSUITABLE FOR PRODUCTION — kept for future research only. Qt Quick composition typically hides DWM Mica/Acrylic; prefer 0 (solid MD3 surface). 0=None 1=Auto 2=Mica 3=Acrylic 4=Tabbed |
| `nativeBorderColor` | `string` | `""` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | DWM border color ("#RRGGBB", "none", "default", or "") |
| `usesSystemBackdrop` | `bool` | `systemBackdrop > 0` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `backdropTint` | `real` | `0.08` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | UNSUITABLE — wash over system backdrop; unused when systemBackdrop is 0. |
| `backdropContentTint` | `real` | `0.18` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `backdropTitleTint` | `real` | `0.06` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `showPinButton` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Title-bar pin (always-on-top). On by default. |
| `pinned` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `showAboutButton` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Title-bar About (info) button → modeless About dialog |
| `aboutAppName` | `string` | `""` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `aboutVersion` | `string` | `""` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `aboutOrganization` | `string` | `""` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `aboutText` | `string` | `""` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `aboutIcon` | `url` | `""` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `aboutContent` | `Component` | `null` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `themeRevealEnabled` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Circular reveal when toggling light/dark (Material-style wipe from click) |
| `themeRevealBusy` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `themeRevealDuration` | `int` | `Md3Motion.long2` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `themeRevealEasing` | `var` | `Md3Motion.emphasized` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `destinations` | `var` | `[]` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | When non-empty, window hosts left rail + on-demand pages (no manual layout needed). |
| `currentIndex` | `int` | `0` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `navigationRail` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `railExpanded` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `railHeader` | `string` | `""` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `pageCacheMode` | `string` | `"arc"` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | "none" \| "one" \| "lru" \| "all" \| "adaptive" \| "arc" Library default: arc + L1=1 + tiny L2 (snappy, low RSS). Override only if needed. |
| `pageCacheLimit` | `int` | `1` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `pageIdleTrimMs` | `int` | `4000` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `pagePadding` | `real` | `Md3Theme.pagePadding` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `pagePrefetch` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `pagePredictPrefetch` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `pageL2Cache` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `pageL2CacheLimit` | `int` | `1` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `pageL2Warm` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Idle L2 warm-all: pace-compile every destination Component (no live Item RSS). |
| `pageLeaveSnapshot` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `pageAsync` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `pageWarmStart` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `pageSourceBase` | `url` | `""` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `pageSourcePreferHotReload` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | When hotReload is on and the agent finds a disk `pages/` tree, use it as sourceBase. |
| `pageNavWarm` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | After first show: raise L1/L2 + neighbor prefetch (Gallery-style snappy shell). |
| `pageNavWarmDelayMs` | `int` | `80` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `pageNavWarmCacheLimit` | `int` | `6` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `pageNavWarmL2CacheLimit` | `int` | `-1` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | -1 → max(32, destinations.length) |
| `pageNavWarmPrefetch` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `pageTransition` | `string` | `"fade"` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `pageTransitionDuration` | `int` | `100` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `pageSkeleton` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `pageHost` | `alias` | `windowBody.pageHost` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Alias → `windowBody.pageHost` |
| `shellRail` | `alias` | `windowBody.rail` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Alias → `windowBody.rail` |
| `progressiveContent` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Within-page progressive sections (Md3DeferredSection). Default on. |
| `resolvedPageSourceBase` | `url` | `{…}` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Effective pages root for PageHost (hot-reload disk path or `pageSourceBase`). |
| `persistSession` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Persist geometry / theme / shell via Md3AppSettings (QSettings). |
| `settingsOrganization` | `string` | `"QML_MD3"` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `settingsApplication` | `string` | `"Md3"` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `hotReload` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Dev hot-reload of QML sources (file watcher + clearComponentCache). |
| `hotReloadAgent` | `alias` | `hotReloadInst` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Alias → `hotReloadInst` |
| `showPerformanceButton` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Built-in performance overlay (title-bar speed button + floating panel). |
| `showPerformanceOverlay` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `performanceDetached` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Optional: pop the panel into its own non-modal window. |
| `performanceMonitor` | `alias` | `perfMonitor` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Alias → `perfMonitor` |
| `performancePanel` | `alias` | `perfPanel` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Alias → `perfPanel` |
| `documentTabsEnabled` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Show Win11-style tab strip under the title bar. |
| `documentTabsManaged` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Auto-handle activate / close / add / reorder / tear-off + sync with currentIndex. |
| `documentTabsCloseWindowWhenEmpty` | `bool` | `false` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Close this window when the last tab is closed (typical for torn-off windows). |
| `documentTabs` | `var` | `[]` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `documentTabIndex` | `int` | `0` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `documentTabsClosable` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `documentTabsTearOff` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Drag a tab outside the window to spawn a peer `Md3TabWindow`. |
| `documentTabsShowAdd` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `unifiedTitleChrome` | `bool` | `true` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Paint title bar + document tabs as one chrome strip (same surfaceContainer). |
| `documentTabBar` | `alias` | `docTabBar` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Alias → `docTabBar` |
| `toolBar` | `alias` | `toolBarSlot.data` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | App-top tool strip between tabs/titlebar and content. |
| `toolBarItem` | `alias` | `toolBarSlot` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Alias → `toolBarSlot` |
| `toolBarHeight` | `real` | `toolBarSlot.visible ? toolBarSlot.height : 0` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `statusBar` | `alias` | `statusBarSlot.data` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | App-bottom status strip (e.g. Md3StatusBar). Spans full content width. |
| `statusBarItem` | `alias` | `statusBarSlot` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Alias → `statusBarSlot` |
| `statusBarHeight` | `real` | `statusBarSlot.visible ? statusBarSlot.height : 0` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `usesDestinations` | `bool` | `destinations && destinations.length > 0` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `showTitleBackButton` | `bool` | `navigationRail && usesDestinations` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Title-bar back when navigation rail + destinations shell are active. |
| `canGoBack` | `bool` | `usesDestinations && windowBody.canGoBack` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `navDepth` | `int` | `usesDestinations ? windowBody.navDepth : 0` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `routeParams` | `var` | `{…}` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `chromeStripColor` | `color` | `{…}` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `layoutMode` | `int` | `Md3ContainerBody.Fit` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `content` | `alias` | `customContent.content` | default read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Default property → `customContent.content` |
| `isMaximizedLike` | `bool` | `visibility === Window.Maximized` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `effectiveRadius` | `real` | `{…}` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `useTransparentFrame` | `bool` | `customChrome && Md3WindowCapabilities.customChrome` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `windowNative` | `alias` | `windowHelper` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Access native helper (signals: thumbBarButtonClicked, trayActivated, dpiChanged). |
| `chromeTop` | `real` | `chromeHost.height` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `edge` | `real` | `6` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `canResize` | `bool` | `customChrome && Md3WindowCapabilities.systemResize` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `themeRevealCx` | `real` | `0` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `themeRevealCy` | `real` | `0` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `themeRevealRadius` | `real` | `0` | read/write | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `windowDpr` | `real` | `windowHelper.devicePixelRatio(root)` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `windowDpi` | `int` | `windowHelper.windowDpi(root)` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `monitorCount` | `int` | `windowHelper.monitorCount()` | readonly | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `documentTabActivated(int index)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `documentTabCloseRequested(int index)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `documentTabAddRequested()` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `documentTabMoved(int from, int to)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `documentTabTearOff(int index, real globalX, real globalY)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `navigateTo(index, opts)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `pushRoute(index, params, opts)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `goBack(opts)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `replaceRoute(index, params, opts)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `showStatusMessage(message, timeout)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `documentTabMeta(pageIndex)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `openTab(pageIndex, asNew)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `addTab(pageIndex)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `closeTab(index)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `moveTab(from, to)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `activateTab(index)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `tearOffTab(index, globalX, globalY)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Drag-out: remove tab from this window and open it in a new `Md3TabWindow`. |
| `toggleThemeAt(x, y)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Toggle theme with circular reveal from a point in chrome / contentItem coords. |
| `toggleThemeFrom(item)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Toggle theme revealing from the center of `item` (mapped into the window chrome). |
| `openAbout()` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Open modeless About dialog (also used by Md3TitleBar info button). |
| `applyPageNavWarm()` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Raise L1/L2 caches after shell paint (`pageNavWarm`). |
| `showSnackbar(message, options)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Enqueue a snackbar on the window host. options: { actionText, dualLine, durationMs, id, priority } |
| `showToast(message, options)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Toast. options: { severity, durationMs, position, id } |
| `restoreSession()` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `saveSession()` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `reloadCurrentPage()` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `toCssColor(c)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Hex helper for Gallery / apps (accepts color or string). |
| `setNativeBorderColor(c)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `setSystemBackdropMode(mode)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | UNSUITABLE FOR PRODUCTION — API retained; Gallery no longer exposes it. |
| `flashTaskbar(flash)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | Flash the Windows taskbar button (attention). |
| `setTaskbarProgress(value, state)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `clearTaskbarProgress()` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `setTaskbarOverlayIcon(iconUrl, description)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `clearTaskbarOverlayIcon()` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `setExcludedFromPeek(excluded)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `setDisallowPeek(disallow)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `setExcludeFromCapture(exclude)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `setJumpListTasks(tasks)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `clearJumpList()` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `setThumbBarButtons(buttons)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `clearThumbBarButtons()` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `setForceIconicRepresentation(enabled)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `setIconicThumbnail(imageUrl)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `clearIconicThumbnail()` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `showSystemTrayIcon(iconUrl, tooltip)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `hideSystemTrayIcon()` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `showTrayNotification(titleText, body, timeoutMs)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `cursorScreenPos()` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `setAlwaysOnTop(onTop)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `raiseWindow()` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `setDockBadge(count)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `setIdleInhibit(inhibit, reason)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `openBlurSettings()` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `setWindowCloaked(cloaked)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `setPreferredAppMode(dark)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `moveToMonitor(index)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `setThumbnailClip(x, y, w, h)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `clearThumbnailClip()` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `setThumbnailTooltip(text)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `registerApplicationRestart(args)` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |
| `unregisterApplicationRestart()` | [`Md3ApplicationWindow`](Md3ApplicationWindow.md) | — |

## Example

```qml
import Md3

Md3TabWindow {
    catalog: []
    initialTabs: []
    initialTabIndex: 0
    customChrome: Md3WindowCapabilities.customChrome
    showTitleBar: true
}
```
