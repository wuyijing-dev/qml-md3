# Md3Spacer

Fixed gap or expanding filler for `Md3HStack` / `Md3VStack`.

- **Source:** `src/Md3/layout/Md3Spacer.qml`

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `size` | real | `0` | Sets both spacerWidth and spacerHeight |
| `spacerWidth` | real | `size` | Fixed width when not expanding |
| `spacerHeight` | real | `size` | Fixed height when not expanding |
| `expand` | bool | `false` | Fill leftover space in parent stack |

## Example

```qml
Md3HStack {
    Md3Button { text: "Left" }
    Md3Spacer { size: 24 }
    Md3Button { text: "Mid" }
    Md3Spacer { expand: true }
    Md3Button { text: "Right" }
}
```
