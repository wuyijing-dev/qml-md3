# API stability & SemVer

How we treat the Md3 public surface so apps can upgrade safely.

## Public vs private

| Surface | SemVer promise | Examples |
|---------|----------------|----------|
| **Public** | Yes | `import Md3` types under `components/`, `layout/`, `window/`, `foundation/` singletons documented in `docs/api/` |
| **Private / internal** | No | `src/Md3/private/`, platform helpers, `*Playground*`, undocumented internals |
| **Experimental** | No (may break anytime) | Types / APIs listed in [experimental.md](../topics/experimental.md) (e.g. liquid glass playground) |

Hand-written usage notes live in [`api-manual/`](../api-manual/README.md) and survive `gen_api_docs.py`.
Generated property tables in `docs/api/` are regenerated from QML; do not treat wording churn there as an API break.

## What counts as breaking (MAJOR)

- Removing a public type, property, signal, method, or enum value
- Changing enum **numeric** values that apps may persist
- Changing default interaction so existing call sites misbehave (e.g. click no longer opens menu)
- Renaming a public QML type without a same-major compatibility alias

## What is NOT breaking (MINOR / PATCH)

- Adding properties / signals / enum values
- Performance improvements, bug fixes, a11y fixes
- Documentation-only changes
- Changes under Experimental / Private
- Visual polish that preserves API and interaction contract

## Deprecation

1. Mark in QML with `/// @deprecated …` (and Gallery note if user-visible)
2. Keep behavior at least one **minor** release
3. Remove only in the next **major**
4. Document in CHANGELOG under “Deprecated” then “Removed”

## Versioning today

- CMake `project(QML_MD3 VERSION 1.1.4)` is the package version (tag `v1.1.4`).
- From **1.0.0** onward, Public API changes follow SemVer in this document (see CHANGELOG).
- Pin product apps to an annotated tag (`v1.1.4`), not floating `main` — see [integration.md](integration.md#lock-a-version-for-your-product-recommended).
- Do not treat an untagged `main` tip as a SemVer guarantee until [release-checklist.md](release-checklist.md) is satisfied for a tagged release.
