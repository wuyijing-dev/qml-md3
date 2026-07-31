# Md3AppToolBar

Compact app tool strip for `Md3ApplicationWindow.toolBar` (desktop chrome).

- **Source:** `src/Md3/components/Md3AppToolBar.qml`
- **Extends:** `Rectangle`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `barHeight` | `real` | `44` | read/write | `Md3AppToolBar` | — |
| `contentSpacing` | `real` | `8` | read/write | `Md3AppToolBar` | — |
| `horizontalPadding` | `real` | `12` | read/write | `Md3AppToolBar` | — |
| `showDivider` | `bool` | `true` | read/write | `Md3AppToolBar` | — |
| `content` | `alias` | `stack.content` | read/write | `Md3AppToolBar` | Alias → `stack.content` |
| `data` | `alias` | `stack.content` | default read/write | `Md3AppToolBar` | Default property → `stack.content` |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3AppToolBar {
    barHeight: 44
    contentSpacing: 8
    horizontalPadding: 12
    showDivider: true
}
```

## 与 CommandBar

需要 **Primary + Secondary（溢出菜单）** 时用 [`Md3CommandBar`](Md3CommandBar.md)；本类型适合任意自定义子项、无溢出语义的轻量条。

详见 [buttons-commands.md](../buttons-commands.md)。
