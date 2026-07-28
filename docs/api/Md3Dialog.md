# Md3Dialog

- **Source:** `src/Md3/components/Md3Dialog.qml`

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `open` | bool | `false` | — |
| `title` / `text` | string | `""` | Header |
| `confirmText` / `dismissText` | string | `"OK"` / `"Cancel"` | Actions |
| `showDismiss` | bool | `true` | — |
| `content` | alias | default | Custom body between text and buttons |

## Signals

`confirmed()`, `dismissed()`

## Example

```qml
Md3Dialog {
    title: qsTr("Edit profile")
    text: qsTr("Update your display name")
    Md3TextField { label: qsTr("Name") }
}
```
