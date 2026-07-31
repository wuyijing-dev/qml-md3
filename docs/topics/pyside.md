# PySide6 / PySide2 + pip

Use the **packaged shared Md3 QML module** from Python. Components stay QML; Python only hosts `QQmlApplicationEngine`. Qt comes from **PySide**, not from Md3.

## Support matrix

| Binding | Qt | `import Md3` | Notes |
|---------|----|--------------|-------|
| **PySide6** | 6.5+ | **Yes** | Matching shared Md3 build |
| **PySide2** | 5.15 | Bootstrap API only | No full Md3 QML on Qt5 yet ([qt-version-matrix.md](qt-version-matrix.md)) |

## What to publish on PyPI

Md3 cannot be “just QML source” on pip: users need `Md3.dll` / `libMd3.so` + `lib/qml/Md3` built against the **same Qt major** as PySide. Three practical products:

| Product | Install | Trade-off |
|---------|---------|-----------|
| **A. Pure Python `md3qml`** | `pip install md3qml[pyside6]` then `md3qml fetch` or `MD3_PREFIX` | Smallest wheel; one extra step for natives |
| **B. Platform wheels** (`md3qml` + `_native/`) | `pip install md3qml[pyside6]` only | Best UX; build win/linux/mac wheels per PySide Qt line |
| **C. Two packages** | `pip install md3qml md3qml-bin-windows` | Clear split; more release work |

**Recommended:** ship **A** immediately; add **B** when CI can build shared Md3 against the Qt kit bundled with a pinned `PySide6==x.y.z`.

Do **not** vendor full Qt inside the wheel — PySide already provides it. Only ship Md3 shared libs + QML.

## Fastest user install (today)

```bash
pip install "md3qml[pyside6]"
md3qml fetch --version 1.0.0 --dest ~/.md3/prefix
export MD3_PREFIX=$HOME/.md3/prefix   # Windows: set MD3_PREFIX=%USERPROFILE%\.md3\prefix
md3qml run path/to/Main.qml
```

Release assets should be named:

```text
Md3-1.0.0-shared-windows-x64.zip
Md3-1.0.0-shared-linux-x64.zip
Md3-1.0.0-shared-macos-x64.zip
```

Zip layout: `lib/qml/Md3/…` and on Windows `bin/Md3.dll`, `bin/Md3plugin.dll` (or top-level `Md3/` with the same). Override URL with `MD3_FETCH_URL`.

## Fastest user install (platform wheel)

Build shared Md3, copy into `python/md3qml/_native/`, then:

```bash
cd python
python -m build --wheel
# tag wheel with win_amd64 / manylinux / macosx matching the PySide pin
twine upload dist/*
```

Users:

```bash
pip install "md3qml[pyside6]"
md3qml info    # shows bundled _native
md3qml run app/Main.qml
```

No `MD3_PREFIX` needed when `_native/lib/qml` is present.

## Develop from the repo

```powershell
pip install -e ".\python[pyside6]"
$env:MD3_PREFIX = "$PWD\dist\Md3"
md3qml run examples\hello-pyside\Main.qml
```

## Minimal API

```python
from pathlib import Path
from md3qml import RunOptions, run

raise SystemExit(run(
    Path("Main.qml"),
    opts=RunOptions(application_name="My App", binding="PySide6"),
))
```

## ABI matching

`Md3plugin` must load against PySide’s Qt. Pin both sides together, e.g. document:

```text
PySide6==6.10.2  ↔  Md3 shared built with Qt 6.10.2
```

Mismatch → “plugin cannot be loaded”. Prefer packaging Md3 with the same kit major.minor as the PySide pin used in CI.

## Example

[examples/hello-pyside](../../examples/hello-pyside/).
