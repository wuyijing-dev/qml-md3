# Md3TextField

- **Source:** `src/Md3/components/Md3TextField.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Enums

### `Md3TextField.Variant`

`Md3TextField.Filled`, `Md3TextField.Outlined`

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `variant` | `int` | `Filled` | Filled / Outlined |
| `text` | `string` | `""` | Field text |
| `label` | `string` | `""` | Floating label |
| `placeholderText` | `string` | `""` | Placeholder |
| `supportingText` | `string` | `""` | Helper text |
| `errorText` | `string` | `""` | Error helper |
| `error` | `bool` | `false` | Error state |
| `enabled` | `bool` | `true` | Enabled |
| `multiline` | `bool` | `false` | Multi-line |
| `leadingIcon` / `trailingIcon` | `string` | `""` | Icons |
| `password` | `bool` | `false` | Password mode |
| `clearOnTrailing` | `bool` | `true` | Clear on trailing close |
| `autoComplete` | `bool` | `false` | Suggestion popup |
| `suggestions` | `var` | `[]` | `string` or `{ label, value }` |
| `suggestionLimit` | `int` | `6` | Max rows |
| `suggestionOpen` | `bool` | — | Popup visibility |
| `filteredSuggestions` | `var` | readonly | Filtered list |

## Signals

| Signal | Description |
|--------|-------------|
| `trailingClicked()` | Trailing action |
| `accepted()` | Enter (or first suggestion applied) |
| `suggestionChosen(var)` | User picked a suggestion |

## Example

```qml
Md3TextField {
    label: qsTr("城市")
    autoComplete: true
    suggestions: ["Beijing", "Shanghai", { label: "Hong Kong", value: "Hong Kong" }]
}
```
