# WebAssembly (Qt for WASM)

Experimental support for building Md3 with **Qt for WebAssembly** (Emscripten).

## What works

| Piece | WASM |
|-------|------|
| Md3 static library + QML module | Yes (mobile native stubs) |
| `examples/hello-md3` | Yes (recommended first target) |
| Gallery | Opt-in (`-DMD3_BUILD_GALLERY=ON`); large download |
| Custom title bar / tray / taskbar | No — uses mobile capability bag |
| `Md3ReleaseUpdater` extract (`QProcess`) | Soft-fail |
| DBus / Widgets / KF WindowSystem | Not linked |

Emscripten reports as `UNIX` to CMake; Md3 detects WASM first (`cmake/Md3Platform.cmake`) and **does not** take the Linux desktop path.

## Configure (Windows host + Qt WASM kit)

Verified with Qt **6.10.2** `wasm_singlethread` + emsdk **4.0.7** at `D:\emsdk`:

```powershell
cmd /c "call D:\emsdk\emsdk_env.bat && D:\Qt\6.10.2\wasm_singlethread\bin\qt-cmake.bat -S . -B build-wasm -G Ninja -DMD3_BUILD_GALLERY=OFF -DMD3_BUILD_EXAMPLES=ON -DMD3_BUILD_SHARED=OFF && cmake --build build-wasm --target hello_md3"
```

Artifacts: `build-wasm/examples/hello-md3/hello_md3.html` (+ `.js` / `.wasm`). Serve over HTTP:

```powershell
python -m http.server 8080 -d build-wasm/examples/hello-md3
```

Set `EMSDK` if qt-cmake cannot find the toolchain (Qt may remember a different install path such as `C:\Utils\emsdk`).

## Notes

- Default Gallery is **OFF** on WASM (root `CMakeLists.txt`).
- Shared libs are forced **OFF**.
- Fonts/icons are already in `qrc` — good for the browser.
- Effects / Liquid Glass / MultiEffect depend on WebGL; degrade gracefully if a shader fails.
- `Qt.platform.os` is typically `"wasm"` → `Md3WindowCapabilities.isWasm` → mobile chrome bag.

## Status

**Verified** locally: `hello_md3.html` / `.js` / `.wasm` produced under `build-wasm/examples/hello-md3/`.  
Still **experimental** — not on the Linux CI matrix. Desktop Windows remains the primary supported target.
