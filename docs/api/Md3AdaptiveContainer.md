# Md3AdaptiveContainer

Standalone column host with Fit / Scroll. Prefer container `layoutMode` when inside Card/Form/Sheet; use this for free-standing column stacks.

- **Source:** `src/Md3/components/Md3AdaptiveContainer.qml`

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `layoutMode` | int | `Fit` | `Fit` / `Scroll` |
| `padding` | real | `0` | — |
| `clipContent` | bool | `true` | — |
| `contentSpacing` | real | `12` | Column spacing |
| `content` | alias | default | Children |

## Example

```qml
Md3AdaptiveContainer {
    layoutMode: Md3AdaptiveContainer.Scroll
    padding: 16
    Md3Text { text: "A" }
    Md3Text { text: "B" }
}
```
