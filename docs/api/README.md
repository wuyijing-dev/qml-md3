# Md3 API Reference

每个控件一份完整 API：**属性（含继承）/ 枚举 / 信号 / 方法**。

由 `scripts/docs/gen_api_docs.py` 从 QML 源码生成；改完控件后请重跑该脚本。

集成与 C++ 启动：[../integration.md](../integration.md) · 主题令牌：[../tokens.md](../tokens.md) · 按钮与命令：[../buttons-commands.md](../buttons-commands.md)

手写附录（WinUI 对照等）放在 [`docs/api-manual/`](../api-manual/)；重新生成时会自动拼接到对应 API 页末尾。

## C++ / native

- [Md3::run / initialize](Md3_cpp.md) — 一键初始化
- [Md3Graphics](Md3Graphics.md) — RHI / alpha buffer
- [Md3WindowHelper](Md3WindowHelper.md) — 原生窗口能力
- [Md3ChartData](Md3ChartData.md) — 大数据序列降采样
- [Md3AppSettings](Md3AppSettings.md) — QSettings facade
- [Md3HotReload](Md3HotReload.md) — QML hot reload watcher

**QML types:** 171

## Actions & selection

- [Md3AppBarButton](Md3AppBarButton.md) — Compact command-bar action (WinUI AppBarButton / AppBarToggleButton). Set `checkable: true` for toggle behavior.
- [Md3AppBarToggleButton](Md3AppBarToggleButton.md) — WinUI AppBarToggleButton — toolbar action that stays pressed when checked.
- [Md3AssistChip](Md3AssistChip.md)
- [Md3Button](Md3Button.md)
- [Md3ButtonGroup](Md3ButtonGroup.md)
- [Md3Checkbox](Md3Checkbox.md)
- [Md3ChipGroup](Md3ChipGroup.md)
- [Md3CommandBar](Md3CommandBar.md) — Desktop command strip with primary actions and a secondary overflow menu (WinUI CommandBar PrimaryCommands / SecondaryCommands).
- [Md3DropDownButton](Md3DropDownButton.md) — Single-piece button that opens a menu (WinUI DropDownButton). Unlike Md3SplitButton, the whole control opens the menu — no primary action.
- [Md3ExtendedFab](Md3ExtendedFab.md)
- [Md3Fab](Md3Fab.md)
- [Md3FabMenu](Md3FabMenu.md)
- [Md3FilterChip](Md3FilterChip.md) — Filter chip — selection is usually owned by the host (`selected:` binding). Does not auto-toggle; emit `clicked` and let the parent update `selected`.
- [Md3Hyperlink](Md3Hyperlink.md) — Text hyperlink / WinUI HyperlinkButton. Optional `url` opens externally on click.
- [Md3IconButton](Md3IconButton.md)
- [Md3InputChip](Md3InputChip.md)
- [Md3Radio](Md3Radio.md)
- [Md3RadioGroup](Md3RadioGroup.md) — Model-driven radio row/column — no host QtObject + manual Md3Radio list.
- [Md3RangeSlider](Md3RangeSlider.md)
- [Md3SegmentedButton](Md3SegmentedButton.md)
- [Md3Slider](Md3Slider.md)
- [Md3SplitButton](Md3SplitButton.md)
- [Md3SuggestionChip](Md3SuggestionChip.md)
- [Md3Switch](Md3Switch.md)
- [Md3ToggleButton](Md3ToggleButton.md) — Text toggle button (WinUI ToggleButton / MD3 toggle). Prefer Md3ToggleIconButton for icon-only.
- [Md3ToggleIconButton](Md3ToggleIconButton.md)

## Charts

