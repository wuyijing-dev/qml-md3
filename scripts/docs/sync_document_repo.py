#!/usr/bin/env python3
"""Sync QML_MD3/docs into the dedicated QML_MD3_Document MkDocs repo.

Usage:
  python scripts/docs/sync_document_repo.py
  python scripts/docs/sync_document_repo.py --dest ../QML_MD3_Document --push
  python scripts/docs/sync_document_repo.py --dest https://github.com/wuyijing-dev/QML_MD3_Document.git --push

Default --dest is ../QML_MD3_Document relative to the library repo root.
"""
from __future__ import annotations

import argparse
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SRC_DOCS = ROOT / "docs"
DEFAULT_DEST = ROOT.parent / "QML_MD3_Document"

# Keep scan JSON / caches out of the public docs repo.
SKIP_NAMES = {
    "a11y-scan.json",
    "i18n-scan.json",
    "__pycache__",
}


def _run(cmd: list[str], cwd: Path | None = None) -> None:
    print("+", " ".join(cmd))
    subprocess.run(cmd, cwd=cwd, check=True)


def _is_git_url(s: str) -> bool:
    return s.startswith("git@") or s.startswith("https://") or s.startswith("http://")


def _copy_docs(dest_docs: Path) -> None:
    if dest_docs.exists():
        shutil.rmtree(dest_docs)
    dest_docs.mkdir(parents=True)

    for path in SRC_DOCS.rglob("*"):
        rel = path.relative_to(SRC_DOCS)
        if any(part in SKIP_NAMES for part in rel.parts):
            continue
        if path.name in SKIP_NAMES:
            continue
        target = dest_docs / rel
        if path.is_dir():
            target.mkdir(parents=True, exist_ok=True)
        else:
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(path, target)


def _ensure_local_clone(url: str, dest: Path) -> Path:
    if dest.exists() and (dest / ".git").exists():
        _run(["git", "fetch", "origin"], cwd=dest)
        _run(["git", "checkout", "main"], cwd=dest)
        _run(["git", "pull", "--ff-only", "origin", "main"], cwd=dest)
        return dest
    dest.parent.mkdir(parents=True, exist_ok=True)
    if dest.exists():
        raise SystemExit(f"Destination exists but is not a git repo: {dest}")
    _run(["git", "clone", url, str(dest)])
    return dest


def _git_push(repo: Path, message: str) -> None:
    _run(["git", "add", "-A"], cwd=repo)
    status = subprocess.run(
        ["git", "status", "--porcelain"],
        cwd=repo,
        check=True,
        capture_output=True,
        text=True,
    )
    if not status.stdout.strip():
        print("Nothing to commit in document repo.")
        return
    _run(["git", "commit", "-m", message], cwd=repo)
    _run(["git", "push", "origin", "HEAD"], cwd=repo)


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument(
        "--dest",
        default=str(DEFAULT_DEST),
        help="Local path or git URL of QML_MD3_Document (default: ../QML_MD3_Document)",
    )
    ap.add_argument(
        "--push",
        action="store_true",
        help="git commit + push after sync (local clone only)",
    )
    ap.add_argument(
        "--message",
        default="Sync docs from QML_MD3",
        help="Commit message when --push",
    )
    args = ap.parse_args()

    if not SRC_DOCS.is_dir():
        print(f"Missing source docs: {SRC_DOCS}", file=sys.stderr)
        return 1

    dest_arg = args.dest
    tmp: tempfile.TemporaryDirectory[str] | None = None
    try:
        if _is_git_url(dest_arg):
            tmp = tempfile.TemporaryDirectory(prefix="qml-md3-doc-")
            repo = _ensure_local_clone(dest_arg, Path(tmp.name) / "QML_MD3_Document")
        else:
            repo = Path(dest_arg).resolve()
            if not repo.exists():
                print(f"Destination missing: {repo}", file=sys.stderr)
                print("Clone first: gh repo clone wuyijing-dev/QML_MD3_Document", file=sys.stderr)
                return 1
            if not (repo / ".git").exists():
                print(f"Not a git repo: {repo}", file=sys.stderr)
                return 1

        if not (repo / "mkdocs.yml").exists():
            print(f"Warning: {repo / 'mkdocs.yml'} missing — syncing docs/ only.")

        _copy_docs(repo / "docs")
        print(f"Synced {SRC_DOCS} -> {repo / 'docs'}")

        if args.push:
            _git_push(repo, args.message)
    finally:
        if tmp is not None:
            tmp.cleanup()

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
