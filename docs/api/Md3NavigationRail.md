# Md3NavigationRail

- **Source:** `src/Md3/components/Md3NavigationRail.qml`
- **Extends:** `Rectangle`

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
| `expanded` | `bool` | `false` | read/write | `Md3NavigationRail` | — |
| `headerLabel` | `string` | `""` | read/write | `Md3NavigationRail` | — |
| `showExpandToggle` | `bool` | `true` | read/write | `Md3NavigationRail` | — |
| `hostWindow` | `var` | `null` | read/write | `Md3NavigationRail` | Optional Window for system-backdrop tint (else Window.window). |
| `scrolling` | `bool` | `flick.moving \|\| flick.dragging` | readonly | `Md3NavigationRail` | True while the destination list is being flicked/dragged. |
| `destinationHeight` | `real` | `56` | readonly | `Md3NavigationRail` | — |
| `destinationSpacing` | `real` | `4` | readonly | `Md3NavigationRail` | — |
| `indicatorInset` | `real` | `12` | readonly | `Md3NavigationRail` | — |
| `collapsedIndicatorWidth` | `real` | `56` | readonly | `Md3NavigationRail` | — |
| `collapsedIndicatorHeight` | `real` | `32` | readonly | `Md3NavigationRail` | — |
| `expandDuration` | `int` | `Md3Motion.spatialDuration` | readonly | `Md3NavigationRail` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `currentIndexChangedByUser(int index)` | `Md3NavigationRail` | — |
| `destinationHovered(int index)` | `Md3NavigationRail` | — |
| `destinationUnhovered(int index)` | `Md3NavigationRail` | — |
| `expandToggleClicked()` | `Md3NavigationRail` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `destIndexOf(entry, fallback)` | `Md3NavigationRail` | — |
| `destinationY(index)` | `Md3NavigationRail` | — |

## Example

```qml
import Md3

Md3NavigationRail {
    model: []
    footerModel: []
    currentIndex: 0
    expanded: false
    headerLabel: ""
}
```
