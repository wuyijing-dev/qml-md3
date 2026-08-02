# Md3AppToolBar

Compact app tool strip for `Md3ApplicationWindow.toolBar` (desktop chrome).

- **Source:** `src/Md3/components/Md3AppToolBar.qml`
- **Extends:** `Rectangle`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 6 | 0 | 0 | 0 |

_Also inherits Qt Quick `Rectangle` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `barHeight` | `real` | `Md3Theme.controlHeight + 8` | read/write | `Md3AppToolBar` | Bar Height. |
| `contentSpacing` | `real` | `Md3Theme.spacingSm` | read/write | `Md3AppToolBar` | Content Spacing. |
| `horizontalPadding` | `real` | `Md3Theme.spacingMd` | read/write | `Md3AppToolBar` | Horizontal Padding. |
| `showDivider` | `bool` | `true` | read/write | `Md3AppToolBar` | Show Divider. |
| `content` | `alias` | `stack.content` | read/write | `Md3AppToolBar` | Content. |
| `data` | `alias` | `stack.content` | default read/write | `Md3AppToolBar` | Data. |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3AppToolBar {
    barHeight: Md3Theme.controlHeight + 8
    contentSpacing: Md3Theme.spacingSm
    horizontalPadding: Md3Theme.spacingMd
    showDivider: true
}
```

## 与 CommandBar

需要 **Primary + Secondary（溢出菜单）** 时用 [`Md3CommandBar`](Md3CommandBar.md)；本类型适合任意自定义子项、无溢出语义的轻量条。

详见 [buttons-commands.md](../guides/buttons-commands.md)。
