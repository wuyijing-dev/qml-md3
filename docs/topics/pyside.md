# PySide6 / PySide2 + pip

Use the **packaged shared Md3 QML module** from Python. Components stay QML; Python hosts `QQmlApplicationEngine`. Qt comes from **PySide**, not from Md3.

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
| **PySide6** | 6.5+ | **Yes** | Matching shared Md3 build |
| **PySide2** | 5.15 | Bootstrap API only | No full Md3 QML on Qt5 yet ([qt-version-matrix.md](qt-version-matrix.md)) |

## Stronger Python API

| Module | Role |
|--------|------|
| `md3qml.qt` | Uniform `QtCore` / `QObject` / `Signal` / `Slot` from detected PySide |
| `md3qml.bridge` | `connect_signal` / `invoke` / `find_child` / `root_object` |
| `md3qml.native.WindowHelper` | **C++-parity** facade over `Md3WindowHelper` (same invokables as C++) |
| `Md3Application.native` | Lazy `WindowHelper` after imports; default window = first root |
| `RunOptions.auto_fetch` | Download shared zip when prefix missing |
| CLI `md3qml install` | Fetch natives (+ optional `pip install PySide6`) |

```python
from md3qml import Md3Application, RunOptions
from md3qml.qt import QObject, Signal, Slot

class Host(QObject):
    @Slot(str)
    def log(self, text: str) -> None:
        print(text)

app = Md3Application(RunOptions(application_name="Demo"))
app.set_context_property("host", Host())
assert app.load_file("Main.qml")

# Same surface as C++ Md3WindowHelper / Md3ApplicationWindow helpers:
n = app.native
print(n.platform_id, n.display_server, n.last_native_status)
n.open_url("https://github.com/wuyijing-dev/QML_MD3")
n.set_idle_inhibit(True, "demo")
n.center_on_screen()
n.set_dock_badge(3)
n.share_text("hello from Python")
n.beep()

raise SystemExit(app.exec())
```

`WindowHelper` methods use snake_case; pass `window=` or rely on the default root after load.

## Gallery via Python

Same QML as the C++ Gallery (`gallery/Main.qml`), hosted by PySide:

```bash
md3qml gallery --auto-fetch
# or: python examples/gallery-pyside/main.py
```

```python
from md3qml import run_gallery
raise SystemExit(run_gallery(auto_fetch=True))
```

## What to publish on PyPI

Md3 cannot be “just QML source” on pip: users need `Md3.dll` / `libMd3.so` + `lib/qml/Md3` built against the **same Qt major** as PySide. Three practical products:

| Product | Install | Trade-off |
|---------|---------|-----------|
| **A. Pure Python `md3qml`** | git / future PyPI + `md3qml fetch` | Smallest; extra native step |
| **B. Platform wheels** (`md3qml` + `_native/`) | `pip install md3qml[pyside6]` only | Best UX when CI publishes |
| **C. Two packages** | `md3qml` + `md3qml-bin-*` | Clear split; more release work |

**Recommended:** keep **git install + `md3qml install/fetch`** until you explicitly decide to publish platform wheels / PyPI. Do **not** vendor full Qt inside any wheel — PySide already provides it.

## Fastest user install (when platform wheels exist)

```bash
pip install "md3qml[pyside6]"
md3qml info    # shows bundled _native
md3qml run app/Main.qml
```

## Develop from the repo

```powershell
pip install -e ".\python[pyside6]"
$env:MD3_PREFIX = "$PWD\dist\Md3"
md3qml run examples\hello-pyside\Main.qml
```

## CLI

```bash
md3qml info
md3qml doctor
md3qml install [--with-pyside6]
md3qml fetch --version 1.0.0
md3qml run path/to/Main.qml [--auto-fetch]
md3qml run-c path/to/Main.qml
```

## ABI matching

`Md3plugin` must load against PySide’s Qt. Pin both sides together when using CI wheels:

```text
CI wheels: PySide6==6.8.3  ↔  Md3 shared built with Qt 6.8.3
```

Mismatch → “plugin cannot be loaded”.

## Example

[examples/hello-pyside](../../examples/hello-pyside/).
