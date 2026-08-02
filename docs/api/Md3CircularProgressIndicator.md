# Md3CircularProgressIndicator

Circular progress — Standard spins the Shape (no per-frame Path mutation); wavy / expressive styles use a throttled polyline rebuild.

- **Source:** `src/Md3/components/Md3CircularProgressIndicator.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 22 | 0 | 1 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Enums

### `Md3CircularProgressIndicator.Style`

`Md3CircularProgressIndicator.Standard`, `Md3CircularProgressIndicator.Wavy`, `Md3CircularProgressIndicator.Lively`, `Md3CircularProgressIndicator.Soft`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `value` | `real` | `0` | read/write | `Md3CircularProgressIndicator` | Current value. |
| `indeterminate` | `bool` | `true` | read/write | `Md3CircularProgressIndicator` | Indeterminate. |
| `style` | `int (Md3CircularProgressIndicator.Style)` | `Md3CircularProgressIndicator.Standard` | read/write | `Md3CircularProgressIndicator` | Style. |
| `hostWindow` | `var` | `null` | read/write | `Md3CircularProgressIndicator` | Optional Window for scene-active checks (else OverlayHost). |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3CircularProgressIndicator` | Drop Shape geometry while page is off-display. |
| `strokeWidth` | `real` | `{…}` | read/write | `Md3CircularProgressIndicator` | Stroke Width. |
| `size` | `real` | `style === Md3CircularProgressIndicator.Standard ? 48 : 52` | read/write | `Md3CircularProgressIndicator` | Control size token (see Enums). |
| `amplitude` | `real` | `{…}` | read/write | `Md3CircularProgressIndicator` | Amplitude. |
| `waveCount` | `int` | `{…}` | read/write | `Md3CircularProgressIndicator` | Wave Count. |
| `wavePhase` | `real` | `0` | read/write | `Md3CircularProgressIndicator` | Wave Phase. |
| `arcRotation` | `real` | `-Math.PI / 2` | read/write | `Md3CircularProgressIndicator` | Arc start angle in radians (wavy / determinate standard). |
| `sweep` | `real` | `Math.PI * 0.55` | read/write | `Md3CircularProgressIndicator` | Sweep. |
| `waveSpeed` | `real` | `Math.PI * 2 / 1.8` | read/write | `Md3CircularProgressIndicator` | Wave Speed. |
| `contained` | `bool` | `true` | read/write | `Md3CircularProgressIndicator` | Thin track + thicker active arc (M3 expressive). |
| `trackLineWidth` | `real` | `contained` | readonly | `Md3CircularProgressIndicator` | Track Line Width. |
| `indicatorLineWidth` | `real` | `strokeWidth` | readonly | `Md3CircularProgressIndicator` | Indicator Line Width. |
| `sweepMin` | `real` | `Math.PI * 0.28` | readonly | `Md3CircularProgressIndicator` | Sweep Min. |
| `sweepMax` | `real` | `Math.PI * 1.15` | readonly | `Md3CircularProgressIndicator` | Sweep Max. |
| `isWavy` | `bool` | `style !== Md3CircularProgressIndicator.Standard` | readonly | `Md3CircularProgressIndicator` | Is Wavy. |
| `sceneActive` | `bool` | `enabled && _treeShown` | readonly | `Md3CircularProgressIndicator` | Scene Active. |
| `radius` | `real` | `Math.min(width, height) / 2 - indicatorLineWidth - (isWavy ? amplitude : 0)` | readonly | `Md3CircularProgressIndicator` | Corner radius. |
| `sweepDir` | `real` | `1` | read/write | `Md3CircularProgressIndicator` | Sweep Dir. |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `radToDeg(r)` | `—` | `Md3CircularProgressIndicator` | Rad To Deg. |

## Example

```qml
import Md3

Md3CircularProgressIndicator {
    value: 0
    indeterminate: true
    style: Md3CircularProgressIndicator.Standard
    hostWindow: null
    unloadWhenPageInactive: true
    strokeWidth: /* … */
}
```
