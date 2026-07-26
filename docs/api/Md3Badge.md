# Md3Badge

- **Source:** `src/Md3/components/Md3Badge.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `text` | `string` | `""` | read/write | `Md3Badge` | — |
| `dot` | `bool` | `false` | read/write | `Md3Badge` | — |
| `badgeColor` | `color` | `Md3Theme.colorScheme.error` | read/write | `Md3Badge` | — |
| `labelColor` | `color` | `Md3Theme.colorScheme.colorOnError` | read/write | `Md3Badge` | — |
| `large` | `bool` | `!dot && text.length > 0` | readonly | `Md3Badge` | — |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3Badge {
    text: ""
    dot: false
    badgeColor: Md3Theme.colorScheme.error
    labelColor: Md3Theme.colorScheme.colorOnError
}
```
