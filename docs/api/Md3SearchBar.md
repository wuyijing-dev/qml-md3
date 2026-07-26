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
| `text` | `alias` | `input.text` | read/write | `Md3SearchBar` | — |
| `placeholderText` | `string` | `"Search"` | read/write | `Md3SearchBar` | — |
| `enabled` | `bool` | `true` | read/write | `Md3SearchBar` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `accepted(string text)` | `Md3SearchBar` | — |
| `clicked()` | `Md3SearchBar` | — |

## Methods

_None._

## Example

```qml
import Md3

Md3SearchBar {
    text: input.text
    placeholderText: "Search"
}
```
