# Md3TagField

Multi-tag / chip input — Enter or comma commits; Backspace removes last tag.

- **Source:** `src/Md3/components/Md3TagField.qml`
- **Extends:** `Item`

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
| `variant` | `int` | `Md3TagField.Filled` | read/write | `Md3TagField` | — |
| `tags` | `var` | `[]` | read/write | `Md3TagField` | — |
| `label` | `string` | `""` | read/write | `Md3TagField` | — |
| `placeholderText` | `string` | `qsTr("Add tag")` | read/write | `Md3TagField` | — |
| `supportingText` | `string` | `""` | read/write | `Md3TagField` | — |
| `errorText` | `string` | `""` | read/write | `Md3TagField` | — |
| `error` | `bool` | `false` | read/write | `Md3TagField` | — |
| `name` | `string` | `""` | read/write | `Md3TagField` | — |
| `allowDuplicates` | `bool` | `false` | read/write | `Md3TagField` | — |
| `separators` | `string` | `",;"` | read/write | `Md3TagField` | Characters that commit the draft (in addition to Enter). |
| `maxTags` | `int` | `0` | read/write | `Md3TagField` | — |
| `accessibleName` | `string` | `""` | read/write | `Md3TagField` | — |
| `hasError` | `bool` | `error \|\| errorText.length > 0` | readonly | `Md3TagField` | — |
| `helper` | `string` | `hasError ? (errorText.length ? errorText : supportingText) : supportingText` | readonly | `Md3TagField` | — |
| `focused` | `bool` | `draft.activeFocus` | readonly | `Md3TagField` | — |
| `floated` | `bool` | `focused \|\| tags.length > 0 \|\| draft.text.length > 0` | readonly | `Md3TagField` | — |
| `activeColor` | `color` | `hasError ? Md3Theme.colorScheme.error` | readonly | `Md3TagField` | — |
| `fieldSurface` | `color` | `Md3Theme.colorScheme.surface` | readonly | `Md3TagField` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `tagAdded(string tag)` | `Md3TagField` | — |
| `tagRemoved(string tag, int index)` | `Md3TagField` | — |
| `tagsChangedByUser()` | `Md3TagField` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `addTag(raw)` | `Md3TagField` | — |
| `removeAt(index)` | `Md3TagField` | — |
| `clear()` | `Md3TagField` | — |
| `commitDraft()` | `Md3TagField` | — |

## Example

```qml
import Md3

Md3TagField {
    variant: Md3TagField.Filled
    tags: []
    label: ""
    placeholderText: qsTr("Add tag")
    supportingText: ""
}
```
