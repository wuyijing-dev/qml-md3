# Md3PageHost

- **Source:** `src/Md3/window/Md3PageHost.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `model` | `var` | `[]` | read/write | `Md3PageHost` | — |
| `currentIndex` | `int` | `0` | read/write | `Md3PageHost` | — |
| `displayedIndex` | `int` | `0` | read/write | `Md3PageHost` | — |
| `cacheMode` | `string` | `"lru"` | read/write | `Md3PageHost` | — |
| `cacheLimit` | `int` | `4` | read/write | `Md3PageHost` | — |
| `idleTrimMs` | `int` | `45000` | read/write | `Md3PageHost` | Adaptive / arc: milliseconds without navigation before trimming to one page |
| `adaptiveCacheMin` | `int` | `1` | read/write | `Md3PageHost` | Adaptive / arc: minimum / starting resident pages while idle |
| `_liveCacheLimit` | `int` | `1` | read/write | `Md3PageHost` | — |
| `_adaptivePrefetch` | `bool` | `false` | read/write | `Md3PageHost` | — |
| `contentPadding` | `real` | `20` | read/write | `Md3PageHost` | — |
| `asynchronous` | `bool` | `true` | read/write | `Md3PageHost` | — |
| `prefetchNeighbors` | `bool` | `false` | read/write | `Md3PageHost` | — |
| `l2Components` | `bool` | `true` | read/write | `Md3PageHost` | Keep compiled Components after L1 eviction (re-instantiate without re-parse) |
| `l2CacheLimit` | `int` | `16` | read/write | `Md3PageHost` | Max L2 Component entries (metadata + bytecode; cheaper than Item trees) |
| `l2WarmIdle` | `bool` | `true` | read/write | `Md3PageHost` | Idle: compile all destination Components (no Item) after startup |
| `predictPrefetch` | `bool` | `true` | read/write | `Md3PageHost` | Markov + hover: L2 always; L1 only if prefetchNeighbors |
| `leaveSnapshot` | `bool` | `true` | read/write | `Md3PageHost` | Freeze leaving page texture while cold target loads (cheap perceived speed) |
| `warmStart` | `bool` | `false` | read/write | `Md3PageHost` | — |
| `showBusyIndicator` | `bool` | `false` | read/write | `Md3PageHost` | — |
| `showSkeleton` | `bool` | `true` | read/write | `Md3PageHost` | — |
| `skeletonLayout` | `string` | `"page"` | read/write | `Md3PageHost` | — |
| `pageTransition` | `string` | `"fade"` | read/write | `Md3PageHost` | "none" \| "fade" \| "slide" \| "slideUp" \| "fadeThrough" \| "scale" \| "launch" |
| `pageTransitionDuration` | `int` | `Md3Motion.spatialDuration` | read/write | `Md3PageHost` | — |
| `launchTransitionDuration` | `int` | `Md3Motion.long2` | read/write | `Md3PageHost` | Duration for tap-origin launch transition. |
| `launchIntensity` | `int` | `Md3PageHost.Normal` | read/write | `Md3PageHost` | Launch strength preset: `Subtle`, `Normal`, `Premium`. |
| `launchAxisProportional` | `bool` | `true` | read/write | `Md3PageHost` | When true, X position follows Android's dedicated launch X path while Y/width/height use emphasized easing. |
| `launchRememberLastSource` | `bool` | `true` | read/write | `Md3PageHost` | Remember last source bounds for return animation fallback. |
| `sourceBase` | `url` | `""` | read/write | `Md3PageHost` | — |
| `currentItem` | `var` | `{…}` | readonly | `Md3PageHost` | — |
| `loading` | `bool` | `{…}` | readonly | `Md3PageHost` | — |
| `awaitingTarget` | `bool` | `{…}` | readonly | `Md3PageHost` | True while the destination page is loading and not yet Ready. |
| `keepFlags` | `var` | `[]` | read/write | `Md3PageHost` | — |
| `lruOrder` | `var` | `[]` | read/write | `Md3PageHost` | — |
| `generation` | `int` | `0` | read/write | `Md3PageHost` | — |
| `_arcT1` | `var` | `[]` | read/write | `Md3PageHost` | — |
| `_arcT2` | `var` | `[]` | read/write | `Md3PageHost` | — |
| `_arcB1` | `var` | `[]` | read/write | `Md3PageHost` | — |
| `_arcB2` | `var` | `[]` | read/write | `Md3PageHost` | — |
| `_arcP` | `real` | `0` | read/write | `Md3PageHost` | — |
| `_l2Map` | `var` | `({})` | read/write | `Md3PageHost` | — |
| `_l2Order` | `var` | `[]` | read/write | `Md3PageHost` | — |
| `_markov` | `var` | `({})` | read/write | `Md3PageHost` | — |
| `_navPrev` | `int` | `-1` | read/write | `Md3PageHost` | — |
| `_hoverHint` | `int` | `-1` | read/write | `Md3PageHost` | — |
| `transitioning` | `bool` | `false` | read/write | `Md3PageHost` | — |
| `transitionFrom` | `int` | `-1` | read/write | `Md3PageHost` | — |
| `transitionTo` | `int` | `-1` | read/write | `Md3PageHost` | — |
| `transitionDir` | `int` | `1` | read/write | `Md3PageHost` | — |
| `transitionProgress` | `real` | `1` | read/write | `Md3PageHost` | — |
| `_pendingShowIndex` | `int` | `-1` | read/write | `Md3PageHost` | Defer enter transition after Loader.Ready so first layout doesn't hitch the anim. |
| `_pendingShowPasses` | `int` | `0` | read/write | `Md3PageHost` | — |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `entryAt(index)` | `Md3PageHost` | — |
| `resolveSource(src)` | `Md3PageHost` | — |
| `noteActivity()` | `Md3PageHost` | — |
| `prefetchHint(index)` | `Md3PageHost` | — |
| `clearPrefetchHint(index)` | `Md3PageHost` | — |
| `navigateTo(index, opts)` | `Md3PageHost` | Route-level page navigation. `opts` supports `transitionMode`, `sourcePoint` (preferred), `sourceRect`, `sourceRadius`, `returnToSource`, `rememberSource`. `transitionMode: "launch"` grows the destination from the tap point (scale pivot) and blurs the leaving page snapshot at animation start. `returnToSource: true` uses a normal transition (`slide` when `pageTransition` is `launch`). |

## Example

```qml
import Md3

Md3PageHost {
    model: []
    currentIndex: 0
    displayedIndex: 0
    cacheMode: "lru"
    cacheLimit: 4
}
```
