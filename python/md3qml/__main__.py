"""CLI: python -m md3qml | md3qml"""

from __future__ import annotations

import argparse
import os
import subprocess
import sys
from pathlib import Path


def _cmd_info(_: argparse.Namespace) -> int:
    from . import __version__
    from .binding import detect_binding
    from .paths import bundled_prefix, resolve_md3_prefix

    print(f"md3qml {__version__}")
    print("PyPI: md3qml is NOT published yet (pip install md3qml → 404).")
    print("Network install today:")
    print('  pip install "git+https://github.com/wuyijing-dev/QML_MD3.git#subdirectory=python[pyside6]"')
    print("  md3qml install   # fetch shared Md3 zip from GitHub Releases")
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


def _cmd_doctor(args: argparse.Namespace) -> int:
    from .doctor import doctor

    code, lines = doctor(md3_prefix=args.md3_prefix)
    print("\n".join(lines))
    return code


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


def _cmd_install(args: argparse.Namespace) -> int:
    """Ensure PySide6 (optional) + download shared Md3 prefix."""
    if args.with_pyside6:
        print("==> pip install PySide6", flush=True)
        subprocess.check_call([sys.executable, "-m", "pip", "install", "-U", "PySide6"])

    from .fetch import fetch_md3_prefix

    dest = Path(args.dest).expanduser()
    prefix = fetch_md3_prefix(
        dest,
        version=args.version,
        url=args.url,
        repo=args.repo,
    )
    print(f"OK prefix={prefix}")
    print(f"export MD3_PREFIX={prefix}" if os.name != "nt" else f"set MD3_PREFIX={prefix}")
    # Persist for current user shell sessions via env file hint
    hint = Path.home() / ".md3" / "env"
    try:
        hint.parent.mkdir(parents=True, exist_ok=True)
        if os.name == "nt":
            hint.write_text(f"MD3_PREFIX={prefix}\n", encoding="utf-8")
        else:
            hint.write_text(f'export MD3_PREFIX="{prefix}"\n', encoding="utf-8")
        print(f"Wrote {hint}", file=sys.stderr)
    except OSError:
        pass

    from .doctor import doctor

    code, lines = doctor(md3_prefix=str(prefix))
    print("\n".join(lines))
    return code


def _cmd_run(args: argparse.Namespace) -> int:
    from .run import RunOptions, run

    opts = RunOptions(
        md3_prefix=args.md3_prefix,
        binding=None if args.binding == "auto" else args.binding,
        require_qt6_for_md3=not args.allow_qt5,
        application_name=args.name,
        module_uri=args.module or "",
        module_component=args.component,
        auto_fetch=args.auto_fetch,
        fetch_version=args.fetch_version,
        fetch_dest=args.fetch_dest,
        fetch_url=args.fetch_url,
    )
    if args.module:
        return run(opts=opts)
    return run(args.qml, opts=opts)


def _cmd_run_c(args: argparse.Namespace) -> int:
    from .capi import CRunConfig, run_qml_file_c

    cfg = CRunConfig(
        application_name=args.name,
        qml_import_path=args.qml_import or "",
    )
    return run_qml_file_c(args.qml, config=cfg, md3_prefix=args.md3_prefix)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        prog="md3qml",
        description="Host the shared Md3 QML module from PySide6 (or PySide2 bootstrap).",
    )
    sub = parser.add_subparsers(dest="cmd", required=True)

    p_info = sub.add_parser("info", help="Show binding, PyPI status, and Md3 prefix")
    p_info.set_defaults(func=_cmd_info)

    p_doc = sub.add_parser("doctor", help="Diagnose PySide + Md3 shared prefix")
    p_doc.add_argument("--md3-prefix", default=None)
    p_doc.set_defaults(func=_cmd_doctor)

    p_fetch = sub.add_parser("fetch", help="Download a shared Md3 zip into a local prefix")
    p_fetch.add_argument("--dest", default="~/.md3/prefix", help="Extract directory")
    p_fetch.add_argument("--version", default="1.0.0", help="Release version (without v)")
    p_fetch.add_argument("--url", default=None, help="Override zip URL (or MD3_FETCH_URL)")
    p_fetch.add_argument("--repo", default=None, help="GitHub owner/repo for release assets")
    p_fetch.set_defaults(func=_cmd_fetch)

    p_inst = sub.add_parser(
        "install",
        help="Fetch shared Md3 from GitHub Releases (+ optional pip install PySide6)",
    )
    p_inst.add_argument("--dest", default="~/.md3/prefix")
    p_inst.add_argument("--version", default="1.0.0")
    p_inst.add_argument("--url", default=None)
    p_inst.add_argument("--repo", default=None)
    p_inst.add_argument(
        "--with-pyside6",
        action="store_true",
        help="Also run: python -m pip install -U PySide6",
    )
    p_inst.set_defaults(func=_cmd_install)

    p_run = sub.add_parser("run", help="Load a .qml file (or --module) that imports Md3")
    p_run.add_argument("qml", nargs="?", default=None, help="Path to Main.qml")
    p_run.add_argument("--module", default=None, help="QML module URI (Qt6 loadFromModule)")
    p_run.add_argument("--component", default="Main")
    p_run.add_argument("--md3-prefix", default=None)
    p_run.add_argument("--binding", choices=("auto", "PySide6", "PySide2"), default="auto")
    p_run.add_argument("--allow-qt5", action="store_true")
    p_run.add_argument("--name", default="Md3 App")
    p_run.add_argument(
        "--auto-fetch",
        action="store_true",
        help="If MD3_PREFIX missing, download shared zip automatically",
    )
    p_run.add_argument("--fetch-version", default="1.0.0")
    p_run.add_argument("--fetch-dest", default="~/.md3/prefix")
    p_run.add_argument("--fetch-url", default=None)
    p_run.set_defaults(func=_cmd_run)

    p_c = sub.add_parser("run-c", help="Load via libMd3 C ABI (md3_run_qml_file)")
    p_c.add_argument("qml", help="Path to Main.qml")
    p_c.add_argument("--md3-prefix", default=None)
    p_c.add_argument("--qml-import", default=None, help="Override lib/qml path")
    p_c.add_argument("--name", default="Md3 App")
    p_c.set_defaults(func=_cmd_run_c)

    args = parser.parse_args(argv)
    if args.cmd == "run" and not args.qml and not args.module:
        p_run.error("provide qml path or --module URI")
    return int(args.func(args))


if __name__ == "__main__":
    raise SystemExit(main())
