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

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `variant` | `int` | `Md3TextField.Filled` | read/write | `Md3TextField` | — |
| `text` | `alias` | `input.text` | read/write | `Md3TextField` | Alias → `input.text` |
| `label` | `string` | `""` | read/write | `Md3TextField` | — |
| `placeholderText` | `string` | `""` | read/write | `Md3TextField` | — |
| `supportingText` | `string` | `""` | read/write | `Md3TextField` | — |
| `errorText` | `string` | `""` | read/write | `Md3TextField` | — |
| `error` | `bool` | `false` | read/write | `Md3TextField` | — |
| `enabled` | `bool` | `true` | read/write | `Md3TextField` | — |
| `multiline` | `bool` | `false` | read/write | `Md3TextField` | — |
| `maximumLineCount` | `int` | `multiline ? 4 : 1` | read/write | `Md3TextField` | — |
| `leadingIcon` | `string` | `""` | read/write | `Md3TextField` | — |
| `trailingIcon` | `string` | `""` | read/write | `Md3TextField` | — |
| `password` | `bool` | `false` | read/write | `Md3TextField` | — |
| `passwordVisible` | `bool` | `false` | read/write | `Md3TextField` | — |
| `clearOnTrailing` | `bool` | `true` | read/write | `Md3TextField` | — |
| `autoComplete` | `bool` | `false` | read/write | `Md3TextField` | Enable typeahead popup from `suggestions`. |
| `suggestions` | `var` | `[]` | read/write | `Md3TextField` | string[] or [{ label, value }] |
| `suggestionLimit` | `int` | `6` | read/write | `Md3TextField` | — |
| `suggestionOpen` | `bool` | `false` | read/write | `Md3TextField` | — |
| `suggestionIndex` | `int` | `-1` | read/write | `Md3TextField` | Keyboard highlight in the suggestion list (-1 = none). |
| `accessibleName` | `string` | `""` | read/write | `Md3TextField` | — |
| `accessibleDescription` | `string` | `""` | read/write | `Md3TextField` | — |
| `focused` | `bool` | `input.activeFocus` | readonly | `Md3TextField` | — |
| `floated` | `bool` | `focused \|\| text.length > 0` | readonly | `Md3TextField` | — |
| `hasError` | `bool` | `error \|\| errorText.length > 0` | readonly | `Md3TextField` | — |
| `helper` | `string` | `hasError ? (errorText.length ? errorText : supportingText) : supportingText` | readonly | `Md3TextField` | — |
| `activeColor` | `color` | `hasError ? Md3Theme.colorScheme.error` | readonly | `Md3TextField` | — |
| `fieldSurface` | `color` | `Md3Theme.colorScheme.surface` | readonly | `Md3TextField` | — |
| `effectiveTrailingIcon` | `string` | `{…}` | readonly | `Md3TextField` | — |
| `filteredSuggestions` | `var` | `{…}` | readonly | `Md3TextField` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `trailingClicked()` | `Md3TextField` | — |
| `accepted()` | `Md3TextField` | — |
| `suggestionChosen(var suggestion)` | `Md3TextField` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `applySuggestion(s)` | `Md3TextField` | — |
| `applyHighlightedSuggestion()` | `Md3TextField` | — |
| `moveSuggestionHighlight(delta)` | `Md3TextField` | — |
| `handleTrailing()` | `Md3TextField` | — |

## Example

```qml
import Md3

Md3TextField {
    variant: Md3TextField.Filled
    label: ""
    placeholderText: ""
    supportingText: ""
    errorText: ""
}
```
