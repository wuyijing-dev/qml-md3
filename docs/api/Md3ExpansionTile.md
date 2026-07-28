# Md3ExpansionTile

- **Source:** `src/Md3/components/Md3ExpansionTile.qml`
- **Extends:** `Column`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `title` | `string` | `""` | read/write | `Md3ExpansionTile` | — |
| `subtitle` | `string` | `""` | read/write | `Md3ExpansionTile` | — |
| `expanded` | `bool` | `false` | read/write | `Md3ExpansionTile` | — |
| `content` | `alias` | `contentCol.data` | default read/write | `Md3ExpansionTile` | Default property → `contentCol.data` |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3ExpansionTile {
    title: ""
    subtitle: ""
    expanded: false
}
```
