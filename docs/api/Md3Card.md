# Md3Card

- **Source:** `src/Md3/components/Md3Card.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Enums

### `Md3Card.Variant`

`Md3Card.Elevated`, `Md3Card.Filled`, `Md3Card.Outlined`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `variant` | `int` | `Md3Card.Elevated` | read/write | `Md3Card` | — |
| `clickable` | `bool` | `false` | read/write | `Md3Card` | — |
| `padding` | `real` | `Md3Theme.spacingLg` | read/write | `Md3Card` | — |
| `layoutMode` | `int` | `Md3ContainerBody.Fit` | read/write | `Md3Card` | — |
| `title` | `string` | `""` | read/write | `Md3Card` | Optional header — when set, users need not nest title Text manually. |
| `subtitle` | `string` | `""` | read/write | `Md3Card` | — |
| `headerTrailing` | `alias` | `headerTrailingSlot.data` | read/write | `Md3Card` | Trailing controls in the header row (e.g. Md3Button). |
| `actions` | `var` | `[]` | read/write | `Md3Card` | [{ text, icon?, variant? }] — compact header actions without Row glue. |
| `content` | `alias` | `bodySlot.data` | default read/write | `Md3Card` | Default property → `bodySlot.data` |
| `elev` | `real` | `variant === Md3Card.Elevated ? 1 : 0` | readonly | `Md3Card` | — |
| `hasHeader` | `bool` | `title.length > 0 \|\| subtitle.length > 0` | readonly | `Md3Card` | — |
| `containerColor` | `color` | `{…}` | readonly | `Md3Card` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `clicked()` | `Md3Card` | — |
| `actionClicked(int index)` | `Md3Card` | — |

## Methods

_None._

## Example

```qml
import Md3

Md3Card {
    variant: Md3Card.Elevated
    clickable: false
    padding: Md3Theme.spacingLg
    layoutMode: Md3ContainerBody.Fit
    title: ""
}
```
