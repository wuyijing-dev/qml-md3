# Md3TabBar

Tab strip + optional content pages (WinUI Pivot-style). When `pages` has children, a StackLayout tracks `currentIndex` — no host sync glue.

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
| `pages` | `alias` | `pageStack.data` | default read/write | `Md3TabBar` | Content pages (synced with currentIndex). Prefer over external StackLayout. |
| `pageAreaHeight` | `real` | `96` | read/write | `Md3TabBar` | Extra height for page area when `pages` are present (Layout / implicit). |
| `hasPages` | `bool` | `pageStack.children.length > 0` | readonly | `Md3TabBar` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `currentIndexChangedByUser(int index)` | `Md3TabBar` | — |

## Methods

_None._

## Example

```qml
import Md3

Md3TabBar {
    variant: Md3TabBar.Primary
    model: []
    currentIndex: 0
    pageAreaHeight: 96
}
```
