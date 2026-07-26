# Md3SearchView

- **Source:** `src/Md3/components/Md3SearchView.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `open` | `bool` | `false` | read/write | `Md3SearchView` | — |
| `text` | `string` | `""` | read/write | `Md3SearchView` | — |
| `suggestions` | `var` | `[]` | read/write | `Md3SearchView` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `suggestionChosen(string value)` | `Md3SearchView` | — |
| `closed()` | `Md3SearchView` | — |

## Methods

_None._

## Example

```qml
import Md3

Md3SearchView {
    open: false
    text: ""
    suggestions: []
}
```
