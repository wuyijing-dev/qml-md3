#!/usr/bin/env python3
"""Copy a shared Md3 install prefix into python/md3qml/_native for wheel packaging."""

from __future__ import annotations

import argparse
import json
import platform
import shutil
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
DEFAULT_NATIVE = ROOT / "python" / "md3qml" / "_native"


def _clear_native(dest: Path) -> None:
    if dest.exists():
        for child in dest.iterdir():
            if child.name == ".gitkeep":
                continue
            if child.is_dir():
                shutil.rmtree(child)
            else:
                child.unlink()
    dest.mkdir(parents=True, exist_ok=True)


def _copy_file(src: Path, dst: Path) -> None:
    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(src, dst)


def stage_runtime(prefix: Path, dest: Path) -> dict:
    """
    Keep only what PySide needs at runtime:
      - shared Md3 library
      - QML plugin + lib/qml/Md3 tree
      - Windows: bin/*.dll
    Drop headers, CMake config, debug companion trees.
    """
    prefix = prefix.resolve()
    if not (prefix / "lib" / "qml").is_dir():
        raise SystemExit(f"Not a shared Md3 prefix (missing lib/qml): {prefix}")

    _clear_native(dest)

    qml_src = prefix / "lib" / "qml"
    shutil.copytree(qml_src, dest / "lib" / "qml", dirs_exist_ok=True)

    lib_src = prefix / "lib"
    patterns = (
        "libMd3.so",
        "libMd3.so.*",
        "libMd3plugin.so",
        "libMd3plugin.so.*",
        "Md3.lib",  # rarely needed; skip huge import libs if present alone
        "libMd3.dylib",
        "libMd3.*.dylib",
        "libMd3plugin.dylib",
        "libMd3plugin.*.dylib",
    )
    for pat in patterns:
        if "lib" in pat and pat.endswith(".lib"):
            continue  # skip MSVC import libs
        for hit in lib_src.glob(pat):
            if hit.is_file():
                _copy_file(hit, dest / "lib" / hit.name)

    bin_src = prefix / "bin"
    if bin_src.is_dir():
        for hit in bin_src.glob("*.dll"):
            _copy_file(hit, dest / "bin" / hit.name)
        # Some installs place the QML plugin only under bin/
        for hit in bin_src.glob("*plugin*.dll"):
            _copy_file(hit, dest / "bin" / hit.name)

    # Ensure plugin DLL also sits next to qmldir when Windows packaging put it only in bin/
    qml_mod = dest / "lib" / "qml" / "Md3"
    if qml_mod.is_dir() and (dest / "bin").is_dir():
        for dll in (dest / "bin").glob("Md3plugin*.dll"):
            target = qml_mod / dll.name
            if not target.is_file():
                _copy_file(dll, target)

    info = {
        "staged_at": datetime.now(timezone.utc).isoformat(),
        "source_prefix": str(prefix),
        "platform": platform.platform(),
        "machine": platform.machine(),
        "system": platform.system(),
    }
    (dest / "BUILD_INFO.json").write_text(json.dumps(info, indent=2) + "\n", encoding="utf-8")
    return info


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--prefix",
        type=Path,
        default=ROOT / "dist" / "Md3",
        help="Shared Md3 install prefix (default: dist/Md3)",
    )
    parser.add_argument(
        "--dest",
        type=Path,
        default=DEFAULT_NATIVE,
        help="Destination md3qml/_native directory",
    )
    args = parser.parse_args(argv)
    info = stage_runtime(args.prefix, args.dest)
    print(f"Staged Md3 runtime → {args.dest.resolve()}")
    print(json.dumps(info, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
