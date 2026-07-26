# Md3AssistChip

- **Source:** `src/Md3/components/Md3AssistChip.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `text` | `string` | `""` | read/write | `Md3AssistChip` | — |
| `icon` | `string` | `""` | read/write | `Md3AssistChip` | — |
| `elevated` | `bool` | `false` | read/write | `Md3AssistChip` | — |
| `enabled` | `bool` | `true` | read/write | `Md3AssistChip` | — |
| `accessibleName` | `string` | `text` | read/write | `Md3AssistChip` | — |
| `containerColor` | `color` | `{…}` | readonly | `Md3AssistChip` | — |
| `contentColor` | `color` | `enabled ? Md3Theme.colorScheme.colorOnSurface` | readonly | `Md3AssistChip` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `clicked()` | `Md3AssistChip` | — |

## Methods

_None._

## Example

```qml
import Md3

Md3AssistChip {
    text: ""
    icon: ""
    elevated: false
    accessibleName: text
}
```
