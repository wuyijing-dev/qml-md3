"""Locate a shared Md3 install prefix and put DLLs / QML on the search path."""

from __future__ import annotations

import os
import sys
from pathlib import Path
from typing import Iterable, List, Optional, Union

PathLike = Union[str, Path]


def bundled_prefix() -> Optional[Path]:
    """Prefix shipped inside the wheel at md3qml/_native (platform wheels)."""
    p = Path(__file__).resolve().parent / "_native"
    if (p / "lib" / "qml").is_dir():
        return p
    return None


def _candidates_from_env() -> List[Path]:
    out: List[Path] = []
    for key in ("MD3_PREFIX", "MD3_ROOT", "MD3_HOME"):
        raw = os.environ.get(key, "").strip()
        if raw:
            out.append(Path(raw))
    return out


def _walk_up_looking_for_dist(start: Path) -> List[Path]:
    found: List[Path] = []
    cur = start.resolve()
    for _ in range(8):
        for name in ("dist/Md3", "Md3", "install/Md3"):
            p = cur / name
            if (p / "lib" / "qml" / "Md3").is_dir() or (p / "lib" / "qml").is_dir():
                found.append(p)
        if cur.parent == cur:
            break
        cur = cur.parent
    return found


def resolve_md3_prefix(
    explicit: Optional[PathLike] = None,
    *,
    start: Optional[PathLike] = None,
) -> Path:
    """
    Resolve the shared Md3 package root (contains lib/qml[/Md3] and bin/ on Windows).

    Search order:
      explicit → MD3_PREFIX → wheel-bundled md3qml/_native → walk up for dist/Md3
    """
    tried: List[Path] = []
    if explicit:
        tried.append(Path(explicit))
    tried.extend(_candidates_from_env())
    bundled = bundled_prefix()
    if bundled:
        tried.append(bundled)
    root = Path(start) if start else Path.cwd()
    tried.extend(_walk_up_looking_for_dist(root))

    for p in tried:
        p = p.resolve()
        qml = p / "lib" / "qml"
        if qml.is_dir():
            return p

    hint = (
        "Install options (pick one):\n"
        "  1) pip install a platform wheel that vendors Md3 under md3qml/_native\n"
        "  2) md3qml fetch --dest %USERPROFILE%\\.md3\\prefix\n"
        "  3) set MD3_PREFIX to a shared package from scripts/packaging/cli.py\n"
    )
    raise FileNotFoundError(
        "Could not find Md3 shared prefix (expected lib/qml).\n"
        f"Tried: {', '.join(str(t) for t in tried) or '(none)'}\n"
        + hint
    )


def setup_native_paths(prefix: PathLike, *, extra_import_paths: Optional[Iterable[PathLike]] = None) -> List[str]:
    """
    Prepare process env so QQmlApplicationEngine can load Md3plugin + QML files.

    Returns the list of QML import paths that should also be passed to engine.addImportPath.
    """
    prefix = Path(prefix).resolve()
    qml_root = prefix / "lib" / "qml"
    if not qml_root.is_dir():
        raise FileNotFoundError(f"Missing QML import root: {qml_root}")

    bin_dir = prefix / "bin"
    lib_dir = prefix / "lib"

    if sys.platform == "win32":
        if bin_dir.is_dir():
            if hasattr(os, "add_dll_directory"):
                os.add_dll_directory(str(bin_dir))
            path = os.environ.get("PATH", "")
            if str(bin_dir) not in path.split(os.pathsep):
                os.environ["PATH"] = str(bin_dir) + os.pathsep + path
    else:
        if lib_dir.is_dir():
            key = "DYLD_LIBRARY_PATH" if sys.platform == "darwin" else "LD_LIBRARY_PATH"
            cur = os.environ.get(key, "")
            if str(lib_dir) not in cur.split(os.pathsep):
                os.environ[key] = str(lib_dir) + (os.pathsep + cur if cur else "")

    imports = [str(qml_root)]
    if extra_import_paths:
        for p in extra_import_paths:
            imports.append(str(Path(p).resolve()))

    existing = os.environ.get("QML2_IMPORT_PATH", "")
    merged = os.pathsep.join([*imports, *([existing] if existing else [])])
    seen = set()
    parts = []
    for part in merged.split(os.pathsep):
        if part and part not in seen:
            seen.add(part)
            parts.append(part)
    os.environ["QML2_IMPORT_PATH"] = os.pathsep.join(parts)
    return imports
