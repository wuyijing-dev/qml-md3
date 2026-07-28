# Md3StatusBar

Desktop status bar: message on the left, optional progress, trailing status items.

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
| `leadingIcon` | `string` | `""` | read/write | `Md3StatusBar` | — |
| `progress` | `real` | `-1` | read/write | `Md3StatusBar` | — |
| `indeterminateProgress` | `bool` | `false` | read/write | `Md3StatusBar` | — |
| `showProgress` | `bool` | `progress >= 0 \|\| indeterminateProgress` | read/write | `Md3StatusBar` | — |
| `content` | `alias` | `trail.data` | default read/write | `Md3StatusBar` | Trailing widgets (Text / Icon / custom). |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `messageClicked()` | `Md3StatusBar` | — |

## Methods

_None._

## Example

```qml
import Md3

Md3StatusBar {
    text: ""
    leadingIcon: ""
    progress: -1
    indeterminateProgress: false
    showProgress: progress >= 0 || indeterminateProgress
}
```
