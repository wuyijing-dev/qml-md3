# Md3Card

- **Source:** `src/Md3/components/Md3Card.qml`

## Enums

`Elevated`, `Filled`, `Outlined`

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `variant` | int | `Elevated` | Surface style |
| `clickable` | bool | `false` | Emits `clicked` |
| `padding` | real | `16` | Content inset |
| `layoutMode` | int | `Fit` | Fit or Scroll body |
| `title` / `subtitle` | string | `""` | Optional header |
| `headerTrailing` | alias | — | Custom trailing header slot |
| `actions` | var | `[]` | `[{ text, icon?, variant? }]` header buttons |
| `content` | alias | default | Body under the header |

## Signals

`clicked()`, `actionClicked(int index)`

## Example

```qml
Md3Card {
    title: qsTr("Storage")
    subtitle: qsTr("Local cache")
    actions: [{ text: qsTr("Reset"), variant: "outlined" }]
    onActionClicked: (i) => console.log(i)
    Md3Switch { text: qsTr("Enabled") }
}
```
