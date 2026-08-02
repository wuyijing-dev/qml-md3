# Md3HStack

Horizontal stack with spacing, padding, alignment, and expanding spacers. Manual Item layout (not Row): setting y/height on Row children re-enters updatePolish and triggers "polish() loop" warnings.  **Default property is `content` (→ layout host), never `data`.** Wrappers must write `default property alias x: stack.content` — aliasing `stack.data` parks children on the stack root and they will not lay out.

- **Source:** `src/Md3/layout/Md3HStack.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 12 | 0 | 0 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Enums

### `Md3HStack.Alignment`

`Md3HStack.Start`, `Md3HStack.Center`, `Md3HStack.End`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `spacing` | `real` | `8` | read/write | `Md3HStack` | Child spacing. |
| `padding` | `real` | `0` | read/write | `Md3HStack` | Uniform padding. |
| `leftPadding` | `real` | `padding` | read/write | `Md3HStack` | Left Padding. |
| `rightPadding` | `real` | `padding` | read/write | `Md3HStack` | Right Padding. |
| `topPadding` | `real` | `padding` | read/write | `Md3HStack` | Top Padding. |
| `bottomPadding` | `real` | `padding` | read/write | `Md3HStack` | Bottom Padding. |
| `fillHeight` | `bool` | `false` | read/write | `Md3HStack` | Fill Height. |
| `stretchChildren` | `bool` | `false` | read/write | `Md3HStack` | Stretch Children. |
| `clipContent` | `bool` | `false` | read/write | `Md3HStack` | Clip Content. |
| `alignment` | `int (Md3HStack.Alignment)` | `Md3HStack.Center` | read/write | `Md3HStack` | Alignment. |
| `contentItem` | `alias` | `contentHost` | read/write | `Md3HStack` | Layout host — use this (or the default property), not `data`. |
| `content` | `alias` | `contentHost.data` | default read/write | `Md3HStack` | Content. |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3HStack {
    spacing: 8
    padding: 0
    leftPadding: padding
    rightPadding: padding
    topPadding: padding
    bottomPadding: padding
}
```
