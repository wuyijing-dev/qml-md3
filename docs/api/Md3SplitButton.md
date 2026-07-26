# Md3SplitButton

- **Source:** `src/Md3/components/Md3SplitButton.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Enums

### `Md3SplitButton.Variant`

`Md3SplitButton.Filled`, `Md3SplitButton.FilledTonal`, `Md3SplitButton.Outlined`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `variant` | `int` | `Md3SplitButton.Filled` | read/write | `Md3SplitButton` | — |
| `text` | `string` | `""` | read/write | `Md3SplitButton` | — |
| `icon` | `string` | `""` | read/write | `Md3SplitButton` | — |
| `menuModel` | `var` | `[]` | read/write | `Md3SplitButton` | — |
| `enabled` | `bool` | `true` | read/write | `Md3SplitButton` | — |
| `accessibleName` | `string` | `text` | read/write | `Md3SplitButton` | — |
| `visualFocus` | `bool` | `false` | read/write | `Md3SplitButton` | — |
| `menuOpen` | `bool` | `menu.open` | readonly | `Md3SplitButton` | — |
| `h` | `real` | `40` | readonly | `Md3SplitButton` | — |
| `corner` | `real` | `h / 2` | readonly | `Md3SplitButton` | — |
| `trailingWidth` | `real` | `40` | readonly | `Md3SplitButton` | — |
| `containerColor` | `color` | `{…}` | readonly | `Md3SplitButton` | — |
| `contentColor` | `color` | `{…}` | readonly | `Md3SplitButton` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `clicked()` | `Md3SplitButton` | — |
| `menuItemClicked(int index)` | `Md3SplitButton` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `openMenu()` | `Md3SplitButton` | — |
| `dismissMenu()` | `Md3SplitButton` | — |

## Example

```qml
import Md3

Md3SplitButton {
    variant: Md3SplitButton.Filled
    text: ""
    icon: ""
    menuModel: []
    accessibleName: text
}
```
