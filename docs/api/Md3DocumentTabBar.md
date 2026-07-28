# Md3DocumentTabBar

Win11 Explorer / browser document tabs — reorder, close, tear-off, add pop-in.

- **Source:** `src/Md3/components/Md3DocumentTabBar.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `model` | `var` | `[]` | read/write | `Md3DocumentTabBar` | [{ title, icon?, closable? }] |
| `currentIndex` | `int` | `0` | read/write | `Md3DocumentTabBar` | — |
| `showAddButton` | `bool` | `true` | read/write | `Md3DocumentTabBar` | — |
| `closable` | `bool` | `true` | read/write | `Md3DocumentTabBar` | — |
| `tearOffEnabled` | `bool` | `false` | read/write | `Md3DocumentTabBar` | — |
| `reorderEnabled` | `bool` | `true` | read/write | `Md3DocumentTabBar` | — |
| `tabHeight` | `real` | `32` | read/write | `Md3DocumentTabBar` | — |
| `minTabWidth` | `real` | `120` | read/write | `Md3DocumentTabBar` | — |
| `maxTabWidth` | `real` | `240` | read/write | `Md3DocumentTabBar` | — |
| `dragThreshold` | `real` | `8` | read/write | `Md3DocumentTabBar` | — |
| `tearOffSlop` | `real` | `28` | read/write | `Md3DocumentTabBar` | — |
| `animateAdd` | `bool` | `true` | read/write | `Md3DocumentTabBar` | Play pop-in when a tab is appended |
| `barColor` | `color` | `{…}` | readonly | `Md3DocumentTabBar` | — |
| `tabSelected` | `color` | `{…}` | readonly | `Md3DocumentTabBar` | — |
| `tabHover` | `color` | `Md3Theme.colorScheme.withOpacity( Md3Theme.colorScheme.colorOnSurface, 0.05)` | readonly | `Md3DocumentTabBar` | — |
| `tabRadius` | `real` | `8` | readonly | `Md3DocumentTabBar` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `tabActivated(int index)` | `Md3DocumentTabBar` | — |
| `tabCloseRequested(int index)` | `Md3DocumentTabBar` | — |
| `tabAddRequested()` | `Md3DocumentTabBar` | — |
| `tabMoved(int from, int to)` | `Md3DocumentTabBar` | — |
| `tabTearOff(int index, real globalX, real globalY)` | `Md3DocumentTabBar` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `scrollTabs(delta)` | `Md3DocumentTabBar` | — |
| `ensureTabVisible(index)` | `Md3DocumentTabBar` | — |

## Example

```qml
import Md3

Md3DocumentTabBar {
    model: []
    currentIndex: 0
    showAddButton: true
    closable: true
    tearOffEnabled: false
}
```
