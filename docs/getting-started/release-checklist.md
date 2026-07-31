# Release checklist

Use before tagging a version consumers will `find_package`.

## Pre-flight

- [ ] `CHANGELOG.md` has a section for this version (features / fixes / breaking)
- [ ] Version in root `CMakeLists.txt` `project(QML_MD3 VERSION …)` matches tag
- [ ] [api-stability.md](api-stability.md): no unannounced Public API breaks
- [ ] Experimental APIs still pointed at [experimental.md](../topics/experimental.md)
- [ ] `LICENSE` + `NOTICE` present and font/icon notes still accurate

## Build & package

- [ ] Configure library: `-DMD3_BUILD_GALLERY=OFF` (and optional shared)
- [ ] `cmake --build` succeeds on the **supported** kit (Qt 6.8+ recommended)
- [ ] Package: `python scripts/packaging/cli.py` → `dist/Md3/`
- [ ] Copy `dist/Md3` into `examples/hello-md3/Md3` **or** point `CMAKE_PREFIX_PATH` and run hello
- [ ] Gallery smoke (optional but recommended): open Buttons / Extras / Dialogs pages

## Docs

- [ ] Guide pages updated if behavior changed (`integration`, `quickstart`, `packaging`)
- [ ] If API surface changed: run `python tools/gen_api_docs.py` **and** intentionally commit `docs/api/`
- [ ] Document site sync is **manual** (`workflow_dispatch` or local `--push`) — not on every API regen

## Tag & announce

- [ ] `git tag vX.Y.Z` and push tag
- [ ] GitHub Release notes from CHANGELOG
- [ ] README “Support scope” still matches what you tested

## Do not

- Auto-push Document repo from gen-api churn
- Tag a major as “stable” without walking this checklist and updating CHANGELOG
