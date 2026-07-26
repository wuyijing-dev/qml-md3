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
| `model` | `var` | `[]` | read/write | `Md3NavigationRail` | — |
| `currentIndex` | `int` | `0` | read/write | `Md3NavigationRail` | — |
| `expanded` | `bool` | `false` | read/write | `Md3NavigationRail` | — |
| `headerLabel` | `string` | `""` | read/write | `Md3NavigationRail` | — |
| `showExpandToggle` | `bool` | `true` | read/write | `Md3NavigationRail` | Built-in control to expand/collapse and show full labels |
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
| `destinationHovered(int index)` | `Md3NavigationRail` | Hover intent for PageHost predictive prefetch (L2 / soft L1). |
| `destinationUnhovered(int index)` | `Md3NavigationRail` | — |
| `expandToggleClicked()` | `Md3NavigationRail` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `destinationY(index)` | `Md3NavigationRail` | — |

## Example

```qml
import Md3

Md3NavigationRail {
    model: []
    currentIndex: 0
    expanded: false
    headerLabel: ""
    showExpandToggle: true
}
```