- [Md3AreaChart](Md3AreaChart.md) — Stacked / single area chart (filled series under a line).
- [Md3BarChart](Md3BarChart.md) — Vertical / horizontal / stacked bar chart — zoom/pan/probe like Md3LineChart.
- [Md3BulletChart](Md3BulletChart.md) — Bullet chart — qualitative ranges + measure + comparative marker.
- [Md3Chart](Md3Chart.md) — Base for all Md3 charts — shared plot metrics, theme resolve, pause/rebuild API.
- [Md3CodeBlock](Md3CodeBlock.md) — Read-only code block with lightweight syntax highlighting (QML / JS / C++ / JSON / plain).
- [Md3FunnelChart](Md3FunnelChart.md) — Funnel chart — stages as stacked trapezoids (conversion / pipeline).
- [Md3HeatmapChart](Md3HeatmapChart.md) — Heatmap — matrix style or GitHub contribution calendar.
- [Md3LineChart](Md3LineChart.md) — Line / area chart — QtQuick.Shapes. Extends Md3Chart. Supports X zoom/pan (`interactive`) and nearest-point probe (`showProbe`).
- [Md3PieChart](Md3PieChart.md) — Pie / donut chart with hover probe (slice value + percent).
- [Md3RadarChart](Md3RadarChart.md) — Radar / spider chart — categories around a polygon, one or more series.
- [Md3RadialBarChart](Md3RadialBarChart.md) — Radial bar chart — each category as an arc bar on concentric tracks.
- [Md3ScatterChart](Md3ScatterChart.md) — Scatter chart — X/Y points with zoom/pan/probe (parity with line chart ops).
- [Md3WaterfallChart](Md3WaterfallChart.md) — Waterfall chart — floating bars for stepwise +/− contributions to a total.

## Components

- [Md3AdaptiveContainer](Md3AdaptiveContainer.md) — Standalone column-stacking adaptive container (gallery / direct use). Md3 container components embed `Md3ContainerBody` and expose `layoutMode` directly.
- [Md3AppToolBar](Md3AppToolBar.md) — Compact app tool strip for `Md3ApplicationWindow.toolBar` (desktop chrome).
- [Md3ArcBandGauge](Md3ArcBandGauge.md) — Thick arc-band gauge with an end cap marker (dashboard KPI band).
- [Md3CompassGauge](Md3CompassGauge.md) — Compass-style circular dial with heading needle (0–360°).
- [Md3ContainerBody](Md3ContainerBody.md) — Fit / Scroll content host embedded by Md3 container components.
- [Md3DeferredSection](Md3DeferredSection.md) — Within-page progressive load: placeholder first, then create `sourceComponent`. Honors Md3Theme.progressiveContent (default on). Set forceImmediate to always load now.
- [Md3DotsGauge](Md3DotsGauge.md) — Circular dots gauge — progress as filled dots around a ring.
- [Md3FileDropZone](Md3FileDropZone.md) — Desktop file drop target with scrollable table preview of dropped files.
- [Md3Gauge](Md3Gauge.md) — Classic horseshoe / arc KPI gauge (open bottom).
- [Md3HalfGauge](Md3HalfGauge.md) — Semicircle / half-dial gauge (flat bottom).
- [Md3InfoBar](Md3InfoBar.md) — WinUI-style in-page info bar — persistent until dismissed (unlike Snackbar).
- [Md3KeySequenceField](Md3KeySequenceField.md) — Desktop shortcut capture field: captures a single chord like Ctrl+K / Shift+Enter.
- [Md3KnobGauge](Md3KnobGauge.md) — Rotary knob-style gauge (value as dial rotation with notch).
- [Md3LiquidGlass](Md3LiquidGlass.md) — EXPERIMENTAL: Liquid Glass API may change without compatibility guarantees. Draggable Liquid Glass — regional backdrop sample (not full-scene blur).
- [Md3LiquidGlassFusionPlayground](Md3LiquidGlassFusionPlayground.md) — EXPERIMENTAL: Liquid Glass fusion demo API may change. Two draggable glass bodies rendered in one fused SDF pass (real metaball merge).
- [Md3MultiRingGauge](Md3MultiRingGauge.md) — Concentric multi-ring gauge — each ring is `{ value, from?, to?, color?, label? }`.
- [Md3NeedleGauge](Md3NeedleGauge.md) — Analog needle gauge with tick marks (speedometer-style).
- [Md3NumberField](Md3NumberField.md) — Numeric spin field: TextField chrome + step buttons (form-friendly SpinBox).
- [Md3Pagination](Md3Pagination.md) — Compact pagination bar for tables / lists.
- [Md3PasswordField](Md3PasswordField.md) — Password field with visibility toggle (via Md3TextField) and optional strength meter.
- [Md3PathField](Md3PathField.md) — Path field — open/save file, multi-file, or folder; recent paths, validation, drop, breadcrumb.
- [Md3ReleaseUpdater](Md3ReleaseUpdater.md) — GitHub Release update client: metadata check, ZIP download, and archive extract. NOTE: This is non-visual (0x0) but uses `Item` so it can safely host the C++ backend instance.
- [Md3RingGauge](Md3RingGauge.md) — Full 360° ring / donut progress gauge.
- [Md3ScrollBar](Md3ScrollBar.md) — Themed scrollbar attached to a Flickable (vertical or horizontal).
- [Md3ScrollView](Md3ScrollView.md) — Themed scroll view: Flickable + optional Md3ScrollBar overlays.
- [Md3SegmentGauge](Md3SegmentGauge.md) — Segmented arc gauge — discrete wedges (battery / steps style).
- [Md3Sparkline](Md3Sparkline.md) — Lightweight sparkline for KPIs / lists — Canvas only (no Md3Chart overhead).
- [Md3StatusBar](Md3StatusBar.md) — Desktop status bar — left / center / right zones, transient messages.
- [Md3TagField](Md3TagField.md) — Multi-tag / chip input — Enter or comma commits; Backspace removes last tag.
- [Md3Text](Md3Text.md)
- [Md3TickRingGauge](Md3TickRingGauge.md) — Tick-ring gauge — circular progress with radial tick marks (no needle).
- [Md3Toast](Md3Toast.md) — Short-lived toast chip. Prefer Md3ToastHost / Md3Notify.toast for stacking & position.
- [Md3ToastHost](Md3ToastHost.md) — Window-level toast host: stacked multi-toast with position + enter/exit animation.
- [Md3TrayHost](Md3TrayHost.md) — Binds system-tray activation to an `Md3Menu` (library menu, not QMenu). Place inside `Md3ApplicationWindow` (or any Window that owns `windowHelper`).  ```qml Md3TrayHost { hostWindow: window Md3MenuItem { text: qsTr("Show"); onClicked: window.raiseWindow() } Md3MenuItem { text: qsTr("Quit"); onClicked: Qt.quit() } } // then: window.showSystemTrayIcon(icon, tip) ```
- [Md3TreeView](Md3TreeView.md) — Hierarchical tree: `{ title, icon?, children?, expanded?, checked?, data? }`.
- [Md3WaveGauge](Md3WaveGauge.md) — Circular gauge with animated liquid / wave fill level (seamless loop).

