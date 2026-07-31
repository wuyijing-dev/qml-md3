# md3qml (PyPI)

Thin Python host for the **shared** Md3 QML module. Qt itself comes from **PySide6**.

## Fast install (platform wheels from CI)

```bash
pip install "md3qml[pyside6]"
md3qml info
md3qml run path/to/Main.qml
```

Wheels are built by `.github/workflows/pyside-wheels.yml` (shared Md3 → `_native` → `win_amd64` / manylinux).

## Fast install (fetch zip)

```bash
pip install "md3qml[pyside6]"
md3qml fetch --version 1.0.0 --dest ~/.md3/prefix
export MD3_PREFIX=~/.md3/prefix
md3qml run path/to/Main.qml
```

## Develop from this repo

```bash
pip install -e "./python[pyside6]"
python scripts/python/stage_native_for_wheel.py --prefix dist/Md3
python scripts/python/build_wheel.py --out artifacts/wheels
```

See [docs/topics/pyside.md](../docs/topics/pyside.md). CLI: `info` · `doctor` · `run` · `run-c` · `fetch`. Rust twin: [docs/topics/rust.md](../docs/topics/rust.md).
