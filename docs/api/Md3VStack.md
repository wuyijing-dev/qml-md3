# Md3VStack

Vertical stack with spacing, padding, alignment, and optional child stretch.  **Default property is `content` (→ layout host), never `data`.** Wrappers must write `default property alias x: stack.content` — aliasing `stack.data` parks children on the stack root and they will not lay out.

- **Source:** `src/Md3/layout/Md3VStack.qml`
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

### `Md3VStack.Alignment`

`Md3VStack.Start`, `Md3VStack.Center`, `Md3VStack.End`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `spacing` | `real` | `8` | read/write | `Md3VStack` | Child spacing. |
| `padding` | `real` | `0` | read/write | `Md3VStack` | Uniform padding. |
| `leftPadding` | `real` | `padding` | read/write | `Md3VStack` | Left Padding. |
| `rightPadding` | `real` | `padding` | read/write | `Md3VStack` | Right Padding. |
| `topPadding` | `real` | `padding` | read/write | `Md3VStack` | Top Padding. |
| `bottomPadding` | `real` | `padding` | read/write | `Md3VStack` | Bottom Padding. |
| `fillWidth` | `bool` | `true` | read/write | `Md3VStack` | Fill Width. |
| `stretchChildren` | `bool` | `true` | read/write | `Md3VStack` | Stretch visible children to content width (skip Md3Spacer with expand). |
| `clipContent` | `bool` | `false` | read/write | `Md3VStack` | Clip Content. |
| `alignment` | `int (Md3VStack.Alignment)` | `Md3VStack.Start` | read/write | `Md3VStack` | Alignment. |
| `contentItem` | `alias` | `contentCol` | read/write | `Md3VStack` | Layout host — use this (or the default property), not `data`. |
| `content` | `alias` | `contentCol.data` | default read/write | `Md3VStack` | Content. |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3VStack {
    spacing: 8
    padding: 0
    leftPadding: padding
    rightPadding: padding
    topPadding: padding
    bottomPadding: padding
}
```
