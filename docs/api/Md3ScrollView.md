# Md3ScrollView

Themed scroll view: Flickable + optional Md3ScrollBar overlays.

- **Source:** `src/Md3/components/Md3ScrollView.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 16 | 0 | 1 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `contentWidth` | `alias` | `flick.contentWidth` | read/write | `Md3ScrollView` | Content Width. |
| `contentHeight` | `alias` | `flick.contentHeight` | read/write | `Md3ScrollView` | Content Height. |
| `contentX` | `alias` | `flick.contentX` | read/write | `Md3ScrollView` | Content X. |
| `contentY` | `alias` | `flick.contentY` | read/write | `Md3ScrollView` | Content Y. |
| `flickable` | `alias` | `flick` | read/write | `Md3ScrollView` | Flickable. |
| `clip` | `alias` | `flick.clip` | read/write | `Md3ScrollView` | Clip children to bounds. |
| `interactive` | `bool` | `true` | read/write | `Md3ScrollView` | Gate activation without forcing `enabled: false`. |
| `showVerticalScrollBar` | `bool` | `true` | read/write | `Md3ScrollView` | Show Vertical Scroll Bar. |
| `showHorizontalScrollBar` | `bool` | `true` | read/write | `Md3ScrollView` | Show Horizontal Scroll Bar. |
| `scrollBarAutoHide` | `bool` | `true` | read/write | `Md3ScrollView` | Scroll Bar Auto Hide. |
| `scrollBarThickness` | `real` | `10` | read/write | `Md3ScrollView` | Scroll Bar Thickness. |
| `fillContentWidth` | `bool` | `true` | read/write | `Md3ScrollView` | When true (default), content width matches the viewport. |
| `minContentHeightToViewport` | `bool` | `false` | read/write | `Md3ScrollView` | When true, contentHeight is at least the viewport (old behavior — empty scroll room). Default false: short content does not create a tall empty flick area. |
| `showScrollToTop` | `bool` | `false` | read/write | `Md3ScrollView` | Optional FAB that appears after scrolling down; animates back to top. |
| `scrollToTopThreshold` | `real` | `120` | read/write | `Md3ScrollView` | Scroll To Top Threshold. |
| `content` | `alias` | `contentHost.data` | default read/write | `Md3ScrollView` | Content. |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `scrollToTop()` | `—` | `Md3ScrollView` | Scroll To Top. |

## Example

```qml
import Md3

Md3ScrollView {
    interactive: true
    showVerticalScrollBar: true
    showHorizontalScrollBar: true
    scrollBarAutoHide: true
    scrollBarThickness: 10
    fillContentWidth: true
}
```
