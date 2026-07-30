"""Interactive prompts for scripts/packaging/cli.py."""

from __future__ import annotations

from pathlib import Path

from .core import PackageOptions
from .qt_detect import QtKit, discover_qt_kits, pick_default_kit


def _prompt_index(title: str, options: list[str], default: int = 0) -> int:
    if not options:
        raise RuntimeError(f"{title}: no options")
    default = max(0, min(default, len(options) - 1))
    print()
    print(title)
    for i, label in enumerate(options):
        mark = " (default)" if i == default else ""
        print(f"  [{i + 1}] {label}{mark}")
    while True:
        raw = input(f"Choose 1-{len(options)} [{default + 1}]: ").strip()
        if not raw:
            return default
        if raw.isdigit():
            idx = int(raw) - 1
            if 0 <= idx < len(options):
                return idx
        print("Invalid choice, try again.")


def _prompt_yes_no(question: str, default: bool = True) -> bool:
    hint = "Y/n" if default else "y/N"
    while True:
        raw = input(f"{question} [{hint}]: ").strip().lower()
        if not raw:
            return default
        if raw in ("y", "yes", "1", "true", "on"):
            return True
        if raw in ("n", "no", "0", "false", "off"):
            return False
        print("Please answer y or n.")


def run_interactive(root: Path) -> PackageOptions:
    kits = discover_qt_kits()
    if not kits:
        raise RuntimeError(
            "No Qt installation found. Set CMAKE_PREFIX_PATH or install Qt under ~/Qt / D:\\Qt."
        )

    default_kit = pick_default_kit(kits) or kits[0]
    default_idx = kits.index(default_kit)
    kit_idx = _prompt_index("Select Qt kit", [k.label for k in kits], default_idx)
    qt: QtKit = kits[kit_idx]

    build_idx = _prompt_index("Build type", ["Release", "Debug"], default=0)
    build_type = "Release" if build_idx == 0 else "Debug"

    link_idx = _prompt_index("Library linkage", ["Shared (recommended)", "Static"], default=0)
    shared = link_idx == 0

    skip_install = not _prompt_yes_no("Install to system/user prefix after staging?", default=True)
    make_archive = _prompt_yes_no("Create dist archive (zip/tar.gz)?", default=True)

    print()
    print("Summary")
    print(f"  Qt:        {qt.label}")
    print(f"  Build:     {build_type}")
    print(f"  Linkage:   {'shared' if shared else 'static'}")
    print(f"  Install:   {'no' if skip_install else 'yes'}")
    print(f"  Archive:   {'yes' if make_archive else 'no'}")
    if not _prompt_yes_no("Start packaging?", default=True):
        raise SystemExit(0)

    return PackageOptions(
        root=root,
        qt=qt,
        build_type=build_type,
        shared=shared,
        skip_system_install=skip_install,
        make_archive=make_archive,
    )
