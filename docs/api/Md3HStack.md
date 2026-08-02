# Md3HStack

Horizontal stack with spacing, padding, alignment, and expanding spacers. Manual Item layout (not Row): setting y/height on Row children re-enters updatePolish and triggers "polish() loop" warnings.

- **Source:** `src/Md3/layout/Md3HStack.qml`
- **Extends:** `Item`

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
| `spacing` | `real` | `8` | read/write | `Md3HStack` | — |
| `padding` | `real` | `0` | read/write | `Md3HStack` | — |
| `leftPadding` | `real` | `padding` | read/write | `Md3HStack` | — |
| `rightPadding` | `real` | `padding` | read/write | `Md3HStack` | — |
| `topPadding` | `real` | `padding` | read/write | `Md3HStack` | — |
| `bottomPadding` | `real` | `padding` | read/write | `Md3HStack` | — |
| `fillHeight` | `bool` | `false` | read/write | `Md3HStack` | — |
| `stretchChildren` | `bool` | `false` | read/write | `Md3HStack` | — |
| `clipContent` | `bool` | `false` | read/write | `Md3HStack` | — |
| `alignment` | `int` | `Md3HStack.Center` | read/write | `Md3HStack` | — |
| `content` | `alias` | `contentHost.data` | default read/write | `Md3HStack` | Default property → `contentHost.data` |

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
}
```
