# Md3SideSheet

- **Source:** `src/Md3/components/Md3SideSheet.qml`
- **Extends:** `Item`

Modal side sheet sliding from start or end edge.

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `open` | bool | `false` | — |
| `modal` | bool | `true` | Scrim dismiss |
| `edge` | enum | `End` | `Start` / `End` |
| `sheetWidth` | real | `360` | Preferred width |
| `title` | string | `""` | Optional header |

## Signals / methods

- `dismissed()` — after close
- `dismiss()` — close programmatically
