# Md3 1.1.1 host notes (manual)

Hand-written lock notes — survive `gen_api_docs.py`. Full property tables remain under `docs/api/`.

## Pin

Use annotated tag **`v1.1.1`** for C++ / Python / Rust / shared prefix. See [integration.md](../getting-started/integration.md#lock-a-version-for-your-product-recommended).

## New / important QML surfaces

| API | Where |
|-----|--------|
| `Md3Notify.copy(text, options?)` | Singleton — clipboard + toast |
| `showShellInfoBar` / `dismissShellInfoBar` | `Md3ApplicationWindow` |
| `Md3Form.focusFirstError()` | Called from failed `submit()` |
| `Md3Button.busy` | Spinner; width stable |
| Snackbar action dwell (~6.5s) | When `actionText` set |
| Toast hover pause + id dedupe | `Md3Toast` / `Md3ToastHost` |

## Host helpers

| Stack | Clipboard | Fonts |
|-------|-----------|-------|
| C++ | `copyToClipboard` on window / helper | `Md3::loadFonts` / `RunOptions.loadFonts` |
| PySide | `app.native.copy_to_clipboard` | `RunOptions.load_fonts` → `md3_load_fonts` |
| Rust C ABI | use QML `Md3Notify.copy` | `md3qml::load_fonts` / `load_fonts` in config |

Feedback guide: [feedback.md](../guides/feedback.md).
