# Md3ButtonGroup

- **Source:** `src/Md3/components/Md3ButtonGroup.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 11 | 1 | 3 | 2 |

_Also inherits Qt Quick `Item` members (not listed)._

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
| `layout` | `int (Md3ButtonGroup.Layout)` | `Md3ButtonGroup.Standard` | read/write | `Md3ButtonGroup` | Layout. |
| `variant` | `int (Md3ButtonGroup.Variant)` | `Md3ButtonGroup.Outlined` | read/write | `Md3ButtonGroup` | Visual / role variant (see Enums). |
| `model` | `var` | `[]` | read/write | `Md3ButtonGroup` | [{ text, icon?, enabled? }] |
| `currentIndex` | `int` | `-1` | read/write | `Md3ButtonGroup` | optional highlight; -1 = none |
| `autoSelect` | `bool` | `true` | read/write | `Md3ButtonGroup` | When true, clicks update `currentIndex` (no host `onClicked: currentIndex = index` glue). |
| `spacing` | `real` | `8` | read/write | `Md3ButtonGroup` | Child spacing. |
| `buttonHeight` | `real` | `40` | read/write | `Md3ButtonGroup` | Compact title-bar / dense UIs: set e.g. 24–28 |
| `iconSize` | `real` | `18` | read/write | `Md3ButtonGroup` | Icon Size. |
| `fontSize` | `real` | `Md3Theme.scaled(Md3Theme.typography.labelLarge.size)` | read/write | `Md3ButtonGroup` | Font Size. |
| `outerRadius` | `real` | `buttonHeight / 2` | readonly | `Md3ButtonGroup` | Outer Radius. |
| `connected` | `bool` | `layout === Md3ButtonGroup.Connected` | readonly | `Md3ButtonGroup` | Connected. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `clicked(int index)` | `Md3ButtonGroup` | Emitted when clicked. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `itemEnabled(index)` | `—` | `Md3ButtonGroup` | Item Enabled. |
| `containerFor(selected)` | `—` | `Md3ButtonGroup` | Container For. |
| `contentFor(selected)` | `—` | `Md3ButtonGroup` | Content For. |

## Example

```qml
import Md3

Md3ButtonGroup {
    layout: Md3ButtonGroup.Standard
    variant: Md3ButtonGroup.Outlined
    model: []
    currentIndex: -1
    autoSelect: true
    spacing: 8
}
```
