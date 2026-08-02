# Md3SearchBar

- **Source:** `src/Md3/components/Md3SearchBar.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `text` | `alias` | `input.text` | read/write | `Md3SearchBar` | Alias → `input.text` |
| `placeholderText` | `string` | `qsTr("Search")` | read/write | `Md3SearchBar` | — |
| `searchView` | `var` | `null` | read/write | `Md3SearchBar` | When set, click / focus opens this Md3SearchView (forwards `text`). |
| `showClearButton` | `bool` | `true` | read/write | `Md3SearchBar` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `accepted(string text)` | `Md3SearchBar` | — |
| `clicked()` | `Md3SearchBar` | — |
| `cleared()` | `Md3SearchBar` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `openSearchView()` | `Md3SearchBar` | — |
| `clear()` | `Md3SearchBar` | — |

## Example

```qml
import Md3

Md3SearchBar {
    placeholderText: qsTr("Search")
    searchView: null
    showClearButton: true
}
```
