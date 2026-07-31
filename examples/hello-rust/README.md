# Hello Rust + Md3

Minimal host using the **Rust** crate `rust/md3qml` and the Md3 **C ABI**.

```bash
# Build/install shared Md3 first, then:
set MD3_PREFIX=D:\path\to\prefix
cd rust\md3qml
cargo run --example hello -- ..\..\examples\hello-rust\Main.qml
```

See [docs/topics/rust.md](../../docs/topics/rust.md) and [docs/topics/pyside.md](../../docs/topics/pyside.md).
