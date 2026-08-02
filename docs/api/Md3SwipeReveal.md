# Md3SwipeReveal

Swipe-to-reveal leading / trailing actions (WinUI SwipeControl–inspired). Actions sit under an opaque sliding panel so they stay hidden until swiped. Only one reveal stays open at a time (via Md3OverlayHost).

- **Source:** `src/Md3/components/Md3SwipeReveal.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `actionWidth` | `real` | `72` | read/write | `Md3SwipeReveal` | — |
| `leadingActions` | `var` | `[]` | read/write | `Md3SwipeReveal` | [{ icon, label?, color?, destructive? }, ...] revealed on swipe right. |
| `trailingActions` | `var` | `[]` | read/write | `Md3SwipeReveal` | [{ icon, label?, color?, destructive? }, ...] revealed on swipe left. |
| `openThreshold` | `real` | `0.4` | read/write | `Md3SwipeReveal` | — |
| `interactive` | `bool` | `true` | read/write | `Md3SwipeReveal` | — |
| `exclusive` | `bool` | `true` | read/write | `Md3SwipeReveal` | When true (default), opening this closes any other SwipeReveal. |
| `panelColor` | `color` | `Md3Theme.colorScheme.surface` | read/write | `Md3SwipeReveal` | Panel fill — must be opaque or actions show through ListTile (transparent bg). |
| `actionFocusIndex` | `int` | `-1` | read/write | `Md3SwipeReveal` | Keyboard focus index into the currently revealed action strip (-1 = none). |
| `leadingWidth` | `real` | `leadingActions.length * actionWidth` | readonly | `Md3SwipeReveal` | — |
| `trailingWidth` | `real` | `trailingActions.length * actionWidth` | readonly | `Md3SwipeReveal` | — |
| `open` | `bool` | `Math.abs(panel.x) > 4` | readonly | `Md3SwipeReveal` | — |
| `leadingOpen` | `bool` | `panel.x > 4` | readonly | `Md3SwipeReveal` | — |
| `trailingOpen` | `bool` | `panel.x < -4` | readonly | `Md3SwipeReveal` | — |
| `revealWidth` | `real` | `trailingOpen ? trailingWidth` | readonly | `Md3SwipeReveal` | — |
| `contentData` | `alias` | `contentHost.data` | default read/write | `Md3SwipeReveal` | Default property → `contentHost.data` |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `actionTriggered(int index, bool leading)` | `Md3SwipeReveal` | — |
| `opened()` | `Md3SwipeReveal` | — |
| `closed()` | `Md3SwipeReveal` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `close()` | `Md3SwipeReveal` | — |
| `revealTrailing()` | `Md3SwipeReveal` | — |
| `revealLeading()` | `Md3SwipeReveal` | — |
| `reveal()` | `Md3SwipeReveal` | Prefer trailing when both exist (mail / list convention). |
| `togglePrimary()` | `Md3SwipeReveal` | — |

## Example

```qml
import Md3

Md3SwipeReveal {
    actionWidth: 72
    leadingActions: []
    trailingActions: []
    openThreshold: 0.4
    interactive: true
}
```

## WinUI 对照

| WinUI | Md3 |
|-------|-----|
| SwipeControl | `Md3SwipeReveal` |

`trailingActions: [{ icon, label?, destructive? }]`；子项为前景内容。详见 [collections.md](../guides/collections.md)。
