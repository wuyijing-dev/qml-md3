# md3qml (Python host)

Thin Python host for the **shared** Md3 QML module. Qt comes from **PySide6**.

## Can I `pip install md3qml` from the network today?

| Channel | Status (2026-07-31) |
|---------|---------------------|
| **PyPI** (`pip install md3qml`) | **No** — package not published (HTTP 404) |
| **TestPyPI** | **No** |
| **GitHub** (`pip install git+…#subdirectory=python`) | **Yes** — pure Python host |
| **GitHub Release wheels** | **Not yet** — `pyside-wheels` CI has not uploaded `.whl`; Release has shared zip only |

### Working network install (today)

```bash
pip install "git+https://github.com/wuyijing-dev/QML_MD3.git#subdirectory=python[pyside6]"
md3qml install                  # downloads Md3-*-shared*.zip from GitHub Releases
# Windows PowerShell:
$env:MD3_PREFIX = "$HOME\.md3\prefix"   # or path printed by install
md3qml doctor
md3qml run path/to/Main.qml
```

`md3qml fetch` / `install` try several asset names, including the v1.0.0 asset
`Md3-windows-AMD64-shared.zip`.

### When PyPI / platform wheels land

```bash
pip install "md3qml[pyside6]"   # after publish + PYPI_API_TOKEN / Release wheels
md3qml info                     # shows bundled _native when present
```

## C++-parity native API

```python
from md3qml import Md3Application, RunOptions

app = Md3Application(RunOptions(application_name="My App"))
assert app.load_file("Main.qml")
n = app.native  # wraps C++ Md3WindowHelper
n.open_url("https://example.com")
n.set_idle_inhibit(True, "work")
n.center_on_screen()
n.raise_window()
print(n.platform_id, n.display_server, n.last_native_status)
raise SystemExit(app.exec())
```

Also: `from md3qml import WindowHelper, create_window_helper`.

## Stronger Python binding

```python
from md3qml import Md3Application, RunOptions
from md3qml.qt import QObject, Signal, Slot

class Host(QObject):
    ping = Signal(str)

    @Slot(str)
    def log(self, text: str) -> None:
        print(text)
        self.ping.emit(text)

app = Md3Application(RunOptions(application_name="My App", auto_fetch=True))
app.set_context_property("host", Host())
assert app.load_file("Main.qml")
raise SystemExit(app.exec())
```

CLI: `info` · `doctor` · `install` · `fetch` · `run` · `run-c`.

See [docs/topics/pyside.md](../docs/topics/pyside.md).
