# Md3SwipeReveal

Swipe-to-reveal leading / trailing actions (WinUI SwipeControl–inspired). Actions sit under an opaque sliding panel so they stay hidden until swiped. Only one reveal stays open at a time (via Md3OverlayHost).

- **Source:** `src/Md3/components/Md3SwipeReveal.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 15 | 3 | 5 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `actionWidth` | `real` | `72` | read/write | `Md3SwipeReveal` | Action Width. |
| `leadingActions` | `var` | `[]` | read/write | `Md3SwipeReveal` | [{ icon, label?, color?, destructive? }, ...] revealed on swipe right. |
| `trailingActions` | `var` | `[]` | read/write | `Md3SwipeReveal` | [{ icon, label?, color?, destructive? }, ...] revealed on swipe left. |
| `openThreshold` | `real` | `0.4` | read/write | `Md3SwipeReveal` | Open Threshold. |
| `interactive` | `bool` | `true` | read/write | `Md3SwipeReveal` | Gate activation without forcing `enabled: false`. |
| `exclusive` | `bool` | `true` | read/write | `Md3SwipeReveal` | When true (default), opening this closes any other SwipeReveal. |
| `panelColor` | `color` | `Md3Theme.colorScheme.surface` | read/write | `Md3SwipeReveal` | Panel fill — must be opaque or actions show through ListTile (transparent bg). |
| `actionFocusIndex` | `int` | `-1` | read/write | `Md3SwipeReveal` | Keyboard focus index into the currently revealed action strip (-1 = none). |
| `leadingWidth` | `real` | `leadingActions.length * actionWidth` | readonly | `Md3SwipeReveal` | Leading Width. |
| `trailingWidth` | `real` | `trailingActions.length * actionWidth` | readonly | `Md3SwipeReveal` | Trailing Width. |
| `open` | `bool` | `Math.abs(panel.x) > 4` | readonly | `Md3SwipeReveal` | Open the overlay / dialog. |
| `leadingOpen` | `bool` | `panel.x > 4` | readonly | `Md3SwipeReveal` | Leading Open. |
| `trailingOpen` | `bool` | `panel.x < -4` | readonly | `Md3SwipeReveal` | Trailing Open. |
| `revealWidth` | `real` | `trailingOpen ? trailingWidth` | readonly | `Md3SwipeReveal` | Reveal Width. |
| `contentData` | `alias` | `contentHost.data` | default read/write | `Md3SwipeReveal` | Content Data. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `actionTriggered(int index, bool leading)` | `Md3SwipeReveal` | Emitted when action Triggered. |
| `opened()` | `Md3SwipeReveal` | Emitted when opened. |
| `closed()` | `Md3SwipeReveal` | Emitted when closed. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `close()` | `—` | `Md3SwipeReveal` | Close the overlay / dialog. |
| `revealTrailing()` | `—` | `Md3SwipeReveal` | Reveal Trailing. |
| `revealLeading()` | `—` | `Md3SwipeReveal` | Reveal Leading. |
| `reveal()` | `—` | `Md3SwipeReveal` | Prefer trailing when both exist (mail / list convention). |
| `togglePrimary()` | `—` | `Md3SwipeReveal` | Toggle Primary. |

## Example

```qml
import Md3

Md3SwipeReveal {
    actionWidth: 72
    leadingActions: []
    trailingActions: []
    openThreshold: 0.4
    interactive: true
    exclusive: true
}
```

## WinUI 对照

| WinUI | Md3 |
|-------|-----|
| SwipeControl | `Md3SwipeReveal` |

`trailingActions: [{ icon, label?, destructive? }]`；子项为前景内容。详见 [collections.md](../guides/collections.md)。
