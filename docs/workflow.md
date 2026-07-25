# Component workflow (mandatory)

For every control (and every non-trivial primitive):

1. **Research** — Fetch M3 overview/specs + Flutter widget/theme defaults.
2. **Document** — Write `docs/md3/<name>.md` using the template below.
3. **Map tokens** — Express colors/type/shape/elevation/motion as existing foundation tokens; extend foundation only when the spec requires a new token.
4. **Implement** — QML under `src/Md3/components/` (or `primitives/`).
5. **Gallery** — Add/update a page with a state matrix.
6. **Accept** — Check enabled/disabled/hover/focus/press/error + motion timings.

## Doc template

```markdown
# <Component>

## Sources
- M3: <url>
- Flutter: <url / source path>

## Variants
- ...

## Metrics
| Token | Value |
|-------|-------|
| height | … |
| padding | … |
| corner | … |
| icon | … |

## Color roles
| State | Container | Content | Outline |
|-------|-----------|---------|---------|
| enabled | … | … | … |
| disabled | … | … | … |
| … | … | … | … |

## Typography
- label: …

## Shape / elevation / tint
- …

## Motion
- duration: Md3Motion.shortN / mediumN
- easing: Md3Motion.standard / emphasized

## Accessibility
- min touch 48×48
- keyboard / focus ring
- contrast notes

## Gallery checklist
- [ ] variants
- [ ] state matrix
- [ ] dark theme
```

## Forbidden

- Magic hex colors inside components (except Gallery seed demos)
- Ad-hoc `duration: 200` / `Easing.InOutQuad` — use `Md3Motion`
- Shipping a control without its `docs/md3` page
