# Md3ExpansionTile

- **Source:** `src/Md3/components/Md3ExpansionTile.qml`
- **Extends:** `Column`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 5 | 0 | 0 | 0 |

_Also inherits Qt Quick `Column` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `title` | `string` | `""` | read/write | `Md3ExpansionTile` | Title text. |
| `subtitle` | `string` | `""` | read/write | `Md3ExpansionTile` | Secondary supporting text. |
| `expanded` | `bool` | `false` | read/write | `Md3ExpansionTile` | Expanded. |
| `layoutMode` | `int` | `Md3ContainerBody.Fit` | read/write | `Md3ExpansionTile` | Layout Mode. |
| `content` | `alias` | `contentCol.data` | default read/write | `Md3ExpansionTile` | Content. |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3ExpansionTile {
    title: ""
    subtitle: ""
    expanded: false
    layoutMode: Md3ContainerBody.Fit
}
```
