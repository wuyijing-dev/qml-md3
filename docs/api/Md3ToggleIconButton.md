# Md3ToggleIconButton

- **Source:** `src/Md3/components/Md3ToggleIconButton.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Enums

### `Md3ToggleIconButton.Variant`

`Md3ToggleIconButton.Standard`, `Md3ToggleIconButton.Filled`, `Md3ToggleIconButton.FilledTonal`, `Md3ToggleIconButton.Outlined`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `variant` | `int` | `Md3ToggleIconButton.Standard` | read/write | `Md3ToggleIconButton` | — |
| `icon` | `string` | `"favorite"` | read/write | `Md3ToggleIconButton` | — |
| `enabled` | `bool` | `true` | read/write | `Md3ToggleIconButton` | — |
| `checked` | `bool` | `false` | read/write | `Md3ToggleIconButton` | — |
| `accessibleName` | `string` | `icon` | read/write | `Md3ToggleIconButton` | — |
| `visualFocus` | `bool` | `false` | read/write | `Md3ToggleIconButton` | — |
| `circleSize` | `real` | `40` | readonly | `Md3ToggleIconButton` | — |
| `circleRadius` | `real` | `circleSize / 2` | readonly | `Md3ToggleIconButton` | — |
| `containerColor` | `color` | `{…}` | readonly | `Md3ToggleIconButton` | — |
| `contentColor` | `color` | `{…}` | readonly | `Md3ToggleIconButton` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `clicked()` | `Md3ToggleIconButton` | — |
| `toggled(bool checked)` | `Md3ToggleIconButton` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `toggle()` | `Md3ToggleIconButton` | — |

## Example

```qml
import Md3

Md3ToggleIconButton {
    variant: Md3ToggleIconButton.Standard
    icon: "favorite"
    checked: false
    accessibleName: icon
    visualFocus: false
}
```
