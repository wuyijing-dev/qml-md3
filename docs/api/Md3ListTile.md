# Md3ListTile

- **Source:** `src/Md3/components/Md3ListTile.qml`

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `title` / `subtitle` / `supportingText` | string | `""` | Lines |
| `leadingIcon` / `trailingIcon` | string | `""` | Material icons |
| `trailingRotation` | real | `0` | Chevron spin |
| `selected` / `showDivider` | bool | `false` | — |
| `fillWidth` | bool | `true` | Stretch to parent (no `width: parent.width`) |
| `trailing` | alias | — | Trailing control slot (e.g. Switch) |

## Signals

`clicked()`, `trailingClicked()`

## Example

```qml
Md3ListTile {
    title: qsTr("Dark theme")
    leadingIcon: "dark_mode"
    showDivider: true
    trailing: Md3Switch { checked: true }
}
```
