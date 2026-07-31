# Changelog

## 1.0.0 (pre-production)

> Not a fully signed-off production tag yet. Track remaining P0 items in
> [docs/professional-todo.md](docs/professional-todo.md). Use
> [docs/release-checklist.md](docs/release-checklist.md) before advertising a stable release.

Desktop-focused Md3 QML component library (MIT).

### Engineering

- Added root `LICENSE` (MIT) and `NOTICE` (fonts / icons / Qt).
- Added `examples/hello-md3` consumer sample (`find_package` or in-tree).
- Added GitHub Actions `build` workflow (library + examples + optional smoke).
- Document sync to QML_MD3_Document is **manual** (`workflow_dispatch` / `--push`).
- Guides: quickstart, API stability / SemVer, release checklist.

### Library highlights

- Desktop surfaces: `Md3ApplicationWindow`, status bar, richer window integration.
- `Md3DataTable`: frozen columns, filter, keyboard nav, in-cell edit.
- Collections: `Md3ListView` / `Md3GridView` / `Md3ItemsView`, Flip carousel, Pips, Swipe, pull-to-refresh.
- Command surface: Toggle / DropDown / Hyperlink / CommandBar.
- Desktop helpers: `Md3KeySequenceField`, `Md3FileDropZone`, `Md3VirtualList`, `Md3ReleaseUpdater`.
