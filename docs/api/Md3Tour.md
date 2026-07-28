# Md3Tour

Guided tour overlay: rounded spotlight cutout + animated step transitions.

- **Source:** `src/Md3/components/Md3Tour.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `active` | `bool` | `false` | read/write | `Md3Tour` | — |
| `currentIndex` | `int` | `0` | read/write | `Md3Tour` | — |
| `steps` | `var` | `[]` | read/write | `Md3Tour` | [{ target: Item, title, body, placement, radius? }] |
| `persistCompleted` | `bool` | `true` | read/write | `Md3Tour` | — |
| `completedKey` | `string` | `"tour/completed"` | read/write | `Md3Tour` | — |
| `holePad` | `real` | `10` | read/write | `Md3Tour` | — |
| `transitionDuration` | `int` | `Md3Motion.medium2` | read/write | `Md3Tour` | — |
| `currentStep` | `var` | `{…}` | readonly | `Md3Tour` | — |
| `currentTarget` | `Item` | `{…}` | readonly | `Md3Tour` | — |
| `holeX` | `real` | `0` | read/write | `Md3Tour` | — |
| `holeY` | `real` | `0` | read/write | `Md3Tour` | — |
| `holeW` | `real` | `0` | read/write | `Md3Tour` | — |
| `holeH` | `real` | `0` | read/write | `Md3Tour` | — |
| `holeR` | `real` | `Md3Theme.shape.large` | read/write | `Md3Tour` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `finished()` | `Md3Tour` | — |
| `skipped()` | `Md3Tour` | — |
| `stepChanged(int index)` | `Md3Tour` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `start(at)` | `Md3Tour` | — |
| `stop(completed)` | `Md3Tour` | — |
| `next()` | `Md3Tour` | — |
| `previous()` | `Md3Tour` | — |

## Example

```qml
import Md3

Md3Tour {
    active: false
    currentIndex: 0
    steps: []
    persistCompleted: true
    completedKey: "tour/completed"
}
```
