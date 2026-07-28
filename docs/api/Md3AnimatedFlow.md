# Md3AnimatedFlow

Flow layout with optional motion. Child size = `max(explicit, implicit)` so fixed `width`/`height` cards do not need mirrored `implicit*` glue.

- **Source:** `src/Md3/layout/Md3AnimatedFlow.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Enums

### `Md3AnimatedFlow.Alignment`

`Start`, `Center`, `End` — horizontal alignment of each wrapped row.

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `content` | alias | default | Children |
| `spacing` | real | `8` | Horizontal gap |
| `rowSpacing` | real | `8` | Vertical gap between rows |
| `padding` | real | `0` | Uniform padding |
| `leftPadding` / `rightPadding` / `topPadding` / `bottomPadding` | real | `padding` | Edge padding |
| `animate` | bool | `true` | Animate child moves |
| `moveDuration` | int | `Md3Motion.spatialDuration` | — |
| `moveEasing` | var | `Md3Motion.spatialDefault` | — |
| `fillWidth` | bool | `true` | Stretch to parent width |
| `alignment` | int | `Start` | Row alignment |
| `rowCount` / `wrapped` / `contentWidth` / `contentHeight` | readonly | — | Metrics |

## Methods

| Method | Description |
|--------|-------------|
| `relayout()` | Recompute placement |

## Example

```qml
Md3AnimatedFlow {
    spacing: 12
    rowSpacing: 12
    Md3Card { title: "A"; width: 180; height: 100 }
    Md3Card { title: "B"; width: 180; height: 100 }
}
```
