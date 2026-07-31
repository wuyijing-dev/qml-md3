#!/usr/bin/env python3
"""Run the repository Gallery with PySide (same QML as C++ appQML_MD3)."""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
PYTHON_DIR = ROOT / "python"
if str(PYTHON_DIR) not in sys.path:
    sys.path.insert(0, str(PYTHON_DIR))

from md3qml.gallery import run_gallery  # noqa: E402


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Md3 Gallery via PySide6")
    parser.add_argument(
        "--gallery",
        default=str(ROOT / "gallery"),
        help="Gallery directory (contains Main.qml)",
    )
    parser.add_argument("--md3-prefix", default=None)
    parser.add_argument("--binding", choices=("PySide6", "PySide2", "auto"), default="auto")
    parser.add_argument(
        "--auto-fetch",
        action="store_true",
        help="Download shared Md3 zip if prefix is missing",
    )
    args = parser.parse_args(argv)
    return run_gallery(
        gallery_dir=args.gallery,
        md3_prefix=args.md3_prefix,
        binding=None if args.binding == "auto" else args.binding,
        auto_fetch=args.auto_fetch,
    )


if __name__ == "__main__":
    raise SystemExit(main())
