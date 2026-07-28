# Md3VStack

Vertical stack with padding, alignment, and optional child stretch / expanding spacers.

- **Source:** `src/Md3/layout/Md3VStack.qml`

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `content` | alias | default | Children |
| `spacing` | real | `8` | — |
| `padding` | real | `0` | Uniform padding |
| `leftPadding` / `rightPadding` / `topPadding` / `bottomPadding` | real | `padding` | — |
| `fillWidth` | bool | `true` | Content column uses parent width |
| `stretchChildren` | bool | `true` | Set each child width to content width |
| `alignment` | int | `Start` | `Start` / `Center` / `End` cross-axis |
| `clipContent` | bool | `false` | — |

## Example

```qml
Md3VStack {
    spacing: 12
    padding: 16
    Md3Text { text: "Title"; role: Md3Text.TitleMedium }
    Md3Text { text: "Body"; tone: Md3Text.OnSurfaceVariant }
    Md3Spacer { expand: true }
    Md3Button { text: "OK" }
}
```
