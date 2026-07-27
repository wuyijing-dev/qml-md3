# Md3SnackbarHost

- **Source:** `src/Md3/components/Md3SnackbarHost.qml`
- **Extends:** `Item`

Window-level snackbar queue with stacking.

Built into `Md3ApplicationWindow` as `snackbarHostItem`; call `showSnackbar(message, options)`.

## Methods

| Method | Description |
|--------|-------------|
| `show(message, options?)` | Enqueue; returns id. options: `actionText`, `dualLine`, `durationMs`, `id` |
| `dismissAll()` | Clear queue and active snacks |

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `maxVisible` | int | `3` | Concurrent stacked snacks |
| `dodgeBottom` | real | `0` | Extra bottom inset (e.g. perf dock) |
