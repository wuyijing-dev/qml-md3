# Md3StatusBar

Desktop status bar — left / center / right zones, transient messages.

- **Source:** `src/Md3/components/Md3StatusBar.qml`
- **Extends:** `Rectangle`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `text` | `string` | `""` | read/write | `Md3StatusBar` | — |
| `centerText` | `string` | `""` | read/write | `Md3StatusBar` | — |
| `leadingIcon` | `string` | `""` | read/write | `Md3StatusBar` | — |
| `progress` | `real` | `-1` | read/write | `Md3StatusBar` | — |
| `indeterminateProgress` | `bool` | `false` | read/write | `Md3StatusBar` | — |
| `showProgress` | `bool` | `progress >= 0 \|\| indeterminateProgress` | read/write | `Md3StatusBar` | — |
| `leftContent` | `alias` | `leftExtra.data` | default read/write | `Md3StatusBar` | Default property → `leftExtra.data` |
| `centerContent` | `alias` | `centerRow.data` | read/write | `Md3StatusBar` | Alias → `centerRow.data` |
| `rightContent` | `alias` | `trailExtras.data` | read/write | `Md3StatusBar` | Alias → `trailExtras.data` |
| `displayText` | `string` | `_showTransient && _transientText.length` | readonly | `Md3StatusBar` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `messageClicked()` | `Md3StatusBar` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `showMessage(message, timeout)` | `Md3StatusBar` | — |
| `clearMessage()` | `Md3StatusBar` | — |

## Example

```qml
import Md3

Md3StatusBar {
    text: ""
    centerText: ""
    leadingIcon: ""
    progress: -1
    indeterminateProgress: false
}
```
