# Md3 API Reference

每个控件一份完整 API：**属性（含继承）/ 枚举 / 信号 / 方法**。

由 `scripts/gen_api_docs.py` 从 QML 源码生成；改完控件后请重跑该脚本。

集成与 C++ 启动：[../integration.md](../integration.md) · 主题令牌：[../tokens.md](../tokens.md)

## C++ / native

- [Md3::run / initialize](Md3_cpp.md) — 一键初始化
- [Md3Graphics](Md3Graphics.md) — RHI / alpha buffer
- [Md3WindowHelper](Md3WindowHelper.md) — 原生窗口能力
- [Md3ChartData](Md3ChartData.md) — 大数据序列降采样

**QML types:** 87

## Actions & selection

- [Md3AssistChip](Md3AssistChip.md)
- [Md3Button](Md3Button.md)
- [Md3ButtonGroup](Md3ButtonGroup.md)
- [Md3Checkbox](Md3Checkbox.md)
- [Md3ChipGroup](Md3ChipGroup.md)
- [Md3ExtendedFab](Md3ExtendedFab.md)
- [Md3Fab](Md3Fab.md)
- [Md3FabMenu](Md3FabMenu.md)
- [Md3FilterChip](Md3FilterChip.md)
- [Md3IconButton](Md3IconButton.md)
- [Md3InputChip](Md3InputChip.md)
- [Md3Radio](Md3Radio.md)
- [Md3RangeSlider](Md3RangeSlider.md)
- [Md3SegmentedButton](Md3SegmentedButton.md)
- [Md3Slider](Md3Slider.md)
- [Md3SplitButton](Md3SplitButton.md)
- [Md3SuggestionChip](Md3SuggestionChip.md)
- [Md3Switch](Md3Switch.md)
- [Md3ToggleIconButton](Md3ToggleIconButton.md)

## Charts

- [Md3BarChart](Md3BarChart.md) — Vertical / horizontal / stacked bar chart — zoom/pan/probe like Md3LineChart.
- [Md3Chart](Md3Chart.md) — Base for all Md3 charts — shared plot metrics, theme resolve, pause/rebuild API.
- [Md3CodeBlock](Md3CodeBlock.md) — Read-only code block with lightweight syntax highlighting (QML / JS / C++ / JSON / plain).
- [Md3LineChart](Md3LineChart.md) — Line / area chart — QtQuick.Shapes. Extends Md3Chart. Supports X zoom/pan (`interactive`) and nearest-point probe (`showProbe`).
- [Md3PieChart](Md3PieChart.md) — Pie / donut chart with hover probe (slice value + percent).
- [Md3ScatterChart](Md3ScatterChart.md) — Scatter chart — X/Y points with zoom/pan/probe (parity with line chart ops).

## Components

- [Md3Scaffold](Md3Scaffold.md)

## Containment & feedback

- [Md3Badge](Md3Badge.md)
- [Md3Banner](Md3Banner.md)
- [Md3BottomSheet](Md3BottomSheet.md)
- [Md3Card](Md3Card.md)
- [Md3Carousel](Md3Carousel.md)
- [Md3Dialog](Md3Dialog.md)
- [Md3Divider](Md3Divider.md)
- [Md3DropdownMenu](Md3DropdownMenu.md)
- [Md3ExpansionTile](Md3ExpansionTile.md)
- [Md3FullscreenDialog](Md3FullscreenDialog.md)
- [Md3Menu](Md3Menu.md)
- [Md3MenuBar](Md3MenuBar.md)
- [Md3MenuDivider](Md3MenuDivider.md)
- [Md3MenuItem](Md3MenuItem.md)
- [Md3Option](Md3Option.md)
- [Md3Skeleton](Md3Skeleton.md) — MD3 skeleton bone — low-cost opacity pulse (avoids continuous sheen transforms).
- [Md3SkeletonPane](Md3SkeletonPane.md) — Full-pane skeleton used by Md3PageHost while a destination loads.
- [Md3Snackbar](Md3Snackbar.md)
- [Md3Stepper](Md3Stepper.md)
- [Md3Tooltip](Md3Tooltip.md)

## Foundation

- [Md3ColorScheme](Md3ColorScheme.md)
- [Md3DynamicScheme](Md3DynamicScheme.md)
- [Md3Elevation](Md3Elevation.md)
- [Md3Motion](Md3Motion.md)
- [Md3Shape](Md3Shape.md)
- [Md3StateLayer](Md3StateLayer.md)
- [Md3Theme](Md3Theme.md)
- [Md3Typography](Md3Typography.md)

## Input

- [Md3DatePicker](Md3DatePicker.md)
- [Md3Form](Md3Form.md)
- [Md3SearchBar](Md3SearchBar.md)
- [Md3SearchView](Md3SearchView.md)
- [Md3TextField](Md3TextField.md)
- [Md3TimePicker](Md3TimePicker.md)

## Layout

- [Md3AnimatedFlow](Md3AnimatedFlow.md)

## Navigation

- [Md3BottomAppBar](Md3BottomAppBar.md)
- [Md3DataTable](Md3DataTable.md)
- [Md3DocumentTabBar](Md3DocumentTabBar.md) — Win11 Explorer / browser document tabs — reorder, close, tear-off, add pop-in.
- [Md3ListTile](Md3ListTile.md)
- [Md3NavigationBar](Md3NavigationBar.md)
- [Md3NavigationDrawer](Md3NavigationDrawer.md)
- [Md3NavigationRail](Md3NavigationRail.md)
- [Md3TabBar](Md3TabBar.md)
- [Md3TopAppBar](Md3TopAppBar.md)

## Primitives

- [Md3Control](Md3Control.md)
- [Md3FocusRing](Md3FocusRing.md)
- [Md3Icon](Md3Icon.md)
- [Md3Ripple](Md3Ripple.md)
- [Md3Shadow](Md3Shadow.md)
- [Md3StateOverlay](Md3StateOverlay.md)
- [Md3Surface](Md3Surface.md)

## Progress

- [Md3CircularProgressIndicator](Md3CircularProgressIndicator.md) — Circular progress — Standard: PathAngleArc; wavy: PathPolyline + RoundJoin (GPU, no seams).
- [Md3LinearProgressIndicator](Md3LinearProgressIndicator.md) — Linear progress — Standard uses Rectangles; wavy uses QtQuick.Shapes (GPU stroke, RoundJoin, no seams).
- [Md3LoadingIndicator](Md3LoadingIndicator.md) — Material 3 Loading indicator — Shape PathAngleArc (GPU), optional caption.

## Window

- [Md3ApplicationWindow](Md3ApplicationWindow.md)
- [Md3CaptionButtons](Md3CaptionButtons.md)
- [Md3DialogWindow](Md3DialogWindow.md) — Separate OS-level dialog window (QWidget-like multi-window), not an overlay.
- [Md3PageHost](Md3PageHost.md)
- [Md3TitleBar](Md3TitleBar.md)
- [Md3TitleBarButton](Md3TitleBarButton.md)
- [Md3WindowCapabilities](Md3WindowCapabilities.md)

