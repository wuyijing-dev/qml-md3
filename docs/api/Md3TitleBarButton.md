# Md3TitleBarButton

- **Source:** `src/Md3/window/Md3TitleBarButton.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `icon` | `string` | `"contrast"` | read/write | `Md3TitleBarButton` | — |
| `accessibleName` | `string` | `icon` | read/write | `Md3TitleBarButton` | — |
| `checked` | `bool` | `false` | read/write | `Md3TitleBarButton` | — |
| `destructive` | `bool` | `false` | read/write | `Md3TitleBarButton` | — |
| `buttonWidth` | `real` | `40` | read/write | `Md3TitleBarButton` | — |
| `buttonHeight` | `real` | `28` | read/write | `Md3TitleBarButton` | — |
| `iconSize` | `real` | `14` | read/write | `Md3TitleBarButton` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `clicked()` | `Md3TitleBarButton` | — |

## Methods

_None._

## Example

```qml
import Md3

Md3TitleBarButton {
    icon: "contrast"
    accessibleName: icon
    checked: false
    destructive: false
    buttonWidth: 40
}
```
