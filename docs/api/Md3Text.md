# Md3Text

Themed `Text` with MD3 type roles and color tones — prefer over raw `Text { color: ...; font... }`.

- **Source:** `src/Md3/components/Md3Text.qml`
- **Extends:** `Text`

## Enums

### `Role`

`DisplayLarge` … `LabelSmall` (full MD3 type scale).

### `Tone`

`OnSurface`, `OnSurfaceVariant`, `Primary`, `Secondary`, `Tertiary`, `Error`, `Custom`.

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `role` | int | `BodyMedium` | Typography token |
| `tone` | int | `OnSurface` | Color token |
| `customColor` | color | onSurface | Used when `tone: Custom` |
| `monospace` | bool | `false` | Consolas face |

## Example

```qml
Md3Text {
    text: qsTr("Hello")
    role: Md3Text.TitleMedium
    tone: Md3Text.OnSurfaceVariant
}
```
