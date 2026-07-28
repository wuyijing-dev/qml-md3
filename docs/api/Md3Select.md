# Md3Select

Field-style select (ComboBox): label, helper/error, menu — aligned with Md3TextField. Supports searchable filtering and multi-select.

- **Source:** `src/Md3/components/Md3Select.qml`
- **Extends:** `Item`

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
| `variant` | `int` | `Md3Select.Outlined` | read/write | `Md3Select` | — |
| `label` | `string` | `""` | read/write | `Md3Select` | — |
| `placeholderText` | `string` | `""` | read/write | `Md3Select` | — |
| `model` | `var` | `[]` | read/write | `Md3Select` | string[] or [{ text, icon?, value? }] |
| `currentIndex` | `int` | `-1` | read/write | `Md3Select` | — |
| `selectedIndices` | `var` | `[]` | read/write | `Md3Select` | Multi-select indices into `model` (used when multiSelect is true). |
| `supportingText` | `string` | `""` | read/write | `Md3Select` | — |
| `errorText` | `string` | `""` | read/write | `Md3Select` | — |
| `error` | `bool` | `false` | read/write | `Md3Select` | — |
| `enabled` | `bool` | `true` | read/write | `Md3Select` | — |
| `leadingIcon` | `string` | `""` | read/write | `Md3Select` | — |
| `accessibleName` | `string` | `""` | read/write | `Md3Select` | — |
| `searchable` | `bool` | `false` | read/write | `Md3Select` | — |
| `multiSelect` | `bool` | `false` | read/write | `Md3Select` | — |
| `searchPlaceholder` | `string` | `qsTr("Search")` | read/write | `Md3Select` | — |
| `suggestionLimit` | `int` | `0` | read/write | `Md3Select` | — |
| `hasError` | `bool` | `error \|\| errorText.length > 0` | readonly | `Md3Select` | — |
| `helper` | `string` | `hasError ? (errorText.length ? errorText : supportingText) : supportingText` | readonly | `Md3Select` | — |
| `activeColor` | `color` | `hasError ? Md3Theme.colorScheme.error : Md3Theme.colorScheme.primary` | readonly | `Md3Select` | — |
| `open` | `bool` | `menu.open` | readonly | `Md3Select` | — |
| `floated` | `bool` | `open \|\| hasSelection \|\| placeholderText.length === 0` | readonly | `Md3Select` | — |
| `hasSelection` | `bool` | `multiSelect` | readonly | `Md3Select` | — |
| `currentItem` | `var` | `{…}` | readonly | `Md3Select` | — |
| `displayText` | `string` | `{…}` | readonly | `Md3Select` | — |
| `currentValue` | `var` | `{…}` | readonly | `Md3Select` | — |
| `filteredEntries` | `var` | `{…}` | readonly | `Md3Select` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `activated(int index)` | `Md3Select` | — |
| `selectionChanged()` | `Md3Select` | — |
| `opened()` | `Md3Select` | — |
| `closed()` | `Md3Select` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `itemLabel(m)` | `Md3Select` | — |
| `itemIcon(m)` | `Md3Select` | — |
| `isIndexSelected(index)` | `Md3Select` | — |
| `toggleIndex(index)` | `Md3Select` | — |
| `toggle()` | `Md3Select` | — |
| `openMenu()` | `Md3Select` | — |
| `clear()` | `Md3Select` | — |

## Example

```qml
import Md3

Md3Select {
    variant: Md3Select.Outlined
    label: ""
    placeholderText: ""
    model: []
    currentIndex: -1
}
```
