# Md3ScrollView

Themed scroll view: Flickable + optional Md3ScrollBar overlays.

- **Source:** `src/Md3/components/Md3ScrollView.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `contentWidth` | `alias` | `flick.contentWidth` | read/write | `Md3ScrollView` | Alias → `flick.contentWidth` |
| `contentHeight` | `alias` | `flick.contentHeight` | read/write | `Md3ScrollView` | Alias → `flick.contentHeight` |
| `contentX` | `alias` | `flick.contentX` | read/write | `Md3ScrollView` | Alias → `flick.contentX` |
| `contentY` | `alias` | `flick.contentY` | read/write | `Md3ScrollView` | Alias → `flick.contentY` |
| `flickable` | `alias` | `flick` | read/write | `Md3ScrollView` | Alias → `flick` |
| `clip` | `alias` | `flick.clip` | read/write | `Md3ScrollView` | Alias → `flick.clip` |
| `interactive` | `bool` | `true` | read/write | `Md3ScrollView` | — |
| `showVerticalScrollBar` | `bool` | `true` | read/write | `Md3ScrollView` | — |
| `showHorizontalScrollBar` | `bool` | `true` | read/write | `Md3ScrollView` | — |
| `scrollBarAutoHide` | `bool` | `true` | read/write | `Md3ScrollView` | — |
| `scrollBarThickness` | `real` | `10` | read/write | `Md3ScrollView` | — |
| `fillContentWidth` | `bool` | `true` | read/write | `Md3ScrollView` | When true (default), content width matches the viewport. |
| `showScrollToTop` | `bool` | `false` | read/write | `Md3ScrollView` | Optional FAB that appears after scrolling down; animates back to top. |
| `scrollToTopThreshold` | `real` | `120` | read/write | `Md3ScrollView` | — |
| `content` | `alias` | `contentHost.data` | default read/write | `Md3ScrollView` | Default property → `contentHost.data` |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `scrollToTop()` | `Md3ScrollView` | — |

## Example

```qml
import Md3

Md3ScrollView {
    interactive: true
    showVerticalScrollBar: true
    showHorizontalScrollBar: true
    scrollBarAutoHide: true
    scrollBarThickness: 10
}
```
