# Md3Select

Field-style select (ComboBox): label, helper/error, menu — aligned with Md3TextField. Supports searchable filtering and multi-select.

- **Source:** `src/Md3/components/Md3Select.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 28 | 4 | 7 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Enums

### `Md3Select.Variant`

`Md3Select.Filled`, `Md3Select.Outlined`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `variant` | `int (Md3Select.Variant)` | `Md3Select.Outlined` | read/write | `Md3Select` | Visual / role variant (see Enums). |
| `label` | `string` | `""` | read/write | `Md3Select` | Field / control label. |
| `placeholderText` | `string` | `""` | read/write | `Md3Select` | Placeholder when empty. |
| `model` | `var` | `[]` | read/write | `Md3Select` | string[] or [{ text, icon?, value? }] |
| `currentIndex` | `int` | `-1` | read/write | `Md3Select` | Current index. |
| `selectedIndices` | `var` | `[]` | read/write | `Md3Select` | Multi-select indices into `model` (used when multiSelect is true). |
| `supportingText` | `string` | `""` | read/write | `Md3Select` | Supporting Text. |
| `errorText` | `string` | `""` | read/write | `Md3Select` | Validation error string (empty = ok). |
| `error` | `bool` | `false` | read/write | `Md3Select` | Error. |
| `name` | `string` | `""` | read/write | `Md3Select` | Form field key for Md3Form.validate / error auto-wiring. |
| `leadingIcon` | `string` | `""` | read/write | `Md3Select` | Leading Icon. |
| `accessibleName` | `string` | `""` | read/write | `Md3Select` | Accessible name override. |
| `searchable` | `bool` | `false` | read/write | `Md3Select` | Searchable. |
| `multiSelect` | `bool` | `false` | read/write | `Md3Select` | Multi Select. |
| `searchPlaceholder` | `string` | `qsTr("Search")` | read/write | `Md3Select` | Search Placeholder. |
| `suggestionLimit` | `int` | `0` | read/write | `Md3Select` | 0 = unlimited |
| `overlayWindow` | `var` | `null` | read/write | `Md3Select` | Optional explicit Window for menu overlay. |
| `hasError` | `bool` | `error \|\| errorText.length > 0` | readonly | `Md3Select` | Has Error. |
| `helper` | `string` | `hasError ? (errorText.length ? errorText : supportingText) : supportingText` | readonly | `Md3Select` | Helper. |
| `activeColor` | `color` | `hasError ? Md3Theme.colorScheme.error : Md3Theme.colorScheme.primary` | readonly | `Md3Select` | Active Color. |
| `open` | `bool` | `menu.open` | readonly | `Md3Select` | Open the overlay / dialog. |
| `floated` | `bool` | `open \|\| hasSelection \|\| placeholderText.length === 0` | readonly | `Md3Select` | Floated. |
| `errorFeedbackEnabled` | `bool` | `true` | read/write | `Md3Select` | Error Feedback Enabled. |
| `hasSelection` | `bool` | `multiSelect` | readonly | `Md3Select` | Has Selection. |
| `currentItem` | `var` | `{…}` | readonly | `Md3Select` | Current Item. |
| `displayText` | `string` | `{…}` | readonly | `Md3Select` | Display Text. |
| `currentValue` | `var` | `{…}` | readonly | `Md3Select` | Current Value. |
| `filteredEntries` | `var` | `{…}` | readonly | `Md3Select` | Filtered Entries. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `activated(int index)` | `Md3Select` | Emitted when activated. |
| `selectionChanged()` | `Md3Select` | Emitted when selection Changed. |
| `opened()` | `Md3Select` | Emitted when opened. |
| `closed()` | `Md3Select` | Emitted when closed. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `itemLabel(m)` | `—` | `Md3Select` | Item Label. |
| `itemIcon(m)` | `—` | `Md3Select` | Item Icon. |
| `isIndexSelected(index)` | `—` | `Md3Select` | Is Index Selected. |
| `toggleIndex(index)` | `—` | `Md3Select` | Toggle Index. |
| `toggle()` | `—` | `Md3Select` | Toggle open / checked state. |
| `openMenu()` | `—` | `Md3Select` | Open Menu. |
| `clear()` | `—` | `Md3Select` | Clear value / selection. |

## Example

```qml
import Md3

Md3Select {
    variant: Md3Select.Outlined
    label: ""
    placeholderText: ""
    model: []
    currentIndex: -1
    selectedIndices: []
}
```
