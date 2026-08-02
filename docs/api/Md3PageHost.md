# Md3PageHost

- **Source:** `src/Md3/window/Md3PageHost.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 75 | 0 | 13 | 2 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Enums

### `Md3PageHost.LaunchIntensity`

`Md3PageHost.Subtle`, `Md3PageHost.Normal`, `Md3PageHost.Premium`

### `Md3PageHost.LaunchBackdrop`

`Md3PageHost.Dim`, `Md3PageHost.Frosted`, `Md3PageHost.Blur`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `edgeSwipeBackEnabled` | `bool` | `true` | read/write | `Md3PageHost` | Left-edge swipe back (phone / compact demos). Esc also goes back when canGoBack. |
| `edgeSwipeDamping` | `real` | `0.55` | read/write | `Md3PageHost` | Rubber-band / damping factor while dragging from the left edge (0–1 applied to raw dx). |
| `edgeSwipeCommitPx` | `real` | `48` | read/write | `Md3PageHost` | Release distance (logical px) after damping to commit goBack. |
| `lightFadeOnCacheHit` | `bool` | `true` | read/write | `Md3PageHost` | When revisiting an L1-resident page, prefer a short fade instead of a heavy transition. |
| `cacheHitFadeMs` | `int` | `90` | read/write | `Md3PageHost` | Cache Hit Fade Ms. |
| `model` | `var` | `[]` | read/write | `Md3PageHost` | Data model. |
| `currentIndex` | `int` | `0` | read/write | `Md3PageHost` | Current index. |
| `displayedIndex` | `int` | `0` | read/write | `Md3PageHost` | Displayed Index. |
| `cacheMode` | `string` | `"arc"` | read/write | `Md3PageHost` | Cache Mode. |
| `cacheLimit` | `int` | `1` | read/write | `Md3PageHost` | Resident Item pages — keep at 1 for low memory (current only after idle trim) |
| `idleTrimMs` | `int` | `4000` | read/write | `Md3PageHost` | Adaptive / arc: ms without navigation before trimming to adaptiveCacheMin |
| `adaptiveCacheMin` | `int` | `1` | read/write | `Md3PageHost` | Adaptive Cache Min. |
| `contentPadding` | `real` | `20` | read/write | `Md3PageHost` | Content Padding. |
| `asynchronous` | `bool` | `false` | read/write | `Md3PageHost` | Asynchronous. |
| `prefetchNeighbors` | `bool` | `false` | read/write | `Md3PageHost` | Prefetch Neighbors. |
| `prefetchNeighborsL1` | `bool` | `true` | read/write | `Md3PageHost` | When prefetchNeighbors is on: true = L1 warm neighbors; false = L2 Component only. |
| `l2Components` | `bool` | `true` | read/write | `Md3PageHost` | L2Components. |
| `l2CacheLimit` | `int` | `1` | read/write | `Md3PageHost` | Few compiled Components — enough for back/forward, not every destination |
| `l2WarmIdle` | `bool` | `false` | read/write | `Md3PageHost` | If true, after idle delay pace-compile every destination Component (L2 only). |
| `predictPrefetch` | `bool` | `false` | read/write | `Md3PageHost` | Predict Prefetch. |
| `leaveSnapshot` | `bool` | `false` | read/write | `Md3PageHost` | Off by default: ShaderEffectSource holds a full-size GPU texture |
| `leaveSnapOpacity` | `real` | `0` | read/write | `Md3PageHost` | Leave Snap Opacity. |
| `leaveSnapHiRes` | `bool` | `false` | read/write | `Md3PageHost` | Full-res leave snapshot during launch (avoids chroma fringing on blurred text). |
| `warmStart` | `bool` | `false` | read/write | `Md3PageHost` | Warm Start. |
| `sparseSlotThreshold` | `int` | `40` | read/write | `Md3PageHost` | Above this destination count (and cacheMode !== "all"), only live/kept pages get Item slots. |
| `useSparseSlots` | `bool` | `{…}` | readonly | `Md3PageHost` | Use Sparse Slots. |
| `showBusyIndicator` | `bool` | `false` | read/write | `Md3PageHost` | Show Busy Indicator. |
| `showSkeleton` | `bool` | `false` | read/write | `Md3PageHost` | Show Skeleton. |
| `skeletonLayout` | `string` | `"page"` | read/write | `Md3PageHost` | Skeleton Layout. |
| `skeletonBones` | `var` | `[]` | read/write | `Md3PageHost` | Optional override bones; when empty, uses destination.skeletonBones / skeletonLayout |
| `pageTransition` | `string` | `"fade"` | read/write | `Md3PageHost` | "none" \| "fade" \| "slide" \| "slideUp" \| "fadeThrough" \| "scale" \| "launch" |
| `pageTransitionDuration` | `int` | `100` | read/write | `Md3PageHost` | Page Transition Duration. |
| `launchTransitionDuration` | `int` | `Md3Motion.long2` | read/write | `Md3PageHost` | Duration used by nonlinear tap-origin launch transition. |
| `launchIntensity` | `int (Md3PageHost.LaunchIntensity)` | `Md3PageHost.Normal` | read/write | `Md3PageHost` | Subtle/Normal/Premium controls launch spring feel and visual strength. |
| `launchBackdropEffect` | `int (Md3PageHost.LaunchBackdrop)` | `Md3PageHost.Frosted` | read/write | `Md3PageHost` | Backdrop while launch runs — default 毛玻璃 (Frosted). |
| `launchAxisProportional` | `bool` | `true` | read/write | `Md3PageHost` | Keep X/Y motion progression proportional to travel distance. |
| `launchRememberLastSource` | `bool` | `true` | read/write | `Md3PageHost` | Launch Remember Last Source. |
| `lastLaunchSourceRect` | `var` | `Qt.rect(0, 0, 0, 0)` | read/write | `Md3PageHost` | Last Launch Source Rect. |
| `lastLaunchSourceRadius` | `real` | `0` | read/write | `Md3PageHost` | Last Launch Source Radius. |
| `lastLaunchSourceIndex` | `int` | `-1` | read/write | `Md3PageHost` | Last Launch Source Index. |
| `lastLaunchTargetIndex` | `int` | `-1` | read/write | `Md3PageHost` | Last Launch Target Index. |
| `sourceBase` | `url` | `""` | read/write | `Md3PageHost` | Source Base. |
| `currentItem` | `var` | `{…}` | readonly | `Md3PageHost` | Current Item. |
| `loading` | `bool` | `{…}` | readonly | `Md3PageHost` | Show loading / busy presentation. |
| `awaitingTarget` | `bool` | `{…}` | readonly | `Md3PageHost` | True while the destination page is loading and not yet Ready. |
| `activeDestination` | `var` | `entryAt(currentIndex)` | readonly | `Md3PageHost` | Active Destination. |
| `effectiveSkeletonBones` | `var` | `{…}` | readonly | `Md3PageHost` | Effective Skeleton Bones. |
| `effectiveSkeletonLayout` | `string` | `{…}` | readonly | `Md3PageHost` | Effective Skeleton Layout. |
| `keepFlags` | `var` | `[]` | read/write | `Md3PageHost` | Keep Flags. |
| `lruOrder` | `var` | `[]` | read/write | `Md3PageHost` | Lru Order. |
| `generation` | `int` | `0` | read/write | `Md3PageHost` | Generation. |
| `navStack` | `var` | `[]` | read/write | `Md3PageHost` | Nav Stack. |
| `routeParams` | `var` | `{…}` | read/write | `Md3PageHost` | Route Params. |
| `sectionRootIndex` | `int` | `-1` | read/write | `Md3PageHost` | Section Root Index. |
| `browseHistory` | `var` | `[]` | read/write | `Md3PageHost` | Top-level rail / index switches (separate from pushRoute hierarchical stack). |
| `browseHistoryLimit` | `int` | `32` | read/write | `Md3PageHost` | Browse History Limit. |
| `canGoBack` | `bool` | `navStack.length > 0 \|\| browseHistory.length > 0` | readonly | `Md3PageHost` | Can Go Back. |
| `navDepth` | `int` | `navStack.length + browseHistory.length` | readonly | `Md3PageHost` | Nav Depth. |
| `transitioning` | `bool` | `false` | read/write | `Md3PageHost` | Transitioning. |
| `transitionFrom` | `int` | `-1` | read/write | `Md3PageHost` | Transition From. |
| `transitionTo` | `int` | `-1` | read/write | `Md3PageHost` | Transition To. |
| `transitionDir` | `int` | `1` | read/write | `Md3PageHost` | Transition Dir. |
| `transitionModeActive` | `string` | `pageTransition` | read/write | `Md3PageHost` | Transition Mode Active. |
| `transitionProgress` | `real` | `1` | read/write | `Md3PageHost` | Transition Progress. |
| `launchReturning` | `bool` | `false` | read/write | `Md3PageHost` | Launch Returning. |
| `launchStartRect` | `rect` | `Qt.rect(0, 0, 0, 0)` | read/write | `Md3PageHost` | Launch Start Rect. |
| `launchEndRect` | `rect` | `Qt.rect(0, 0, 0, 0)` | read/write | `Md3PageHost` | Launch End Rect. |
| `launchStartRadius` | `real` | `16` | read/write | `Md3PageHost` | Launch Start Radius. |
| `launchEndRadius` | `real` | `Md3Theme.shape.large` | read/write | `Md3PageHost` | Launch End Radius. |
| `launchCurveX` | `var` | `[0.0, 0.0, 0.2, 1.0]` | read/write | `Md3PageHost` | Launch Curve X. |
| `launchCurveY` | `var` | `Md3Motion.emphasizedDecelerate` | read/write | `Md3PageHost` | Launch Curve Y. |
| `launchWeightX` | `real` | `0.5` | read/write | `Md3PageHost` | Launch Weight X. |
| `launchWeightY` | `real` | `0.5` | read/write | `Md3PageHost` | Launch Weight Y. |
| `launchPivotX` | `real` | `0` | read/write | `Md3PageHost` | Tap origin in page-loader local coordinates (for scale pivot). |
| `launchPivotY` | `real` | `0` | read/write | `Md3PageHost` | Launch Pivot Y. |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `resetNavStack()` | `—` | `Md3PageHost` | Reset Nav Stack. |
| `resetBrowseHistory()` | `—` | `Md3PageHost` | Reset Browse History. |
| `pushRoute(index, params, opts)` | `—` | `Md3PageHost` | Push Route. |
| `replaceRoute(index, params, opts)` | `—` | `Md3PageHost` | Replace Route. |
| `goBack(opts)` | `—` | `Md3PageHost` | Go Back. |
| `entryAt(index)` | `—` | `Md3PageHost` | Entry At. |
| `reloadCurrent()` | `—` | `Md3PageHost` | Clear current page Loader and reopen (used by hot reload). |
| `resolveSource(src)` | `—` | `Md3PageHost` | Resolve Source. |
| `noteActivity()` | `—` | `Md3PageHost` | Note Activity. |
| `prefetchHint(index)` | `—` | `Md3PageHost` | Prefetch Hint. |
| `clearPrefetchHint(index)` | `—` | `Md3PageHost` | Clear Prefetch Hint. |
| `clearAllPrefetchHints()` | `—` | `Md3PageHost` | Drop pending hover / predict warm work (e.g. rail flick started). |
| `navigateTo(index, opts)` | `—` | `Md3PageHost` | Navigate To. |

## Example

```qml
import Md3

Md3PageHost {
    edgeSwipeBackEnabled: true
    edgeSwipeDamping: 0.55
    edgeSwipeCommitPx: 48
    lightFadeOnCacheHit: true
    cacheHitFadeMs: 90
    model: []
}
```
