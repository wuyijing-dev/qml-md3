# Md3Motion

- **Source:** `src/Md3/foundation/Md3Motion.qml`
- **Extends:** `QtObject`
- **Singleton:** `true` (`pragma Singleton`)
- **Policy:** iOS / UIKit / Core Animation timing (see [tokens.md](../guides/tokens.md#motion-ios--uikit--core-animation))

## Import

```qml
import Md3
```

Curves: `iosDefault` (0.25, 0.1, 0.25, 1), `iosEaseIn`, `iosEaseOut`, `iosEaseInOut`, `iosSheet`, `iosSnap`.
Material-era names (`emphasized`, `standard`, …) alias these iOS curves.

Semantic durations: `uiDuration` 350 · `spatialDuration` 500 · `menuDuration`/`overlayDuration`/`effectsDuration` 250 · `stateDuration` 200.

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `durationScale` | `real` | `1.0` | read/write | `Md3Motion` | Global duration multiplier. 1 = Material/Flutter original pacing. |
| `reduced` | `bool` | `Md3Theme ? Md3Theme.reduceMotion : false` | readonly | `Md3Motion` | Explicit binding — do not hide Md3Theme.reduceMotion only inside _scaled() (some QML engines won't re-eval token props when the flag flips). |
| `short1` | `int` | `_scaled(50)` | readonly | `Md3Motion` | — |
| `short2` | `int` | `_scaled(100)` | readonly | `Md3Motion` | — |
| `short3` | `int` | `_scaled(150)` | readonly | `Md3Motion` | — |
| `short4` | `int` | `_scaled(200)` | readonly | `Md3Motion` | — |
| `medium1` | `int` | `_scaled(250)` | readonly | `Md3Motion` | — |
| `medium2` | `int` | `_scaled(300)` | readonly | `Md3Motion` | — |
| `medium3` | `int` | `_scaled(350)` | readonly | `Md3Motion` | — |
| `medium4` | `int` | `_scaled(400)` | readonly | `Md3Motion` | — |
| `long1` | `int` | `_scaled(450)` | readonly | `Md3Motion` | — |
| `long2` | `int` | `_scaled(500)` | readonly | `Md3Motion` | — |
| `long3` | `int` | `_scaled(550)` | readonly | `Md3Motion` | — |
| `long4` | `int` | `_scaled(600)` | readonly | `Md3Motion` | — |
| `extraLong1` | `int` | `_scaled(700)` | readonly | `Md3Motion` | — |
| `extraLong2` | `int` | `_scaled(800)` | readonly | `Md3Motion` | — |
| `extraLong3` | `int` | `_scaled(900)` | readonly | `Md3Motion` | — |
| `extraLong4` | `int` | `_scaled(1000)` | readonly | `Md3Motion` | — |
| `emphasized` | `var` | `[0.2, 0.0, 0.0, 1.0]` | readonly | `Md3Motion` | — |
| `emphasizedDecelerate` | `var` | `[0.05, 0.7, 0.1, 1.0]` | readonly | `Md3Motion` | — |
| `emphasizedAccelerate` | `var` | `[0.3, 0.0, 0.8, 0.15]` | readonly | `Md3Motion` | — |
| `standard` | `var` | `[0.2, 0.0, 0.0, 1.0]` | readonly | `Md3Motion` | — |
| `standardDecelerate` | `var` | `[0.0, 0.0, 0.0, 1.0]` | readonly | `Md3Motion` | — |
| `standardAccelerate` | `var` | `[0.3, 0.0, 1.0, 1.0]` | readonly | `Md3Motion` | — |
| `legacy` | `var` | `[0.4, 0.0, 0.2, 1.0]` | readonly | `Md3Motion` | — |
| `legacyDecelerate` | `var` | `[0.0, 0.0, 0.2, 1.0]` | readonly | `Md3Motion` | — |
| `legacyAccelerate` | `var` | `[0.4, 0.0, 1.0, 1.0]` | readonly | `Md3Motion` | — |
| `spatialFast` | `var` | `[0.42, 1.67, 0.21, 0.90]` | readonly | `Md3Motion` | — |
| `spatialDefault` | `var` | `[0.38, 1.21, 0.22, 1.00]` | readonly | `Md3Motion` | — |
| `spatialSlow` | `var` | `[0.39, 1.29, 0.35, 0.98]` | readonly | `Md3Motion` | — |
| `effectsFast` | `var` | `[0.31, 0.94, 0.34, 1.00]` | readonly | `Md3Motion` | — |
| `effectsDefault` | `var` | `[0.34, 0.80, 0.34, 1.00]` | readonly | `Md3Motion` | — |
| `effectsSlow` | `var` | `[0.34, 0.88, 0.34, 1.00]` | readonly | `Md3Motion` | — |
| `snapOut` | `var` | `[0.0, 0.0, 0.2, 1.0]` | readonly | `Md3Motion` | — |
| `ui` | `var` | `emphasized` | readonly | `Md3Motion` | — |
| `uiEnter` | `var` | `emphasizedDecelerate` | readonly | `Md3Motion` | — |
| `uiExit` | `var` | `emphasizedAccelerate` | readonly | `Md3Motion` | — |
| `uiSpatial` | `var` | `spatialDefault` | readonly | `Md3Motion` | — |
| `uiSpatialSnap` | `var` | `spatialFast` | readonly | `Md3Motion` | — |
| `uiEffects` | `var` | `effectsDefault` | readonly | `Md3Motion` | — |
| `uiEffectsSnap` | `var` | `effectsFast` | readonly | `Md3Motion` | — |
| `uiDuration` | `int` | `medium2` | readonly | `Md3Motion` | — |
| `spatialDuration` | `int` | `medium4` | readonly | `Md3Motion` | — |
| `spatialSnapDuration` | `int` | `medium2` | readonly | `Md3Motion` | — |
| `effectsDuration` | `int` | `short4` | readonly | `Md3Motion` | — |
| `menuDuration` | `int` | `short3` | readonly | `Md3Motion` | — |
| `overlayDuration` | `int` | `short2` | readonly | `Md3Motion` | — |
| `rippleDuration` | `int` | `medium2` | readonly | `Md3Motion` | — |
| `stateDuration` | `int` | `short2` | readonly | `Md3Motion` | — |
| `springSnap` | `real` | `5.0` | readonly | `Md3Motion` | — |
| `dampingSnap` | `real` | `0.55` | readonly | `Md3Motion` | — |
| `massSnap` | `real` | `1.0` | readonly | `Md3Motion` | — |
| `epsilonSnap` | `real` | `0.1` | readonly | `Md3Motion` | — |
| `springSoft` | `real` | `3.5` | readonly | `Md3Motion` | — |
| `dampingSoft` | `real` | `0.5` | readonly | `Md3Motion` | — |
| `massSoft` | `real` | `1.0` | readonly | `Md3Motion` | — |
| `epsilonSoft` | `real` | `0.35` | readonly | `Md3Motion` | — |
| `springMenu` | `real` | `4.5` | readonly | `Md3Motion` | — |
| `dampingMenu` | `real` | `0.55` | readonly | `Md3Motion` | — |
| `massMenu` | `real` | `1.0` | readonly | `Md3Motion` | — |
| `epsilonMenu` | `real` | `0.02` | readonly | `Md3Motion` | — |
| `smoothSnapVelocity` | `real` | `110 / Math.max(0.5, durationScale)` | readonly | `Md3Motion` | — |
| `smoothPanelVelocity` | `real` | `520 / Math.max(0.5, durationScale)` | readonly | `Md3Motion` | — |
| `smoothOpacityVelocity` | `real` | `3.0 / Math.max(0.5, durationScale)` | readonly | `Md3Motion` | — |
| `smoothOpacityFastVelocity` | `real` | `5.0 / Math.max(0.5, durationScale)` | readonly | `Md3Motion` | — |
| `smoothScaleVelocity` | `real` | `1.8 / Math.max(0.5, durationScale)` | readonly | `Md3Motion` | — |
| `smoothSnapEasing` | `int` | `_scaled(140)` | readonly | `Md3Motion` | — |
| `smoothPanelEasing` | `int` | `_scaled(160)` | readonly | `Md3Motion` | — |
| `smoothMaxEasing` | `int` | `_scaled(180)` | readonly | `Md3Motion` | — |
| `progressTravel` | `int` | `_scaled(1800)` | readonly | `Md3Motion` | — |
| `progressSpin` | `int` | `_scaled(1600)` | readonly | `Md3Motion` | — |
| `progressSweep` | `int` | `_scaled(1100)` | readonly | `Md3Motion` | — |
| `progressWave` | `int` | `_scaled(2400)` | readonly | `Md3Motion` | — |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `curve(token)` | `Md3Motion` | — |
| `apply(animation, token)` | `Md3Motion` | — |
| `applySpring(animation, kind)` | `Md3Motion` | — |
| `durationFor(kind)` | `Md3Motion` | — |

## Example

```qml
import Md3

// Singleton — use as `Md3Motion.…`
console.log(Md3Motion)
```
