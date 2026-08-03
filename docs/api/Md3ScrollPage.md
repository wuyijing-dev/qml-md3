# Md3ScrollPage

Reliable page scroller: measured VStack inside ``Md3ScrollView`` (Tab / Fit hosts).

- **Source:** `src/Md3/layout/Md3ScrollPage.qml`
- **Extends:** `Md3ScrollView`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 4 | 0 | 0 | 0 |

## Import

```qml
import Md3
```

## Inheritance

[`Md3ScrollPage`](Md3ScrollPage.md) → [`Md3ScrollView`](Md3ScrollView.md)

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `pageSpacing` | `real` | `Md3Theme.spacingMd` | read/write | `Md3ScrollPage` | Page Spacing. |
| `pagePadding` | `real` | `0` | read/write | `Md3ScrollPage` | Page Padding. |
| `pageContent` | `alias` | `column.data` | default read/write | `Md3ScrollPage` | Page Content. |
| `column` | `alias` | `column` | read/write | `Md3ScrollPage` | Column. |
| `contentWidth` | `alias` | `flick.contentWidth` | read/write | [`Md3ScrollView`](Md3ScrollView.md) | Content Width. |
| `contentHeight` | `alias` | `flick.contentHeight` | read/write | [`Md3ScrollView`](Md3ScrollView.md) | Content Height. |
| `contentX` | `alias` | `flick.contentX` | read/write | [`Md3ScrollView`](Md3ScrollView.md) | Content X. |
| `contentY` | `alias` | `flick.contentY` | read/write | [`Md3ScrollView`](Md3ScrollView.md) | Content Y. |
| `flickable` | `alias` | `flick` | read/write | [`Md3ScrollView`](Md3ScrollView.md) | Flickable. |
| `clip` | `alias` | `flick.clip` | read/write | [`Md3ScrollView`](Md3ScrollView.md) | Clip children to bounds. |
| `interactive` | `bool` | `true` | read/write | [`Md3ScrollView`](Md3ScrollView.md) | Gate activation without forcing `enabled: false`. |
| `showVerticalScrollBar` | `bool` | `true` | read/write | [`Md3ScrollView`](Md3ScrollView.md) | Show Vertical Scroll Bar. |
| `showHorizontalScrollBar` | `bool` | `true` | read/write | [`Md3ScrollView`](Md3ScrollView.md) | Show Horizontal Scroll Bar. |
| `scrollBarAutoHide` | `bool` | `true` | read/write | [`Md3ScrollView`](Md3ScrollView.md) | Scroll Bar Auto Hide. |
| `scrollBarThickness` | `real` | `10` | read/write | [`Md3ScrollView`](Md3ScrollView.md) | Scroll Bar Thickness. |
| `fillContentWidth` | `bool` | `true` | read/write | [`Md3ScrollView`](Md3ScrollView.md) | When true (default), content width matches the viewport. |
| `minContentHeightToViewport` | `bool` | `false` | read/write | [`Md3ScrollView`](Md3ScrollView.md) | When true, contentHeight is at least the viewport (old behavior — empty scroll room). Default false: short content does not create a tall empty flick area. |
| `verticalScrollbarGutter` | `real` | `0` | read/write | [`Md3ScrollView`](Md3ScrollView.md) | Inset subtracted from content width when ``fillContentWidth`` (e.g. ``scrollBarThickness`` or ``4`` so labels are not clipped under the vertical overlay bar). |
| `contentAvailableWidth` | `real` | `Math.max(0, width - verticalScrollbarGutter)` | readonly | [`Md3ScrollView`](Md3ScrollView.md) | Viewport width minus ``verticalScrollbarGutter`` — bind child ``width`` to this in panes. |
| `showScrollToTop` | `bool` | `false` | read/write | [`Md3ScrollView`](Md3ScrollView.md) | Optional FAB that appears after scrolling down; animates back to top. |
| `scrollToTopThreshold` | `real` | `120` | read/write | [`Md3ScrollView`](Md3ScrollView.md) | Scroll To Top Threshold. |
| `content` | `alias` | `contentHost.data` | default read/write | [`Md3ScrollView`](Md3ScrollView.md) | Content. |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `scrollToTop()` | `—` | [`Md3ScrollView`](Md3ScrollView.md) | Scroll To Top. |

## Example

```qml
import Md3

Md3ScrollPage {
    pageSpacing: Md3Theme.spacingMd
    pagePadding: 0
    interactive: true
    showVerticalScrollBar: true
    showHorizontalScrollBar: true
    scrollBarAutoHide: true
}
```
