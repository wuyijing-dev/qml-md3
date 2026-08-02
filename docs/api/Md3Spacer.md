# Md3Spacer

Lightweight spacer. Use `size` for fixed gaps, or `expand: true` inside Md3HStack / Md3VStack to absorb remaining space (SwiftUI-style).

- **Source:** `src/Md3/layout/Md3Spacer.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 4 | 0 | 0 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `size` | `real` | `0` | read/write | `Md3Spacer` | Control size token (see Enums). |
| `spacerWidth` | `real` | `size` | read/write | `Md3Spacer` | Spacer Width. |
| `spacerHeight` | `real` | `size` | read/write | `Md3Spacer` | Spacer Height. |
| `expand` | `bool` | `false` | read/write | `Md3Spacer` | When true, parent Md3HStack/Md3VStack stretches this item to fill leftover space. |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3Spacer {
    size: 0
    spacerWidth: size
    spacerHeight: size
    expand: false
}
```
