# Md3CommandPalette

- **Source:** `src/Md3/components/Md3CommandPalette.qml`
- **Extends:** `Item`

Spotlight command launcher (Gallery: `Ctrl+K`).

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `open` | bool | `false` | — |
| `placeholder` | string | Type a command… | — |
| `model` | var | `[]` | `{ title, subtitle?, icon?, … }` |
| `maxResults` | int | `12` | — |

## Signals

- `activated(var item)`
- `closed()`

Keyboard: ↑↓ highlight, Enter activate, Esc dismiss.
