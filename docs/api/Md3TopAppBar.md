# Md3TopAppBar

- **Source:** `src/Md3/components/Md3TopAppBar.qml`
- **Extends:** `Rectangle`

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
| `size` | `int` | `Md3TopAppBar.Small` | read/write | `Md3TopAppBar` | — |
| `title` | `string` | `""` | read/write | `Md3TopAppBar` | — |
| `leadingIcon` | `string` | `"menu"` | read/write | `Md3TopAppBar` | — |
| `showLeading` | `bool` | `true` | read/write | `Md3TopAppBar` | — |
| `trailingIcons` | `var` | `[]` | read/write | `Md3TopAppBar` | Strings or `{ icon, badge?, badgeText?, badgeDot?, badgeMax? }` |
| `barHeight` | `real` | `{…}` | readonly | `Md3TopAppBar` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `leadingClicked()` | `Md3TopAppBar` | — |
| `trailingClicked(int index)` | `Md3TopAppBar` | — |

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
