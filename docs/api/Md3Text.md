# Md3Text

- **Source:** `src/Md3/components/Md3Text.qml`
- **Extends:** `Text`

## Import

```qml
import Md3
```

## Enums

### `Md3Text.Role`

`Md3Text.DisplayLarge`, `Md3Text.DisplayMedium`, `Md3Text.DisplaySmall`, `Md3Text.HeadlineLarge`, `Md3Text.HeadlineMedium`, `Md3Text.HeadlineSmall`, `Md3Text.TitleLarge`, `Md3Text.TitleMedium`, `Md3Text.TitleSmall`, `Md3Text.BodyLarge`, `Md3Text.BodyMedium`, `Md3Text.BodySmall`, `Md3Text.LabelLarge`, `Md3Text.LabelMedium`, `Md3Text.LabelSmall`

### `Md3Text.Tone`

`Md3Text.OnSurface`, `Md3Text.OnSurfaceVariant`, `Md3Text.Primary`, `Md3Text.Secondary`, `Md3Text.Tertiary`, `Md3Text.Error`, `Md3Text.Custom`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `role` | `int` | `Md3Text.BodyMedium` | read/write | `Md3Text` | — |
| `tone` | `int` | `Md3Text.OnSurface` | read/write | `Md3Text` | — |
| `customColor` | `color` | `Md3Theme.colorScheme.colorOnSurface` | read/write | `Md3Text` | — |
| `monospace` | `bool` | `false` | read/write | `Md3Text` | — |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3Text {
    role: Md3Text.BodyMedium
    tone: Md3Text.OnSurface
    customColor: Md3Theme.colorScheme.colorOnSurface
    monospace: false
}
```
