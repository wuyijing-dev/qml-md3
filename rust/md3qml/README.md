# md3qml (Rust)

Thin **library** host for the shared Md3 QML module via the C ABI (`md3_capi.h`).

Runnable sample: [`examples/hello-rust`](../../examples/hello-rust/) (`src/main.rs` + `Main.qml`).

## Prerequisites

1. Build Md3 shared (`BUILD_SHARED_LIBS` / `MD3_BUILD_SHARED=ON`) and install to a prefix.
2. Set `MD3_PREFIX` (`bin/Md3.dll` or `lib/libMd3.so`, plus `lib/qml`).
3. Same Qt used to build Md3 on `PATH` / `QTDIR` / `LD_LIBRARY_PATH`.

## Use from your crate

```toml
[dependencies]
md3qml = { path = "../path/to/rust/md3qml" }
```

```rust
md3qml::run_qml_file(std::path::Path::new("Main.qml"), None, "My App")?;
```

## API

- `md3qml::run_qml_file(path, prefix, app_name)` → exit code
- `md3qml::version_string(prefix)` → `md3_version_string()`

Python hosts use the same C ABI via `md3qml.run_qml_file_c` / `md3qml run-c`.
