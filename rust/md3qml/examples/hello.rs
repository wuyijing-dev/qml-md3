//! Minimal Md3 host: cargo run --example hello -- path/to/Main.qml
//! Requires MD3_PREFIX pointing at a shared Md3 install (with Qt on PATH).

use std::env;
use std::path::PathBuf;
use std::process;

fn main() {
    let qml = env::args()
        .nth(1)
        .map(PathBuf::from)
        .unwrap_or_else(|| {
            PathBuf::from(env!("CARGO_MANIFEST_DIR"))
                .join("../../examples/hello-rust/Main.qml")
        });

    if !qml.is_file() {
        eprintln!("QML not found: {}", qml.display());
        process::exit(2);
    }

    match md3qml::version_string(None) {
        Ok(v) if !v.is_empty() => eprintln!("Md3 C ABI version: {v}"),
        Ok(_) => {}
        Err(e) => eprintln!("warning: {e}"),
    }

    match md3qml::run_qml_file(&qml, None, "Hello Rust Md3") {
        Ok(code) => process::exit(code),
        Err(e) => {
            eprintln!("{e}");
            process::exit(1);
        }
    }
}
