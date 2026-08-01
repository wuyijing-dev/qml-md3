# PySide6 + pip

Use the **packaged shared Md3 QML module** from Python. Components stay QML; Python hosts `QQmlApplicationEngine`. Qt comes from **PySide6**, not from Md3.

## Can you `pip install` from the network today?

**PyPI: not publishing for now** (intentional). `pip install md3qml` → 404.

| Source | Works? | Notes |
|--------|--------|-------|
| `pip install md3qml` (PyPI) | **No** | Not published; deferred |
| `pip install "git+https://github.com/wuyijing-dev/QML_MD3.git#subdirectory=python[pyside6]"` | **Yes** | Pure-Python host |
| Platform wheels on GitHub Release | **Not yet** | Shared zip only on v1.0.0 |
| `md3qml install` / `fetch` | **Yes** | Downloads shared zip from Releases |

Until PyPI publish (`PYPI_API_TOKEN` + Release upload), use **git install + fetch**:

```bash
pip install "git+https://github.com/wuyijing-dev/QML_MD3.git#subdirectory=python[pyside6]"
md3qml install --with-pyside6
export MD3_PREFIX="$HOME/.md3/prefix"   # path printed by install
md3qml doctor
md3qml run examples/hello-pyside/Main.qml --auto-fetch
```

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
| `md3qml.native.WindowHelper` | **C++-parity** facade over `Md3WindowHelper` (same invokables as C++) |
| `Md3Application.native` | Lazy `WindowHelper` after imports; default window = first root |
| `md3qml.gallery` | `run_gallery()` — load in-repo `gallery/Main.qml` |

## Gallery from Python

```bash
export MD3_PREFIX=/path/to/dist/Md3   # shared install matching PySide6's Qt
python -m md3qml gallery
# or
python examples/gallery-pyside/main.py
```

## Hello example

See [examples/hello-pyside/README.md](../../examples/hello-pyside/README.md).

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
