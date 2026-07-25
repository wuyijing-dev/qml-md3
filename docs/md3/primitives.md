# Primitives — Surface, Ripple, State overlay, Focus, Icon, Shadow, Control

## Sources
- M3 state layers: https://m3.material.io/foundations/interaction/states/state-layers
- M3 elevation / surface tint: https://m3.material.io/styles/elevation/overview
- Flutter ink: `InkRipple` / Material 3 ink sparkle behavior (we approximate with circular expand + fade)
- Flutter focus: secondary focus indicator

## Md3Surface
- Base fill color + optional elevation tint (`surfaceTint` × elevation opacity)
- Clipped to shape radius
- Hosts child content

## Md3Ripple
- Origin at pointer
- Expand duration `medium2`, easing `standardDecelerate`
- Fade out `short4`, easing `standard`
- Color = content/on* role at low opacity

## Md3StateOverlay
- Opacities from `Md3Theme.stateLayer` (hover 0.08, focus/press 0.12, drag 0.16)
- Color = content role

## Md3FocusRing
- 2 dp outline using `secondary` (M3 secondary focus indicator)
- Visible only when keyboard-focused

## Md3Shadow
- Dual soft shadows via `QtQuick.Effects.MultiEffect` blur
- **Ambient**: wide, low opacity — lifts surface from page
- **Key**: tighter, slightly darker, stronger Y — directional contact
- Tokens from `Md3Elevation` (`ambient*` / `key*`); color = `colorScheme.shadow`
- Elevation changes animate with `short4` + `standard`

## Md3Icon
- Size + color role binding
- Local **Material Icons Outlined** / **Material Icons** ligature glyphs (`resources/fonts/`)
- `icon` accepts Material icon names (`settings`, `arrow_back`, …); a few aliases (`calendar` → `calendar_today`)
- `variant`: `"outlined"` (default) | `"filled"`

## Md3Control
- Shared interaction shell: hover/press/focus, ripple, overlay, focus ring, Accessible hooks
