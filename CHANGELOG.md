# Changelog

## 1.0.0

First production-ready tag for the desktop-focused Md3 QML component library (MIT).

### Engineering

- Root `LICENSE` (MIT) and `NOTICE` (fonts / icons / Qt).
- Consumer sample `examples/hello-md3` (`find_package` or in-tree); shared packages no longer require `Q_IMPORT_QML_PLUGIN`.
- GitHub Actions `build` workflow (library + examples + optional smoke).
- Document sync to QML_MD3_Document is **manual** (`workflow_dispatch` / `--push`).
- Guides: quickstart, API stability / SemVer, release checklist, a11y spot-check.
- Packaging: Windows `vcvars` Path merge fixed for VS 2022+ / VS 2026.

### Library highlights

- Desktop surfaces: `Md3ApplicationWindow`, status bar, richer window integration.
- `Md3DataTable`: frozen columns, filter, keyboard nav, in-cell edit.
- Collections: `Md3ListView` / `Md3GridView` / `Md3ItemsView`, Flip carousel, Pips, Swipe, pull-to-refresh.
- Command surface: Toggle / DropDown / Hyperlink / CommandBar.
- Desktop helpers: `Md3KeySequenceField`, `Md3FileDropZone`, `Md3VirtualList`, `Md3ReleaseUpdater`.
