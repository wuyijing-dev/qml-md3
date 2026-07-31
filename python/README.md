# md3qml (PyPI)

Thin Python host for the **shared** Md3 QML module. Qt itself comes from **PySide6**.

## Fast install (recommended path once platform wheels exist)

```bash
pip install "md3qml[pyside6]"
# If the wheel vendors md3qml/_native — you are done.
md3qml info
md3qml run path/to/Main.qml
```

## Fast install (pure-Python wheel + fetch binaries)

```bash
pip install "md3qml[pyside6]"
md3qml fetch --version 1.0.0 --dest ~/.md3/prefix
export MD3_PREFIX=~/.md3/prefix   # Windows: set MD3_PREFIX=%USERPROFILE%\.md3\prefix
md3qml run examples/hello-pyside/Main.qml
```

Upload release zips named `Md3-{ver}-shared-{windows-x64|linux-x64|macos-x64}.zip`
(contents: `lib/qml`, Windows also `bin/`).

## Develop from this repo

```bash
pip install -e "./python[pyside6]"
```

See [docs/topics/pyside.md](../docs/topics/pyside.md).