## Containment & feedback

- [Md3Avatar](Md3Avatar.md) — Circular avatar: image, initials, or icon fallback.
- [Md3AvatarGroup](Md3AvatarGroup.md) — Overlapping row of avatars. model: [{ source?, initials?, icon?, color? }, ...] or strings (initials).
- [Md3Badge](Md3Badge.md) — Material Badge — numeric / dot / max-count, attach to any item via anchors.
- [Md3Badged](Md3Badged.md) — Wraps content and positions an Md3Badge (top-end by default).
- [Md3Banner](Md3Banner.md)
- [Md3BottomSheet](Md3BottomSheet.md)
- [Md3Card](Md3Card.md)
- [Md3Carousel](Md3Carousel.md)
- [Md3ContextMenuArea](Md3ContextMenuArea.md) — Transparent right-click host over a page / region. Left-clicks pass through; right-click opens `contextMenu` at the cursor.  ```qml Md3ContextMenuArea { anchors.fill: parent contextMenu: pageMenu } Md3Menu { id: pageMenu Md3MenuItem { text: qsTr("Refresh") } } ```
- [Md3Dialog](Md3Dialog.md)
- [Md3Divider](Md3Divider.md)
- [Md3DropdownMenu](Md3DropdownMenu.md)
- [Md3EmptyState](Md3EmptyState.md) — Empty / no-results placeholder: icon, title, body, optional CTA.
- [Md3ExpansionTile](Md3ExpansionTile.md)
- [Md3FullscreenDialog](Md3FullscreenDialog.md)
- [Md3Menu](Md3Menu.md)
- [Md3MenuBar](Md3MenuBar.md)
- [Md3MenuDivider](Md3MenuDivider.md)
- [Md3MenuItem](Md3MenuItem.md)
- [Md3Option](Md3Option.md)
- [Md3SideSheet](Md3SideSheet.md) — Modal/standard side sheet — slides from start (left) or end (right).
- [Md3Skeleton](Md3Skeleton.md) — MD3 skeleton bone — low-cost opacity pulse (avoids continuous sheen transforms).
- [Md3SkeletonPane](Md3SkeletonPane.md) — Full-pane skeleton used by Md3PageHost while a destination loads. Prefer `bones` (per-page outline); otherwise fall back to `layout` presets.
- [Md3Snackbar](Md3Snackbar.md)
- [Md3SnackbarHost](Md3SnackbarHost.md) — Window-level snackbar queue: stacks up to maxVisible, then queues the rest.
- [Md3SplitView](Md3SplitView.md) — Horizontal (or vertical) draggable split panes for list/detail layouts.
- [Md3Stepper](Md3Stepper.md) — Step indicator + optional step body pages and Next/Back actions.
- [Md3Tooltip](Md3Tooltip.md)
- [Md3Tour](Md3Tour.md) — Guided tour overlay: rounded spotlight cutout + animated step transitions.

