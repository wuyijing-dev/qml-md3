# Md3TagField

Multi-tag / chip input — Enter or comma commits; Backspace removes last tag.

- **Source:** `src/Md3/components/Md3TagField.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 18 | 3 | 4 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Enums

### `Md3TagField.Variant`

`Md3TagField.Filled`, `Md3TagField.Outlined`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `variant` | `int (Md3TagField.Variant)` | `Md3TagField.Filled` | read/write | `Md3TagField` | Visual / role variant (see Enums). |
| `tags` | `var` | `[]` | read/write | `Md3TagField` | Tags. |
| `label` | `string` | `""` | read/write | `Md3TagField` | Field / control label. |
| `placeholderText` | `string` | `qsTr("Add tag")` | read/write | `Md3TagField` | Placeholder when empty. |
| `supportingText` | `string` | `""` | read/write | `Md3TagField` | Supporting Text. |
| `errorText` | `string` | `""` | read/write | `Md3TagField` | Validation error string (empty = ok). |
| `error` | `bool` | `false` | read/write | `Md3TagField` | Error. |
| `name` | `string` | `""` | read/write | `Md3TagField` | Form field key / identity. |
| `allowDuplicates` | `bool` | `false` | read/write | `Md3TagField` | Allow Duplicates. |
| `separators` | `string` | `",;"` | read/write | `Md3TagField` | Characters that commit the draft (in addition to Enter). |
| `maxTags` | `int` | `0` | read/write | `Md3TagField` | Max Tags. |
| `accessibleName` | `string` | `""` | read/write | `Md3TagField` | Accessible name override. |
| `hasError` | `bool` | `error \|\| errorText.length > 0` | readonly | `Md3TagField` | Has Error. |
| `helper` | `string` | `hasError ? (errorText.length ? errorText : supportingText) : supportingText` | readonly | `Md3TagField` | Helper. |
| `focused` | `bool` | `draft.activeFocus` | readonly | `Md3TagField` | Focused. |
| `floated` | `bool` | `focused \|\| tags.length > 0 \|\| draft.text.length > 0` | readonly | `Md3TagField` | Floated. |
| `activeColor` | `color` | `hasError ? Md3Theme.colorScheme.error` | readonly | `Md3TagField` | Active Color. |
| `fieldSurface` | `color` | `Md3Theme.colorScheme.surface` | readonly | `Md3TagField` | Field Surface. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `tagAdded(string tag)` | `Md3TagField` | Emitted when tag Added. |
| `tagRemoved(string tag, int index)` | `Md3TagField` | Emitted when tag Removed. |
| `tagsChangedByUser()` | `Md3TagField` | Emitted when tags Changed By User. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `addTag(raw)` | `—` | `Md3TagField` | Add Tag. |
| `removeAt(index)` | `—` | `Md3TagField` | Remove At. |
| `clear()` | `—` | `Md3TagField` | Clear value / selection. |
| `commitDraft()` | `—` | `Md3TagField` | Commit Draft. |

## Example

```qml
import Md3

Md3TagField {
    variant: Md3TagField.Filled
    tags: []
    label: ""
    placeholderText: qsTr("Add tag")
    supportingText: ""
    errorText: ""
}
```
