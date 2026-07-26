# Md3TitleBar

- **Source:** `src/Md3/window/Md3TitleBar.qml`
- **Extends:** `Rectangle`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `targetWindow` | `var` | `null` | read/write | `Md3TitleBar` | — |
| `windowHelper` | `var` | `null` | read/write | `Md3TitleBar` | — |
| `title` | `string` | `""` | read/write | `Md3TitleBar` | — |
| `subtitle` | `string` | `""` | read/write | `Md3TitleBar` | Deprecated — Win title bars are single-line; kept for API compat, not shown |
| `leadingIcon` | `string` | `""` | read/write | `Md3TitleBar` | — |
| `showLeading` | `bool` | `leadingIcon.length > 0` | read/write | `Md3TitleBar` | — |
| `showTitle` | `bool` | `true` | read/write | `Md3TitleBar` | — |
| `showAppIcon` | `bool` | `true` | read/write | `Md3TitleBar` | — |
| `showThemeToggle` | `bool` | `true` | read/write | `Md3TitleBar` | — |
| `showPin` | `bool` | `true` | read/write | `Md3TitleBar` | Pin / always-on-top (shown by default) |
| `pinned` | `bool` | `false` | read/write | `Md3TitleBar` | — |
| `showMinimize` | `bool` | `true` | read/write | `Md3TitleBar` | — |
| `showMaximize` | `bool` | `true` | read/write | `Md3TitleBar` | — |
| `showClose` | `bool` | `true` | read/write | `Md3TitleBar` | — |
| `dragEnabled` | `bool` | `Md3WindowCapabilities.systemMove` | read/write | `Md3TitleBar` | — |
| `nativeCaptionHit` | `bool` | `Md3WindowCapabilities.captionHitTest` | read/write | `Md3TitleBar` | — |
| `leadingInset` | `real` | `Md3WindowCapabilities.trafficLightsInset` | read/write | `Md3TitleBar` | — |
| `cornerRadius` | `real` | `0` | read/write | `Md3TitleBar` | — |
| `appIcon` | `url` | `""` | read/write | `Md3TitleBar` | Window / taskbar icon (qrc or file). Synced from Md3ApplicationWindow.windowIcon when bound. |
| `preferredHeight` | `real` | `28` | read/write | `Md3TitleBar` | — |
| `compactHeight` | `real` | `28` | read/write | `Md3TitleBar` | — |
| `compact` | `bool` | `false` | read/write | `Md3TitleBar` | — |
| `barHeight` | `real` | `-1` | read/write | `Md3TitleBar` | — |
| `padding` | `real` | `6` | read/write | `Md3TitleBar` | — |
| `contentSpacing` | `real` | `6` | read/write | `Md3TitleBar` | — |
| `minTitleWidth` | `real` | `96` | read/write | `Md3TitleBar` | Reserved title area (Win-like); middle never steals from this |
| `maxTitleWidth` | `real` | `240` | read/write | `Md3TitleBar` | — |
| `responsiveMode` | `int` | `0` | read/write | `Md3TitleBar` | 0=Auto (narrow → second row for middle only), 1=SingleRow, 2=TwoRow |
| `collapseWidth` | `real` | `900` | read/write | `Md3TitleBar` | — |
| `leadingContent` | `alias` | `leadingSlot.data` | read/write | `Md3TitleBar` | — |
| `trailingContent` | `alias` | `trailingSlot.data` | read/write | `Md3TitleBar` | — |
| `extraActions` | `alias` | `trailingSlot.data` | read/write | `Md3TitleBar` | — |
| `middleContent` | `alias` | `middleFlow.content` | read/write | `Md3TitleBar` | — |
| `centerContent` | `alias` | `middleFlow.content` | read/write | `Md3TitleBar` | — |
| `baseHeight` | `real` | `barHeight >= 0 ? barHeight` | readonly | `Md3TitleBar` | — |
| `twoRow` | `bool` | `{…}` | readonly | `Md3TitleBar` | — |
| `contentHeight` | `real` | `{…}` | readonly | `Md3TitleBar` | — |
| `_titleBlockWidth` | `real` | `{…}` | readonly | `Md3TitleBar` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `leadingClicked()` | `Md3TitleBar` | — |
| `themeToggled()` | `Md3TitleBar` | — |
| `pinToggled(bool pinned)` | `Md3TitleBar` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `setPinned(onTop)` | `Md3TitleBar` | — |
| `togglePinned()` | `Md3TitleBar` | — |
| `reportNativeHits()` | `Md3TitleBar` | — |
| `openSystemMenu(globalX, globalY)` | `Md3TitleBar` | — |

## Example

```qml
import Md3

Md3TitleBar {
    targetWindow: null
    windowHelper: null
    title: ""
    subtitle: ""
    leadingIcon: ""
}
```
