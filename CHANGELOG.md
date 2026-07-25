# Changelog

## 0.1.0

Initial enterprise scaffold for **Md3** (Flutter Material 3–aligned QML module).

### Added
- Foundation tokens: `Md3Theme`, `Md3ColorScheme`, `Md3Typography`, `Md3Shape`, `Md3Elevation`, `Md3Motion`, `Md3StateLayer`
- Primitives: Surface, Ripple, StateOverlay, FocusRing, Icon, Shadow, Control
- Actions: Button, IconButton, FAB, ExtendedFAB, SegmentedButton
- Selection: Checkbox, Radio, Switch, Slider, RangeSlider, Chips
- Text: TextField, SearchBar, SearchView
- Containment / feedback: Card, Divider, ListTile, Dialog, FullscreenDialog, BottomSheet, Badge, Progress, Snackbar
- Navigation: Top/Bottom AppBar, NavigationBar/Rail/Drawer, TabBar, Scaffold
- Menus / pickers: Menu, MenuItem, MenuBar, DropdownMenu, DatePicker, TimePicker
- Enterprise: Tooltip, ExpansionTile, DataTable, Stepper, Banner, Carousel, Form
- Gallery browser + Login / Settings / List-Detail scenes
- Docs-first workflow under `docs/`

### Stability
Most controls are **experimental** pending pixel/motion audits against Flutter Material 3 and m3.material.io.

### Notes
- Seed color uses baseline remapping; full HCT `ColorScheme.fromSeed` is reserved for a later release
- Bundle Roboto / Material Symbols into `resources/fonts` for production typography/icons
