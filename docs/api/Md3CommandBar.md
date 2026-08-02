# Md3CommandBar

Desktop command strip with primary actions and a secondary overflow menu (WinUI CommandBar PrimaryCommands / SecondaryCommands).

- **Source:** `src/Md3/components/Md3CommandBar.qml`
- **Extends:** `Rectangle`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 11 | 1 | 2 | 0 |

_Also inherits Qt Quick `Rectangle` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `barHeight` | `real` | `48` | read/write | `Md3CommandBar` | Bar Height. |
| `contentSpacing` | `real` | `4` | read/write | `Md3CommandBar` | Content Spacing. |
| `horizontalPadding` | `real` | `8` | read/write | `Md3CommandBar` | Horizontal Padding. |
| `showDivider` | `bool` | `true` | read/write | `Md3CommandBar` | Show Divider. |
| `overflowModel` | `var` | `[]` | read/write | `Md3CommandBar` | Secondary / overflow items: [{ text, icon?, enabled? }, ...] |
| `overlayWindow` | `var` | `null` | read/write | `Md3CommandBar` | Optional explicit Window for overflow menu overlay. |
| `accessibleName` | `string` | `qsTr("Command bar")` | read/write | `Md3CommandBar` | Accessible name override. |
| `content` | `alias` | `primaryStack.content` | read/write | `Md3CommandBar` | Content. |
| `data` | `alias` | `primaryStack.content` | default read/write | `Md3CommandBar` | Data. |
| `overflowOpen` | `bool` | `overflowMenu.open` | readonly | `Md3CommandBar` | Overflow Open. |
| `hasOverflow` | `bool` | `overflowModel.length > 0` | readonly | `Md3CommandBar` | Has Overflow. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `overflowItemClicked(int index)` | `Md3CommandBar` | Emitted when overflow Item Clicked. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `openOverflow()` | `—` | `Md3CommandBar` | Open Overflow. |
| `dismissOverflow()` | `—` | `Md3CommandBar` | Dismiss Overflow. |

## Example

```qml
import Md3

Md3CommandBar {
    barHeight: 48
    contentSpacing: 4
    horizontalPadding: 8
    showDivider: true
    overflowModel: []
    overlayWindow: null
}
```

## WinUI 对照

| WinUI | Md3 | 说明 |
|-------|-----|------|
| CommandBar | `Md3CommandBar` | Primary = 子项；Secondary = `overflowModel` |
| AppBarButton | `Md3AppBarButton` | 工具栏项 |
| （简单自定义条） | `Md3AppToolBar` | 无溢出菜单时的轻量替代 |

## 用法

```qml
Md3CommandBar {
    width: parent.width
    overflowModel: [
        { text: qsTr("Share"), icon: "share" },
        { text: qsTr("Print"), icon: "print" }
    ]
    onOverflowItemClicked: (i) => runOverflow(i)

    Md3AppBarButton { icon: "save"; label: qsTr("Save") }
    Md3AppBarButton { icon: "undo"; label: qsTr("Undo") }
    Md3AppBarToggleButton { icon: "grid_view"; label: qsTr("Grid"); checked: true }
}
```

适合 `Md3ApplicationWindow.toolBar`。详见 [buttons-commands.md](../guides/buttons-commands.md)。
