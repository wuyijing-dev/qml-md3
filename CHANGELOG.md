# Changelog

## Unreleased

_(empty — next work goes here)_

## 1.1.1

Patch lock for consumer apps: UX polish + Linux D-Bus fix on top of 1.1.0. **No intentional Public API breaks.**

### Highlights

- **Snackbar / Toast** — Undo-friendly dwell when `actionText` is set; swipe fade + snap-back; toast pause-on-hover and id dedupe refresh.
- **Forms / buttons** — `Md3Form.focusFirstError` on failed `submit`; `Md3Button.busy` spinner without width jump.
- **Shell** — `Md3ApplicationWindow.showShellInfoBar` / `dismissShellInfoBar`; density soft transition on page padding / table / list tile; Dialog / Menu / CommandPalette focus restore.
- **Gallery recipes** — Communication Undo + InfoBar + copy; Motion pageTransition playground; Patterns skeleton crossfade; DesktopPatterns delete/rename Undo; Containment scroll-to-top.
- **Polish** — collapsed NavigationRail tip; Fab tooltip; SearchBar focus chrome; TabBar hover + arrow keys; `Md3Notify.copy`; CodeBlock copy; EmptyState enter; Select error shake; Pickers DeferredSection height; BarChart/PieChart ASI `requestPaint` fix.
- **Linux** — portal D-Bus connect uses QObject slot (no lambda) so builds link cleanly.

### Notes

- Android / WASM remain **experimental**.
- Prefer tag **`v1.1.1`** (not floating `main`) when starting a product app.
- Host stacks (PySide clipboard/fonts, C ABI `md3_load_fonts`, docs matrix): see [host-lock-1.1.1.md](docs/api-manual/host-lock-1.1.1.md).

## 1.1.0

Performance-focused maintenance release for desktop Gallery / embedded shells. **Appearance-preserving** page lifecycle, chart/gauge unload, and smoother window drag.

### Highlights

- **Page activity lifecycle** — `Md3PageHost` injects `md3PageActive`; `Md3DeferredSection` + `Md3PageActivityGate` unload heavy subtrees while the page shell stays in L1.
- **Charts / gauges / progress** — Canvas/Shape trees follow Gate / `chartActive`; specialty charts (Area/Radar/Waterfall/Funnel/RadialBar/Heatmap) match `Md3Chart` flip tracking.
- **Window move** — `persistSession` debounces QSettings (~400 ms); `Md3AppSettings` reuses one settings handle (no registry storm while dragging).
- **System corners** — Win DWM + macOS `NSView` layer clip; skip full-window MultiEffect chrome mask when the OS already rounds the silhouette (`systemCornersSupported` / `usesSystemCorners`). Linux keeps client mask when rounded.
- Gallery Profile F defaults documented (restrained L1, L2 warm, `pagePrefetchL1: false`).

### Library

- `Md3NavigationView`, `Md3Flyout` (from post-1.0 workstream).
- Table/list/tree virtualization and idle poll cuts (DataTable / TreeView / Form / PageHost).
- SearchView / CommandPalette clear closed models; Skeleton / Stepper page gates.
- Dual licensing notes remain LGPL-3.0 **or** Commercial (see `docs/licensing.md`).

### Platform

- **Windows / macOS**: prefer system corner clip over chrome FBO for drag smoothness.
- **Linux (Wayland/X11)**: CSD + `startSystemMove`; client MultiEffect when `roundedCorners` and no system clip API.
- **Android / WASM**: remain **experimental**; see device smoke checklist in `docs/topics/android.md`. WASM unchanged (experimental).
- `Md3NativeShell` Electron-parity host (single instance, login item, hotkeys, protocols) across desktop OS.

### Docs

- `docs/topics/performance.md` wins through session debounce + system corners.
- Android device smoke checklist; native-platforms corner/backdrop honesty.
- Release checklist exercised for this tag.

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
