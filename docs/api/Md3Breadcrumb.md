# Md3Breadcrumb

- **Source:** `src/Md3/components/Md3Breadcrumb.qml`
- **Extends:** `Item`

Trail for hierarchical navigation (`pushRoute` / `goBack`).

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `model` | var | `[]` | Strings or `{ title, icon? }` |
| `maxVisible` | int | `6` | Collapse middle with ellipsis |

## Signals

- `crumbClicked(int index)` — not emitted for the last (current) crumb
