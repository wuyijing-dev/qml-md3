# md3qml (Rust)

Thin host for the **shared Md3** QML module via the C ABI (`md3_capi.h`).

## Prerequisites

1. Build Md3 shared (`BUILD_SHARED_LIBS=ON`) and install to a prefix.
2. Set `MD3_PREFIX` to that prefix (`bin/Md3.dll` or `lib/libMd3.so`, plus `lib/qml`).
3. Ensure the **same** Qt used to build Md3 is on `PATH` / `LD_LIBRARY_PATH`.

## Run example

```bash
export MD3_PREFIX=/path/to/prefix   # Windows: set MD3_PREFIX=...
cargo run -p md3qml --example hello -- ../../examples/hello-rust/Main.qml
```

From this directory:

```bash
cargo run --example hello
```

## API

- `md3qml::run_qml_file(path, prefix, app_name)` → exit code
- `md3qml::version_string(prefix)` → `md3_version_string()`

Python hosts use the same C ABI via `md3qml.run_qml_file_c` / `md3qml run-c`.
