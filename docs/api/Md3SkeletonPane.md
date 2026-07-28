# Md3SkeletonPane

Full-pane skeleton used by Md3PageHost while a destination loads. Prefer `bones` (per-page outline); otherwise fall back to `layout` presets.

- **Source:** `src/Md3/components/Md3SkeletonPane.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `active` | `bool` | `true` | read/write | `Md3SkeletonPane` | — |
| `layout` | `string` | `"page"` | read/write | `Md3SkeletonPane` | "page" \| "list" \| "cards" |
| `bones` | `var` | `[]` | read/write | `Md3SkeletonPane` | Optional outline: [{ variant, width, height, radius? }, ...] variant: "text"\|"circular"\|"rounded"\|"rectangular" or Md3Skeleton enum int |
| `useBones` | `bool` | `bones && bones.length > 0` | readonly | `Md3SkeletonPane` | — |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3SkeletonPane {
    active: true
    layout: "page"
    bones: []
}
```
