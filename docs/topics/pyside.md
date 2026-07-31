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

**Recommended:** use **B** via Actions `pyside-wheels` (or local `stage_native` + `build_wheel`); keep **A** (`md3qml fetch`) for mirrors / custom builds.

Do **not** vendor full Qt inside the wheel — PySide already provides it. Only ship Md3 shared libs + QML.

## Fastest user install (platform wheel)

CI workflow [`.github/workflows/pyside-wheels.yml`](../../.github/workflows/pyside-wheels.yml):

1. Build **shared** Md3 (Qt 6.8.3, Gallery off)  
2. `python scripts/python/stage_native_for_wheel.py` → `python/md3qml/_native/`  
3. `python scripts/python/build_wheel.py` → `win_amd64` / manylinux (Qt libs excluded) + fetch zip  

Triggers: `workflow_dispatch`, tag `v*`, GitHub Release. Artifacts upload to the Release; optional PyPI via secret `PYPI_API_TOKEN`.

Local:

```powershell
cmake -S . -B build-wheel -G Ninja -DCMAKE_BUILD_TYPE=Release `
  -DMD3_BUILD_SHARED=ON -DMD3_BUILD_GALLERY=OFF
cmake --build build-wheel --parallel
cmake --install build-wheel --prefix dist/Md3
python scripts/python/stage_native_for_wheel.py --prefix dist/Md3
python scripts/python/build_wheel.py --out artifacts/wheels --version 1.0.0
pip install artifacts/wheels/md3qml-*.whl
pip install "PySide6==6.8.3"   # match CI Qt line
md3qml info
```

Users (after wheels are on PyPI / Release):

```bash
pip install "md3qml[pyside6]"
md3qml info    # shows bundled _native
md3qml run app/Main.qml
```

No `MD3_PREFIX` needed when `_native/lib/qml` is present.

## Fastest user install (pure-Python + fetch)

```bash
pip install "md3qml[pyside6]"
md3qml fetch --version 1.0.0 --dest ~/.md3/prefix
export MD3_PREFIX=$HOME/.md3/prefix
md3qml run path/to/Main.qml
```

Release assets from the same CI job:

```text
Md3-1.0.0-shared-windows-x64.zip
Md3-1.0.0-shared-linux-x64.zip
```

Override URL with `MD3_FETCH_URL`.


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
md3qml run path/to/Main.qml
md3qml run --module MyApp --component Main   # Qt6 loadFromModule
md3qml run-c path/to/Main.qml                # libMd3 C ABI (same as Rust)
```

## Minimal API

```python
from pathlib import Path
from md3qml import Md3Application, RunOptions, run

# One-shot
raise SystemExit(run(
    Path("Main.qml"),
    opts=RunOptions(
        application_name="My App",
        binding="PySide6",
        context_properties={"appVersion": "1.0.0"},
    ),
))

# Long-lived engine (context props / signals)
app = Md3Application(RunOptions(application_name="My App"))
app.set_context_property("bridge", my_qobject)
assert app.load_file("Main.qml")
raise SystemExit(app.exec())
```

C ABI (ctypes, shared with Rust): `from md3qml import run_qml_file_c`.

## ABI matching

`Md3plugin` must load against PySide’s Qt. Pin both sides together, e.g. document:

```text
CI wheels: PySide6==6.8.3  ↔  Md3 shared built with Qt 6.8.3
```

Mismatch → “plugin cannot be loaded”. Prefer packaging Md3 with the same kit major.minor as the PySide pin used in CI.

## Example

[examples/hello-pyside](../../examples/hello-pyside/).
