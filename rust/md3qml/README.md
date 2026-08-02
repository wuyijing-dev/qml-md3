# md3qml (Rust)

Thin **library** host for the shared Md3 QML module via the C ABI (`md3_capi.h`). Kept in sync with Python `md3qml.capi`.

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
use md3qml::RunOptions;

let opts = RunOptions::new("My App").with_banner(true);
md3qml::run_qml_file(std::path::Path::new("Main.qml"), &opts)?;
// md3qml::run_qml_module("MyApp", "Main", &opts)?;
```

## API (parity with Python `capi`)

| Rust | Python |
|------|--------|
| `RunOptions` | `CRunConfig` (+ `md3_prefix` kwarg) |
| `run_qml_file` | `run_qml_file_c` |
| `run_qml_module` | `run_qml_module_c` |
| `md3qml` | `version_string` / `load_fonts` |
| `discover_qt_bin_dirs` | `discover_qt_bin_dirs` |
| `find_md3_library` | `load_md3_library` |

See [docs/topics/rust.md](../../docs/topics/rust.md) for the full field matrix.
