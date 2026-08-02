# Md3NavigationView

Adaptive navigation shell (WinUI NavigationView–inspired). Modes: Auto / Left (expanded rail) / LeftCompact (collapsed rail) / Top (app bar + bottom bar). Default property is page content (like Scaffold) — does not own PageHost.

- **Source:** `src/Md3/components/Md3NavigationView.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 14 | 4 | 3 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Enums

### `Md3NavigationView.PaneDisplayMode`

`Md3NavigationView.Auto`, `Md3NavigationView.Left`, `Md3NavigationView.LeftCompact`, `Md3NavigationView.Top`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `destinations` | `var` | `[]` | read/write | `Md3NavigationView` | Destinations: { icon, label\|title, destIndex?, pin:"bottom"\|footer, badge… } |
| `model` | `alias` | `root.destinations` | read/write | `Md3NavigationView` | Data model. |
| `currentIndex` | `int` | `0` | read/write | `Md3NavigationView` | Current index. |
| `paneDisplayMode` | `int (Md3NavigationView.PaneDisplayMode)` | `Md3NavigationView.Auto` | read/write | `Md3NavigationView` | Pane Display Mode. |
| `headerLabel` | `string` | `""` | read/write | `Md3NavigationView` | Header Label. |
| `drawerTitle` | `string` | `""` | read/write | `Md3NavigationView` | Drawer Title. |
| `expanded` | `bool` | `true` | read/write | `Md3NavigationView` | Used when effective mode is Left (ignored in LeftCompact). |
| `showExpandToggle` | `bool` | `true` | read/write | `Md3NavigationView` | Show Expand Toggle. |
| `drawerOpen` | `bool` | `false` | read/write | `Md3NavigationView` | Drawer Open. |
| `hostWindow` | `var` | `null` | read/write | `Md3NavigationView` | Host Window. |
| `compactBreakpoint` | `real` | `Md3Adaptive.navigationCompactBreakpoint` | read/write | `Md3NavigationView` | Aligned with Md3Adaptive / Material WindowSizeClass (compact < 600, medium < 840). |
| `expandedBreakpoint` | `real` | `Md3Adaptive.navigationExpandedBreakpoint` | read/write | `Md3NavigationView` | Expanded Breakpoint. |
| `content` | `alias` | `contentHost.data` | default read/write | `Md3NavigationView` | Content. |
| `effectivePaneDisplayMode` | `int` | `{…}` | readonly | `Md3NavigationView` | Effective Pane Display Mode. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `currentIndexChangedByUser(int index)` | `Md3NavigationView` | Emitted when current Index Changed By User. |
| `expandToggleClicked()` | `Md3NavigationView` | Emitted when expand Toggle Clicked. |
| `drawerDismissed()` | `Md3NavigationView` | Emitted when drawer Dismissed. |
| `destinationPreview(int index)` | `Md3NavigationView` | Emitted when destination Preview. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `openDrawer()` | `—` | `Md3NavigationView` | Open Drawer. |
| `closeDrawer()` | `—` | `Md3NavigationView` | Close Drawer. |
| `handleBack()` | `—` | `Md3NavigationView` | Handle Back. |

## Example

```qml
import Md3

Md3NavigationView {
    destinations: []
    currentIndex: 0
    paneDisplayMode: Md3NavigationView.Auto
    headerLabel: ""
    drawerTitle: ""
    expanded: true
}
```
