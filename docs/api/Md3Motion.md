# Md3Motion

Motion tokens aligned with **iOS / UIKit / Core Animation**. Curves: CAMediaTimingFunction Default / EaseIn / EaseOut / EaseInEaseOut. Durations: common UIKit intervals (0.25 / 0.35 / 0.5 s). Springs: SwiftUI-style dampingFraction ≈ 0.82–0.88 (mapped to Qt SpringAnimation).

- **Source:** `src/Md3/foundation/Md3Motion.qml`
- **Extends:** `QtObject`
- **Singleton:** `true` (`pragma Singleton`)

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 79 | 0 | 5 | 0 |

_Also inherits Qt Quick `QtObject` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `durationScale` | `real` | `1.0` | read/write | `Md3Motion` | Global duration multiplier. 1 = iOS baseline pacing. |
| `reduced` | `bool` | `Md3Theme ? Md3Theme.reduceMotion : false` | readonly | `Md3Motion` | Explicit binding — do not hide Md3Theme.reduceMotion only inside _scaled() (some QML engines won't re-eval token props when the flag flips). |
| `short1` | `int` | `_scaled(100)` | readonly | `Md3Motion` | Short1. |
| `short2` | `int` | `_scaled(150)` | readonly | `Md3Motion` | Short2. |
| `short3` | `int` | `_scaled(200)` | readonly | `Md3Motion` | Short3. |
| `short4` | `int` | `_scaled(250)` | readonly | `Md3Motion` | UIView default-ish (0.25s) |
| `medium1` | `int` | `_scaled(300)` | readonly | `Md3Motion` | Medium1. |
| `medium2` | `int` | `_scaled(350)` | readonly | `Md3Motion` | push / most UI |
| `medium3` | `int` | `_scaled(400)` | readonly | `Md3Motion` | Medium3. |
| `medium4` | `int` | `_scaled(450)` | readonly | `Md3Motion` | Medium4. |
| `long1` | `int` | `_scaled(500)` | readonly | `Md3Motion` | modal / sheet |
| `long2` | `int` | `_scaled(550)` | readonly | `Md3Motion` | Long2. |
| `long3` | `int` | `_scaled(600)` | readonly | `Md3Motion` | Long3. |
| `long4` | `int` | `_scaled(650)` | readonly | `Md3Motion` | Long4. |
| `extraLong1` | `int` | `_scaled(700)` | readonly | `Md3Motion` | Extra Long1. |
| `extraLong2` | `int` | `_scaled(800)` | readonly | `Md3Motion` | Extra Long2. |
| `extraLong3` | `int` | `_scaled(900)` | readonly | `Md3Motion` | Extra Long3. |
| `extraLong4` | `int` | `_scaled(1000)` | readonly | `Md3Motion` | Extra Long4. |
| `iosDefault` | `var` | `[0.25, 0.1, 0.25, 1.0]` | readonly | `Md3Motion` | Ios Default. |
| `iosEaseIn` | `var` | `[0.42, 0.0, 1.0, 1.0]` | readonly | `Md3Motion` | Ios Ease In. |
| `iosEaseOut` | `var` | `[0.0, 0.0, 0.58, 1.0]` | readonly | `Md3Motion` | Ios Ease Out. |
| `iosEaseInOut` | `var` | `[0.42, 0.0, 0.58, 1.0]` | readonly | `Md3Motion` | Ios Ease In Out. |
| `iosSheet` | `var` | `[0.32, 0.72, 0.0, 1.0]` | readonly | `Md3Motion` | Sheet / card settle — iOS-like decelerate with slight anticipation |
| `iosSnap` | `var` | `[0.2, 0.9, 0.1, 1.0]` | readonly | `Md3Motion` | Snappy interactive settle (control chrome, toggles) |
| `emphasized` | `var` | `iosDefault` | readonly | `Md3Motion` | Emphasized. |
| `emphasizedDecelerate` | `var` | `iosEaseOut` | readonly | `Md3Motion` | Emphasized Decelerate. |
| `emphasizedAccelerate` | `var` | `iosEaseIn` | readonly | `Md3Motion` | Emphasized Accelerate. |
| `standard` | `var` | `iosDefault` | readonly | `Md3Motion` | Standard. |
| `standardDecelerate` | `var` | `iosEaseOut` | readonly | `Md3Motion` | Standard Decelerate. |
| `standardAccelerate` | `var` | `iosEaseIn` | readonly | `Md3Motion` | Standard Accelerate. |
| `legacy` | `var` | `iosEaseInOut` | readonly | `Md3Motion` | Legacy. |
| `legacyDecelerate` | `var` | `iosEaseOut` | readonly | `Md3Motion` | Legacy Decelerate. |
| `legacyAccelerate` | `var` | `iosEaseIn` | readonly | `Md3Motion` | Legacy Accelerate. |
| `spatialFast` | `var` | `iosSnap` | readonly | `Md3Motion` | Spatial Fast. |
| `spatialDefault` | `var` | `iosSheet` | readonly | `Md3Motion` | Spatial Default. |
| `spatialSlow` | `var` | `iosEaseOut` | readonly | `Md3Motion` | Spatial Slow. |
| `effectsFast` | `var` | `iosEaseOut` | readonly | `Md3Motion` | Effects Fast. |
| `effectsDefault` | `var` | `iosDefault` | readonly | `Md3Motion` | Effects Default. |
| `effectsSlow` | `var` | `iosEaseInOut` | readonly | `Md3Motion` | Effects Slow. |
| `snapOut` | `var` | `iosEaseOut` | readonly | `Md3Motion` | Snap Out. |
| `ui` | `var` | `iosDefault` | readonly | `Md3Motion` | Ui. |
| `uiEnter` | `var` | `iosEaseOut` | readonly | `Md3Motion` | Ui Enter. |
| `uiExit` | `var` | `iosEaseIn` | readonly | `Md3Motion` | Ui Exit. |
| `uiSpatial` | `var` | `iosSheet` | readonly | `Md3Motion` | Ui Spatial. |
| `uiSpatialSnap` | `var` | `iosSnap` | readonly | `Md3Motion` | Ui Spatial Snap. |
| `uiEffects` | `var` | `iosDefault` | readonly | `Md3Motion` | Ui Effects. |
| `uiEffectsSnap` | `var` | `iosEaseOut` | readonly | `Md3Motion` | Ui Effects Snap. |
| `uiDuration` | `int` | `medium2` | readonly | `Md3Motion` | 350 |
| `spatialDuration` | `int` | `long1` | readonly | `Md3Motion` | 500 sheet / panel |
| `spatialSnapDuration` | `int` | `medium2` | readonly | `Md3Motion` | 350 |
| `effectsDuration` | `int` | `short4` | readonly | `Md3Motion` | 250 |
| `menuDuration` | `int` | `short4` | readonly | `Md3Motion` | 250 |
| `overlayDuration` | `int` | `short4` | readonly | `Md3Motion` | 250 scrim |
| `rippleDuration` | `int` | `short4` | readonly | `Md3Motion` | 250 press |
| `stateDuration` | `int` | `short3` | readonly | `Md3Motion` | 200 hover/press chrome |
| `springSnap` | `real` | `4.2` | readonly | `Md3Motion` | Spring Snap. |
| `dampingSnap` | `real` | `0.86` | readonly | `Md3Motion` | Damping Snap. |
| `massSnap` | `real` | `1.0` | readonly | `Md3Motion` | Mass Snap. |
| `epsilonSnap` | `real` | `0.08` | readonly | `Md3Motion` | Epsilon Snap. |
| `springSoft` | `real` | `2.8` | readonly | `Md3Motion` | Spring Soft. |
| `dampingSoft` | `real` | `0.82` | readonly | `Md3Motion` | Damping Soft. |
| `massSoft` | `real` | `1.0` | readonly | `Md3Motion` | Mass Soft. |
| `epsilonSoft` | `real` | `0.25` | readonly | `Md3Motion` | Epsilon Soft. |
| `springMenu` | `real` | `3.6` | readonly | `Md3Motion` | Spring Menu. |
| `dampingMenu` | `real` | `0.88` | readonly | `Md3Motion` | Damping Menu. |
| `massMenu` | `real` | `1.0` | readonly | `Md3Motion` | Mass Menu. |
| `epsilonMenu` | `real` | `0.02` | readonly | `Md3Motion` | Epsilon Menu. |
| `smoothSnapVelocity` | `real` | `90 / Math.max(0.5, durationScale)` | readonly | `Md3Motion` | Smooth Snap Velocity. |
| `smoothPanelVelocity` | `real` | `420 / Math.max(0.5, durationScale)` | readonly | `Md3Motion` | Smooth Panel Velocity. |
| `smoothOpacityVelocity` | `real` | `2.6 / Math.max(0.5, durationScale)` | readonly | `Md3Motion` | Smooth Opacity Velocity. |
| `smoothOpacityFastVelocity` | `real` | `4.0 / Math.max(0.5, durationScale)` | readonly | `Md3Motion` | Smooth Opacity Fast Velocity. |
| `smoothScaleVelocity` | `real` | `1.5 / Math.max(0.5, durationScale)` | readonly | `Md3Motion` | Smooth Scale Velocity. |
| `smoothSnapEasing` | `int` | `_scaled(160)` | readonly | `Md3Motion` | Smooth Snap Easing. |
| `smoothPanelEasing` | `int` | `_scaled(200)` | readonly | `Md3Motion` | Smooth Panel Easing. |
| `smoothMaxEasing` | `int` | `_scaled(250)` | readonly | `Md3Motion` | Smooth Max Easing. |
| `progressTravel` | `int` | `essential(1800)` | readonly | `Md3Motion` | Progress Travel. |
| `progressSpin` | `int` | `essential(1600)` | readonly | `Md3Motion` | Progress Spin. |
| `progressSweep` | `int` | `essential(1100)` | readonly | `Md3Motion` | Progress Sweep. |
| `progressWave` | `int` | `essential(2400)` | readonly | `Md3Motion` | Progress Wave. |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `essential(ms)` | `—` | `Md3Motion` | Durations for loaders / progress / live indicators. Fixed wall-clock ms — never follow reduceMotion (1ms collapse) or durationScale. UIActivityIndicatorView-like pacing: ~1.5–1.8s per revolution. |
| `curve(token)` | `—` | `Md3Motion` | Curve. |
| `apply(animation, token)` | `—` | `Md3Motion` | Apply. |
| `applySpring(animation, kind)` | `—` | `Md3Motion` | Apply Spring. |
| `durationFor(kind)` | `—` | `Md3Motion` | Duration For. |

## Example

```qml
import Md3

// Singleton — use as `Md3Motion.…`
console.log(Md3Motion)
```
