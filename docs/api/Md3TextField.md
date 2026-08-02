# Md3TextField

- **Source:** `src/Md3/components/Md3TextField.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 36 | 5 | 4 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

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
| `variant` | `int (Md3TextField.Variant)` | `Md3TextField.Filled` | read/write | `Md3TextField` | Visual / role variant (see Enums). |
| `text` | `alias` | `input.text` | read/write | `Md3TextField` | Primary label text. |
| `label` | `string` | `""` | read/write | `Md3TextField` | Field / control label. |
| `placeholderText` | `string` | `""` | read/write | `Md3TextField` | Placeholder when empty. |
| `supportingText` | `string` | `""` | read/write | `Md3TextField` | Supporting Text. |
| `errorText` | `string` | `""` | read/write | `Md3TextField` | Validation error string (empty = ok). |
| `error` | `bool` | `false` | read/write | `Md3TextField` | Error. |
| `name` | `string` | `""` | read/write | `Md3TextField` | Form field key for Md3Form.validate / error auto-wiring. |
| `multiline` | `bool` | `false` | read/write | `Md3TextField` | Multiline. |
| `maximumLineCount` | `int` | `multiline ? 4 : 1` | read/write | `Md3TextField` | Maximum Line Count. |
| `leadingIcon` | `string` | `""` | read/write | `Md3TextField` | Leading Icon. |
| `trailingIcon` | `string` | `""` | read/write | `Md3TextField` | Trailing Icon. |
| `password` | `bool` | `false` | read/write | `Md3TextField` | Password. |
| `passwordVisible` | `bool` | `false` | read/write | `Md3TextField` | Password Visible. |
| `clearOnTrailing` | `bool` | `true` | read/write | `Md3TextField` | Clear On Trailing. |
| `showClearButton` | `bool` | `false` | read/write | `Md3TextField` | When true, shows a clear affordance whenever the field has text (unless password). |
| `announceErrors` | `bool` | `true` | read/write | `Md3TextField` | Shake + announce when error becomes active; optional Android haptic. |
| `errorFeedbackEnabled` | `bool` | `true` | read/write | `Md3TextField` | Error Feedback Enabled. |
| `errorShakeMs` | `int` | `Md3Motion.short3` | read/write | `Md3TextField` | Error Shake Ms. |
| `errorShakePx` | `real` | `6` | read/write | `Md3TextField` | Error Shake Px. |
| `autoComplete` | `bool` | `false` | read/write | `Md3TextField` | Enable typeahead popup from `suggestions`. |
| `suggestions` | `var` | `[]` | read/write | `Md3TextField` | string[] or [{ label, value }] |
| `suggestionLimit` | `int` | `6` | read/write | `Md3TextField` | Suggestion Limit. |
| `suggestionOpen` | `bool` | `false` | read/write | `Md3TextField` | Suggestion Open. |
| `suggestionIndex` | `int` | `-1` | read/write | `Md3TextField` | Keyboard highlight in the suggestion list (-1 = none). |
| `accessibleName` | `string` | `""` | read/write | `Md3TextField` | Accessible name override. |
| `accessibleDescription` | `string` | `""` | read/write | `Md3TextField` | Accessible description override. |
| `overlayWindow` | `var` | `null` | read/write | `Md3TextField` | Optional explicit Window for autocomplete overlay reparent. |
| `focused` | `bool` | `input.activeFocus` | readonly | `Md3TextField` | Focused. |
| `floated` | `bool` | `focused \|\| text.length > 0` | readonly | `Md3TextField` | Floated. |
| `hasError` | `bool` | `error \|\| errorText.length > 0` | readonly | `Md3TextField` | Has Error. |
| `helper` | `string` | `hasError ? (errorText.length ? errorText : supportingText) : supportingText` | readonly | `Md3TextField` | Helper. |
| `activeColor` | `color` | `hasError ? Md3Theme.colorScheme.error` | readonly | `Md3TextField` | Active Color. |
| `fieldSurface` | `color` | `Md3Theme.colorScheme.surface` | readonly | `Md3TextField` | Field Surface. |
| `effectiveTrailingIcon` | `string` | `{…}` | readonly | `Md3TextField` | Effective Trailing Icon. |
| `filteredSuggestions` | `var` | `{…}` | readonly | `Md3TextField` | Filtered Suggestions. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `trailingClicked()` | `Md3TextField` | Emitted when trailing Clicked. |
| `accepted()` | `Md3TextField` | Emitted on Enter / Return (same as Qt Quick Controls TextField.accepted). |
| `editingFinished()` | `Md3TextField` | Emitted when editing ends: accepted, or focus leaves the field with text changed. Prefer this over a non-existent `editingFinished` on older snippets. |
| `suggestionChosen(var suggestion)` | `Md3TextField` | Emitted when suggestion Chosen. |
| `textEdited()` | `Md3TextField` | Emitted when text Edited. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `applySuggestion(s)` | `—` | `Md3TextField` | Apply Suggestion. |
| `applyHighlightedSuggestion()` | `—` | `Md3TextField` | Apply Highlighted Suggestion. |
| `moveSuggestionHighlight(delta)` | `—` | `Md3TextField` | Move Suggestion Highlight. |
| `handleTrailing()` | `—` | `Md3TextField` | Handle Trailing. |

## Example

```qml
import Md3

Md3TextField {
    variant: Md3TextField.Filled
    label: ""
    placeholderText: ""
    supportingText: ""
    errorText: ""
    error: false
}
```
