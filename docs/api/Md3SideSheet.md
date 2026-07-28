# Md3SideSheet

Modal/standard side sheet — slides from start (left) or end (right).

- **Source:** `src/Md3/components/Md3SideSheet.qml`

## Enums

`Edge`: `Start`, `End`

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `open` / `modal` | bool | `false` / `true` | — |
| `edge` | int | `End` | — |
| `sheetWidth` | real | `360` | — |
| `title` / `text` | string | `""` | Header + body copy |
| `layoutMode` | int | `Fit` | Fit / Scroll |
| `content` | alias | default | Extra body under `text` |

## Signals / methods

`dismissed()`, `dismiss()`

## Example

```qml
Md3SideSheet {
    title: qsTr("Details")
    text: qsTr("Secondary content without leaving the page.")
    Md3Button { text: qsTr("Done"); onClicked: dismiss() }
}
```
