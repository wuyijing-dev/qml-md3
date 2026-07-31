"""Doctor / diagnostics for Md3 + PySide installs."""

from __future__ import annotations

import os
import sys
from pathlib import Path
from typing import List, Tuple

from .binding import detect_binding
from .paths import bundled_prefix, resolve_md3_prefix


def doctor(*, md3_prefix: str | None = None) -> Tuple[int, List[str]]:
    """
    Return (exit_code, lines). exit_code 0 = healthy enough to try loading Md3.
    """
    lines: List[str] = []
    ok = True

    try:
        b = detect_binding()
        lines.append(f"OK  binding={b.name} qt_major={b.qt_major}")
        if b.qt_major < 6:
            lines.append("WARN Md3 QML module requires Qt 6 / PySide6 today")
            ok = False
    except ImportError as exc:
        lines.append(f"FAIL no PySide6/PySide2: {exc}")
        return 1, lines

    bundled = bundled_prefix()
    if bundled:
        lines.append(f"OK  bundled _native={bundled}")
    else:
        lines.append("INFO no wheel-bundled _native (ok if using MD3_PREFIX / fetch)")

    env = os.environ.get("MD3_PREFIX") or os.environ.get("MD3_ROOT")
    if env:
        lines.append(f"INFO MD3_PREFIX={env}")

    try:
        prefix = resolve_md3_prefix(md3_prefix)
        lines.append(f"OK  prefix={prefix}")
        qml = prefix / "lib" / "qml" / "Md3"
        if qml.is_dir():
            lines.append(f"OK  module dir={qml}")
            qmldir = qml / "qmldir"
            if qmldir.is_file():
                lines.append(f"OK  qmldir present ({qmldir.stat().st_size} bytes)")
            else:
                lines.append("FAIL missing qmldir")
                ok = False
        else:
            # Some layouts use lib/qml only
            if (prefix / "lib" / "qml").is_dir():
                lines.append(f"WARN lib/qml exists but Md3/ subfolder missing: {prefix / 'lib' / 'qml'}")
            else:
                lines.append("FAIL missing lib/qml/Md3")
                ok = False

        if sys.platform == "win32":
            dll = prefix / "bin" / "Md3.dll"
            plug = prefix / "bin" / "Md3plugin.dll"
            if not dll.is_file():
                # plugin-only layouts
                lines.append("WARN bin/Md3.dll not found (check install layout)")
            else:
                lines.append(f"OK  {dll.name}")
            if plug.is_file() or any((prefix / "lib" / "qml" / "Md3").glob("*plugin*")):
                lines.append("OK  QML plugin binary present")
            else:
                lines.append("WARN Md3plugin not found next to bin/ or qmldir")
        else:
            libs = list((prefix / "lib").glob("libMd3.so*"))
            if libs:
                lines.append(f"OK  {libs[0].name}")
            else:
                lines.append("WARN libMd3.so* not found under lib/")
    except FileNotFoundError as exc:
        lines.append(f"FAIL prefix: {exc}")
        ok = False
        prefix = None
    else:
        # C ABI (Rust / run-c)
        try:
            from .capi import load_md3_library

            lib = load_md3_library(prefix)
            has_run = hasattr(lib, "md3_run_qml_file")
            has_ver = hasattr(lib, "md3_version_string")
            if has_run and has_ver:
                lines.append("OK  C ABI md3_run_qml_file / md3_version_string")
            else:
                lines.append("WARN Md3 loaded but C ABI symbols missing — rebuild shared Md3")
        except Exception as exc:  # noqa: BLE001 — doctor should never crash
            lines.append(f"WARN C ABI load: {exc}")

    lines.append("INFO CLI: pip install -e ./python   then  md3qml doctor")
    lines.append("INFO or:  python -m md3qml doctor")
    lines.append("INFO native: app.native → WindowHelper (C++ Md3WindowHelper)")
    lines.append("OK  doctor finished" if ok else "FAIL doctor found blocking issues")
    return (0 if ok else 1), lines
