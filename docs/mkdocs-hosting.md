# 用 MkDocs 托管文档

仓库根目录已提供 `mkdocs.yml`（`docs_dir: docs`）。构建产物在 `site/`（已 gitignore）。

## 本地预览

```bash
pip install "mkdocs-material>=9"
mkdocs serve
# 浏览器打开 http://127.0.0.1:8000
```

静态构建：

```bash
mkdocs build
# 输出：./site
```

## GitHub Pages（推荐）

### 方式 A：GitHub Actions（自动）

1. 仓库 Settings → Pages → Source 选 **GitHub Actions**。
2. 合并下方 workflow 到 `main` 后，每次推送会发布 `site/`。

示例 `.github/workflows/docs.yml`：

```yaml
name: docs
on:
  push:
    branches: [main]
    paths: [docs/**, mkdocs.yml, .github/workflows/docs.yml]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: pages
  cancel-in-progress: true

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"
      - run: pip install "mkdocs-material>=9"
      - run: mkdocs build --strict
      - uses: actions/upload-pages-artifact@v3
        with:
          path: site
  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - id: deployment
        uses: actions/deploy-pages@v4
```

站点地址一般为：`https://<user>.github.io/<repo>/`  
若使用 project pages，确认 `mkdocs.yml` 里 `site_url` / `repo_url` 与仓库一致。

### 方式 B：手动 `gh-pages` 分支

```bash
pip install "mkdocs-material>=9" mkdocs-gh-deploy
mkdocs gh-deploy
```

会构建并强制更新 `gh-pages` 分支（仅文档发布用，勿与业务分支混用）。

## 其它静态托管

把 `mkdocs build` 生成的 `site/` 整目录上传即可：

| 平台 | 要点 |
|------|------|
| Cloudflare Pages | 构建命令 `mkdocs build`，输出目录 `site` |
| Netlify | 同上；或拖拽 `site/` |
| Nginx / IIS | 将 `site/` 指为网站根；SPA 不需要，MkDocs 是多页静态站 |

## 维护注意

- API 页由 `python scripts/docs/gen_api_docs.py` 生成；改控件后先重生再 `mkdocs build`。
- `docs/professional-todo.md` 为内部清单，默认未进导航；需要可在 `mkdocs.yml` `nav` 中打开。
- `--strict` 会把断链当错误；CI 建议开启。
