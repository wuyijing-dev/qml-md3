"""Launch the in-repo Md3 Gallery from PySide (same QML as the C++ app)."""

from __future__ import annotations

import os
import sys
from pathlib import Path
from typing import List, Optional

from .paths import PathLike
from .run import RunOptions


def _package_repo_root() -> Optional[Path]:
    """When developing from a checkout: …/QML_MD3/python/md3qml → repo root."""
    here = Path(__file__).resolve().parent
    # md3qml/ → python/ → repo/
    cand = here.parent.parent
    if (cand / "gallery" / "Main.qml").is_file():
        return cand
    return None


def resolve_gallery_dir(explicit: Optional[PathLike] = None) -> Path:
    """
    Locate ``gallery/Main.qml``.

    Order: explicit → ``MD3_GALLERY`` → cwd walk-up → package checkout walk-up.
    """
    tried: List[Path] = []
    if explicit:
        tried.append(Path(explicit))
    env = os.environ.get("MD3_GALLERY", "").strip()
    if env:
        tried.append(Path(env))

    def consider(base: Path) -> Optional[Path]:
        base = base.resolve()
        if (base / "Main.qml").is_file():
            return base
        if (base / "gallery" / "Main.qml").is_file():
            return base / "gallery"
        return None

    for p in tried:
        hit = consider(p)
        if hit:
            return hit

    cur = Path.cwd().resolve()
    for _ in range(10):
        hit = consider(cur)
        if hit:
            return hit
        if cur.parent == cur:
            break
        cur = cur.parent

    pkg = _package_repo_root()
    if pkg:
        hit = consider(pkg)
        if hit:
            return hit

    raise FileNotFoundError(
        "Could not find gallery/Main.qml.\n"
        "Run from the QML_MD3 checkout, or set MD3_GALLERY to the gallery directory "
        "(the folder that contains Main.qml)."
    )


def run_gallery(
    *,
    gallery_dir: Optional[PathLike] = None,
    md3_prefix: Optional[PathLike] = None,
    binding: Optional[str] = None,
    auto_fetch: bool = False,
    fetch_version: str = "1.1.1",
    fetch_dest: str = "~/.md3/prefix",
    fetch_url: Optional[str] = None,
    argv: Optional[List[str]] = None,
) -> int:
    """
    Load the current repository Gallery QML with PySide + shared Md3.

    Uses the same ``gallery/Main.qml`` / ``pages/*.qml`` as the C++ ``appQML_MD3`` target
    (file URLs — no Gallery qmlcache module required).
    """
    from .app import Md3Application

    gal = resolve_gallery_dir(gallery_dir)
    main = gal / "Main.qml"
    if not main.is_file():
        raise FileNotFoundError(main)

    opts = RunOptions(
        organization="QML_MD3",
        application_name="Md3 Gallery",
        application_version="1.1.1",
        desktop_file_name="QML_MD3_Gallery",
        print_banner=True,
        md3_prefix=md3_prefix,
        binding=binding,
        auto_fetch=auto_fetch,
        fetch_version=fetch_version,
        fetch_dest=fetch_dest,
        fetch_url=fetch_url,
        require_qt6_for_md3=True,
        extra_import_paths=[gal],
    )
    app = Md3Application(opts, argv=argv)
    if not app.load_file(main):
        print(f"Failed to load Gallery: {main}", file=sys.stderr)
        print(f"  prefix={app.prefix}  imports={app.import_paths}", file=sys.stderr)
        return 1
    print(f"md3qml gallery: {main}", file=sys.stderr)
    return app.exec()
