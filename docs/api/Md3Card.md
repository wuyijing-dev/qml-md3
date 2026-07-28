# Md3Card

- **Source:** `src/Md3/components/Md3Card.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Enums

### `Md3Card.Variant`

`Elevated`, `Filled`, `Outlined`

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `variant` | int | `Elevated` | Surface style |
| `clickable` | bool | `false` | Emits `clicked` |
| `padding` | real | `16` | Content inset |
| `layoutMode` | int | `Md3ContainerBody.Fit` | Fit or Scroll body |
| `title` | string | `""` | Optional header (no nested Text needed) |
| `subtitle` | string | `""` | Optional supporting header |
| `content` | alias | default | Body children under the header |
| `elev` / `containerColor` | readonly | — | Resolved chrome |

## Signals

| Signal | Description |
|--------|-------------|
| `clicked()` | When `clickable` |

## Example

```qml
Md3Card {
    title: qsTr("Storage")
    subtitle: qsTr("Local cache settings")
    layoutMode: Md3ContainerBody.Scroll
    Md3Switch { /* ... */ }
}
```