## Foundation

- [Md3Accessibility](Md3Accessibility.md) _(singleton)_ — Library-wide accessibility preferences and helpers.
- [Md3AppIcons](Md3AppIcons.md) _(singleton)_ — Default app / window icons shipped inside the Md3 module (resources/icons). Paths: qrc:/md3/icons/app-icon.png … — used when windowIcon is left empty.
- [Md3ColorScheme](Md3ColorScheme.md)
- [Md3DynamicScheme](Md3DynamicScheme.md)
- [Md3Elevation](Md3Elevation.md)
- [Md3IconFonts](Md3IconFonts.md) _(singleton)_ — Shared Material Icons font faces — one FontLoader pair for the whole app (not per Md3Icon).
- [Md3Motion](Md3Motion.md) _(singleton)_
- [Md3Notify](Md3Notify.md) _(singleton)_ — App-wide notify helpers. Hosts register from Md3ApplicationWindow automatically.
- [Md3OverlayHost](Md3OverlayHost.md) _(singleton)_ — Resolve overlay parents / popup coordinates without each control re-implementing Window.window. Prefer explicit `win` (`hostWindow` / `overlayWindow`); fall back to `Window.window` of `anchor`.
- [Md3Shape](Md3Shape.md)
- [Md3StateLayer](Md3StateLayer.md)
- [Md3Theme](Md3Theme.md) _(singleton)_
- [Md3TreeVisibility](Md3TreeVisibility.md) _(singleton)_ — Shared ancestor / window visibility checks (PageHost hides pages via opacity). Prefer this over duplicating `while (parent)` walks in components.
- [Md3Typography](Md3Typography.md)

## Input

- [Md3ColorPicker](Md3ColorPicker.md) — Compact HSL color picker for theme seed / design tools.
- [Md3CommandPalette](Md3CommandPalette.md) — Spotlight-style command palette (Ctrl+K). model: [{ title, subtitle?, icon?, id? }]
- [Md3DateField](Md3DateField.md) — Docked MD3 date field: text field + calendar popup (Material docked date picker).
- [Md3DatePicker](Md3DatePicker.md) — Material 3 date picker — calendar / input, year grid, min/max, today, week start. Inline by default. Set `modal: true` and `open` with anchors.fill on a host for dialog overlay.
- [Md3DateRangePicker](Md3DateRangePicker.md) — Material 3 date range picker — shared chrome with Md3DatePicker (calendar/input/year/min-max).
- [Md3Form](Md3Form.md)
- [Md3SearchBar](Md3SearchBar.md)
- [Md3SearchView](Md3SearchView.md)
- [Md3Select](Md3Select.md) — Field-style select (ComboBox): label, helper/error, menu — aligned with Md3TextField. Supports searchable filtering and multi-select.
- [Md3TextField](Md3TextField.md)
- [Md3TimeField](Md3TimeField.md) — Docked MD3 time field: text field + time picker popup (peer of Md3DateField).
- [Md3TimePicker](Md3TimePicker.md) — Material 3 time picker — dial / keyboard input, hour↔minute, AM/PM, 12h/24h, modal.

## Layout

- [Md3AnimatedFlow](Md3AnimatedFlow.md) — Flow layout: children reflow with spatial easing. Sizes use max(explicit, implicit) so callers need not mirror width/height into implicit*.
- [Md3FlowLayout](Md3FlowLayout.md) — Wrapping flow — thin wrapper over Md3AnimatedFlow (no animation by default).
- [Md3GridLayout](Md3GridLayout.md) — Responsive uniform grid for arbitrary child items.
- [Md3HStack](Md3HStack.md) — Horizontal stack with spacing, padding, alignment, and expanding spacers.
- [Md3PageSection](Md3PageSection.md) — Page section: title + optional subtitle + content — cuts gallery/form glue.
- [Md3Spacer](Md3Spacer.md) — Lightweight spacer. Use `size` for fixed gaps, or `expand: true` inside Md3HStack / Md3VStack to absorb remaining space (SwiftUI-style).
- [Md3VStack](Md3VStack.md) — Vertical stack with spacing, padding, alignment, and optional child stretch.

