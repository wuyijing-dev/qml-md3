# Hello Md3 (PySide)

Run the shared **Md3** QML module from Python — no Shiboken / C++ wrappers.

## Requirements

1. **PySide6** (Qt 6.5+) — required for `import Md3`  
2. A **shared** Md3 package built against a Qt kit ABI-compatible with that PySide wheel  
3. Python 3.9+

PySide2 / Qt 5 is not supported. See [docs/topics/pyside.md](../../docs/topics/pyside.md).

## Package Md3 (shared)

Use the **same Qt major/minor family** as your PySide6 build when possible:

```powershell
python scripts/packaging/cli.py --qt-prefix "D:\Qt\6.10.2\msvc2022_64" --shared -y
# → dist/Md3/
```

## Run

```powershell
pip install -r examples/hello-pyside/requirements-pyside6.txt
$env:MD3_PREFIX = "D:\QML_MD3\QML_MD3\dist\Md3"
python examples/hello-pyside/main.py
# or
python examples/hello-pyside/main.py --md3-prefix "D:\QML_MD3\QML_MD3\dist\Md3"
```

```bash
pip install -r examples/hello-pyside/requirements-pyside6.txt
export MD3_PREFIX=/path/to/dist/Md3
python examples/hello-pyside/main.py
```

## Layout

| Path | Role |
|------|------|
| `main.py` | Host process |
| `Main.qml` | `import Md3` UI (same pattern as hello-md3) |
| `../../python/md3qml/` | Reusable bootstrap (`run`, path setup, PySide6/2 detect) |
