# Md3CommandBar

Desktop command strip with primary actions and a secondary overflow menu (WinUI CommandBar PrimaryCommands / SecondaryCommands).

- **Source:** `src/Md3/components/Md3CommandBar.qml`
- **Extends:** `Rectangle`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `barHeight` | `real` | `48` | read/write | `Md3CommandBar` | — |
| `contentSpacing` | `real` | `4` | read/write | `Md3CommandBar` | — |
| `horizontalPadding` | `real` | `8` | read/write | `Md3CommandBar` | — |
| `showDivider` | `bool` | `true` | read/write | `Md3CommandBar` | — |
| `overflowModel` | `var` | `[]` | read/write | `Md3CommandBar` | Secondary / overflow items: [{ text, icon?, enabled? }, ...] |
| `overlayWindow` | `var` | `null` | read/write | `Md3CommandBar` | Optional explicit Window for overflow menu overlay. |
| `content` | `alias` | `primaryStack.content` | read/write | `Md3CommandBar` | Alias → `primaryStack.content` |
| `data` | `alias` | `primaryStack.content` | default read/write | `Md3CommandBar` | Default property → `primaryStack.content` |
| `overflowOpen` | `bool` | `overflowMenu.open` | readonly | `Md3CommandBar` | — |
| `hasOverflow` | `bool` | `overflowModel.length > 0` | readonly | `Md3CommandBar` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `overflowItemClicked(int index)` | `Md3CommandBar` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `openOverflow()` | `Md3CommandBar` | — |
| `dismissOverflow()` | `Md3CommandBar` | — |

## Example

```qml
import Md3

Md3CommandBar {
    barHeight: 48
    contentSpacing: 4
    horizontalPadding: 8
    showDivider: true
    overflowModel: []
}
```
