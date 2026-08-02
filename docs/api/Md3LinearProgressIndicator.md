# Md3LinearProgressIndicator

Linear progress — Standard uses Rectangles + NumberAnimation; wavy styles rebuild polylines on a capped cadence (not every vsync).

- **Source:** `src/Md3/components/Md3LinearProgressIndicator.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 19 | 0 | 0 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Enums

### `Md3LinearProgressIndicator.Style`

`Md3LinearProgressIndicator.Standard`, `Md3LinearProgressIndicator.Wavy`, `Md3LinearProgressIndicator.Lively`, `Md3LinearProgressIndicator.Soft`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `value` | `real` | `0` | read/write | `Md3LinearProgressIndicator` | Current value. |
| `indeterminate` | `bool` | `false` | read/write | `Md3LinearProgressIndicator` | Indeterminate. |
| `style` | `int (Md3LinearProgressIndicator.Style)` | `Md3LinearProgressIndicator.Standard` | read/write | `Md3LinearProgressIndicator` | Style. |
| `hostWindow` | `var` | `null` | read/write | `Md3LinearProgressIndicator` | Optional Window for scene-active checks (else OverlayHost). |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3LinearProgressIndicator` | Drop Shape / animated chrome while page is off-display. |
| `wavelength` | `real` | `style === Md3LinearProgressIndicator.Lively ? 28` | read/write | `Md3LinearProgressIndicator` | Wavelength. |
| `amplitude` | `real` | `{…}` | read/write | `Md3LinearProgressIndicator` | Amplitude. |
| `trackThickness` | `real` | `{…}` | read/write | `Md3LinearProgressIndicator` | Track Thickness. |
| `contained` | `bool` | `true` | read/write | `Md3LinearProgressIndicator` | Expressive look: thin track + thicker active segment (matches M3 specs). |
| `trackLineThickness` | `real` | `contained` | readonly | `Md3LinearProgressIndicator` | Track Line Thickness. |
| `indicatorThickness` | `real` | `trackThickness` | readonly | `Md3LinearProgressIndicator` | Indicator Thickness. |
| `wavePhase` | `real` | `0` | read/write | `Md3LinearProgressIndicator` | Wave Phase. |
| `showStopIndicator` | `bool` | `true` | read/write | `Md3LinearProgressIndicator` | Show Stop Indicator. |
| `waveSpeed` | `real` | `Math.PI * 2 / 1.8` | read/write | `Md3LinearProgressIndicator` | Wave Speed. |
| `isWavy` | `bool` | `style !== Md3LinearProgressIndicator.Standard` | readonly | `Md3LinearProgressIndicator` | Is Wavy. |
| `progress` | `real` | `Math.max(0, Math.min(1, value))` | readonly | `Md3LinearProgressIndicator` | Progress. |
| `barWidth` | `real` | `indeterminate ? Math.max(48, width * 0.35) : width * progress` | readonly | `Md3LinearProgressIndicator` | Bar Width. |
| `sceneActive` | `bool` | `enabled && _treeShown` | readonly | `Md3LinearProgressIndicator` | Scene Active. |
| `travelX` | `real` | `-barWidth` | read/write | `Md3LinearProgressIndicator` | Travel X. |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3LinearProgressIndicator {
    value: 0
    indeterminate: false
    style: Md3LinearProgressIndicator.Standard
    hostWindow: null
    unloadWhenPageInactive: true
    wavelength: style === Md3LinearProgressIndicator.Lively ? 28
}
```
