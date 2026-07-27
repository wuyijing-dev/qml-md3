# Md3SkeletonPane

- **Source:** `src/Md3/components/Md3SkeletonPane.qml`
- **Related:** `Md3Skeleton`, `Md3PageHost`

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `active` | `bool` | `true` | Pulse animation |
| `layout` | `string` | `"page"` | Fallback: `page` / `list` / `cards` |
| `bones` | `var` | `[]` | Preferred outline: `[{ variant, width, height }]` |

`width` may be a fraction `0–1` of the pane width. Destination entries may set `skeletonBones` or `skeletonLayout`; PageHost picks them while `awaitingTarget`.
