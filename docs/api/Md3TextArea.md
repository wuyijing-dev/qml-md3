# Md3TextArea

Multiline text field alias — same API as ``Md3TextField { multiline: true }``.

- **Source:** `src/Md3/components/Md3TextArea.qml`
- **Extends:** `Md3TextField`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 0 | 0 | 0 | 0 |

## Import

```qml
import Md3
```

## Inheritance

[`Md3TextArea`](Md3TextArea.md) → [`Md3TextField`](Md3TextField.md)

## Enums

### `Md3TextField.Variant` _(from [Md3TextField](Md3TextField.md))_

`Md3TextField.Filled`, `Md3TextField.Outlined`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `variant` | `int (Md3TextField.Variant)` | `Md3TextField.Filled` | read/write | [`Md3TextField`](Md3TextField.md) | Visual / role variant (see Enums). |
| `text` | `alias` | `input.text` | read/write | [`Md3TextField`](Md3TextField.md) | Primary label text. |
| `label` | `string` | `""` | read/write | [`Md3TextField`](Md3TextField.md) | Field / control label. |
| `placeholderText` | `string` | `""` | read/write | [`Md3TextField`](Md3TextField.md) | Placeholder when empty. |
| `supportingText` | `string` | `""` | read/write | [`Md3TextField`](Md3TextField.md) | Supporting Text. |
| `errorText` | `string` | `""` | read/write | [`Md3TextField`](Md3TextField.md) | Validation error string (empty = ok). |
| `error` | `bool` | `false` | read/write | [`Md3TextField`](Md3TextField.md) | Error. |
| `name` | `string` | `""` | read/write | [`Md3TextField`](Md3TextField.md) | Form field key for Md3Form.validate / error auto-wiring. |
| `multiline` | `bool` | `false` | read/write | [`Md3TextField`](Md3TextField.md) | Multiline. |
| `maximumLineCount` | `int` | `multiline ? 4 : 1` | read/write | [`Md3TextField`](Md3TextField.md) | Maximum Line Count. |
| `leadingIcon` | `string` | `""` | read/write | [`Md3TextField`](Md3TextField.md) | Leading Icon. |
| `trailingIcon` | `string` | `""` | read/write | [`Md3TextField`](Md3TextField.md) | Trailing Icon. |
| `password` | `bool` | `false` | read/write | [`Md3TextField`](Md3TextField.md) | Password. |
| `passwordVisible` | `bool` | `false` | read/write | [`Md3TextField`](Md3TextField.md) | Password Visible. |
| `clearOnTrailing` | `bool` | `true` | read/write | [`Md3TextField`](Md3TextField.md) | Clear On Trailing. |
| `showClearButton` | `bool` | `false` | read/write | [`Md3TextField`](Md3TextField.md) | When true, shows a clear affordance whenever the field has text (unless password). |
| `announceErrors` | `bool` | `true` | read/write | [`Md3TextField`](Md3TextField.md) | Shake + announce when error becomes active; optional Android haptic. |
| `errorFeedbackEnabled` | `bool` | `true` | read/write | [`Md3TextField`](Md3TextField.md) | Error Feedback Enabled. |
| `errorShakeMs` | `int` | `Md3Motion.short3` | read/write | [`Md3TextField`](Md3TextField.md) | Error Shake Ms. |
| `errorShakePx` | `real` | `6` | read/write | [`Md3TextField`](Md3TextField.md) | Error Shake Px. |
| `autoComplete` | `bool` | `false` | read/write | [`Md3TextField`](Md3TextField.md) | Enable typeahead popup from `suggestions`. |
| `suggestions` | `var` | `[]` | read/write | [`Md3TextField`](Md3TextField.md) | string[] or [{ label, value }] |
| `suggestionLimit` | `int` | `6` | read/write | [`Md3TextField`](Md3TextField.md) | Suggestion Limit. |
| `suggestionOpen` | `bool` | `false` | read/write | [`Md3TextField`](Md3TextField.md) | Suggestion Open. |
| `suggestionIndex` | `int` | `-1` | read/write | [`Md3TextField`](Md3TextField.md) | Keyboard highlight in the suggestion list (-1 = none). |
| `accessibleName` | `string` | `""` | read/write | [`Md3TextField`](Md3TextField.md) | Accessible name override. |
| `accessibleDescription` | `string` | `""` | read/write | [`Md3TextField`](Md3TextField.md) | Accessible description override. |
| `overlayWindow` | `var` | `null` | read/write | [`Md3TextField`](Md3TextField.md) | Optional explicit Window for autocomplete overlay reparent. |
| `focused` | `bool` | `input.activeFocus` | readonly | [`Md3TextField`](Md3TextField.md) | Focused. |
| `floated` | `bool` | `focused \|\| text.length > 0` | readonly | [`Md3TextField`](Md3TextField.md) | Floated. |
| `hasError` | `bool` | `error \|\| errorText.length > 0` | readonly | [`Md3TextField`](Md3TextField.md) | Has Error. |
| `helper` | `string` | `hasError ? (errorText.length ? errorText : supportingText) : supportingText` | readonly | [`Md3TextField`](Md3TextField.md) | Helper. |
| `activeColor` | `color` | `hasError ? Md3Theme.colorScheme.error` | readonly | [`Md3TextField`](Md3TextField.md) | Active Color. |
| `fieldSurface` | `color` | `Md3Theme.colorScheme.surface` | readonly | [`Md3TextField`](Md3TextField.md) | Field Surface. |
| `effectiveTrailingIcon` | `string` | `{…}` | readonly | [`Md3TextField`](Md3TextField.md) | Effective Trailing Icon. |
| `filteredSuggestions` | `var` | `{…}` | readonly | [`Md3TextField`](Md3TextField.md) | Filtered Suggestions. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `trailingClicked()` | [`Md3TextField`](Md3TextField.md) | Emitted when trailing Clicked. |
| `accepted()` | [`Md3TextField`](Md3TextField.md) | Emitted on Enter / Return (same as Qt Quick Controls TextField.accepted). |
| `editingFinished()` | [`Md3TextField`](Md3TextField.md) | Emitted when editing ends: accepted, or focus leaves the field with text changed. Prefer this over a non-existent `editingFinished` on older snippets. |
| `suggestionChosen(var suggestion)` | [`Md3TextField`](Md3TextField.md) | Emitted when suggestion Chosen. |
| `textEdited()` | [`Md3TextField`](Md3TextField.md) | Emitted when text Edited. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `applySuggestion(s)` | `—` | [`Md3TextField`](Md3TextField.md) | Apply Suggestion. |
| `applyHighlightedSuggestion()` | `—` | [`Md3TextField`](Md3TextField.md) | Apply Highlighted Suggestion. |
| `moveSuggestionHighlight(delta)` | `—` | [`Md3TextField`](Md3TextField.md) | Move Suggestion Highlight. |
| `handleTrailing()` | `—` | [`Md3TextField`](Md3TextField.md) | Handle Trailing. |

## Example

```qml
import Md3

Md3TextArea {
    variant: Md3TextField.Filled
    label: ""
    placeholderText: ""
    supportingText: ""
    errorText: ""
    error: false
}
```
