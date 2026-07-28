# Md3PageSection

Title + optional subtitle + content block — reduces page/form boilerplate.

- **Source:** `src/Md3/layout/Md3PageSection.qml`

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `title` | string | `""` | Section title |
| `subtitle` | string | `""` | Supporting text |
| `spacing` | real | `12` | Gap under header |
| `padding` | real | `0` | Outer padding |
| `fillWidth` | bool | `true` | Stretch to parent |
| `content` | alias | default | Body children |

## Example

```qml
Md3PageSection {
    title: qsTr("Theme")
    subtitle: qsTr("Colors and density")
    Md3Switch { /* ... */ }
}
```
