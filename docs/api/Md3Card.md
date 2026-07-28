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
| `padding` | `real` | `16` | read/write | `Md3Card` | — |
| `content` | `alias` | `contentHost.data` | default read/write | `Md3Card` | Default property → `contentHost.data` |
| `elev` | `real` | `variant === Md3Card.Elevated ? 1 : 0` | readonly | `Md3Card` | — |
| `containerColor` | `color` | `{…}` | readonly | `Md3Card` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `clicked()` | `Md3Card` | — |

## Methods

_None._

## Example

```qml
import Md3

Md3Card {
    variant: Md3Card.Elevated
    clickable: false
    padding: 16
}
```
