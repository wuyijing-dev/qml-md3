# Md3NavigationBar

- **Source:** `src/Md3/components/Md3NavigationBar.qml`
- **Extends:** `Rectangle`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `model` | `var` | `[]` | read/write | `Md3NavigationBar` | — |
| `currentIndex` | `int` | `0` | read/write | `Md3NavigationBar` | — |
| `indicatorWidth` | `real` | `64` | readonly | `Md3NavigationBar` | — |
| `indicatorHeight` | `real` | `32` | readonly | `Md3NavigationBar` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `currentIndexChangedByUser(int index)` | `Md3NavigationBar` | — |
| `destinationPreview(int index)` | `Md3NavigationBar` | Fired on long-press of a destination (preview / peek). |

## Methods

_None._

## Example

```qml
import Md3

Md3NavigationBar {
    model: []
    currentIndex: 0
}
```
