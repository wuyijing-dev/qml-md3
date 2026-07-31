# Md3MenuBar

- **Source:** `src/Md3/components/Md3MenuBar.qml`
- **Extends:** `Rectangle`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `model` | `var` | `[]` | read/write | `Md3MenuBar` | [{ text, icon?, items?: [...] }] — use `items` (not `children`; that clashes with Item) |
| `overlayWindow` | `var` | `null` | read/write | `Md3MenuBar` | Optional explicit Window for menu overlay (else Window.window). |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `itemClicked(string path)` | `Md3MenuBar` | — |

## Methods

_None._

## Example

```qml
import Md3

Md3MenuBar {
    model: []
    overlayWindow: null
}
```
