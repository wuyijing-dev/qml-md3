# Rust + Md3 (C ABI)

Host the **shared Md3 QML module** from Rust without rewriting components. Qt and Md3 stay native; Rust only loads `libMd3` and calls `md3_run_qml_file` (same ABI as Python `md3qml.run_qml_file_c`).

## Layout

| Path | Role |
|------|------|
| [`rust/md3qml`](../../rust/md3qml/) | `md3qml` library crate |
| [`examples/hello-rust`](../../examples/hello-rust/) | `src/main.rs` + `Main.qml` |
| [`src/Md3/md3_capi.h`](../../src/Md3/md3_capi.h) | Stable C entry points |

## Prerequisites

1. Build/install **shared** Md3 (`MD3_BUILD_SHARED=ON`) into a prefix.
2. `MD3_PREFIX` → that prefix (`bin/Md3.dll` or `lib/libMd3.so`, plus `lib/qml`).
3. Same Qt used to build Md3 on `PATH` / `QTDIR` / `LD_LIBRARY_PATH`.

## Run

```powershell
$env:MD3_PREFIX = "$PWD\dist\Md3"
$env:QTDIR = "D:\Qt\6.8.0\msvc2022_64"   # kit that built Md3
$env:PATH = "$env:QTDIR\bin;$env:PATH"
cargo run --manifest-path examples/hello-rust/Cargo.toml
```

## C ABI (summary)

```c
typedef struct Md3RunConfig { /* org, name, qml_import_path, … */ } Md3RunConfig;
int md3_run_qml_file(int argc, char **argv, const char *qml_file, const Md3RunConfig *config);
int md3_run_qml_module(int argc, char **argv, const char *uri, const char *component, const Md3RunConfig *config);
const char *md3_version_string(void);
```

## Related

- Python host: [pyside.md](pyside.md) (`md3qml run` / `run-c`)
- Platform notes: [native-platforms.md](native-platforms.md)
