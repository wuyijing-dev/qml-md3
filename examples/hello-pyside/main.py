#!/usr/bin/env python3
"""Minimal PySide host for the shared Md3 QML module."""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
PYTHON_DIR = ROOT / "python"
if str(PYTHON_DIR) not in sys.path:
    sys.path.insert(0, str(PYTHON_DIR))

from md3qml import RunOptions, run  # noqa: E402


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Hello Md3 via PySide6 / PySide2 bootstrap")
    parser.add_argument(
        "--md3-prefix",
        default=None,
        help="Shared Md3 install root (contains lib/qml). Default: MD3_PREFIX or ../dist/Md3",
    )
    parser.add_argument(
        "--binding",
        choices=("PySide6", "PySide2", "auto"),
        default="auto",
        help="Qt for Python binding (Md3 QML requires PySide6 / Qt6 today)",
    )
    parser.add_argument(
        "--allow-qt5",
        action="store_true",
        help="Allow PySide2 even when loading Md3 (will fail unless a Qt5 Md3 module exists)",
    )
    args = parser.parse_args(argv)

    opts = RunOptions(
        organization="QML_MD3",
        application_name="Hello Md3 PySide",
        application_version="1.0.0",
        desktop_file_name="Hello_Md3_PySide",
        md3_prefix=args.md3_prefix,
        binding=None if args.binding == "auto" else args.binding,
        require_qt6_for_md3=not args.allow_qt5,
    )
    return run(Path(__file__).with_name("Main.qml"), opts=opts)


if __name__ == "__main__":
    raise SystemExit(main())
