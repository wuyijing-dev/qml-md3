//! Thin Rust host for shared Md3 via the C ABI (`md3_capi.h`).
//!
//! Dynamically load `Md3` (and ensure Qt is on PATH / rpath), then call [`run_qml_file`].
//! Set `MD3_PREFIX` to a shared install (`bin/Md3.dll` or `lib/libMd3.so`, plus `lib/qml`).

use libloading::{Library, Symbol};
use std::env;
use std::ffi::{CStr, CString};
use std::os::raw::{c_char, c_int};
use std::path::{Path, PathBuf};
use std::ptr;

#[repr(C)]
pub struct Md3RunConfig {
    pub organization: *const c_char,
    pub application_name: *const c_char,
    pub application_version: *const c_char,
    pub style: *const c_char,
    pub desktop_file_name: *const c_char,
    pub app_user_model_id: *const c_char,
    pub qml_import_path: *const c_char,
    pub alpha_buffer: c_int,
    pub load_fonts: c_int,
}

type Md3RunQmlFile =
    unsafe extern "C" fn(c_int, *mut *mut c_char, *const c_char, *const Md3RunConfig) -> c_int;
type Md3VersionString = unsafe extern "C" fn() -> *const c_char;

fn default_lib_names() -> &'static [&'static str] {
    if cfg!(windows) {
        &["Md3.dll", "libMd3.dll"]
    } else if cfg!(target_os = "macos") {
        &["libMd3.dylib", "Md3"]
    } else {
        &["libMd3.so", "libMd3.so.1"]
    }
}

/// Resolve shared library path under `MD3_PREFIX` or explicit `prefix`.
pub fn find_md3_library(prefix: Option<&Path>) -> Result<PathBuf, String> {
    let prefix = prefix
        .map(PathBuf::from)
        .or_else(|| env::var_os("MD3_PREFIX").map(PathBuf::from))
        .ok_or_else(|| "set MD3_PREFIX or pass prefix".to_string())?;

    let candidates = [prefix.join("bin"), prefix.join("lib"), prefix.clone()];
    for dir in candidates {
        for name in default_lib_names() {
            let p = dir.join(name);
            if p.is_file() {
                return Ok(p);
            }
        }
    }
    Err(format!(
        "Md3 shared library not found under {}",
        prefix.display()
    ))
}

fn default_qml_import(prefix: &Path) -> PathBuf {
    prefix.join("lib").join("qml")
}

/// Run a QML file that `import Md3`. Returns the process exit code from Md3.
pub fn run_qml_file(
    qml: &Path,
    prefix: Option<&Path>,
    application_name: &str,
) -> Result<i32, String> {
    let prefix_buf = prefix
        .map(PathBuf::from)
        .or_else(|| env::var_os("MD3_PREFIX").map(PathBuf::from))
        .ok_or_else(|| "MD3_PREFIX required".to_string())?;

    let lib_path = find_md3_library(Some(&prefix_buf))?;
    let qml_import = default_qml_import(&prefix_buf);
    if !qml_import.is_dir() {
        return Err(format!("missing QML import dir {}", qml_import.display()));
    }

    let qml_c = CString::new(qml.to_string_lossy().as_ref()).map_err(|e| e.to_string())?;
    let org = CString::new("Md3").unwrap();
    let name = CString::new(application_name).map_err(|e| e.to_string())?;
    let ver = CString::new("1.0.0").unwrap();
    let style = CString::new("Basic").unwrap();
    let desk = CString::new(application_name).map_err(|e| e.to_string())?;
    let import = CString::new(qml_import.to_string_lossy().as_ref()).map_err(|e| e.to_string())?;
    let prog = CString::new("md3qml-rs").unwrap();

    let cfg = Md3RunConfig {
        organization: org.as_ptr(),
        application_name: name.as_ptr(),
        application_version: ver.as_ptr(),
        style: style.as_ptr(),
        desktop_file_name: desk.as_ptr(),
        app_user_model_id: ptr::null(),
        qml_import_path: import.as_ptr(),
        alpha_buffer: 1,
        load_fonts: 1,
    };

    let mut argv_ptrs: Vec<*mut c_char> = vec![prog.as_ptr() as *mut c_char];

    unsafe {
        let lib = Library::new(&lib_path).map_err(|e| format!("load {}: {e}", lib_path.display()))?;
        let run: Symbol<Md3RunQmlFile> = lib
            .get(b"md3_run_qml_file")
            .map_err(|e| format!("md3_run_qml_file: {e}"))?;
        let code = run(1, argv_ptrs.as_mut_ptr(), qml_c.as_ptr(), &cfg);
        // Keep owned CStrings / Library alive across the call.
        let _keep = (&prog, &org, &name, &ver, &style, &desk, &import, &qml_c, lib);
        Ok(code)
    }
}

pub fn version_string(prefix: Option<&Path>) -> Result<String, String> {
    let lib_path = find_md3_library(prefix)?;
    unsafe {
        let lib = Library::new(&lib_path).map_err(|e| e.to_string())?;
        let ver: Symbol<Md3VersionString> = lib
            .get(b"md3_version_string")
            .map_err(|e| e.to_string())?;
        let p = ver();
        if p.is_null() {
            return Ok(String::new());
        }
        Ok(CStr::from_ptr(p).to_string_lossy().into_owned())
    }
}
