# Md3SwipeReveal

Swipe-to-reveal trailing actions behind content (WinUI SwipeControl-lite).

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
| `trailingActions` | `var` | `[]` | read/write | `Md3SwipeReveal` | [{ icon, label?, color?, destructive? }, ...] revealed on swipe left. |
| `openThreshold` | `real` | `0.4` | read/write | `Md3SwipeReveal` | — |
| `interactive` | `bool` | `true` | read/write | `Md3SwipeReveal` | — |
| `open` | `bool` | `Math.abs(panel.x) > 4` | readonly | `Md3SwipeReveal` | — |
| `revealWidth` | `real` | `trailingActions.length * actionWidth` | readonly | `Md3SwipeReveal` | — |
| `contentData` | `alias` | `panel.data` | default read/write | `Md3SwipeReveal` | Default property → `panel.data` |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `actionTriggered(int index)` | `Md3SwipeReveal` | — |
| `opened()` | `Md3SwipeReveal` | — |
| `closed()` | `Md3SwipeReveal` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `close()` | `Md3SwipeReveal` | — |
| `reveal()` | `Md3SwipeReveal` | — |

## Example

```qml
import Md3

Md3SwipeReveal {
    actionWidth: 72
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
