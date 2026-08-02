# Rust + Md3 (C ABI)

Host the **shared Md3 QML module** from Rust without rewriting components. Qt and Md3 stay native; Rust loads `libMd3` and calls the same C ABI as Python `md3qml.capi`.

## Layout

| Path | Role |
|------|------|
| [`rust/md3qml`](../../rust/md3qml/) | `md3qml` library crate |
| [`examples/hello-rust`](../../examples/hello-rust/) | `src/main.rs` + `Main.qml` |
| [`src/Md3/md3_capi.h`](../../src/Md3/md3_capi.h) | Stable C entry points |
| [`python/md3qml/capi.py`](../../python/md3qml/capi.py) | Python ctypes twin |

## Prerequisites

1. Build/install **shared** Md3 (`MD3_BUILD_SHARED=ON`) into a prefix.
2. `MD3_PREFIX` → that prefix (`bin/Md3.dll` or `lib/libMd3.so`, plus `lib/qml`).
3. Same Qt used to build Md3 on `PATH` / `QTDIR` / `LD_LIBRARY_PATH`.
4. Rebuild the shared library after any `Md3RunConfig` field change.

## Run

```powershell
$env:MD3_PREFIX = "$PWD\dist\Md3"
$env:QTDIR = "D:\Qt\6.8.0\msvc2022_64"   # kit that built Md3
$env:PATH = "$env:QTDIR\bin;$env:PATH"
cargo run --manifest-path examples/hello-rust/Cargo.toml
```

```rust
use md3qml::RunOptions;

let opts = RunOptions::new("Hello Rust Md3").with_banner(true);
md3qml::run_qml_file(&qml, &opts)?;
// or: md3qml::run_qml_module("MyApp", "Main", &opts)?;
```

## Host API parity (C path)

| Surface | C++ | C ABI | Python `capi` | Rust `md3qml` |
|---------|-----|-------|---------------|---------------|
| Config | `Md3::RunOptions` (subset) | `Md3RunConfig` | `CRunConfig` | `RunOptions` |
| File | `Md3::runQmlFile` | `md3_run_qml_file` | `run_qml_file_c` | `run_qml_file` |
| Module | `Md3::run` | `md3_run_qml_module` | `run_qml_module_c` | `run_qml_module` |
| Version | — | `md3_version_string` | `version_string_c` | `version_string` |
| Fonts (after QGuiApplication) | — | `md3_load_fonts` | `load_fonts_c` | `load_fonts` |
| Qt bins | — | — | `discover_qt_bin_dirs` | `discover_qt_bin_dirs` |

### `Md3RunConfig` / `CRunConfig` / Rust `RunOptions` fields

| Field | Notes |
|-------|--------|
| `organization` | App organization |
| `application_name` | Display / process name |
| `application_version` | Version string |
| `style` | Qt Quick Controls style (default `Basic`) |
| `desktop_file_name` | Linux desktop id; defaults to application name |
| `app_user_model_id` | Windows AUMID (optional) |
| `qml_import_path` | Single extra import dir (usually `…/lib/qml`) |
| `alpha_buffer` | Default on |
| `load_fonts` | Default on |
| `print_banner` | Release-only ANSI banner; no-op in Debug Md3 |

Rust also has `md3_prefix` on `RunOptions` (maps to env `MD3_PREFIX` / Python `md3_prefix=` kwarg).

PySide `md3qml.run.RunOptions` adds binding / auto-fetch / context properties and is **not** the C ABI twin — use `CRunConfig` + `run_qml_file_c` / `run-c` for parity with Rust.

## C ABI (summary)

```c
typedef struct Md3RunConfig {
    const char *organization;
    const char *application_name;
    const char *application_version;
    const char *style;
    const char *desktop_file_name;
    const char *app_user_model_id;
    const char *qml_import_path;
    int alpha_buffer;
    int load_fonts;
    int print_banner;
} Md3RunConfig;

int md3_run_qml_file(int argc, char **argv, const char *qml_file, const Md3RunConfig *config);
int md3_run_qml_module(int argc, char **argv, const char *uri, const char *component, const Md3RunConfig *config);
const char *md3_version_string(void);
int md3_load_fonts(void);
```

UX (toast / snackbar / shell InfoBar / form busy) lives in **QML**; Rust only bootstraps. Pin checkout + `MD3_PREFIX` to the same tag (`v1.1.1`).

## Related

- Python host: [pyside.md](pyside.md) (`md3qml run` / `run-c`)
- Platform notes: [native-platforms.md](native-platforms.md)
