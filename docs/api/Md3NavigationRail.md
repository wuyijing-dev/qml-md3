# Md3NavigationRail

- **Source:** `src/Md3/components/Md3NavigationRail.qml`
- **Extends:** `Rectangle`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 16 | 5 | 2 | 0 |

_Also inherits Qt Quick `Rectangle` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `model` | `var` | `[]` | read/write | `Md3NavigationRail` | Main (scrollable) destinations. Each entry: { icon, label, destIndex? } destIndex defaults to array index when omitted (legacy). |
| `footerModel` | `var` | `[]` | read/write | `Md3NavigationRail` | Bottom-pinned destinations (same entry shape). Use real destIndex for PageHost. |
| `currentIndex` | `int` | `0` | read/write | `Md3NavigationRail` | Selected destination index (maps to destIndex, not visual row). |
| `expanded` | `bool` | `false` | read/write | `Md3NavigationRail` | Expanded. |
| `headerLabel` | `string` | `""` | read/write | `Md3NavigationRail` | Header Label. |
| `showExpandToggle` | `bool` | `true` | read/write | `Md3NavigationRail` | Show Expand Toggle. |
| `hostWindow` | `var` | `null` | read/write | `Md3NavigationRail` | Optional Window for system-backdrop tint (else Window.window). |
| `showCollapsedTooltips` | `bool` | `true` | read/write | `Md3NavigationRail` | When collapsed, show destination label tip on hover (reparented outside rail clip). |
| `collapsedTooltipDelayMs` | `int` | `420` | read/write | `Md3NavigationRail` | Collapsed Tooltip Delay Ms. |
| `scrolling` | `bool` | `flick.moving \|\| flick.dragging` | readonly | `Md3NavigationRail` | True while the destination list is being flicked/dragged. |
| `destinationHeight` | `real` | `Md3Theme.navDestinationHeight` | readonly | `Md3NavigationRail` | Destination Height. |
| `destinationSpacing` | `real` | `4` | readonly | `Md3NavigationRail` | Destination Spacing. |
| `indicatorInset` | `real` | `12` | readonly | `Md3NavigationRail` | Indicator Inset. |
| `collapsedIndicatorWidth` | `real` | `56` | readonly | `Md3NavigationRail` | Collapsed Indicator Width. |
| `collapsedIndicatorHeight` | `real` | `Md3Theme.densityCompact ? 28 : 32` | readonly | `Md3NavigationRail` | Collapsed Indicator Height. |
| `expandDuration` | `int` | `Md3Motion.spatialDuration` | readonly | `Md3NavigationRail` | Expand Duration. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `currentIndexChangedByUser(int index)` | `Md3NavigationRail` | Emitted when current Index Changed By User. |
| `destinationHovered(int index)` | `Md3NavigationRail` | Emitted when destination Hovered. |
| `destinationUnhovered(int index)` | `Md3NavigationRail` | Emitted when destination Unhovered. |
| `destinationPreview(int index)` | `Md3NavigationRail` | Fired on long-press of a destination (preview / peek). |
| `expandToggleClicked()` | `Md3NavigationRail` | Emitted when expand Toggle Clicked. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `destIndexOf(entry, fallback)` | `—` | `Md3NavigationRail` | Dest Index Of. |
| `destinationY(index)` | `—` | `Md3NavigationRail` | Destination Y. |

## Example

```qml
import Md3

Md3NavigationRail {
    model: []
    footerModel: []
    currentIndex: 0
    expanded: false
    headerLabel: ""
    showExpandToggle: true
}
```
