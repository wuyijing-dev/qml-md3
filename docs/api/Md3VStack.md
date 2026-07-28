# Md3VStack

- **Source:** `src/Md3/layout/Md3VStack.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `content` | `alias` | `contentCol.data` | default read/write | `Md3VStack` | Default property -> `contentCol.data` |
| `spacing` | `real` | `8` | read/write | `Md3VStack` | Child spacing |
| `padding` | `real` | `0` | read/write | `Md3VStack` | Inner padding |
| `fillWidth` | `bool` | `true` | read/write | `Md3VStack` | Stretch content width to container |
| `clipContent` | `bool` | `false` | read/write | `Md3VStack` | Clip inner column |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3VStack {
    spacing: 12
    padding: 16
    Md3Text { text: "Title"; role: Md3Text.TitleMedium }
    Md3Text { text: "Body"; tone: Md3Text.OnSurfaceVariant }
}
```
