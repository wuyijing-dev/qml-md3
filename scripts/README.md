# Scripts layout

| Directory | Purpose |
|-----------|---------|
| [`package.py`](package.py) | **Main entry** — TUI/CLI to build & package Md3 (`python scripts/package.py`) |
| [`packaging/`](packaging/) | Qt auto-discovery, CMake packaging core, interactive prompts |
| [`checks/`](checks/) | Static analysis (a11y, i18n `qsTr` coverage) |
| [`docs/`](docs/) | API doc generator (`gen_api_docs.py`) |
| [`assets/`](assets/) | Font download and other asset helpers |

## Packaging

```bash
# Interactive TUI (pick Qt kit, Debug/Release, shared/static)
python scripts/package.py

# Non-interactive
python scripts/package.py --qt-prefix D:/Qt/6.11.0/msvc2022_64 --build-type Release --shared -y

# List detected Qt installations
python scripts/package.py --list-qt
```

Legacy wrappers (forward to `package.py`):

- `scripts/package-linux.sh`
- `scripts/package-windows.ps1`

Environment variables still supported for CI: `CMAKE_PREFIX_PATH`, `BUILD_TYPE`, `SHARED`, `SKIP_SYSTEM_INSTALL`, `BUILD_DIR`, `MAKE_TARBALL`.

## Quality checks

```bash
python scripts/checks/check_a11y_qml.py --json docs/a11y-scan.json
python scripts/checks/check_qstr_coverage.py --json docs/i18n-scan.json
```

Shims at `scripts/check_*.py` remain for older docs/commands.

## API docs

```bash
python scripts/docs/gen_api_docs.py
# or: python scripts/gen_api_docs.py
```

## Assets

```powershell
powershell -File scripts/assets/download-fonts.ps1
# or: powershell -File scripts/download-fonts.ps1
```
