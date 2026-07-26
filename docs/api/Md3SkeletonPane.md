# Md3SkeletonPane

Full-pane skeleton used by Md3PageHost while a destination loads.

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
}
```
