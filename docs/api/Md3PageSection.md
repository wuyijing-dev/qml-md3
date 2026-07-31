# Md3PageSection

Page section: title + optional subtitle + content — cuts gallery/form glue.

- **Source:** `src/Md3/layout/Md3PageSection.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `title` | `string` | `""` | read/write | `Md3PageSection` | — |
| `subtitle` | `string` | `""` | read/write | `Md3PageSection` | — |
| `spacing` | `real` | `Md3Theme.spacingMd` | read/write | `Md3PageSection` | — |
| `padding` | `real` | `0` | read/write | `Md3PageSection` | — |
| `fillWidth` | `bool` | `true` | read/write | `Md3PageSection` | — |
| `content` | `alias` | `body.data` | default read/write | `Md3PageSection` | Default property → `body.data` |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3PageSection {
    title: ""
    subtitle: ""
    spacing: Md3Theme.spacingMd
    padding: 0
    fillWidth: true
}
```
