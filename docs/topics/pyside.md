# PySide6 / PySide2

Use the **packaged shared Md3 QML module** from Python. Components stay QML; Python only hosts `QQmlApplicationEngine`.

## Support matrix

| Binding | Qt | `import Md3` | Notes |
|---------|----|--------------|-------|
| **PySide6** | 6.5+ | **Yes** | Build shared Md3 with a matching Qt 6 kit |
| **PySide2** | 5.15 | Bootstrap API only | No full Md3 QML module on Qt5 yet ([qt-version-matrix.md](qt-version-matrix.md)) |

Do **not** generate Shiboken wrappers unless you need direct Python access to C++ helpers (`Md3WindowHelper`, chart models). Normal apps only need QML.

## Install

```bash
pip install PySide6
# package Md3 shared — see getting-started/packaging.md
export MD3_PREFIX=/path/to/dist/Md3   # Windows: set MD3_PREFIX=...
```

In-repo helper package (no pip publish required):

```text
python/md3qml/     # add this directory to PYTHONPATH
examples/hello-pyside/
```

```powershell
$env:PYTHONPATH = "D:\QML_MD3\QML_MD3\python"
$env:MD3_PREFIX = "D:\QML_MD3\QML_MD3\dist\Md3"
python examples/hello-pyside/main.py
```

## Minimal host

```python
from pathlib import Path
import sys
sys.path.insert(0, str(Path("python").resolve()))

from md3qml import RunOptions, run

raise SystemExit(run(
    Path("examples/hello-pyside/Main.qml"),
    opts=RunOptions(
        application_name="My App",
        md3_prefix=None,  # or r"D:\...\dist\Md3"
        binding="PySide6",
    ),
))
```

`md3qml` will:

1. Prefer **PySide6**, fall back to PySide2 for the import shim  
2. Resolve `MD3_PREFIX` / `dist/Md3`  
3. On Windows, add `bin/` via `os.add_dll_directory` + `PATH`  
4. Set `QML2_IMPORT_PATH` and `engine.addImportPath(lib/qml)`  
5. Apply Basic style + optional alpha buffer (parity with `Md3::run`)

## ABI matching

`Md3.dll` / `Md3plugin` must match the Qt libraries bundled with PySide. Mismatched kits often fail with “plugin cannot be loaded” or missing symbols. Prefer packaging Md3 with the Qt prefix that corresponds to your PySide6 version, or copy `lib/qml` + `bin` next to a known-good kit.

## Example

See [examples/hello-pyside/README.md](../../examples/hello-pyside/README.md).
