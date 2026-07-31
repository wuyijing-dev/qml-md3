# 用 MkDocs 托管文档（专用仓）

对外站点放在独立仓库 **[QML_MD3_Document](https://github.com/wuyijing-dev/QML_MD3_Document)**，不在本库开 Pages。

| 仓库 | 角色 |
|------|------|
| [QML_MD3](https://github.com/wuyijing-dev/QML_MD3) | `docs/` 真源；改文档、跑 `gen_api_docs.py` |
| [QML_MD3_Document](https://github.com/wuyijing-dev/QML_MD3_Document) | `mkdocs.yml` + 同步内容；**GitHub Pages 构建与发布** |

站点：https://wuyijing-dev.github.io/QML_MD3_Document/

## 日常流程

1. 在本库改 `docs/`（或重生 API 文档）
2. 同步到 Document 仓：

```bash
# 默认目标：与本仓同级的 ../QML_MD3_Document
python scripts/docs/sync_document_repo.py

# 或指定路径 / 直接 push
python scripts/docs/sync_document_repo.py --dest D:/QML_MD3/QML_MD3_Document --push
```

3. Document 仓的 Actions 自动 `mkdocs build` 并部署 Pages

CI：本库 `.github/workflows/docs-sync.yml` 仅 **`workflow_dispatch` 手动触发**（避免 `gen_api_docs` 刷屏推送 Document 仓）。需配置 secret `DOCUMENT_SYNC_TOKEN`。

本地默认同步**不推送**；确认后再加 `--push`：

```bash
python scripts/docs/sync_document_repo.py
python scripts/docs/sync_document_repo.py --push
```

`gen_api_docs.py` 只写本仓 `docs/api/`；**不要**在每次重生后自动 push Document 仓。

## Document 仓本地预览

```bash
cd ../QML_MD3_Document   # 或 clone git@github.com:wuyijing-dev/QML_MD3_Document.git
pip install "mkdocs-material>=9"
mkdocs serve             # http://127.0.0.1:8000
mkdocs build             # 输出 ./site
```

## GitHub Pages（在 Document 仓）

1. 打开 [QML_MD3_Document Settings → Pages](https://github.com/wuyijing-dev/QML_MD3_Document/settings/pages)
2. Source 选 **GitHub Actions**
3. 推送 `main` 后由 Document 仓内 `.github/workflows/docs.yml` 发布

## CI 自动同步（可选）

在 **QML_MD3** 仓库 Settings → Secrets 增加：

- `DOCUMENT_SYNC_TOKEN`：具备 `repo` 权限的 PAT（或 fine-grained：对 `QML_MD3_Document` 的 Contents 写权限）

未配置 secret 时，同步 workflow 会跳过 push，仅本地/`workflow_dispatch` 人工同步。

## 维护注意

- API 页：`python scripts/docs/gen_api_docs.py`（在本库）→ 再 `sync_document_repo.py`
- `docs/professional-todo.md` 为内部清单，默认不进 MkDocs `nav`
- Document 仓 `mkdocs build --strict` 会把断链当错误
