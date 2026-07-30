#!/usr/bin/env python3
"""Md3 packaging entry — TUI or CLI.

Interactive (default):
  python scripts/package.py

Non-interactive:
  python scripts/package.py --qt-prefix D:/Qt/6.11.0/msvc2022_64 --build-type Release --shared --yes
"""

from __future__ import annotations

import argparse
import os
import sys
from pathlib import Path

SCRIPTS_DIR = Path(__file__).resolve().parent
if str(SCRIPTS_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPTS_DIR))

from packaging.core import PackageOptions, run_package
from packaging.qt_detect import _kit_from_prefix, discover_qt_kits, pick_default_kit
from packaging.tui import run_interactive

ROOT = SCRIPTS_DIR.parent


def _env_bool(name: str, default: bool) -> bool:
    raw = os.environ.get(name, "").strip().lower()
    if not raw:
        return default
    if raw in ("1", "on", "true", "yes"):
        return True
    if raw in ("0", "off", "false", "no"):
        return False
    return default


def _parse_args() -> argparse.Namespace:
    ap = argparse.ArgumentParser(description="Build and package Md3 library")
    ap.add_argument("--qt-prefix", type=Path, help="Qt kit prefix (CMAKE_PREFIX_PATH)")
    ap.add_argument("--qt-index", type=int, help="Pick Nth kit from auto-discovery (1-based)")
    ap.add_argument("--build-type", choices=("Debug", "Release"), default=None)
    link = ap.add_mutually_exclusive_group()
    link.add_argument("--shared", action="store_true", default=None, help="Shared library")
    link.add_argument("--static", action="store_true", default=None, help="Static library")
    ap.add_argument("--build-dir", type=Path, default=None)
    ap.add_argument("--stage-prefix", type=Path, default=None)
    ap.add_argument("--install-prefix", type=Path, default=None)
    ap.add_argument("--jobs", type=int, default=None)
    ap.add_argument("--generator", default=None)
    ap.add_argument("--skip-install", action="store_true")
    ap.add_argument("--no-archive", action="store_true")
    ap.add_argument("--no-clean", action="store_true")
    ap.add_argument("--bundle-dir", type=Path, default=None, help="Copy staged Md3 next to Md3Create")
    ap.add_argument("--yes", "-y", action="store_true", help="Skip interactive prompts")
    ap.add_argument("--list-qt", action="store_true", help="List detected Qt kits and exit")
    return ap.parse_args()


def _resolve_qt(args: argparse.Namespace):
    if args.qt_prefix:
        kit = _kit_from_prefix(args.qt_prefix)
        if kit is None:
            raise RuntimeError(f"Not a valid Qt prefix: {args.qt_prefix}")
        return kit

    env_prefix = os.environ.get("CMAKE_PREFIX_PATH", "").strip()
    if env_prefix and args.yes:
        first = env_prefix.split(os.pathsep)[0].split(";")[0]
        kit = _kit_from_prefix(Path(first))
        if kit:
            return kit

    kits = discover_qt_kits()
    if not kits:
        raise RuntimeError("No Qt installation found. Use --qt-prefix or set CMAKE_PREFIX_PATH.")

    if args.qt_index is not None:
        idx = args.qt_index - 1
        if idx < 0 or idx >= len(kits):
            raise RuntimeError(f"--qt-index out of range (1-{len(kits)})")
        return kits[idx]

    return pick_default_kit(kits) or kits[0]


def _options_from_args(args: argparse.Namespace) -> PackageOptions | None:
    if args.list_qt:
        kits = discover_qt_kits()
        if not kits:
            print("No Qt kits found.")
        else:
            for i, kit in enumerate(kits, start=1):
                print(f"[{i}] {kit.label}")
        return None

    interactive = (
        not args.yes
        and args.qt_prefix is None
        and args.qt_index is None
        and sys.stdin.isatty()
    )
    if interactive:
        return run_interactive(ROOT)

    qt = _resolve_qt(args)
    if args.static:
        shared = False
    elif args.shared:
        shared = True
    else:
        shared = _env_bool("SHARED", True)
    build_type = args.build_type or os.environ.get("BUILD_TYPE", "Release")
    skip_install = args.skip_install or _env_bool("SKIP_SYSTEM_INSTALL", False)

    build_dir = args.build_dir
    if build_dir is None and os.environ.get("BUILD_DIR"):
        build_dir = Path(os.environ["BUILD_DIR"])

    return PackageOptions(
        root=ROOT,
        qt=qt,
        build_type=build_type,
        shared=shared,
        build_dir=build_dir,
        stage_prefix=args.stage_prefix,
        install_prefix=args.install_prefix,
        jobs=args.jobs,
        generator=args.generator or os.environ.get("GENERATOR") or None,
        skip_system_install=skip_install,
        make_archive=not args.no_archive and _env_bool("MAKE_TARBALL", True),
        clean_build=not args.no_clean,
        create_bundle_dir=args.bundle_dir,
    )


def main() -> int:
    args = _parse_args()
    try:
        opt = _options_from_args(args)
        if opt is None:
            return 0
        run_package(opt)
    except SystemExit as exc:
        return int(exc.code or 0)
    except KeyboardInterrupt:
        print("\nCancelled.")
        return 130
    except Exception as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
