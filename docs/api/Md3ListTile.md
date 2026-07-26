# Md3ListTile

- **Source:** `src/Md3/components/Md3ListTile.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `title` | `string` | `""` | read/write | `Md3ListTile` | — |
| `subtitle` | `string` | `""` | read/write | `Md3ListTile` | — |
| `supportingText` | `string` | `""` | read/write | `Md3ListTile` | — |
| `leadingIcon` | `string` | `""` | read/write | `Md3ListTile` | — |
| `trailingIcon` | `string` | `""` | read/write | `Md3ListTile` | — |
| `selected` | `bool` | `false` | read/write | `Md3ListTile` | — |
| `enabled` | `bool` | `true` | read/write | `Md3ListTile` | — |
| `showDivider` | `bool` | `false` | read/write | `Md3ListTile` | — |
| `lines` | `int` | `{…}` | readonly | `Md3ListTile` | — |
| `minH` | `real` | `lines === 1 ? 56 : (lines === 2 ? 72 : 88)` | readonly | `Md3ListTile` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `clicked()` | `Md3ListTile` | — |
| `trailingClicked()` | `Md3ListTile` | — |

## Methods

_None._

## Example

```qml
import Md3

Md3ListTile {
    title: ""
    subtitle: ""
    supportingText: ""
    leadingIcon: ""
    trailingIcon: ""
}
```
