# Scripts

按功能分类；根目录只保留本说明。

| Directory | Purpose | Entry |
|-----------|---------|-------|
| [`packaging/`](packaging/) | Qt 探测、CMake 打包、TUI | `python scripts/packaging/cli.py` |
| [`checks/`](checks/) | 静态检查（a11y / qsTr） | `python scripts/checks/check_*.py` |
| [`docs/`](docs/) | API 文档生成 | `python scripts/docs/gen_api_docs.py` |
| [`assets/`](assets/) | 字体等资源下载 | `powershell -File scripts/assets/download-fonts.ps1` |

## packaging/

```bash
# Interactive TUI — 选 Qt / Debug|Release / shared|static
python scripts/packaging/cli.py

# Non-interactive
python scripts/packaging/cli.py --qt-prefix D:/Qt/6.11.0/msvc2022_64 --build-type Release --shared -y

# List kits
python scripts/packaging/cli.py --list-qt

# Platform wrappers (same CLI)
./scripts/packaging/package-linux.sh
.\scripts\packaging\package-windows.ps1
```

Env (CI): `CMAKE_PREFIX_PATH`, `BUILD_TYPE`, `SHARED`, `SKIP_SYSTEM_INSTALL`, `BUILD_DIR`, `MAKE_TARBALL`, `GENERATOR`.

## checks/

```bash
python scripts/checks/check_a11y_qml.py --json docs/a11y-scan.json
python scripts/checks/check_qstr_coverage.py --json docs/i18n-scan.json
```

## docs/

```bash
python scripts/docs/gen_api_docs.py
```

## assets/

```powershell
powershell -File scripts/assets/download-fonts.ps1
powershell -File scripts/assets/download-fonts.ps1 -ExtraWeights
```
