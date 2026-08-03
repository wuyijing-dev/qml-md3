# Md3AppToolBar

Compact app tool strip for `Md3ApplicationWindow.toolBar` (desktop chrome).

- **Source:** `src/Md3/components/Md3AppToolBar.qml`
- **Extends:** `Rectangle`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 8 | 0 | 0 | 1 |

_Also inherits Qt Quick `Rectangle` members (not listed)._

## Import

```qml
import Md3
```

## Enums

### `Md3AppToolBar.Density`

`Md3AppToolBar.Standard`, `Md3AppToolBar.Compact`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `density` | `int (Md3AppToolBar.Density)` | `Md3AppToolBar.Standard` | read/write | `Md3AppToolBar` | Layout density (see Enums / theme). |
| `barHeight` | `real` | `density === Md3AppToolBar.Compact` | read/write | `Md3AppToolBar` | Bar Height. |
| `contentSpacing` | `real` | `density === Md3AppToolBar.Compact` | read/write | `Md3AppToolBar` | Content Spacing. |
| `horizontalPadding` | `real` | `Md3Theme.spacingMd` | read/write | `Md3AppToolBar` | Horizontal Padding. |
| `showDivider` | `bool` | `true` | read/write | `Md3AppToolBar` | Show Divider. |
| `trailing` | `alias` | `trailingSlot.data` | read/write | `Md3AppToolBar` | Optional overflow control (e.g. Md3IconButton "more") pinned to the trailing edge. |
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
    density: Md3AppToolBar.Standard
    barHeight: density === Md3AppToolBar.Compact
    contentSpacing: density === Md3AppToolBar.Compact
    horizontalPadding: Md3Theme.spacingMd
    showDivider: true
}
```

## 与 CommandBar

需要 **Primary + Secondary（溢出菜单）** 时用 [`Md3CommandBar`](Md3CommandBar.md)；本类型适合任意自定义子项、无溢出语义的轻量条。

详见 [buttons-commands.md](../guides/buttons-commands.md)。
