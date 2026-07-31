# Changelog

## Unreleased

### Library

- **`Md3NavigationView`**: Auto / Left / LeftCompact / Top adaptive shell (Rail + Drawer + Bar); Gallery Navigation page demo.

### Platform

- **WebAssembly**: detect Emscripten before UNIX desktop path; mobile native stubs; no DBus/Widgets; hello-md3 builds with Qt 6.10.2 wasm_singlethread. See `docs/topics/wasm.md`.

### Licensing

- Switched to **Qt-style dual licensing**: LGPL-3.0 **or** Commercial (support / vendor certification). See `LICENSE`, `LICENSES/`, `docs/licensing.md`.
- Historical MIT-tagged artifacts keep the license shipped with that tag.

### Docs

- Reorganized `docs/` into `getting-started/`, `guides/`, `topics/`, `project/` (scan JSON moved to `scripts/checks/out/`).
- Moved API doc tools from `scripts/docs/` → `tools/` (`gen_api_docs.py`, `sync_document_repo.py`).

## 1.0.0

First production-ready tag for the desktop-focused Md3 QML component library (MIT at tag time).

### Engineering

- Root `LICENSE` (MIT at the time) and `NOTICE` (fonts / icons / Qt).
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
