//! Minimal Md3 host — mirrors examples/hello-pyside/main.py.
//!
//! ```text
//! set MD3_PREFIX=%CD%\dist\Md3
//! set QTDIR=D:\Qt\6.8.0\msvc2022_64
//! set PATH=%QTDIR%\bin;%PATH%
//! cargo run --manifest-path examples/hello-rust/Cargo.toml
//! ```

use std::env;
use std::path::PathBuf;
use std::process;

fn main() {
    let qml = env::args()
        .nth(1)
        .map(PathBuf::from)
        .unwrap_or_else(|| PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("Main.qml"));

    if !qml.is_file() {
        eprintln!("QML not found: {}", qml.display());
        process::exit(2);
    }

    // Do not probe/unload Md3 before run — keep one LoadLibrary for the Qt lifetime.
    match md3qml::run_qml_file(&qml, None, "Hello Rust Md3") {
        Ok(code) => process::exit(code),
        Err(e) => {
            eprintln!("{e}");
            process::exit(1);
        }
    }
}
