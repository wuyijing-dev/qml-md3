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
| `fade` | Cross-fade — **default** |
| `slide` | Horizontal shared-axis (clipped to page pane, not over rail) |
| `slideUp` | Subtle vertical enter |
| `fadeThrough` | MD fade-through (exit then enter + scale) |
| `scale` | Soft scale + fade |

`pageTransitionDuration` defaults to `Md3Motion.spatialDuration`.

## Skeleton
| Type | Role |
|------|------|
| `Md3Skeleton` | Single bone (`Text` / `Circular` / `Rounded` / `Rectangular`) + shimmer |
| `Md3SkeletonPane` | Page / list / cards placeholder layout |
| `pageSkeleton` | When true, PageHost shows pane while destination loads |

Cold navigation keeps the previous page visible and stacks a skeleton layer on top as the incoming-page placeholder; when Ready, the skeleton fades out and the normal leave→enter transition runs.

## Page cache (`Md3PageHost`)
- **L1**: resident page `Item`s (default limit **2**, idle trim → 1)
- **L2**: compiled `Component`s + optional idle warm of all destinations
- **Leave snapshot**: `ShaderEffectSource` while cold target loads
- **`arc`**: ARC + cost-aware victims; predict/hover are L2-only unless `pagePrefetch`
- Per destination: optional `cacheCost`, `cachePin`

