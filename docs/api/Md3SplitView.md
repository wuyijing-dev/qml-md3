# Md3SplitView

- **Source:** `src/Md3/components/Md3SplitView.qml`
- **Extends:** `Item`

Draggable two-pane layout for list/detail shells.

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `orientation` | enum | `Horizontal` | `Horizontal` / `Vertical` |
| `splitRatio` | real | `0.35` | First pane fraction of available space |
| `minPane1` / `minPane2` | real | `180` / `240` | Minimum sizes |
| `handleThickness` | real | `6` | Drag handle size |
| `showHandle` | bool | `true` | — |

Place two child items as panes (default property).
