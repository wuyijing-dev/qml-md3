# Architecture

## Modules

```
appQML_MD3 (Gallery)  --links-->  Md3 (STATIC QML module)
                                      |
                                      +-- foundation/  tokens & theme singleton
                                      +-- primitives/  surface, ripple, focus, icon
                                      +-- components/  public MD3 controls
                                      +-- private/     internal helpers
```

- **URI `Md3`**: importable library for product apps
- **URI `Gallery`**: demo shell only; not for reuse

## Theming

`Md3Theme` (singleton) owns:

- `dark` / brightness
- `seed` color (baseline palette until full HCT `fromSeed`)
- `colorScheme`, `typography`, `shape`, `elevation`, `stateLayer`
- Motion lives in `Md3Motion` singleton (stable token table)

Controls read tokens only through `Md3Theme` / `Md3Motion`.

## Control contract

Every interactive control derives interaction semantics from `Md3Control`:

- `enabled`, pointer hover/press, keyboard focus
- State overlays via `Md3StateOverlay` + opacity tokens
- Ripple via `Md3Ripple` where MD3 specifies ink
- Accessible name / role properties for a11y

## Fidelity sources

1. [m3.material.io](https://m3.material.io) component specs
2. Flutter `packages/flutter/lib/src/material/*`
3. Local excerpts under `docs/md3/`

When Flutter and m3.material.io diverge, prefer the published M3 token and record the difference in the component doc.
