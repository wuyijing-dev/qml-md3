# Md3PageHost

- **Source:** `src/Md3/window/Md3PageHost.qml`
- **Extends:** `Item`

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
| `cacheHitFadeMs` | `int` | `90` | read/write | `Md3PageHost` | — |
| `model` | `var` | `[]` | read/write | `Md3PageHost` | — |
| `currentIndex` | `int` | `0` | read/write | `Md3PageHost` | — |
| `displayedIndex` | `int` | `0` | read/write | `Md3PageHost` | — |
| `cacheMode` | `string` | `"arc"` | read/write | `Md3PageHost` | — |
| `cacheLimit` | `int` | `1` | read/write | `Md3PageHost` | Resident Item pages — keep at 1 for low memory (current only after idle trim) |
| `idleTrimMs` | `int` | `4000` | read/write | `Md3PageHost` | Adaptive / arc: ms without navigation before trimming to adaptiveCacheMin |
| `adaptiveCacheMin` | `int` | `1` | read/write | `Md3PageHost` | — |
| `contentPadding` | `real` | `20` | read/write | `Md3PageHost` | — |
| `asynchronous` | `bool` | `false` | read/write | `Md3PageHost` | — |
| `prefetchNeighbors` | `bool` | `false` | read/write | `Md3PageHost` | — |
| `prefetchNeighborsL1` | `bool` | `true` | read/write | `Md3PageHost` | When prefetchNeighbors is on: true = L1 warm neighbors; false = L2 Component only. |
| `l2Components` | `bool` | `true` | read/write | `Md3PageHost` | — |
| `l2CacheLimit` | `int` | `1` | read/write | `Md3PageHost` | Few compiled Components — enough for back/forward, not every destination |
| `l2WarmIdle` | `bool` | `false` | read/write | `Md3PageHost` | If true, after idle delay pace-compile every destination Component (L2 only). |
| `predictPrefetch` | `bool` | `false` | read/write | `Md3PageHost` | — |
| `leaveSnapshot` | `bool` | `false` | read/write | `Md3PageHost` | Off by default: ShaderEffectSource holds a full-size GPU texture |
| `leaveSnapOpacity` | `real` | `0` | read/write | `Md3PageHost` | — |
| `leaveSnapHiRes` | `bool` | `false` | read/write | `Md3PageHost` | Full-res leave snapshot during launch (avoids chroma fringing on blurred text). |
| `warmStart` | `bool` | `false` | read/write | `Md3PageHost` | — |
| `sparseSlotThreshold` | `int` | `40` | read/write | `Md3PageHost` | Above this destination count (and cacheMode !== "all"), only live/kept pages get Item slots. |
| `useSparseSlots` | `bool` | `{…}` | readonly | `Md3PageHost` | — |
| `showBusyIndicator` | `bool` | `false` | read/write | `Md3PageHost` | — |
| `showSkeleton` | `bool` | `false` | read/write | `Md3PageHost` | — |
| `skeletonLayout` | `string` | `"page"` | read/write | `Md3PageHost` | — |
| `skeletonBones` | `var` | `[]` | read/write | `Md3PageHost` | Optional override bones; when empty, uses destination.skeletonBones / skeletonLayout |
| `pageTransition` | `string` | `"fade"` | read/write | `Md3PageHost` | "none" \| "fade" \| "slide" \| "slideUp" \| "fadeThrough" \| "scale" \| "launch" |
| `pageTransitionDuration` | `int` | `100` | read/write | `Md3PageHost` | — |
| `launchTransitionDuration` | `int` | `Md3Motion.long2` | read/write | `Md3PageHost` | Duration used by nonlinear tap-origin launch transition. |
| `launchIntensity` | `int` | `Md3PageHost.Normal` | read/write | `Md3PageHost` | Subtle/Normal/Premium controls launch spring feel and visual strength. |
| `launchBackdropEffect` | `int` | `Md3PageHost.Frosted` | read/write | `Md3PageHost` | Backdrop while launch runs — default 毛玻璃 (Frosted). |
| `launchAxisProportional` | `bool` | `true` | read/write | `Md3PageHost` | Keep X/Y motion progression proportional to travel distance. |
| `launchRememberLastSource` | `bool` | `true` | read/write | `Md3PageHost` | — |
| `lastLaunchSourceRect` | `var` | `Qt.rect(0, 0, 0, 0)` | read/write | `Md3PageHost` | — |
| `lastLaunchSourceRadius` | `real` | `0` | read/write | `Md3PageHost` | — |
| `lastLaunchSourceIndex` | `int` | `-1` | read/write | `Md3PageHost` | — |
| `lastLaunchTargetIndex` | `int` | `-1` | read/write | `Md3PageHost` | — |
| `sourceBase` | `url` | `""` | read/write | `Md3PageHost` | — |
| `currentItem` | `var` | `{…}` | readonly | `Md3PageHost` | — |
| `loading` | `bool` | `{…}` | readonly | `Md3PageHost` | — |
| `awaitingTarget` | `bool` | `{…}` | readonly | `Md3PageHost` | True while the destination page is loading and not yet Ready. |
| `activeDestination` | `var` | `entryAt(currentIndex)` | readonly | `Md3PageHost` | — |
| `effectiveSkeletonBones` | `var` | `{…}` | readonly | `Md3PageHost` | — |
| `effectiveSkeletonLayout` | `string` | `{…}` | readonly | `Md3PageHost` | — |
| `keepFlags` | `var` | `[]` | read/write | `Md3PageHost` | — |
| `lruOrder` | `var` | `[]` | read/write | `Md3PageHost` | — |
| `generation` | `int` | `0` | read/write | `Md3PageHost` | — |
| `navStack` | `var` | `[]` | read/write | `Md3PageHost` | — |
| `routeParams` | `var` | `{…}` | read/write | `Md3PageHost` | — |
| `sectionRootIndex` | `int` | `-1` | read/write | `Md3PageHost` | — |
| `browseHistory` | `var` | `[]` | read/write | `Md3PageHost` | Top-level rail / index switches (separate from pushRoute hierarchical stack). |
| `browseHistoryLimit` | `int` | `32` | read/write | `Md3PageHost` | — |
| `canGoBack` | `bool` | `navStack.length > 0 \|\| browseHistory.length > 0` | readonly | `Md3PageHost` | — |
| `navDepth` | `int` | `navStack.length + browseHistory.length` | readonly | `Md3PageHost` | — |
| `transitioning` | `bool` | `false` | read/write | `Md3PageHost` | — |
| `transitionFrom` | `int` | `-1` | read/write | `Md3PageHost` | — |
| `transitionTo` | `int` | `-1` | read/write | `Md3PageHost` | — |
| `transitionDir` | `int` | `1` | read/write | `Md3PageHost` | — |
| `transitionModeActive` | `string` | `pageTransition` | read/write | `Md3PageHost` | — |
| `transitionProgress` | `real` | `1` | read/write | `Md3PageHost` | — |
| `launchReturning` | `bool` | `false` | read/write | `Md3PageHost` | — |
| `launchStartRect` | `rect` | `Qt.rect(0, 0, 0, 0)` | read/write | `Md3PageHost` | — |
| `launchEndRect` | `rect` | `Qt.rect(0, 0, 0, 0)` | read/write | `Md3PageHost` | — |
| `launchStartRadius` | `real` | `16` | read/write | `Md3PageHost` | — |
| `launchEndRadius` | `real` | `Md3Theme.shape.large` | read/write | `Md3PageHost` | — |
| `launchCurveX` | `var` | `[0.0, 0.0, 0.2, 1.0]` | read/write | `Md3PageHost` | — |
| `launchCurveY` | `var` | `Md3Motion.emphasizedDecelerate` | read/write | `Md3PageHost` | — |
| `launchWeightX` | `real` | `0.5` | read/write | `Md3PageHost` | — |
| `launchWeightY` | `real` | `0.5` | read/write | `Md3PageHost` | — |
| `launchPivotX` | `real` | `0` | read/write | `Md3PageHost` | Tap origin in page-loader local coordinates (for scale pivot). |
| `launchPivotY` | `real` | `0` | read/write | `Md3PageHost` | — |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `resetNavStack()` | `Md3PageHost` | — |
| `resetBrowseHistory()` | `Md3PageHost` | — |
| `pushRoute(index, params, opts)` | `Md3PageHost` | — |
| `replaceRoute(index, params, opts)` | `Md3PageHost` | — |
| `goBack(opts)` | `Md3PageHost` | — |
| `entryAt(index)` | `Md3PageHost` | — |
| `reloadCurrent()` | `Md3PageHost` | Clear current page Loader and reopen (used by hot reload). |
| `resolveSource(src)` | `Md3PageHost` | — |
| `noteActivity()` | `Md3PageHost` | — |
| `prefetchHint(index)` | `Md3PageHost` | — |
| `clearPrefetchHint(index)` | `Md3PageHost` | — |
| `clearAllPrefetchHints()` | `Md3PageHost` | Drop pending hover / predict warm work (e.g. rail flick started). |
| `navigateTo(index, opts)` | `Md3PageHost` | — |

## Example

```qml
import Md3

Md3PageHost {
    edgeSwipeBackEnabled: true
    edgeSwipeDamping: 0.55
    edgeSwipeCommitPx: 48
    lightFadeOnCacheHit: true
    cacheHitFadeMs: 90
}
```
