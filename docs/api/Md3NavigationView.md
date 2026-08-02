# Md3NavigationView

Adaptive navigation shell (WinUI NavigationView–inspired). Modes: Auto / Left (expanded rail) / LeftCompact (collapsed rail) / Top (app bar + bottom bar). Default property is page content (like Scaffold) — does not own PageHost.

- **Source:** `src/Md3/components/Md3NavigationView.qml`
- **Extends:** `Item`

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
| `model` | `alias` | `root.destinations` | read/write | `Md3NavigationView` | Alias → `root.destinations` |
| `currentIndex` | `int` | `0` | read/write | `Md3NavigationView` | — |
| `paneDisplayMode` | `int` | `Md3NavigationView.Auto` | read/write | `Md3NavigationView` | — |
| `headerLabel` | `string` | `""` | read/write | `Md3NavigationView` | — |
| `drawerTitle` | `string` | `""` | read/write | `Md3NavigationView` | — |
| `expanded` | `bool` | `true` | read/write | `Md3NavigationView` | Used when effective mode is Left (ignored in LeftCompact). |
| `showExpandToggle` | `bool` | `true` | read/write | `Md3NavigationView` | — |
| `drawerOpen` | `bool` | `false` | read/write | `Md3NavigationView` | — |
| `hostWindow` | `var` | `null` | read/write | `Md3NavigationView` | — |
| `compactBreakpoint` | `real` | `Md3Adaptive.navigationCompactBreakpoint` | read/write | `Md3NavigationView` | Aligned with Md3Adaptive / Material WindowSizeClass (compact < 600, medium < 840). |
| `expandedBreakpoint` | `real` | `Md3Adaptive.navigationExpandedBreakpoint` | read/write | `Md3NavigationView` | — |
| `content` | `alias` | `contentHost.data` | default read/write | `Md3NavigationView` | Default property → `contentHost.data` |
| `effectivePaneDisplayMode` | `int` | `{…}` | readonly | `Md3NavigationView` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `currentIndexChangedByUser(int index)` | `Md3NavigationView` | — |
| `expandToggleClicked()` | `Md3NavigationView` | — |
| `drawerDismissed()` | `Md3NavigationView` | — |
| `destinationPreview(int index)` | `Md3NavigationView` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `openDrawer()` | `Md3NavigationView` | — |
| `closeDrawer()` | `Md3NavigationView` | — |
| `handleBack()` | `Md3NavigationView` | — |

## Example

```qml
import Md3

Md3NavigationView {
    destinations: []
    currentIndex: 0
    paneDisplayMode: Md3NavigationView.Auto
    headerLabel: ""
    drawerTitle: ""
}
```
