# Md3Theme

- **Source:** `src/Md3/foundation/Md3Theme.qml`
- **Extends:** `QtObject`
- **Singleton:** `true` (`pragma Singleton`)

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `dark` | `bool` | `false` | read/write | `Md3Theme` | — |
| `seed` | `color` | `"#6750A4"` | read/write | `Md3Theme` | — |
| `textScale` | `real` | `1.0` | read/write | `Md3Theme` | — |
| `highContrast` | `bool` | `false` | read/write | `Md3Theme` | — |
| `reduceMotion` | `bool` | `false` | read/write | `Md3Theme` | Prefer near-instant motion for vestibular / a11y preferences. |
| `progressiveContent` | `bool` | `true` | read/write | `Md3Theme` | Within-page progressive load (Md3DeferredSection). Default on; set false to load everything immediately. |
| `density` | `int` | `0` | read/write | `Md3Theme` | Desktop UI density: `0` Comfortable (默认) / `1` Compact（工具/数据密集）。 Aligns with `Md3DataTable.Density`; drives spacing* / pagePadding / controlHeight hints. |
| `densityCompact` | `bool` | `density >= 1` | readonly | `Md3Theme` | — |
| `spacingXs` | `real` | `4` | readonly | `Md3Theme` | 4 / 4 dp |
| `spacingSm` | `real` | `densityCompact ? 6 : 8` | readonly | `Md3Theme` | 8 → 6 |
| `spacingMd` | `real` | `densityCompact ? 8 : 12` | readonly | `Md3Theme` | 12 → 8（表单、区块内） |
| `spacingLg` | `real` | `densityCompact ? 12 : 16` | readonly | `Md3Theme` | 16 → 12 |
| `spacingXl` | `real` | `densityCompact ? 16 : 24` | readonly | `Md3Theme` | 24 → 16（区块之间） |
| `pagePadding` | `real` | `densityCompact ? 12 : 20` | readonly | `Md3Theme` | Window / page content inset hint（`Md3ApplicationWindow.pagePadding` 可绑此值） |
| `controlHeight` | `real` | `densityCompact ? 36 : 40` | readonly | `Md3Theme` | Default control row height hint（按钮/字段外壳；控件可自有高度） |
| `tableRowHeight` | `real` | `densityCompact ? 40 : 52` | readonly | `Md3Theme` | Data table row height hint（与 Md3DataTable Comfortable/Compact 对齐） |
| `effectsLevel` | `int` | `1` | read/write | `Md3Theme` | Global visual-effects budget for device adaptation. 0 = Low (流畅), 1 = Balanced (均衡), 2 = High (画质). |
| `effectsIntensity` | `real` | `1.0` | read/write | `Md3Theme` | Extra intensity on interaction ink / state layers (0.35–1.35). Multiplies tier defaults. |
| `effectsLow` | `bool` | `effectsLevel <= 0` | readonly | `Md3Theme` | — |
| `effectsHigh` | `bool` | `effectsLevel >= 2` | readonly | `Md3Theme` | — |
| `effectsChartSmooth` | `bool` | `effectsLevel >= 2 && !reduceMotion` | readonly | `Md3Theme` | Chart Catmull smoothing (expensive on pan settle). |
| `effectsChartInertia` | `bool` | `effectsLevel >= 1 && !reduceMotion` | readonly | `Md3Theme` | Chart pan inertia after drag release. |
| `effectsLiveMotion` | `bool` | `!reduceMotion` | readonly | `Md3Theme` | Live chart / wave continuous animation (all tiers; FPS capped on lower tiers). |
| `effectsLiveFps` | `int` | `effectsLevel >= 2 ? 0 : (effectsLevel >= 1 ? 24 : 15)` | readonly | `Md3Theme` | 0 = display refresh; >0 caps live charts / wave. |
| `effectsShadows` | `bool` | `effectsLevel >= 1` | readonly | `Md3Theme` | Soft dual-blur elevation shadows (MultiEffect FBOs). |
| `effectsMaxElevation` | `real` | `effectsLevel >= 2 ? 12 : (effectsLevel >= 1 ? 3 : 0)` | readonly | `Md3Theme` | Max elevation applied when shadows are on (High keeps full). |
| `effectsGlassQuality` | `int` | `Math.max(0, Math.min(2, effectsLevel))` | readonly | `Md3Theme` | Liquid-glass quality hint: 0 low / 1 mid / 2 high. |
| `effectsPageMotion` | `bool` | `!reduceMotion` | readonly | `Md3Theme` | Prefer page / overlay transitions (identical across effects tiers; only reduceMotion kills them). |
| `effectsRipple` | `bool` | `effectsLevel >= 1 && !reduceMotion` | readonly | `Md3Theme` | Ripple expand ink — 均衡/画质. 流畅 uses rounded press-flash instead (no mask FBO). |
| `effectsRippleMasked` | `bool` | `effectsRipple` | readonly | `Md3Theme` | Rounded MultiEffect mask for expand ink (only when effectsRipple). |
| `effectsRipplePeak` | `real` | `{…}` | readonly | `Md3Theme` | Peak / hold opacity for ripple / press-flash. |
| `effectsRippleHold` | `real` | `effectsRipplePeak * 0.5` | readonly | `Md3Theme` | — |
| `effectsRippleSpread` | `real` | `effectsLevel >= 2 ? 2.2 : 2.0` | readonly | `Md3Theme` | Expand factor for ink diameter. |
| `effectsStateIntensity` | `real` | `{…}` | readonly | `Md3Theme` | Hover / press state-layer strength. |
| `colorScheme` | `Md3ColorScheme` | `{…}` | read/write | `Md3Theme` | — |
| `dynamicScheme` | `Md3DynamicScheme` | `{…}` | read/write | `Md3Theme` | — |
| `typography` | `Md3Typography` | `{…}` | read/write | `Md3Theme` | — |
| `shape` | `Md3Shape` | `{…}` | read/write | `Md3Theme` | — |
| `elevation` | `Md3Elevation` | `{…}` | read/write | `Md3Theme` | — |
| `stateLayer` | `Md3StateLayer` | `{…}` | read/write | `Md3Theme` | — |
| `accessibleOutline` | `color` | `highContrast` | readonly | `Md3Theme` | Outline role — stronger in high-contrast mode. |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `setEffectsLevel(level)` | `Md3Theme` | — |
| `setEffectsIntensity(v)` | `Md3Theme` | — |
| `setDensity(level)` | `Md3Theme` | — |
| `densityLabel()` | `Md3Theme` | — |
| `effectsLevelLabel()` | `Md3Theme` | — |
| `applySeed(c)` | `Md3Theme` | Rebuild the full MD3 role set from seed + dark (Material You–style). |
| `toggleDark()` | `Md3Theme` | — |
| `scaled(px)` | `Md3Theme` | — |

## Example

```qml
import Md3

// Singleton — use as `Md3Theme.…`
console.log(Md3Theme)
```
