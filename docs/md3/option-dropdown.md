# Option / Dropdown menu

## Sources
- M3 menus: https://m3.material.io/components/menus/specs
- Flutter `DropdownMenu` / `MenuAnchor`

## Md3Option / Md3DropdownMenu
- Outlined field chrome, floating label, rotating expand icon
- Menu: scale + opacity + Y settle with `uiSpatial` / `uiEnter`
- Items: selected = secondaryContainer + check icon pop
- Modal scrim dismiss

## Motion
- Open/close: `menuDuration` + spatial / enter-exit curves
- Chevron: `medium2` + `uiSpatial`
