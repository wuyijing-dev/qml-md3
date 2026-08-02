# Md3TopAppBar

- **Source:** `src/Md3/components/Md3TopAppBar.qml`
- **Extends:** `Rectangle`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 6 | 2 | 0 | 1 |

_Also inherits Qt Quick `Rectangle` members (not listed)._

## Import

```qml
import Md3
```

## Enums

### `Md3TopAppBar.Size`

`Md3TopAppBar.Small`, `Md3TopAppBar.CenterAligned`, `Md3TopAppBar.Medium`, `Md3TopAppBar.Large`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `size` | `int (Md3TopAppBar.Size)` | `Md3TopAppBar.Small` | read/write | `Md3TopAppBar` | Control size token (see Enums). |
| `title` | `string` | `""` | read/write | `Md3TopAppBar` | Title text. |
| `leadingIcon` | `string` | `"menu"` | read/write | `Md3TopAppBar` | Leading Icon. |
| `showLeading` | `bool` | `true` | read/write | `Md3TopAppBar` | Show Leading. |
| `trailingIcons` | `var` | `[]` | read/write | `Md3TopAppBar` | Trailing Icons. |
| `barHeight` | `real` | `{…}` | readonly | `Md3TopAppBar` | Bar Height. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `leadingClicked()` | `Md3TopAppBar` | Emitted when leading Clicked. |
| `trailingClicked(int index)` | `Md3TopAppBar` | Emitted when trailing Clicked. |

## Methods

_None._

## Example

```qml
import Md3

Md3TopAppBar {
    size: Md3TopAppBar.Small
    title: ""
    leadingIcon: "menu"
    showLeading: true
    trailingIcons: []
}
```
