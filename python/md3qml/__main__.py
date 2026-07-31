"""CLI: python -m md3qml | md3qml"""

from __future__ import annotations

import argparse
import os
import sys
from pathlib import Path


def _cmd_info(_: argparse.Namespace) -> int:
    from . import __version__
    from .binding import detect_binding
    from .paths import bundled_prefix, resolve_md3_prefix

    print(f"md3qml {__version__}")
    try:
        b = detect_binding()
        print(f"binding: {b.name} (Qt {b.qt_major})")
    except ImportError as exc:
        print(f"binding: (none) — {exc}")

    bundled = bundled_prefix()
    print(f"bundled _native: {bundled or '(not in this wheel)'}")
    print(f"MD3_PREFIX: {os.environ.get('MD3_PREFIX') or '(unset)'}")
    try:
        print(f"resolved prefix: {resolve_md3_prefix()}")
    except FileNotFoundError as exc:
        print(f"resolved prefix: (missing)\n{exc}")
        return 1
    return 0


def _cmd_fetch(args: argparse.Namespace) -> int:
    from .fetch import fetch_md3_prefix

    dest = Path(args.dest).expanduser()
    prefix = fetch_md3_prefix(
        dest,
        version=args.version,
        url=args.url,
        repo=args.repo,
    )
    print(prefix)
    print(f"Set MD3_PREFIX={prefix}", file=sys.stderr)
    return 0


def _cmd_run(args: argparse.Namespace) -> int:
    from .run import RunOptions, run

    opts = RunOptions(
        md3_prefix=args.md3_prefix,
        binding=None if args.binding == "auto" else args.binding,
        require_qt6_for_md3=not args.allow_qt5,
        application_name=args.name,
    )
    return run(args.qml, opts=opts)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        prog="md3qml",
        description="Host the shared Md3 QML module from PySide6 (or PySide2 bootstrap).",
    )
    sub = parser.add_subparsers(dest="cmd", required=True)

    p_info = sub.add_parser("info", help="Show binding and Md3 prefix resolution")
    p_info.set_defaults(func=_cmd_info)

    p_fetch = sub.add_parser("fetch", help="Download a shared Md3 zip into a local prefix")
    p_fetch.add_argument("--dest", default="~/.md3/prefix", help="Extract directory")
    p_fetch.add_argument("--version", default="1.0.0", help="Release version (without v)")
    p_fetch.add_argument("--url", default=None, help="Override zip URL (or MD3_FETCH_URL)")
    p_fetch.add_argument("--repo", default=None, help="GitHub owner/repo for release assets")
    p_fetch.set_defaults(func=_cmd_fetch)

    p_run = sub.add_parser("run", help="Load a .qml file that imports Md3")
    p_run.add_argument("qml", help="Path to Main.qml")
    p_run.add_argument("--md3-prefix", default=None)
    p_run.add_argument("--binding", choices=("auto", "PySide6", "PySide2"), default="auto")
    p_run.add_argument("--allow-qt5", action="store_true")
    p_run.add_argument("--name", default="Md3 App")
    p_run.set_defaults(func=_cmd_run)

    args = parser.parse_args(argv)
    return int(args.func(args))


if __name__ == "__main__":
    raise SystemExit(main())
