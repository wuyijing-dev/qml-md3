# Menus, search, pickers

## Menu / MenuBar / DropdownMenu
- Sources: https://m3.material.io/components/menus/specs ; Flutter MenuAnchor / DropdownMenu
- Container: surfaceContainer, elevation 2, corner **large (16)** (soft MD3 panel)
- Item height 48; highlight inset 8 with **large** radius pill; hover via state layer
- Leading icon + label; optional trailing chevron (`submenu` / `hasSubMenu`) / check
- **Cascading submenus**: `Md3MenuItem { submenu: Md3Menu { ... } }` — hover or click opens to the side; `dismissCascade()` closes the chain
- Menu bar model nests with `items` (prefer over `children`, which clashes with `Item.children`)
- Selected: secondaryContainer fill + leading or trailing check (`leadingCheck`)
- Divider: outlineVariant, 16 horizontal inset
- Motion: enter short4 emphasizedDecelerate; item color short4 standard
- Ripple clipped to item highlight radius

## SearchBar / SearchView
- Sources: https://m3.material.io/components/search/specs
- SearchBar height 56, corner full, container surfaceContainerHigh
- SearchView expands to surfaceContainer with list

## DatePicker / TimePicker
- Sources: M3 date/time pickers; Flutter showDatePicker / showTimePicker
- Date: header + day grid; selected day primary circle 40
- Time: dial 256 or input fields; clock hand primary
