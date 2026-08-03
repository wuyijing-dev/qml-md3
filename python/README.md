# md3qml (Python host)

Thin Python host for the **shared** Md3 QML module. Qt comes from **PySide6**.

**Lock tag:** pin git + shared Md3 to **`v1.1.4`** (see [integration.md](../docs/getting-started/integration.md)).

## Can I `pip install md3qml` from the network today?

| Channel | Status |
|---------|--------|
| **PyPI** (`pip install md3qml`) | **No** — not published |
| **GitHub** (`pip install git+…@v1.1.4#subdirectory=python[pyside6]`) | **Yes** — pure Python host |
| **GitHub Release wheels / zip** | Optional — `md3qml install --version 1.1.4` when assets are attached |

### Working network install

```bash
pip install "git+https://github.com/wuyijing-dev/QML_MD3.git@v1.1.4#subdirectory=python[pyside6]"
md3qml install --version 1.1.4 --with-pyside6
# Windows PowerShell:
$env:MD3_PREFIX = "$HOME\.md3\prefix"   # or path printed by install
md3qml doctor
md3qml run path/to/Main.qml
```

Prefer a **locally built** shared prefix from the same tag for product apps.

## Host vs QML

| Need | Do this |
|------|---------|
| Toast / Snackbar / Undo / shell InfoBar / form busy | Implement in **QML** (`Md3Notify`, `Md3ApplicationWindow`, …) |
| Clipboard from Python | `app.native.copy_to_clipboard("…")` |
| Fonts | Default on (`RunOptions.load_fonts=True` → `md3_load_fonts`) |
| Call a window method | `app.invoke("showShellInfoBar", msg, opts)` |

`WindowHelper` covers **desktop** system APIs (clipboard, tray, taskbar, backdrop…). It is **not** a 1:1 dump of every Android invokable.

## C++-style Application

```python
from md3qml import Md3Application, RunOptions

app = Md3Application(RunOptions(application_name="My App", load_fonts=True))
app.load_file("Main.qml")
raise SystemExit(app.exec())
```

## Related

- [docs/topics/pyside.md](../docs/topics/pyside.md)
- [docs/api-manual/host-lock-1.1.4.md](../docs/api-manual/host-lock-1.1.4.md)
