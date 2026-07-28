# Md3BottomSheet

- **Source:** `src/Md3/components/Md3BottomSheet.qml`

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `open` / `modal` | bool | `false` / `true` | — |
| `layoutMode` | int | `Fit` | Fit / Scroll body |
| `title` / `text` | string | `""` | Optional header copy |
| `confirmText` / `dismissText` | string | `""` | Action buttons (hidden when empty) |
| `content` | alias | default | Custom body |

## Signals

`dismissed()`, `confirmed()`

## Example

```qml
Md3BottomSheet {
    title: qsTr("Options")
    text: qsTr("Choose an action")
    confirmText: qsTr("Done")
}
```
