# tools/

| Script | Purpose |
|--------|---------|
| [`gen_api_docs.py`](gen_api_docs.py) | Generate `docs/api/*.md` from QML (merges `docs/api-manual/`) |
| [`sync_document_repo.py`](sync_document_repo.py) | Copy `docs/` → QML_MD3_Document; push only with `--push` |

```powershell
python tools/gen_api_docs.py
python tools/sync_document_repo.py
python tools/sync_document_repo.py --push
```
