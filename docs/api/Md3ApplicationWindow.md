# Md3ApplicationWindow

- **Source:** `src/Md3/window/Md3ApplicationWindow.qml`
- **Extends:** `Window`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `customChrome` | `bool` | `Md3WindowCapabilities.customChrome` | read/write | `Md3ApplicationWindow` | — |
| `showTitleBar` | `bool` | `true` | read/write | `Md3ApplicationWindow` | — |
| `roundedCorners` | `bool` | `Md3WindowCapabilities.roundedCorners` | read/write | `Md3ApplicationWindow` | — |
| `cornerRadius` | `real` | `Md3WindowCapabilities.windowCornerRadius` | read/write | `Md3ApplicationWindow` | — |
| `showWindowBorder` | `bool` | `true` | read/write | `Md3ApplicationWindow` | — |
| `titleBarItem` | `alias` | `titleBarLoader.item` | read/write | `Md3ApplicationWindow` | — |
| `overlay` | `alias` | `overlayHost.data` | read/write | `Md3ApplicationWindow` | — |
| `overlayItem` | `alias` | `overlayHost` | read/write | `Md3ApplicationWindow` | — |
| `titleBar` | `Component` | `null` | read/write | `Md3ApplicationWindow` | — |
| `windowIcon` | `url` | `""` | read/write | `Md3ApplicationWindow` | App icon for title bar + taskbar / Alt-Tab (qrc or file URL) |
| `syncImmersiveDarkMode` | `bool` | `true` | read/write | `Md3ApplicationWindow` | Sync DWM immersive dark mode with Md3Theme.dark (Windows) |
| `systemBackdrop` | `int` | `0` | read/write | `Md3ApplicationWindow` | UNSUITABLE FOR PRODUCTION — kept for future research only. Qt Quick composition typically hides DWM Mica/Acrylic; prefer 0 (solid MD3 surface). 0=None 1=Auto 2=Mica 3=Acrylic 4=Tabbed |
| `nativeBorderColor` | `string` | `""` | read/write | `Md3ApplicationWindow` | DWM border color ("#RRGGBB", "none", "default", or "") |
| `usesSystemBackdrop` | `bool` | `systemBackdrop > 0` | readonly | `Md3ApplicationWindow` | — |
| `backdropTint` | `real` | `0.08` | read/write | `Md3ApplicationWindow` | UNSUITABLE — wash over system backdrop; unused when systemBackdrop is 0. |
| `backdropContentTint` | `real` | `0.18` | read/write | `Md3ApplicationWindow` | — |
| `backdropTitleTint` | `real` | `0.06` | read/write | `Md3ApplicationWindow` | — |
| `showPinButton` | `bool` | `true` | read/write | `Md3ApplicationWindow` | Title-bar pin (always-on-top). On by default. |
| `pinned` | `bool` | `false` | read/write | `Md3ApplicationWindow` | — |
| `showAboutButton` | `bool` | `true` | read/write | `Md3ApplicationWindow` | Title-bar About (info) → modeless dialog |
| `aboutAppName` | `string` | `""` | read/write | `Md3ApplicationWindow` | — |
| `aboutVersion` | `string` | `""` | read/write | `Md3ApplicationWindow` | — |
| `aboutOrganization` | `string` | `""` | read/write | `Md3ApplicationWindow` | — |
| `aboutText` | `string` | `""` | read/write | `Md3ApplicationWindow` | — |
| `aboutIcon` | `url` | `""` | read/write | `Md3ApplicationWindow` | — |
| `aboutContent` | `Component` | `null` | read/write | `Md3ApplicationWindow` | Custom About body |
| `themeRevealEnabled` | `bool` | `true` | read/write | `Md3ApplicationWindow` | Circular reveal when toggling light/dark (Material-style wipe from click) |
| `themeRevealBusy` | `bool` | `false` | read/write | `Md3ApplicationWindow` | — |
| `themeRevealDuration` | `int` | `Md3Motion.long2` | read/write | `Md3ApplicationWindow` | — |
| `themeRevealEasing` | `var` | `Md3Motion.emphasized` | read/write | `Md3ApplicationWindow` | — |
| `destinations` | `var` | `[]` | read/write | `Md3ApplicationWindow` | When non-empty, window hosts left rail + on-demand pages (no manual layout needed). |
| `currentIndex` | `int` | `0` | read/write | `Md3ApplicationWindow` | — |
| `navigationRail` | `bool` | `true` | read/write | `Md3ApplicationWindow` | — |
| `railExpanded` | `bool` | `false` | read/write | `Md3ApplicationWindow` | — |
| `railHeader` | `string` | `""` | read/write | `Md3ApplicationWindow` | — |
| `pageCacheMode` | `string` | `"arc"` | read/write | `Md3ApplicationWindow` | "none" \| "one" \| "lru" \| "all" \| "adaptive" \| "arc" Best combo default: arc + small L1 + L2 + predict(L2) + leave snapshot |
| `pageCacheLimit` | `int` | `2` | read/write | `Md3ApplicationWindow` | — |
| `pageIdleTrimMs` | `int` | `12000` | read/write | `Md3ApplicationWindow` | Idle time before adaptive/arc mode drops to a single resident page |
| `pagePadding` | `real` | `20` | read/write | `Md3ApplicationWindow` | — |
| `pagePrefetch` | `bool` | `false` | read/write | `Md3ApplicationWindow` | Prefetch ±1 neighbors into L1 (Item) — off in best combo (use L2 instead) |
| `pagePredictPrefetch` | `bool` | `true` | read/write | `Md3ApplicationWindow` | Markov + rail-hover → L2 Component only |
| `pageL2Cache` | `bool` | `true` | read/write | `Md3ApplicationWindow` | Keep compiled QQmlComponent after Item teardown |
| `pageL2CacheLimit` | `int` | `24` | read/write | `Md3ApplicationWindow` | — |
| `pageL2Warm` | `bool` | `true` | read/write | `Md3ApplicationWindow` | After startup, compile all destination Components in the background |
| `pageLeaveSnapshot` | `bool` | `true` | read/write | `Md3ApplicationWindow` | Freeze leaving page while cold target loads |
| `pageAsync` | `bool` | `true` | read/write | `Md3ApplicationWindow` | — |
| `pageWarmStart` | `bool` | `false` | read/write | `Md3ApplicationWindow` | Background-warm all destinations as Items (off — high memory) |
| `pageSourceBase` | `url` | `""` | read/write | `Md3ApplicationWindow` | Resolve relative destination sources against this URL (Gallery: Qt.resolvedUrl(".")) |
| `pageTransition` | `string` | `"fade"` | read/write | `Md3ApplicationWindow` | "none" \| "fade" \| "slide" \| "slideUp" \| "fadeThrough" \| "scale" \| "launch" |
| `pageTransitionDuration` | `int` | `Md3Motion.spatialDuration` | read/write | `Md3ApplicationWindow` | — |
| `pageHost` | `alias` | `windowBody.pageHost` | read/write | `Md3ApplicationWindow` | Exposes the route host for advanced `navigateTo(index, opts)` usage. |
| `pageSkeleton` | `bool` | `true` | read/write | `Md3ApplicationWindow` | Show Md3SkeletonPane while a destination loads |
| `documentTabsEnabled` | `bool` | `false` | read/write | `Md3ApplicationWindow` | Show Win11-style tab strip under the title bar. |
| `documentTabsManaged` | `bool` | `true` | read/write | `Md3ApplicationWindow` | Auto-handle activate / close / add / reorder + sync with currentIndex. |
| `documentTabsCloseWindowWhenEmpty` | `bool` | `false` | read/write | `Md3ApplicationWindow` | — |
| `documentTabs` | `var` | `[]` | read/write | `Md3ApplicationWindow` | — |
| `documentTabIndex` | `int` | `0` | read/write | `Md3ApplicationWindow` | — |
| `documentTabsClosable` | `bool` | `true` | read/write | `Md3ApplicationWindow` | — |
| `documentTabsTearOff` | `bool` | `false` | read/write | `Md3ApplicationWindow` | Tear-off to a separate window is disabled (no Md3TabWindow). |
| `documentTabsShowAdd` | `bool` | `true` | read/write | `Md3ApplicationWindow` | — |
| `documentTabBar` | `alias` | `docTabBar` | read/write | `Md3ApplicationWindow` | — |
| `_docTabSyncing` | `bool` | `false` | read/write | `Md3ApplicationWindow` | — |
| `usesDestinations` | `bool` | `destinations && destinations.length > 0` | readonly | `Md3ApplicationWindow` | — |
| `isMaximizedLike` | `bool` | `visibility === Window.Maximized` | readonly | `Md3ApplicationWindow` | — |
| `effectiveRadius` | `real` | `{…}` | readonly | `Md3ApplicationWindow` | — |
| `useTransparentFrame` | `bool` | `customChrome && Md3WindowCapabilities.customChrome` | readonly | `Md3ApplicationWindow` | — |
| `windowNative` | `alias` | `windowHelper` | readonly | `Md3ApplicationWindow` | Access native helper (signals: thumbBarButtonClicked, trayActivated, dpiChanged). |
| `chromeTop` | `real` | `{…}` | readonly | `Md3ApplicationWindow` | — |
| `edge` | `real` | `6` | readonly | `Md3ApplicationWindow` | — |
| `canResize` | `bool` | `customChrome && Md3WindowCapabilities.systemResize` | readonly | `Md3ApplicationWindow` | — |
| `themeRevealCx` | `real` | `0` | read/write | `Md3ApplicationWindow` | — |
| `themeRevealCy` | `real` | `0` | read/write | `Md3ApplicationWindow` | — |
| `themeRevealRadius` | `real` | `0` | read/write | `Md3ApplicationWindow` | — |
| `windowDpr` | `real` | `windowHelper.devicePixelRatio(root)` | readonly | `Md3ApplicationWindow` | — |
| `windowDpi` | `int` | `windowHelper.windowDpi(root)` | readonly | `Md3ApplicationWindow` | — |
| `monitorCount` | `int` | `windowHelper.monitorCount()` | readonly | `Md3ApplicationWindow` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `documentTabActivated(int index)` | `Md3ApplicationWindow` | — |
| `documentTabCloseRequested(int index)` | `Md3ApplicationWindow` | — |
| `documentTabAddRequested()` | `Md3ApplicationWindow` | — |
| `documentTabMoved(int from, int to)` | `Md3ApplicationWindow` | — |
| `documentTabTearOff(int index, real globalX, real globalY)` | `Md3ApplicationWindow` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `navigateTo(index, opts)` | `Md3ApplicationWindow` | Route-level page navigation. `opts.transitionMode: "launch"` enables tap-origin whole-page animation (Android `LaunchAnimator` style: linear time, emphasized Y/scale, dedicated X path, early leave fade). Tune via `pageHost.launchIntensity` and `pageHost.launchAxisProportional`. |
| `documentTabMeta(pageIndex)` | `Md3ApplicationWindow` | — |
| `openTab(pageIndex, asNew)` | `Md3ApplicationWindow` | — |
| `addTab(pageIndex)` | `Md3ApplicationWindow` | — |
| `closeTab(index)` | `Md3ApplicationWindow` | — |
| `moveTab(from, to)` | `Md3ApplicationWindow` | — |
| `activateTab(index)` | `Md3ApplicationWindow` | — |
| `tearOffTab(index, globalX, globalY)` | `Md3ApplicationWindow` | Tear-off windows removed — signal only for apps that want custom handling. |
| `toggleThemeAt(x, y)` | `Md3ApplicationWindow` | Toggle theme with circular reveal from a point in chrome / contentItem coords. |
| `toggleThemeFrom(item)` | `Md3ApplicationWindow` | Toggle theme revealing from the center of `item` (mapped into the window chrome). |
| `toCssColor(c)` | `Md3ApplicationWindow` | Hex helper for Gallery / apps (accepts color or string). |
| `setNativeBorderColor(c)` | `Md3ApplicationWindow` | — |
| `setSystemBackdropMode(mode)` | `Md3ApplicationWindow` | UNSUITABLE FOR PRODUCTION — API retained; Gallery no longer exposes it. |
| `flashTaskbar(flash)` | `Md3ApplicationWindow` | Flash the Windows taskbar button (attention). |
| `setTaskbarProgress(value, state)` | `Md3ApplicationWindow` | — |
| `clearTaskbarProgress()` | `Md3ApplicationWindow` | — |
| `setTaskbarOverlayIcon(iconUrl, description)` | `Md3ApplicationWindow` | — |
| `clearTaskbarOverlayIcon()` | `Md3ApplicationWindow` | — |
| `setExcludedFromPeek(excluded)` | `Md3ApplicationWindow` | — |
| `setDisallowPeek(disallow)` | `Md3ApplicationWindow` | — |
| `setExcludeFromCapture(exclude)` | `Md3ApplicationWindow` | — |
| `setJumpListTasks(tasks)` | `Md3ApplicationWindow` | — |
| `clearJumpList()` | `Md3ApplicationWindow` | — |
| `setThumbBarButtons(buttons)` | `Md3ApplicationWindow` | — |
| `clearThumbBarButtons()` | `Md3ApplicationWindow` | — |
| `setForceIconicRepresentation(enabled)` | `Md3ApplicationWindow` | — |
| `setIconicThumbnail(imageUrl)` | `Md3ApplicationWindow` | — |
| `clearIconicThumbnail()` | `Md3ApplicationWindow` | — |
| `showSystemTrayIcon(iconUrl, tooltip)` | `Md3ApplicationWindow` | — |
| `hideSystemTrayIcon()` | `Md3ApplicationWindow` | — |
| `showTrayNotification(titleText, body, timeoutMs)` | `Md3ApplicationWindow` | — |
| `setAlwaysOnTop(onTop)` | `Md3ApplicationWindow` | — |
| `raiseWindow()` | `Md3ApplicationWindow` | — |
| `setDockBadge(count)` | `Md3ApplicationWindow` | — |
| `setIdleInhibit(inhibit, reason)` | `Md3ApplicationWindow` | — |
| `openBlurSettings()` | `Md3ApplicationWindow` | — |
| `setWindowCloaked(cloaked)` | `Md3ApplicationWindow` | — |
| `setPreferredAppMode(dark)` | `Md3ApplicationWindow` | — |
| `moveToMonitor(index)` | `Md3ApplicationWindow` | — |
| `setThumbnailClip(x, y, w, h)` | `Md3ApplicationWindow` | — |
| `clearThumbnailClip()` | `Md3ApplicationWindow` | — |
| `setThumbnailTooltip(text)` | `Md3ApplicationWindow` | — |
| `registerApplicationRestart(args)` | `Md3ApplicationWindow` | — |
| `unregisterApplicationRestart()` | `Md3ApplicationWindow` | — |

## Example

```qml
import Md3

Md3ApplicationWindow {
    customChrome: Md3WindowCapabilities.customChrome
    showTitleBar: true
    roundedCorners: Md3WindowCapabilities.roundedCorners
    cornerRadius: Md3WindowCapabilities.windowCornerRadius
    showWindowBorder: true
}
```
