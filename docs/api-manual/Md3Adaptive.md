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
