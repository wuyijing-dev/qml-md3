//! Thin Rust host for shared Md3 via the C ABI (`md3_capi.h`).
//!
//! Dynamically load `Md3` (and ensure Qt is discoverable on Windows), then call [`run_qml_file`].
//! Set `MD3_PREFIX` to a shared install (`bin/Md3.dll` or `lib/libMd3.so`, plus `lib/qml`).
//! On Windows also set `QTDIR` / `CMAKE_PREFIX_PATH` / PATH to the **same** Qt used to build Md3.

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

/// Candidate Qt `bin/` dirs (Windows) so `Md3.dll` can resolve `Qt6*.dll`.
pub fn discover_qt_bin_dirs() -> Vec<PathBuf> {
    let mut out = Vec::new();
    let mut push = |p: PathBuf| {
        if p.is_dir() && !out.iter().any(|x| x == &p) {
            out.push(p);
        }
    };

    for key in ["QTDIR", "QT_DIR", "Qt6_DIR"] {
        if let Ok(v) = env::var(key) {
            let root = PathBuf::from(v);
            // Qt6_DIR often points at lib/cmake/Qt6
            if root.ends_with("Qt6") || root.ends_with("cmake") {
                if let Some(prefix) = root.ancestors().nth(2) {
                    push(prefix.join("bin"));
                }
            }
            push(root.join("bin"));
            if root.file_name().and_then(|s| s.to_str()) == Some("bin") {
                push(root);
            }
        }
    }

    if let Ok(cpp) = env::var("CMAKE_PREFIX_PATH") {
        for part in env::split_paths(&cpp) {
            push(part.join("bin"));
        }
    }

    // Walk PATH for a directory that already contains Qt6Core.dll / Qt5Core.dll
    if let Ok(path) = env::var("PATH") {
        for part in env::split_paths(&path) {
            if part.join("Qt6Core.dll").is_file()
                || part.join("Qt5Core.dll").is_file()
                || part.join("Qt6Core.so").is_file()
            {
                push(part);
            }
        }
    }

    out
}

#[cfg(windows)]
mod win_dll {
    use std::ffi::OsStr;
    use std::os::windows::ffi::OsStrExt;
    use std::path::Path;

    type DllDirectoryCookie = *mut std::ffi::c_void;

    #[link(name = "kernel32")]
    extern "system" {
        fn SetDefaultDllDirectories(flags: u32) -> i32;
        fn AddDllDirectory(new_directory: *const u16) -> DllDirectoryCookie;
        fn GetLastError() -> u32;
    }

    const LOAD_LIBRARY_SEARCH_DEFAULT_DIRS: u32 = 0x00001000;
    const LOAD_LIBRARY_SEARCH_USER_DIRS: u32 = 0x00000400;

    fn wide(path: &Path) -> Vec<u16> {
        OsStr::new(path)
            .encode_wide()
            .chain(std::iter::once(0))
            .collect()
    }

    /// Register DLL search directories (Md3 bin + Qt bin), then prepend PATH.
    pub fn prepare_search_dirs(dirs: &[std::path::PathBuf]) -> Result<(), String> {
        unsafe {
            let _ = SetDefaultDllDirectories(
                LOAD_LIBRARY_SEARCH_DEFAULT_DIRS | LOAD_LIBRARY_SEARCH_USER_DIRS,
            );
            for d in dirs {
                if !d.is_dir() {
                    continue;
                }
                let w = wide(d);
                if AddDllDirectory(w.as_ptr()).is_null() {
                    let err = GetLastError();
                    eprintln!(
                        "warning: AddDllDirectory({}) failed (Win32 {err})",
                        d.display()
                    );
                }
            }
        }
        let mut path = std::env::var_os("PATH").unwrap_or_default();
        for d in dirs.iter().rev() {
            if d.is_dir() {
                let mut new_path = d.as_os_str().to_os_string();
                new_path.push(";");
                new_path.push(&path);
                path = new_path;
            }
        }
        std::env::set_var("PATH", path);
        Ok(())
    }

    pub fn load_library(path: &Path) -> Result<libloading::Library, String> {
        // SAFETY: path is a real filesystem DLL; search dirs prepared by caller.
        unsafe {
            libloading::Library::new(path).map_err(|e| {
                format!(
                    "load {} failed: {e}. Put the Qt bin used to build Md3 on PATH / QTDIR \
                     (ABI mismatch with another Qt also fails here).",
                    path.display()
                )
            })
        }
    }
}

fn prepare_native_load(prefix: &Path, lib_path: &Path) -> Result<(), String> {
    #[cfg(windows)]
    {
        let mut dirs = Vec::new();
        if let Some(bin) = lib_path.parent() {
            dirs.push(bin.to_path_buf());
        }
        dirs.push(prefix.join("bin"));
        dirs.extend(discover_qt_bin_dirs());
        win_dll::prepare_search_dirs(&dirs)?;
    }
    #[cfg(not(windows))]
    {
        let _ = (prefix, lib_path);
    }
    Ok(())
}

fn open_md3(lib_path: &Path) -> Result<Library, String> {
    #[cfg(windows)]
    {
        win_dll::load_library(lib_path)
    }
    #[cfg(not(windows))]
    {
        Library::new(lib_path).map_err(|e| format!("load {}: {e}", lib_path.display()))
    }
}

fn load_error_hint(lib_path: &Path, detail: &str) -> String {
    format!(
        "{detail}\n  library: {}\n  hint: rebuild/install shared Md3 after md3_capi landed; \
         match QTDIR to the kit that built Md3 (this tree often uses Qt 6.8.x).",
        lib_path.display()
    )
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
    prepare_native_load(&prefix_buf, &lib_path)?;

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
        let lib = open_md3(&lib_path).map_err(|e| load_error_hint(&lib_path, &e))?;
        let run: Symbol<Md3RunQmlFile> = lib.get(b"md3_run_qml_file").map_err(|e| {
            load_error_hint(
                &lib_path,
                &format!(
                    "symbol md3_run_qml_file missing ({e}). \
                     dist/Md3 was likely built before C ABI — rebuild shared Md3."
                ),
            )
        })?;
        let code = run(1, argv_ptrs.as_mut_ptr(), qml_c.as_ptr(), &cfg);
        let _keep = (
            &prog, &org, &name, &ver, &style, &desk, &import, &qml_c, lib,
        );
        Ok(code)
    }
}

pub fn version_string(prefix: Option<&Path>) -> Result<String, String> {
    let prefix_buf = prefix
        .map(PathBuf::from)
        .or_else(|| env::var_os("MD3_PREFIX").map(PathBuf::from));
    let lib_path = find_md3_library(prefix_buf.as_deref())?;
    if let Some(ref p) = prefix_buf {
        prepare_native_load(p, &lib_path)?;
    } else if let Some(parent) = lib_path.parent() {
        let prefix_guess = parent.parent().unwrap_or(parent);
        prepare_native_load(prefix_guess, &lib_path)?;
    }

    unsafe {
        let lib = open_md3(&lib_path).map_err(|e| load_error_hint(&lib_path, &e))?;
        let ver: Symbol<Md3VersionString> = lib.get(b"md3_version_string").map_err(|e| {
            load_error_hint(
                &lib_path,
                &format!("symbol md3_version_string missing ({e})"),
            )
        })?;
        let p = ver();
        if p.is_null() {
            return Ok(String::new());
        }
        Ok(CStr::from_ptr(p).to_string_lossy().into_owned())
    }
}
