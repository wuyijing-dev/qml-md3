# Md3Motion

Motion tokens aligned with **iOS / UIKit / Core Animation**. Curves: CAMediaTimingFunction Default / EaseIn / EaseOut / EaseInEaseOut. Durations: common UIKit intervals (0.25 / 0.35 / 0.5 s). Springs: SwiftUI-style dampingFraction ≈ 0.82–0.88 (mapped to Qt SpringAnimation).

- **Source:** `src/Md3/foundation/Md3Motion.qml`
- **Extends:** `QtObject`
- **Singleton:** `true` (`pragma Singleton`)

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `durationScale` | `real` | `1.0` | read/write | `Md3Motion` | Global duration multiplier. 1 = iOS baseline pacing. |
| `reduced` | `bool` | `Md3Theme ? Md3Theme.reduceMotion : false` | readonly | `Md3Motion` | Explicit binding — do not hide Md3Theme.reduceMotion only inside _scaled() (some QML engines won't re-eval token props when the flag flips). |
| `short1` | `int` | `_scaled(100)` | readonly | `Md3Motion` | — |
| `short2` | `int` | `_scaled(150)` | readonly | `Md3Motion` | — |
| `short3` | `int` | `_scaled(200)` | readonly | `Md3Motion` | — |
| `short4` | `int` | `_scaled(250)` | readonly | `Md3Motion` | — |
| `medium1` | `int` | `_scaled(300)` | readonly | `Md3Motion` | — |
| `medium2` | `int` | `_scaled(350)` | readonly | `Md3Motion` | — |
| `medium3` | `int` | `_scaled(400)` | readonly | `Md3Motion` | — |
| `medium4` | `int` | `_scaled(450)` | readonly | `Md3Motion` | — |
| `long1` | `int` | `_scaled(500)` | readonly | `Md3Motion` | — |
| `long2` | `int` | `_scaled(550)` | readonly | `Md3Motion` | — |
| `long3` | `int` | `_scaled(600)` | readonly | `Md3Motion` | — |
| `long4` | `int` | `_scaled(650)` | readonly | `Md3Motion` | — |
| `extraLong1` | `int` | `_scaled(700)` | readonly | `Md3Motion` | — |
| `extraLong2` | `int` | `_scaled(800)` | readonly | `Md3Motion` | — |
| `extraLong3` | `int` | `_scaled(900)` | readonly | `Md3Motion` | — |
| `extraLong4` | `int` | `_scaled(1000)` | readonly | `Md3Motion` | — |
| `iosDefault` | `var` | `[0.25, 0.1, 0.25, 1.0]` | readonly | `Md3Motion` | — |
| `iosEaseIn` | `var` | `[0.42, 0.0, 1.0, 1.0]` | readonly | `Md3Motion` | — |
| `iosEaseOut` | `var` | `[0.0, 0.0, 0.58, 1.0]` | readonly | `Md3Motion` | — |
| `iosEaseInOut` | `var` | `[0.42, 0.0, 0.58, 1.0]` | readonly | `Md3Motion` | — |
| `iosSheet` | `var` | `[0.32, 0.72, 0.0, 1.0]` | readonly | `Md3Motion` | Sheet / card settle — iOS-like decelerate with slight anticipation |
| `iosSnap` | `var` | `[0.2, 0.9, 0.1, 1.0]` | readonly | `Md3Motion` | Snappy interactive settle (control chrome, toggles) |
| `emphasized` | `var` | `iosDefault` | readonly | `Md3Motion` | — |
| `emphasizedDecelerate` | `var` | `iosEaseOut` | readonly | `Md3Motion` | — |
| `emphasizedAccelerate` | `var` | `iosEaseIn` | readonly | `Md3Motion` | — |
| `standard` | `var` | `iosDefault` | readonly | `Md3Motion` | — |
| `standardDecelerate` | `var` | `iosEaseOut` | readonly | `Md3Motion` | — |
| `standardAccelerate` | `var` | `iosEaseIn` | readonly | `Md3Motion` | — |
| `legacy` | `var` | `iosEaseInOut` | readonly | `Md3Motion` | — |
| `legacyDecelerate` | `var` | `iosEaseOut` | readonly | `Md3Motion` | — |
| `legacyAccelerate` | `var` | `iosEaseIn` | readonly | `Md3Motion` | — |
| `spatialFast` | `var` | `iosSnap` | readonly | `Md3Motion` | — |
| `spatialDefault` | `var` | `iosSheet` | readonly | `Md3Motion` | — |
| `spatialSlow` | `var` | `iosEaseOut` | readonly | `Md3Motion` | — |
| `effectsFast` | `var` | `iosEaseOut` | readonly | `Md3Motion` | — |
| `effectsDefault` | `var` | `iosDefault` | readonly | `Md3Motion` | — |
| `effectsSlow` | `var` | `iosEaseInOut` | readonly | `Md3Motion` | — |
| `snapOut` | `var` | `iosEaseOut` | readonly | `Md3Motion` | — |
| `ui` | `var` | `iosDefault` | readonly | `Md3Motion` | — |
| `uiEnter` | `var` | `iosEaseOut` | readonly | `Md3Motion` | — |
| `uiExit` | `var` | `iosEaseIn` | readonly | `Md3Motion` | — |
| `uiSpatial` | `var` | `iosSheet` | readonly | `Md3Motion` | — |
| `uiSpatialSnap` | `var` | `iosSnap` | readonly | `Md3Motion` | — |
| `uiEffects` | `var` | `iosDefault` | readonly | `Md3Motion` | — |
| `uiEffectsSnap` | `var` | `iosEaseOut` | readonly | `Md3Motion` | — |
| `uiDuration` | `int` | `medium2` | readonly | `Md3Motion` | — |
| `spatialDuration` | `int` | `long1` | readonly | `Md3Motion` | — |
| `spatialSnapDuration` | `int` | `medium2` | readonly | `Md3Motion` | — |
| `effectsDuration` | `int` | `short4` | readonly | `Md3Motion` | — |
| `menuDuration` | `int` | `short4` | readonly | `Md3Motion` | — |
| `overlayDuration` | `int` | `short4` | readonly | `Md3Motion` | — |
| `rippleDuration` | `int` | `short4` | readonly | `Md3Motion` | — |
| `stateDuration` | `int` | `short3` | readonly | `Md3Motion` | — |
| `springSnap` | `real` | `4.2` | readonly | `Md3Motion` | — |
| `dampingSnap` | `real` | `0.86` | readonly | `Md3Motion` | — |
| `massSnap` | `real` | `1.0` | readonly | `Md3Motion` | — |
| `epsilonSnap` | `real` | `0.08` | readonly | `Md3Motion` | — |
| `springSoft` | `real` | `2.8` | readonly | `Md3Motion` | — |
| `dampingSoft` | `real` | `0.82` | readonly | `Md3Motion` | — |
| `massSoft` | `real` | `1.0` | readonly | `Md3Motion` | — |
| `epsilonSoft` | `real` | `0.25` | readonly | `Md3Motion` | — |
| `springMenu` | `real` | `3.6` | readonly | `Md3Motion` | — |
| `dampingMenu` | `real` | `0.88` | readonly | `Md3Motion` | — |
| `massMenu` | `real` | `1.0` | readonly | `Md3Motion` | — |
| `epsilonMenu` | `real` | `0.02` | readonly | `Md3Motion` | — |
| `smoothSnapVelocity` | `real` | `90 / Math.max(0.5, durationScale)` | readonly | `Md3Motion` | — |
| `smoothPanelVelocity` | `real` | `420 / Math.max(0.5, durationScale)` | readonly | `Md3Motion` | — |
| `smoothOpacityVelocity` | `real` | `2.6 / Math.max(0.5, durationScale)` | readonly | `Md3Motion` | — |
| `smoothOpacityFastVelocity` | `real` | `4.0 / Math.max(0.5, durationScale)` | readonly | `Md3Motion` | — |
| `smoothScaleVelocity` | `real` | `1.5 / Math.max(0.5, durationScale)` | readonly | `Md3Motion` | — |
| `smoothSnapEasing` | `int` | `_scaled(160)` | readonly | `Md3Motion` | — |
| `smoothPanelEasing` | `int` | `_scaled(200)` | readonly | `Md3Motion` | — |
| `smoothMaxEasing` | `int` | `_scaled(250)` | readonly | `Md3Motion` | — |
| `progressTravel` | `int` | `essential(1800)` | readonly | `Md3Motion` | — |
| `progressSpin` | `int` | `essential(1600)` | readonly | `Md3Motion` | — |
| `progressSweep` | `int` | `essential(1100)` | readonly | `Md3Motion` | — |
| `progressWave` | `int` | `essential(2400)` | readonly | `Md3Motion` | — |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `essential(ms)` | `Md3Motion` | Durations for loaders / progress / live indicators. Fixed wall-clock ms — never follow reduceMotion (1ms collapse) or durationScale. UIActivityIndicatorView-like pacing: ~1.5–1.8s per revolution. |
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