## Navigation

- [Md3BottomAppBar](Md3BottomAppBar.md)
- [Md3Breadcrumb](Md3Breadcrumb.md) — Horizontal breadcrumb trail. model: ["Home","Folder"] or [{ title, icon? }, ...]
- [Md3DataTable](Md3DataTable.md) — Enterprise data table: sort, filter, multi-select, pagination, frozen columns, column resize, custom cell delegate, keyboard nav, row reorder, server paging.
- [Md3DocumentTabBar](Md3DocumentTabBar.md) — Win11 Explorer / browser document tabs — reorder, close, tear-off, add pop-in.
- [Md3ListTile](Md3ListTile.md)
- [Md3NavigationBar](Md3NavigationBar.md)
- [Md3NavigationDrawer](Md3NavigationDrawer.md)
- [Md3NavigationRail](Md3NavigationRail.md)
- [Md3Scaffold](Md3Scaffold.md) — App shell: optional built-in TopAppBar / NavigationBar / Drawer from props, or custom slots (`appBar:`, `navigationBar:`, `drawer:`, `fab:`).
- [Md3TabBar](Md3TabBar.md) — Tab strip + optional content pages (WinUI Pivot-style). When `pages` has children, a StackLayout tracks `currentIndex` — no host sync glue.
- [Md3TopAppBar](Md3TopAppBar.md)
- [Md3VirtualList](Md3VirtualList.md) — Thin virtualized list wrapper for large models with jump/scroll helpers.

## Primitives

- [Md3AbstractButton](Md3AbstractButton.md) — Shared pressable base for Md3Button / IconButton / FAB / Chip. Subclasses set `contentColor`, `containerColor`, `cornerRadius`, `pressTarget`, and handle `onPressFeedback` to pulse their Md3Ripple.
- [Md3Control](Md3Control.md)
- [Md3FocusRing](Md3FocusRing.md)
- [Md3Icon](Md3Icon.md)
- [Md3Ripple](Md3Ripple.md)
- [Md3SelectionControl](Md3SelectionControl.md) — Shared shell for selection controls such as Checkbox / Radio / Switch. Subclasses provide the left-side chrome and handle `onActivated`.
- [Md3Shadow](Md3Shadow.md)
- [Md3StateOverlay](Md3StateOverlay.md)
- [Md3Surface](Md3Surface.md)

## Progress

- [Md3CircularProgressIndicator](Md3CircularProgressIndicator.md) — Circular progress — Standard animates PathAngleArc in-place; wavy uses sparse polyline.
- [Md3LinearProgressIndicator](Md3LinearProgressIndicator.md) — Linear progress — Standard uses Rectangles; wavy uses sparse polylines + throttled rebuild.
- [Md3LoadingIndicator](Md3LoadingIndicator.md) — Material 3 Loading indicator — PathAngleArc updated in-place (no per-frame Shape rebuild).
- [Md3MorphLoadingIndicator](Md3MorphLoadingIndicator.md) — Material 3 Expressive morph loading indicator — rounded 8-lobe clover / asterisk.

## Window

- [Md3ApplicationWindow](Md3ApplicationWindow.md)
- [Md3CaptionButtons](Md3CaptionButtons.md)
- [Md3DialogWindow](Md3DialogWindow.md) — Separate OS-level dialog window (QWidget-like multi-window), not an overlay.
- [Md3Page](Md3Page.md) — Base root for Md3PageHost destinations. Declares injectables that PageHost fills — prefer these over Window.window duck-typing.
- [Md3PageHost](Md3PageHost.md)
- [Md3TabWindow](Md3TabWindow.md) — Peer window spawned by document-tab tear-off (`Md3ApplicationWindow.tearOffTab`). Uses the normal title bar + tab strip (browserChrome was removed).
- [Md3TitleBar](Md3TitleBar.md)
- [Md3TitleBarButton](Md3TitleBarButton.md)
- [Md3WindowCapabilities](Md3WindowCapabilities.md) _(singleton)_

