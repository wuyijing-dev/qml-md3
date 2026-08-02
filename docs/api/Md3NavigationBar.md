# Md3NavigationBar

- **Source:** `src/Md3/components/Md3NavigationBar.qml`
- **Extends:** `Rectangle`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 4 | 2 | 0 | 0 |

_Also inherits Qt Quick `Rectangle` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `model` | `var` | `[]` | read/write | `Md3NavigationBar` | Data model. |
| `currentIndex` | `int` | `0` | read/write | `Md3NavigationBar` | Current index. |
| `indicatorWidth` | `real` | `64` | readonly | `Md3NavigationBar` | Indicator Width. |
| `indicatorHeight` | `real` | `32` | readonly | `Md3NavigationBar` | Indicator Height. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `currentIndexChangedByUser(int index)` | `Md3NavigationBar` | Emitted when current Index Changed By User. |
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
