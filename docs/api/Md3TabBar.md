# Md3TabBar

- **Source:** `src/Md3/components/Md3TabBar.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Enums

### `Md3TabBar.Variant`

`Md3TabBar.Primary`, `Md3TabBar.Secondary`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `variant` | `int` | `Md3TabBar.Primary` | read/write | `Md3TabBar` | — |
| `model` | `var` | `[]` | read/write | `Md3TabBar` | — |
| `currentIndex` | `int` | `0` | read/write | `Md3TabBar` | — |
| `pages` | `alias` | `pageStack.data` | default read/write | `Md3TabBar` | Optional content pages; StackLayout tracks `currentIndex` |
| `hasPages` | `bool` | — | readonly | `Md3TabBar` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `currentIndexChangedByUser(int index)` | `Md3TabBar` | — |

## Example

```qml
import Md3

Md3TabBar {
    model: [{ text: "One" }, { text: "Two" }]
    Item { /* page 0 */ }
    Item { /* page 1 */ }
}
```
