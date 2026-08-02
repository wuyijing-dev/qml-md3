# Md3TitleBar

- **Source:** `src/Md3/window/Md3TitleBar.qml`
- **Extends:** `Rectangle`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 54 | 7 | 9 | 0 |

_Also inherits Qt Quick `Rectangle` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `targetWindow` | `var` | `null` | read/write | `Md3TitleBar` | Target Window. |
| `windowHelper` | `var` | `null` | read/write | `Md3TitleBar` | Window Helper. |
| `title` | `string` | `""` | read/write | `Md3TitleBar` | Title text. |
| `subtitle` | `string` | `""` | read/write | `Md3TitleBar` | Deprecated — Win title bars are single-line; kept for API compat, not shown |
| `leadingIcon` | `string` | `""` | read/write | `Md3TitleBar` | Leading Icon. |
| `showLeading` | `bool` | `leadingIcon.length > 0` | read/write | `Md3TitleBar` | Show Leading. |
| `showBackButton` | `bool` | `false` | read/write | `Md3TitleBar` | Page-stack back (left of icon/title). Typical with navigation rail shells. |
| `backEnabled` | `bool` | `true` | read/write | `Md3TitleBar` | Back Enabled. |
| `backIcon` | `string` | `"arrow_back"` | read/write | `Md3TitleBar` | Back Icon. |
| `showTitle` | `bool` | `true` | read/write | `Md3TitleBar` | Show Title. |
| `showAppIcon` | `bool` | `true` | read/write | `Md3TitleBar` | Show App Icon. |
| `showThemeToggle` | `bool` | `true` | read/write | `Md3TitleBar` | Show Theme Toggle. |
| `showAboutButton` | `bool` | `true` | read/write | `Md3TitleBar` | Info button opens a modeless About dialog |
| `aboutAppName` | `string` | `""` | read/write | `Md3TitleBar` | About App Name. |
| `aboutVersion` | `string` | `""` | read/write | `Md3TitleBar` | About Version. |
| `aboutOrganization` | `string` | `""` | read/write | `Md3TitleBar` | About Organization. |
| `aboutText` | `string` | `""` | read/write | `Md3TitleBar` | About Text. |
| `aboutIcon` | `url` | `""` | read/write | `Md3TitleBar` | About Icon. |
| `aboutContent` | `Component` | `null` | read/write | `Md3TitleBar` | Optional custom body for the About dialog (replaces default text block) |
| `showPerformanceToggle` | `bool` | `false` | read/write | `Md3TitleBar` | Performance monitor toggle (right of trailing content, before theme) |
| `performanceChecked` | `bool` | `false` | read/write | `Md3TitleBar` | Performance Checked. |
| `showTourButton` | `bool` | `false` | read/write | `Md3TitleBar` | Product tour / onboarding guide (before About / performance / theme) |
| `showPin` | `bool` | `true` | read/write | `Md3TitleBar` | Pin / always-on-top (shown by default) |
| `pinned` | `bool` | `false` | read/write | `Md3TitleBar` | Pinned. |
| `showMinimize` | `bool` | `true` | read/write | `Md3TitleBar` | Show Minimize. |
| `showMaximize` | `bool` | `true` | read/write | `Md3TitleBar` | Show Maximize. |
| `showClose` | `bool` | `true` | read/write | `Md3TitleBar` | Show Close. |
| `showCaptionButtons` | `bool` | `true` | read/write | `Md3TitleBar` | Master switch for min/max/close (adaptive desktop vs system chrome). |
| `dragEnabled` | `bool` | `Md3WindowCapabilities.systemMove` | read/write | `Md3TitleBar` | Drag Enabled. |
| `nativeCaptionHit` | `bool` | `Md3WindowCapabilities.captionHitTest` | read/write | `Md3TitleBar` | Native Caption Hit. |
| `leadingInset` | `real` | `Md3WindowCapabilities.trafficLightsInset` | read/write | `Md3TitleBar` | Leading Inset. |
| `cornerRadius` | `real` | `0` | read/write | `Md3TitleBar` | Corner radius. |
| `unifiedChrome` | `bool` | `false` | read/write | `Md3TitleBar` | When true, fill is transparent so a parent chrome strip paints title+tabs as one. |
| `appIcon` | `url` | `""` | read/write | `Md3TitleBar` | Window / taskbar icon (qrc or file). Synced from Md3ApplicationWindow.windowIcon when bound. |
| `preferredHeight` | `real` | `28` | read/write | `Md3TitleBar` | Preferred Height. |
| `compactHeight` | `real` | `24` | read/write | `Md3TitleBar` | Compact Height. |
| `compact` | `bool` | `false` | read/write | `Md3TitleBar` | Compact. |
| `barHeight` | `real` | `-1` | read/write | `Md3TitleBar` | Bar Height. |
| `padding` | `real` | `6` | read/write | `Md3TitleBar` | Uniform padding. |
| `contentSpacing` | `real` | `6` | read/write | `Md3TitleBar` | Content Spacing. |
| `minTitleWidth` | `real` | `96` | read/write | `Md3TitleBar` | Reserved title area (Win-like); middle never steals from this |
| `maxTitleWidth` | `real` | `240` | read/write | `Md3TitleBar` | Max Title Width. |
| `responsiveMode` | `int` | `0` | read/write | `Md3TitleBar` | 0=Auto (narrow → second row for middle only), 1=SingleRow, 2=TwoRow |
| `collapseWidth` | `real` | `900` | read/write | `Md3TitleBar` | Collapse Width. |
| `leadingContent` | `alias` | `leadingSlot.data` | read/write | `Md3TitleBar` | Leading Content. |
| `trailingContent` | `alias` | `trailingSlot.data` | read/write | `Md3TitleBar` | Trailing Content. |
| `extraActions` | `alias` | `trailingSlot.data` | read/write | `Md3TitleBar` | Extra Actions. |
| `middleContent` | `alias` | `middleFlow.content` | read/write | `Md3TitleBar` | Middle Content. |
| `centerContent` | `alias` | `middleFlow.content` | read/write | `Md3TitleBar` | Center Content. |
| `content` | `alias` | `middleFlow.content` | default read/write | `Md3TitleBar` | Content. |
| `baseHeight` | `real` | `barHeight >= 0 ? barHeight` | readonly | `Md3TitleBar` | Base Height. |
| `twoRow` | `bool` | `{…}` | readonly | `Md3TitleBar` | Two Row. |
| `contentHeight` | `real` | `{…}` | readonly | `Md3TitleBar` | Content Height. |
| `rightChromeWidth` | `real` | `rightChrome.width` | readonly | `Md3TitleBar` | Trailing chrome width so shell resize edges can leave caption buttons alone |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `leadingClicked()` | `Md3TitleBar` | Emitted when leading Clicked. |
| `backClicked()` | `Md3TitleBar` | Emitted when back Clicked. |
| `themeToggled()` | `Md3TitleBar` | Emitted when theme Toggled. |
| `performanceClicked()` | `Md3TitleBar` | Emitted when performance Clicked. |
| `tourClicked()` | `Md3TitleBar` | Emitted when tour Clicked. |
| `pinToggled(bool pinned)` | `Md3TitleBar` | Emitted when pin Toggled. |
| `aboutClicked()` | `Md3TitleBar` | Emitted when about Clicked. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `resolvedAboutName()` | `—` | `Md3TitleBar` | Resolved About Name. |
| `resolvedAboutVersion()` | `—` | `Md3TitleBar` | Resolved About Version. |
| `resolvedAboutOrganization()` | `—` | `Md3TitleBar` | Resolved About Organization. |
| `resolvedAboutIcon()` | `—` | `Md3TitleBar` | Resolved About Icon. |
| `openAbout()` | `—` | `Md3TitleBar` | Open About. |
| `setPinned(onTop)` | `—` | `Md3TitleBar` | Set Pinned. |
| `togglePinned()` | `—` | `Md3TitleBar` | Toggle Pinned. |
| `reportNativeHits()` | `—` | `Md3TitleBar` | Report Native Hits. |
| `openSystemMenu(globalX, globalY)` | `—` | `Md3TitleBar` | Open System Menu. |

## Example

```qml
import Md3

Md3TitleBar {
    targetWindow: null
    windowHelper: null
    title: ""
    subtitle: ""
    leadingIcon: ""
    showLeading: leadingIcon.length > 0
}
```
