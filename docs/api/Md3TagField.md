# Md3TagField

- **Source:** `src/Md3/components/Md3TagField.qml`
- **Extends:** `Item`

Multi-tag chip input. Enter / separators commit; Backspace removes the last tag.

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `variant` | `int` | `Filled` | `Filled` / `Outlined` |
| `tags` | `var` | `[]` | string[] |
| `label` / `placeholderText` / `supportingText` / `errorText` | `string` | | Field chrome |
| `allowDuplicates` | `bool` | `false` | — |
| `separators` | `string` | `",;"` | Commit characters |
| `maxTags` | `int` | `0` | 0 = unlimited |

## Signals

`tagAdded(string)`, `tagRemoved(string, int)`, `tagsChangedByUser()`

## Example

```qml
Md3TagField {
    label: qsTr("Tags")
    tags: ["design"]
}
```
