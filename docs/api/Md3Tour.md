# Md3Tour

Guided tour overlay: rounded spotlight cutout + animated step transitions.

- **Source:** `src/Md3/components/Md3Tour.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 14 | 3 | 4 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `active` | `bool` | `false` | read/write | `Md3Tour` | Active. |
| `currentIndex` | `int` | `0` | read/write | `Md3Tour` | Current index. |
| `steps` | `var` | `[]` | read/write | `Md3Tour` | [{ target: Item, title, body, placement, radius? }] |
| `persistCompleted` | `bool` | `true` | read/write | `Md3Tour` | Persist Completed. |
| `completedKey` | `string` | `"tour/completed"` | read/write | `Md3Tour` | Completed Key. |
| `holePad` | `real` | `10` | read/write | `Md3Tour` | Hole Pad. |
| `transitionDuration` | `int` | `Md3Motion.medium2` | read/write | `Md3Tour` | Transition Duration. |
| `currentStep` | `var` | `{…}` | readonly | `Md3Tour` | Current Step. |
| `currentTarget` | `Item` | `{…}` | readonly | `Md3Tour` | Current Target. |
| `holeX` | `real` | `0` | read/write | `Md3Tour` | Hole X. |
| `holeY` | `real` | `0` | read/write | `Md3Tour` | Hole Y. |
| `holeW` | `real` | `0` | read/write | `Md3Tour` | Hole W. |
| `holeH` | `real` | `0` | read/write | `Md3Tour` | Hole H. |
| `holeR` | `real` | `Md3Theme.shape.large` | read/write | `Md3Tour` | Hole R. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `finished()` | `Md3Tour` | Emitted when finished. |
| `skipped()` | `Md3Tour` | Emitted when skipped. |
| `stepChanged(int index)` | `Md3Tour` | Emitted when step Changed. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `start(at)` | `—` | `Md3Tour` | Start. |
| `stop(completed)` | `—` | `Md3Tour` | Stop. |
| `next()` | `—` | `Md3Tour` | Next. |
| `previous()` | `—` | `Md3Tour` | Previous. |

## Example

```qml
import Md3

Md3Tour {
    active: false
    currentIndex: 0
    steps: []
    persistCompleted: true
    completedKey: "tour/completed"
    holePad: 10
}
```
