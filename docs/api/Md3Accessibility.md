# Md3Accessibility

- **Source:** `src/Md3/foundation/Md3Accessibility.qml`
- **Type:** QML singleton (`import Md3`)

Central accessibility preferences and screen-reader announcements.

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `reduceMotion` | `bool` | mirrors `Md3Theme.reduceMotion` | Collapse motion durations (~1ms) |
| `highContrast` | `bool` | mirrors `Md3Theme.highContrast` | Stronger outlines via theme |
| `showFocusRings` | `bool` | `true` | Always show keyboard focus rings |
| `textScale` | `real` | mirrors `Md3Theme.textScale` | Global type scale |
| `liveMessage` | `string` | readonly | Last `announce()` text |

## Methods

| Method | Description |
|--------|-------------|
| `announce(message)` | Push a live-region string (window hosts an invisible Accessible label) |
| `syncFromTheme()` / `applyToTheme()` | Bidirectional sync helpers |

## Theme integration

- `Md3Theme.reduceMotion` → `Md3Motion` duration tokens become ~1ms
- `Md3Theme.highContrast` → boosts `outline` / `outlineVariant` after `applySeed`
- `Md3ApplicationWindow.persistSession` stores `a11y/*` keys

## Example

```qml
Md3Switch {
    text-related: true
    checked: Md3Theme.reduceMotion
    onToggled: function (on) {
        Md3Theme.reduceMotion = on
        Md3Accessibility.announce(on ? qsTr("减弱动效已开") : qsTr("减弱动效已关"))
    }
}
```
