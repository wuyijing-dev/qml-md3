# Scripts

按功能分类；根目录只保留本说明。

| Directory | Purpose | Entry |
|-----------|---------|-------|
| [`packaging/`](packaging/) | Qt 探测、CMake 打包、TUI | `python scripts/packaging/cli.py` |
| [`checks/`](checks/) | 静态检查（a11y / qsTr） | `python scripts/checks/check_*.py` |
| [`assets/`](assets/) | 字体等资源下载 | `powershell -File scripts/assets/download-fonts.ps1` |

Repo-root [`tools/`](../tools/)（不在 `scripts/` 下）：

| Tool | Purpose |
|------|---------|
| `tools/gen_api_docs.py` | 生成本仓 `docs/api/` |
| `tools/sync_document_repo.py` | 同步到 Document 仓（需显式 `--push`） |

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
python scripts/checks/check_a11y_qml.py --json scripts/checks/out/a11y-scan.json
python scripts/checks/check_qstr_coverage.py --json scripts/checks/out/i18n-scan.json
```

## tools/ (repo root)

```bash
# Regenerate docs/api/*.md locally (merges docs/api-manual appendices).
python tools/gen_api_docs.py
# Do not auto-push the Document repo after regen.

python tools/sync_document_repo.py          # copy only
python tools/sync_document_repo.py --push   # explicit push only
```

## assets/

```powershell
powershell -File scripts/assets/download-fonts.ps1
powershell -File scripts/assets/download-fonts.ps1 -ExtraWeights
```
