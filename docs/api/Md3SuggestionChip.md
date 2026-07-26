# Md3SuggestionChip

- **Source:** `src/Md3/components/Md3SuggestionChip.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `text` | `string` | `""` | read/write | `Md3SuggestionChip` | — |
| `elevated` | `bool` | `false` | read/write | `Md3SuggestionChip` | — |
| `enabled` | `bool` | `true` | read/write | `Md3SuggestionChip` | — |
| `accessibleName` | `string` | `text` | read/write | `Md3SuggestionChip` | — |
| `contentColor` | `color` | `enabled ? Md3Theme.colorScheme.colorOnSurfaceVariant` | readonly | `Md3SuggestionChip` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `clicked()` | `Md3SuggestionChip` | — |

## Methods

_None._

## Example

```qml
import Md3

Md3SuggestionChip {
    text: ""
    elevated: false
    accessibleName: text
}
```
