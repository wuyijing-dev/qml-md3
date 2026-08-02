# Md3DocumentTabBar

Win11 Explorer / browser document tabs — reorder, close, tear-off, add pop-in.

- **Source:** `src/Md3/components/Md3DocumentTabBar.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 18 | 5 | 2 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `model` | `var` | `[]` | read/write | `Md3DocumentTabBar` | [{ title, icon?, closable? }] |
| `currentIndex` | `int` | `0` | read/write | `Md3DocumentTabBar` | Current index. |
| `showAddButton` | `bool` | `true` | read/write | `Md3DocumentTabBar` | Show Add Button. |
| `closable` | `bool` | `true` | read/write | `Md3DocumentTabBar` | Closable. |
| `tearOffEnabled` | `bool` | `false` | read/write | `Md3DocumentTabBar` | Tear Off Enabled. |
| `reorderEnabled` | `bool` | `true` | read/write | `Md3DocumentTabBar` | Reorder Enabled. |
| `tabHeight` | `real` | `32` | read/write | `Md3DocumentTabBar` | Tab Height. |
| `minTabWidth` | `real` | `120` | read/write | `Md3DocumentTabBar` | Min Tab Width. |
| `maxTabWidth` | `real` | `240` | read/write | `Md3DocumentTabBar` | Max Tab Width. |
| `dragThreshold` | `real` | `8` | read/write | `Md3DocumentTabBar` | Drag Threshold. |
| `tearOffSlop` | `real` | `28` | read/write | `Md3DocumentTabBar` | Tear Off Slop. |
| `animateAdd` | `bool` | `true` | read/write | `Md3DocumentTabBar` | Play pop-in when a tab is appended |
| `unifiedWithTitleBar` | `bool` | `false` | read/write | `Md3DocumentTabBar` | When true, bar fill is transparent so a parent chrome strip paints title+tabs as one. |
| `hostWindow` | `var` | `null` | read/write | `Md3DocumentTabBar` | Optional Window for backdrop tint / tear-off bounds (else Window.window). |
| `barColor` | `color` | `{…}` | readonly | `Md3DocumentTabBar` | Bar Color. |
| `tabSelected` | `color` | `{…}` | readonly | `Md3DocumentTabBar` | Tab Selected. |
| `tabHover` | `color` | `Md3Theme.colorScheme.withOpacity( Md3Theme.colorScheme.colorOnSurface, 0.05)` | readonly | `Md3DocumentTabBar` | Tab Hover. |
| `tabRadius` | `real` | `8` | readonly | `Md3DocumentTabBar` | Tab Radius. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `tabActivated(int index)` | `Md3DocumentTabBar` | Emitted when tab Activated. |
| `tabCloseRequested(int index)` | `Md3DocumentTabBar` | Emitted when tab Close Requested. |
| `tabAddRequested()` | `Md3DocumentTabBar` | Emitted when tab Add Requested. |
| `tabMoved(int from, int to)` | `Md3DocumentTabBar` | Emitted when tab Moved. |
| `tabTearOff(int index, real globalX, real globalY)` | `Md3DocumentTabBar` | Emitted when tab Tear Off. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `scrollTabs(delta)` | `—` | `Md3DocumentTabBar` | Scroll Tabs. |
| `ensureTabVisible(index)` | `—` | `Md3DocumentTabBar` | Ensure Tab Visible. |

## Example

```qml
import Md3

Md3DocumentTabBar {
    model: []
    currentIndex: 0
    showAddButton: true
    closable: true
    tearOffEnabled: false
    reorderEnabled: true
}
```
