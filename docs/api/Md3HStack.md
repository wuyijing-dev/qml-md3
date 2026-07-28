# Md3HStack

Horizontal stack with padding, vertical alignment, and expanding spacers.

- **Source:** `src/Md3/layout/Md3HStack.qml`

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `content` | alias | default | Children |
| `spacing` | real | `8` | — |
| `padding` | real | `0` | Uniform padding |
| `leftPadding` / `rightPadding` / `topPadding` / `bottomPadding` | real | `padding` | — |
| `fillHeight` | bool | `false` | Row fills parent height |
| `stretchChildren` | bool | `false` | Stretch child heights |
| `alignment` | int | `Center` | `Start` / `Center` / `End` cross-axis |
| `clipContent` | bool | `false` | — |

## Example

```qml
Md3HStack {
    spacing: 8
    Md3Button { text: "Cancel"; variant: Md3Button.Outlined }
    Md3Spacer { expand: true }
    Md3Button { text: "Save" }
}
```
