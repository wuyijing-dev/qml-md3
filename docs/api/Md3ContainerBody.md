# Md3ContainerBody

Fit / Scroll content host embedded by Md3 containers. Prefer setting `layoutMode` on the parent container (`Md3Card`, sheets, …) instead of nesting this manually.

- **Source:** `src/Md3/components/Md3ContainerBody.qml`

## Enums

### `LayoutMode`

`Fit`, `Scroll`

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `layoutMode` | int | `Fit` | Fit grows with content; Scroll enables internal flick |
| `padding` | real | `0` | Inner padding |
| `clipContent` | bool | `true` | Clip flickable |
| `fitFallbackHeight` | real | `320` | Used when a fill-anchored child would create a height loop |
| `content` | alias | default | Children |
| `contentImplicitWidth` / `contentImplicitHeight` | readonly | — | Measured content size |

## Example

Usually via parent:

```qml
Md3Card {
    layoutMode: Md3ContainerBody.Scroll
    /* content */
}
```
