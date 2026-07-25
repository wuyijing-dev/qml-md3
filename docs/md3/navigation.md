# Navigation components

## Sources
- https://m3.material.io/components/top-app-bar/specs
- https://m3.material.io/components/bottom-app-bar/specs
- https://m3.material.io/components/navigation-bar/specs
- https://m3.material.io/components/navigation-rail/specs
- https://m3.material.io/components/navigation-drawer/specs
- https://m3.material.io/components/tabs/specs
- Flutter: AppBar, NavigationBar, NavigationRail, NavigationDrawer, TabBar

## Top app bar
| Type | Height |
|------|--------|
| small / center | 64 |
| medium | 112 |
| large | 152 |
Container: surface; headline titleLarge/medium/large

## Bottom app bar
Height 80; surfaceContainer; optional FAB cradle

## Navigation bar
Height 80; indicator pill secondaryContainer; icon 24; label labelMedium

## Navigation rail
Width 80 collapsed / 256 expanded; destinations with pill

## Navigation drawer
Width 360; modal scrim; destination pill

## Page host transitions
`Md3PageHost` / `Md3ApplicationWindow`:

| `pageTransition` | Behavior |
|------------------|----------|
| `none` | Instant swap |
| `fade` | Cross-fade |
| `slide` | Horizontal shared-axis (direction follows index) |
| `slideUp` | Subtle vertical enter |
| `fadeThrough` | MD fade-through (exit then enter + scale) — default |
| `scale` | Soft scale + fade |

`pageTransitionDuration` defaults to `Md3Motion.spatialDuration`.

## Skeleton
| Type | Role |
|------|------|
| `Md3Skeleton` | Single bone (`Text` / `Circular` / `Rounded` / `Rectangular`) + shimmer |
| `Md3SkeletonPane` | Page / list / cards placeholder layout |
| `pageSkeleton` | When true, PageHost shows pane while destination loads |

Cold navigation clears the previous page (`displayedIndex = -1`) before showing the skeleton, then plays an enter transition when Ready.

