# PySide6 + pip

Use the **packaged shared Md3 QML module** from Python. Components stay QML; Python hosts `QQmlApplicationEngine`. Qt comes from **PySide6**, not from Md3.

## Can you `pip install` from the network today?

**PyPI: not publishing for now** (intentional). `pip install md3qml` → 404.

| Source | Works? | Notes |
|--------|--------|-------|
| `pip install md3qml` (PyPI) | **No** | Not published; deferred |
| `pip install "git+https://github.com/wuyijing-dev/QML_MD3.git#subdirectory=python[pyside6]"` | **Yes** | Pure-Python host |
| Platform wheels on GitHub Release | **Optional** | Prefer `git+…@v1.1.2#subdirectory=python`; shared zip via `md3qml install --version 1.1.2` when attached to the Release |
| `md3qml install` / `fetch` | **Yes** | Downloads shared zip from Releases |

Until PyPI publish (`PYPI_API_TOKEN` + Release upload), use **git install + fetch**:

```bash
pip install "git+https://github.com/wuyijing-dev/QML_MD3.git@v1.1.2#subdirectory=python[pyside6]"
md3qml install --version 1.1.2 --with-pyside6
export MD3_PREFIX="$HOME/.md3/prefix"   # path printed by install
md3qml doctor
md3qml run examples/hello-pyside/Main.qml --auto-fetch
```

Pin the same **`v1.1.2`** tag for the shared Md3 build and the Python host (see [integration.md](../getting-started/integration.md#lock-a-version-for-your-product-recommended)).
## Support matrix

| Binding | Qt | `import Md3` | Notes |
|---------|----|--------------|-------|
| **PySide6** | 6.5+ | **Yes** | Matching shared Md3 build ([qt-version-matrix.md](qt-version-matrix.md)) |

PySide2 / Qt 5.15 is **not supported**.

## Stronger Python API

| Module | Role |
|--------|------|
| `md3qml.qt` | Uniform `QtCore` / `QObject` / `Signal` / `Slot` from PySide6 |
| `md3qml.bridge` | `connect_signal` / `invoke` / `find_child` / `root_object` |
| `md3qml.native.WindowHelper` | Desktop facade over `Md3WindowHelper` (clipboard, tray, taskbar, backdrop…). **Not** full Android invokable matrix — Android remains experimental |
| `Md3Application.native` | Lazy `WindowHelper` after imports; default window = first root |
| `md3qml.gallery` | `run_gallery()` — load in-repo `gallery/Main.qml` |
| `md3qml.capi.load_fonts_c` | Explicit font load (also run automatically when `RunOptions.load_fonts=True`) |

### QML-only vs host-callable (v1.1.2)

| Use from… | Examples |
|-----------|----------|
| **QML (preferred for UX)** | `Md3Notify.toast` / `snackbar` / `copy`; `showShellInfoBar`; `Md3Form.submit` + `focusFirstError`; `Md3Button.busy` |
| **Python host** | `app.native.copy_to_clipboard(text)`; `app.invoke("showShellInfoBar", msg, opts)`; fonts via `load_fonts` |

Do not claim “every C++ `Md3WindowHelper` invokable is wrapped” — check `python/md3qml/native.py` for the live list.

## Gallery from Python

```bash
export MD3_PREFIX=/path/to/dist/Md3   # shared install matching PySide6's Qt
python -m md3qml gallery
# or
python examples/gallery-pyside/main.py
```

## Hello example

See [examples/hello-pyside/README.md](https://github.com/wuyijing-dev/qml-md3/blob/main/examples/hello-pyside/README.md).

## C ABI host (Rust parity)

Prefer `md3qml run` (PySide) for day-to-day apps. For the same entry as Rust `md3qml::run_qml_file` / `run_qml_module`:

```bash
md3qml run-c examples/hello-pyside/Main.qml --banner
# or: md3qml run-c --module MyApp --component Main --banner
```

| Python | Rust |
|--------|------|
| `CRunConfig` / `run_qml_file_c` / `run_qml_module_c` | `RunOptions` / `run_qml_file` / `run_qml_module` |

Field matrix: [rust.md](rust.md).
