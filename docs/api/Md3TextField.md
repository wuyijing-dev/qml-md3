# Md3TextField

- **Source:** `src/Md3/components/Md3TextField.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `variant` | `int` | `Filled` | Filled / Outlined |
| `text` | `string` | `""` | Field text |
| `label` | `string` | `""` | Floating label |
| `autoComplete` | `bool` | `false` | Suggestion popup |
| `suggestions` | `var` | `[]` | `string` or `{ label, value }` |
| `suggestionLimit` | `int` | `6` | Max rows |
| `suggestionIndex` | `int` | `-1` | Keyboard highlight |
| `accessibleName` | `string` | `""` | Screen reader name |
| `accessibleDescription` | `string` | `""` | Screen reader description |

## AutoComplete keys

| Key | Action |
|-----|--------|
| `↓` / `↑` | Move highlight |
| `Enter` | Apply highlight (or first item) |
| `Esc` | Close popup |
| `Tab` | Apply highlight when one is selected |

## Signals

`trailingClicked()`, `accepted()`, `suggestionChosen(var)`

## Example

```qml
Md3TextField {
    label: qsTr("城市")
    autoComplete: true
    accessibleName: qsTr("城市")
    suggestions: ["Beijing", "Shanghai"]
}
```
