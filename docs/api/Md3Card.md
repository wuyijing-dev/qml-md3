# Md3Card

- **Source:** `src/Md3/components/Md3Card.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 14 | 2 | 0 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

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
| `variant` | `int (Md3Card.Variant)` | `Md3Card.Elevated` | read/write | `Md3Card` | Visual / role variant (see Enums). |
| `clickable` | `bool` | `false` | read/write | `Md3Card` | Clickable. |
| `padding` | `real` | `Md3Theme.spacingLg` | read/write | `Md3Card` | Uniform padding. |
| `layoutMode` | `int` | `Md3ContainerBody.Fit` | read/write | `Md3Card` | Layout Mode. |
| `title` | `string` | `""` | read/write | `Md3Card` | Optional header — when set, users need not nest title Text manually. |
| `subtitle` | `string` | `""` | read/write | `Md3Card` | Secondary supporting text. |
| `headerTrailing` | `alias` | `headerTrailingSlot.data` | read/write | `Md3Card` | Trailing controls in the header row (e.g. Md3Button). |
| `actions` | `var` | `[]` | read/write | `Md3Card` | [{ text, icon?, variant? }] — compact header actions without Row glue. |
| `actionsMaxVisible` | `int` | `0` | read/write | `Md3Card` | Cap header actions before overflow menu (0 = show all). |
| `fillFallbackHeight` | `real` | `160` | read/write | `Md3Card` | Body height when children use anchors.fill (StatTile-style). |
| `content` | `alias` | `bodySlot.data` | default read/write | `Md3Card` | Content. |
| `elev` | `real` | `variant === Md3Card.Elevated ? 1 : 0` | readonly | `Md3Card` | Elev. |
| `hasHeader` | `bool` | `title.length > 0 \|\| subtitle.length > 0` | readonly | `Md3Card` | Has Header. |
| `containerColor` | `color` | `{…}` | readonly | `Md3Card` | Container Color. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `clicked()` | `Md3Card` | Emitted when clicked. |
| `actionClicked(int index)` | `Md3Card` | Emitted when action Clicked. |

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
    subtitle: ""
}
```
