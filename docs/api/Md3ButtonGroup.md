# Md3ButtonGroup

- **Source:** `src/Md3/components/Md3ButtonGroup.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Enums

### `Md3ButtonGroup.Layout`

`Md3ButtonGroup.Standard`, `Md3ButtonGroup.Connected`

### `Md3ButtonGroup.Variant`

`Md3ButtonGroup.Filled`, `Md3ButtonGroup.FilledTonal`, `Md3ButtonGroup.Outlined`, `Md3ButtonGroup.Text`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `layout` | `int` | `Md3ButtonGroup.Standard` | read/write | `Md3ButtonGroup` | — |
| `variant` | `int` | `Md3ButtonGroup.Outlined` | read/write | `Md3ButtonGroup` | — |
| `model` | `var` | `[]` | read/write | `Md3ButtonGroup` | — |
| `enabled` | `bool` | `true` | read/write | `Md3ButtonGroup` | — |
| `currentIndex` | `int` | `-1` | read/write | `Md3ButtonGroup` | — |
| `spacing` | `real` | `8` | read/write | `Md3ButtonGroup` | — |
| `buttonHeight` | `real` | `40` | read/write | `Md3ButtonGroup` | Compact title-bar / dense UIs: set e.g. 24–28 |
| `iconSize` | `real` | `18` | read/write | `Md3ButtonGroup` | — |
| `fontSize` | `real` | `Md3Theme.scaled(Md3Theme.typography.labelLarge.size)` | read/write | `Md3ButtonGroup` | — |
| `outerRadius` | `real` | `buttonHeight / 2` | readonly | `Md3ButtonGroup` | — |
| `connected` | `bool` | `layout === Md3ButtonGroup.Connected` | readonly | `Md3ButtonGroup` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `clicked(int index)` | `Md3ButtonGroup` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `itemEnabled(index)` | `Md3ButtonGroup` | — |
| `containerFor(selected)` | `Md3ButtonGroup` | — |
| `contentFor(selected)` | `Md3ButtonGroup` | — |

## Example

```qml
import Md3

Md3ButtonGroup {
    layout: Md3ButtonGroup.Standard
    variant: Md3ButtonGroup.Outlined
    model: []
    currentIndex: -1
    spacing: 8
}
```
