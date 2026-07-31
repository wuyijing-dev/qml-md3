# Hello Rust + Md3

Same shape as [hello-pyside](../hello-pyside/): UI in `Main.qml`, process entry in `src/main.rs`. Library code stays in [`rust/md3qml`](../../rust/md3qml/).

## Run

```powershell
# Shared Md3 install (rebuild after C ABI changes)
$env:MD3_PREFIX = "$PWD\dist\Md3"
# Must match the Qt kit that built Md3 (this tree: 6.8.x msvc2022_64)
$env:QTDIR = "D:\Qt\6.8.0\msvc2022_64"
$env:PATH = "$env:QTDIR\bin;$env:PATH"

cargo run --manifest-path examples/hello-rust/Cargo.toml
# or: cargo run --manifest-path examples/hello-rust/Cargo.toml -- path\to\Other.qml
```

See [docs/topics/rust.md](../../docs/topics/rust.md).
