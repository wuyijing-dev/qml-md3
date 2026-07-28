# Md3HStack

- **Source:** `src/Md3/layout/Md3HStack.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `content` | `alias` | `contentRow.data` | default read/write | `Md3HStack` | Default property -> `contentRow.data` |
| `spacing` | `real` | `8` | read/write | `Md3HStack` | Child spacing |
| `padding` | `real` | `0` | read/write | `Md3HStack` | Inner padding |
| `fillHeight` | `bool` | `false` | read/write | `Md3HStack` | Stretch content height to container |
| `clipContent` | `bool` | `false` | read/write | `Md3HStack` | Clip inner row |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3HStack {
    spacing: 8
    Md3Button { text: "Cancel"; variant: Md3Button.Outlined }
    Md3Button { text: "Save" }
}
```
