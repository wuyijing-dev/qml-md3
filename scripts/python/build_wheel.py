#!/usr/bin/env python3
"""Build a platform md3qml wheel from python/ after staging md3qml/_native."""

from __future__ import annotations

import argparse
import os
import platform
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
PYTHON_PKG = ROOT / "python"
NATIVE = PYTHON_PKG / "md3qml" / "_native"


def _run(cmd: list[str], *, cwd: Path | None = None, env: dict | None = None) -> None:
    print("==>", " ".join(cmd), flush=True)
    subprocess.check_call(cmd, cwd=cwd, env=env)


def _has_native() -> bool:
    return (NATIVE / "lib" / "qml").is_dir()


def _platform_zip_name(version: str) -> str:
    ver = version.lstrip("v")
    system = platform.system()
    if system == "Windows":
        tag = "windows-x64"
    elif system == "Darwin":
        tag = "macos-x64"
    else:
        tag = "linux-x64"
    return f"Md3-{ver}-shared-{tag}.zip"


def _make_fetch_zip(out_dir: Path, version: str) -> Path:
    """Zip _native contents as a fetchable shared prefix (lib/qml at archive root)."""
    out_dir.mkdir(parents=True, exist_ok=True)
    zip_path = out_dir / _platform_zip_name(version)
    if zip_path.exists():
        zip_path.unlink()
    # zip from inside _native so lib/ is top-level
    base = NATIVE.resolve()
    import zipfile

    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as zf:
        for path in base.rglob("*"):
            if path.is_file() and path.name != ".gitkeep":
                zf.write(path, path.relative_to(base).as_posix())
    return zip_path


def _auditwheel_repair(wheel_dir: Path) -> None:
    wheels = sorted(wheel_dir.glob("*.whl"))
    if not wheels:
        raise SystemExit(f"No wheels in {wheel_dir}")
    repaired = wheel_dir / "repaired"
    repaired.mkdir(parents=True, exist_ok=True)
    # Qt libs come from PySide6 — exclude them so auditwheel does not vendor Qt.
    excludes = [
        "libQt6*",
        "libicu*",
        "libstdc++.so.*",
        "libgcc_s.so.*",
        "libgobject-2.0.so.*",
        "libglib-2.0.so.*",
        "libGL.so.*",
        "libOpenGL.so.*",
        "libGLdispatch.so.*",
        "libEGL.so.*",
        "libxkbcommon*",
        "libxcb*",
        "libX11*",
        "libXext*",
        "libXrender*",
        "libfontconfig*",
        "libfreetype*",
    ]
    cmd = [sys.executable, "-m", "auditwheel", "repair", "-w", str(repaired)]
    for ex in excludes:
        cmd.extend(["--exclude", ex])
    cmd.append(str(wheels[-1]))
    try:
        _run(cmd)
    except subprocess.CalledProcessError as exc:
        print(f"auditwheel repair failed ({exc}); keeping un-repaired wheel", file=sys.stderr)
        return
    for whl in repaired.glob("*.whl"):
        target = wheel_dir / whl.name
        if target.exists():
            target.unlink()
        shutil.move(str(whl), str(target))
    # remove original non-manylinux if repair produced a new name
    for whl in list(wheel_dir.glob("*.whl")):
        if "manylinux" not in whl.name and "musllinux" not in whl.name:
            # keep if repair did not replace
            peers = [
                p
                for p in wheel_dir.glob("*.whl")
                if p != whl and p.stem.split("-")[0:2] == whl.stem.split("-")[0:2]
            ]
            if any("manylinux" in p.name or "musllinux" in p.name for p in wheel_dir.glob("*.whl")):
                # drop linux_x86_64 original when manylinux exists
                if "linux_" in whl.name and "manylinux" not in whl.name:
                    whl.unlink(missing_ok=True)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--out", type=Path, default=ROOT / "artifacts" / "wheels")
    parser.add_argument("--version", default="1.1.1", help="Version stamped on fetch zip name")
    parser.add_argument("--skip-zip", action="store_true")
    parser.add_argument("--skip-auditwheel", action="store_true")
    args = parser.parse_args(argv)

    if not _has_native():
        raise SystemExit(
            f"Missing staged runtime at {NATIVE}/lib/qml — "
            "run scripts/python/stage_native_for_wheel.py first"
        )

    args.out.mkdir(parents=True, exist_ok=True)
    for old in args.out.glob("*.whl"):
        old.unlink()

    _run([sys.executable, "-m", "pip", "install", "-U", "build", "wheel", "packaging"], cwd=ROOT)
    env = os.environ.copy()
    # Ensure package data under _native is included
    _run(
        [sys.executable, "-m", "build", "--wheel", "--outdir", str(args.out.resolve())],
        cwd=PYTHON_PKG,
        env=env,
    )

    if platform.system() == "Linux" and not args.skip_auditwheel:
        _run([sys.executable, "-m", "pip", "install", "-U", "auditwheel"], cwd=ROOT)
        _auditwheel_repair(args.out)

    if not args.skip_zip:
        zpath = _make_fetch_zip(args.out, args.version)
        print(f"Fetch zip: {zpath}")

    print("Wheels:")
    for whl in sorted(args.out.glob("*.whl")):
        print(" ", whl)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
