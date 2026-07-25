# Toggle icon button / Split button / Button groups

## Sources
- M3 icon buttons: https://m3.material.io/components/icon-buttons/overview
- M3 buttons / button groups (connected vs standard)
- Flutter: `IconButton.toggleable`, segmented/connected patterns

## Variants

### Md3ToggleIconButton
- Standard / Filled / FilledTonal / Outlined
- `checked` toggles on click (`checkable: true`)
- Selected container uses `secondaryContainer` (standard/outlined) or stronger filled roles

### Md3SplitButton
- Leading action segment (label + optional icon) + trailing menu chevron
- Connected shape (shared corners); primary uses Filled / Tonal / Outlined
- Trailing opens `Md3Menu` with `menuModel` items

### Md3ButtonGroup
- **Standard**: separate buttons with 8 dp gap
- **Connected**: shared outline / joined corners (first/last pill ends)
- `model: [{ text, icon?, enabled? }]` emits `clicked(index)`

## Metrics
| Token | Value |
|-------|-------|
| toggle icon target | 48 |
| toggle container | 40 |
| split height | 40 |
| group button height | 40 |
| standard gap | 8 |
| connected outer radius | 20 (full) |

## Color roles
| Control | Unselected / idle | Selected / active |
|---------|-------------------|-------------------|
| Toggle standard | transparent / onSurfaceVariant | secondaryContainer / onSecondaryContainer |
| Split filled | primary / onPrimary | — |
| Connected segment selected | secondaryContainer | onSecondaryContainer |

## Motion
- Color / container: `short4` + `standard`
- Menu open: existing `Md3Menu` motion
- Connected selection fill: `short4` color + width where applicable

## States
- enabled / disabled / hover / press / focus / checked (toggle)

## A11y
- Toggle: `Accessible.checkable` + `Accessible.checked`
- Split: main = Button; menu = Button “More”
- Group items: Button

## Gallery checklist
- [ ] Toggle all variants checked/unchecked
- [ ] Split open/dismiss menu
- [ ] Standard vs Connected groups
