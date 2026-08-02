# Md3SearchBar

- **Source:** `src/Md3/components/Md3SearchBar.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 4 | 3 | 2 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `text` | `alias` | `input.text` | read/write | `Md3SearchBar` | Primary label text. |
| `placeholderText` | `string` | `qsTr("Search")` | read/write | `Md3SearchBar` | Placeholder when empty. |
| `searchView` | `var` | `null` | read/write | `Md3SearchBar` | When set, click / focus opens this Md3SearchView (forwards `text`). |
| `showClearButton` | `bool` | `true` | read/write | `Md3SearchBar` | Show Clear Button. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `accepted(string text)` | `Md3SearchBar` | Emitted when accepted. |
| `clicked()` | `Md3SearchBar` | Emitted when clicked. |
| `cleared()` | `Md3SearchBar` | Emitted when cleared. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `openSearchView()` | `—` | `Md3SearchBar` | Open Search View. |
| `clear()` | `—` | `Md3SearchBar` | Clear value / selection. |

## Example

```qml
import Md3

Md3SearchBar {
    placeholderText: qsTr("Search")
    searchView: null
    showClearButton: true
}
```
