# Md3ColorPicker

Compact HSL color picker for theme seed / design tools.

- **Source:** `src/Md3/components/Md3ColorPicker.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 3 | 2 | 1 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `color` | `color` | `Md3Theme.seed` | read/write | `Md3ColorPicker` | Foreground / content color. |
| `showHex` | `bool` | `true` | read/write | `Md3ColorPicker` | Show Hex. |
| `showApplySeed` | `bool` | `false` | read/write | `Md3ColorPicker` | Show Apply Seed. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `colorEdited(color c)` | `Md3ColorPicker` | Emitted when color Edited. |
| `applySeedRequested(color c)` | `Md3ColorPicker` | Emitted when apply Seed Requested. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `setFromColor(c)` | `—` | `Md3ColorPicker` | Set From Color. |

## Example

```qml
import Md3

Md3ColorPicker {
    color: Md3Theme.seed
    showHex: true
    showApplySeed: false
}
```
