# Md3Accessibility

Library-wide accessibility preferences and helpers.

- **Source:** `src/Md3/foundation/Md3Accessibility.qml`
- **Extends:** `QtObject`
- **Singleton:** `true` (`pragma Singleton`)

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `reduceMotion` | `bool` | `Md3Theme.reduceMotion` | read/write | `Md3Accessibility` | Prefer reduced / near-zero motion (mirrors Md3Theme.reduceMotion). |
| `highContrast` | `bool` | `Md3Theme.highContrast` | read/write | `Md3Accessibility` | Stronger outlines / surfaces (mirrors Md3Theme.highContrast). |
| `showFocusRings` | `bool` | `true` | read/write | `Md3Accessibility` | Always show keyboard focus rings when true. |
| `textScale` | `real` | `Md3Theme.textScale` | read/write | `Md3Accessibility` | Extra text scale convenience (delegates to Md3Theme.textScale). |
| `liveMessage` | `string` | `_announceText` | readonly | `Md3Accessibility` | Screen-reader live message (read via Accessible on the gallery/window live region). |
| `liveSerial` | `int` | `_announceSerial` | readonly | `Md3Accessibility` | — |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `announce(message)` | `Md3Accessibility` | — |
| `syncFromTheme()` | `Md3Accessibility` | — |
| `applyToTheme()` | `Md3Accessibility` | — |

## Example

```qml
import Md3

// Singleton — use as `Md3Accessibility.…`
console.log(Md3Accessibility)
```
