# Md3Adaptive

Material 3–aligned window size classes + desktop/mobile chrome policy. Breakpoints match common MD3 / Material WindowSizeClass widths (dp ≈ logical px).

- **Source:** `src/Md3/foundation/Md3Adaptive.qml`
- **Extends:** `QtObject`
- **Singleton:** `true` (`pragma Singleton`)

## Import

```qml
import Md3
```

## Enums

### `Md3Adaptive.WidthClass`

`Md3Adaptive.Compact`, `Md3Adaptive.Medium`, `Md3Adaptive.Expanded`, `Md3Adaptive.Large`, `Md3Adaptive.ExtraLarge`

### `Md3Adaptive.HeightClass`

`Md3Adaptive.Compact`, `Md3Adaptive.Medium`, `Md3Adaptive.Expanded`

### `Md3Adaptive.DeviceClass`

`Md3Adaptive.Phone`, `Md3Adaptive.Tablet`, `Md3Adaptive.Desktop`, `Md3Adaptive.Tv`

### `Md3Adaptive.WindowAppearance`

`Md3Adaptive.WASM`, `Md3Adaptive.or forced)
        System`, `Md3Adaptive.snap`, `Md3Adaptive.etc. when capable)
        DesktopChrome`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `compactMax` | `real` | `599` | readonly | `Md3Adaptive` | — |
| `mediumMax` | `real` | `839` | readonly | `Md3Adaptive` | — |
| `expandedMax` | `real` | `1199` | readonly | `Md3Adaptive` | — |
| `largeMax` | `real` | `1599` | readonly | `Md3Adaptive` | — |
| `heightCompactMax` | `real` | `479` | readonly | `Md3Adaptive` | — |
| `heightMediumMax` | `real` | `899` | readonly | `Md3Adaptive` | — |
| `navigationCompactBreakpoint` | `real` | `600` | readonly | `Md3Adaptive` | Same thresholds as Md3NavigationView Auto mode. |
| `navigationExpandedBreakpoint` | `real` | `840` | readonly | `Md3Adaptive` | — |
| `safeAreaWindow` | `var` | `null` | read/write | `Md3Adaptive` | Optional Window used to read Qt 6.9+ `safeAreaMargins` (falls back when unset). |
| `safeBottomInset` | `real` | `{…}` | readonly | `Md3Adaptive` | Home-indicator / gesture-bar padding. On Qt 6.9+ uses Window.safeAreaMargins when `safeAreaWindow` is set; otherwise platform fallback (6.5 baseline). |
| `safeTopInset` | `real` | `{…}` | readonly | `Md3Adaptive` | — |
| `safeLeftInset` | `real` | `{…}` | readonly | `Md3Adaptive` | — |
| `safeRightInset` | `real` | `{…}` | readonly | `Md3Adaptive` | — |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `widthClassFor(w)` | `Md3Adaptive` | — |
| `heightClassFor(h)` | `Md3Adaptive` | — |
| `widthClassName(wc)` | `Md3Adaptive` | — |
| `deviceClassFor(w, h)` | `Md3Adaptive` | — |
| `deviceClassName(dc)` | `Md3Adaptive` | — |
| `windowAppearanceFor(w, h)` | `Md3Adaptive` | Recommended window chrome appearance for this size + platform. |
| `windowAppearanceName(a)` | `Md3Adaptive` | — |
| `useCustomChrome(w, h)` | `Md3Adaptive` | Whether frameless / CSD should be active. |
| `preferCompactTitleBar(w, h)` | `Md3Adaptive` | — |
| `preferCaptionButtons(w, h)` | `Md3Adaptive` | — |
| `preferNavigationBar(w, h)` | `Md3Adaptive` | Navigation density hint for shells (rail vs bar). |
| `preferNavigationRail(w, h)` | `Md3Adaptive` | — |
| `safeInsetsFor(win)` | `Md3Adaptive` | Resolve insets from a Window (Qt 6.9+ `safeAreaMargins`) with platform fallback. |

## Example

```qml
import Md3

// Singleton — use as `Md3Adaptive.…`
console.log(Md3Adaptive)
```

# Md3Adaptive

Singleton for Material 3–aligned window size classes and desktop/mobile chrome policy.

See [Window appearance](../guides/window-appearance.md).

## Breakpoints

| Constant | Default | Meaning |
|----------|---------|---------|
| `compactMax` | 599 | Max width for Compact |
| `mediumMax` | 839 | Max width for Medium |
| `expandedMax` | 1199 | Max width for Expanded |
| `largeMax` | 1599 | Max width for Large |
| `navigationCompactBreakpoint` | 600 | NavigationView Top below this |
| `navigationExpandedBreakpoint` | 840 | NavigationView LeftCompact below this |

## Key functions

| Function | Returns |
|----------|---------|
| `widthClassFor(w)` / `heightClassFor(h)` | Size class enum |
| `deviceClassFor(w, h)` | Phone / Tablet / Desktop / Tv |
| `windowAppearanceFor(w, h)` | System / CompactChrome / DesktopChrome |
| `useCustomChrome(w, h)` | Whether CSD should be on |
| `preferCompactTitleBar(w, h)` | Dense title bar |
| `preferCaptionButtons(w, h)` | Show min/max/close in CSD |
| `preferNavigationBar(w, h)` / `preferNavigationRail(w, h)` | Shell nav density |

`Md3ApplicationWindow` mirrors these as readonly properties when `adaptiveChrome` is true.

## Safe area (Qt 6.9+)

| API | Notes |
|-----|--------|
| `safeAreaWindow` | Optional Window; `Md3ApplicationWindow` sets this on completed |
| `safeBottomInset` / `safeTopInset` / `safeLeftInset` / `safeRightInset` | From `Window.safeAreaMargins` when Qt ≥ 6.9 and window bound; else platform fallback |
| `safeInsetsFor(win)` | Resolve insets for an arbitrary Window |
