# Md3VStack

Vertical stack with spacing, padding, alignment, and optional child stretch.

- **Source:** `src/Md3/layout/Md3VStack.qml`
- **Extends:** `Item`

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
| `spacing` | `real` | `8` | read/write | `Md3VStack` | — |
| `padding` | `real` | `0` | read/write | `Md3VStack` | — |
| `leftPadding` | `real` | `padding` | read/write | `Md3VStack` | — |
| `rightPadding` | `real` | `padding` | read/write | `Md3VStack` | — |
| `topPadding` | `real` | `padding` | read/write | `Md3VStack` | — |
| `bottomPadding` | `real` | `padding` | read/write | `Md3VStack` | — |
| `fillWidth` | `bool` | `true` | read/write | `Md3VStack` | — |
| `stretchChildren` | `bool` | `true` | read/write | `Md3VStack` | Stretch visible children to content width (skip Md3Spacer with expand). |
| `clipContent` | `bool` | `false` | read/write | `Md3VStack` | — |
| `alignment` | `int` | `Md3VStack.Start` | read/write | `Md3VStack` | — |
| `content` | `alias` | `contentCol.data` | default read/write | `Md3VStack` | Default property → `contentCol.data` |

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
}
```
