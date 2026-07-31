"""Run a QML application that imports the packaged Md3 module."""

from __future__ import annotations

import sys
from dataclasses import dataclass, field
from pathlib import Path
from typing import List, Optional, Sequence, Union

from .binding import Binding, detect_binding, import_qt
from .paths import PathLike, resolve_md3_prefix, setup_native_paths


@dataclass
class RunOptions:
    organization: str = "Md3"
    application_name: str = "Md3 App"
    application_version: str = "1.0.0"
    style: str = "Basic"
    alpha_buffer: bool = True
    desktop_file_name: str = ""
    """Prefer PySide6 or PySide2 (None = auto)."""
    binding: Optional[str] = None
    """Shared Md3 install prefix (lib/qml). None = auto-discover / MD3_PREFIX."""
    md3_prefix: Optional[PathLike] = None
    """Require Qt6 / PySide6 when loading Md3 (default True)."""
    require_qt6_for_md3: bool = True
    extra_import_paths: Sequence[PathLike] = field(default_factory=list)


def _sanitize_desktop_id(name: str) -> str:
    safe = []
    for ch in name.strip():
        o = ord(ch)
        if (65 <= o <= 90) or (97 <= o <= 122) or (48 <= o <= 57):
            safe.append(ch)
        else:
            safe.append("_")
    out = "".join(safe)
    while "__" in out:
        out = out.replace("__", "_")
    return out.strip("_") or "Md3_App"


def run(
    qml: PathLike,
    *,
    argv: Optional[List[str]] = None,
    opts: Optional[RunOptions] = None,
) -> int:
    """
    Bootstrap QGuiApplication + QQmlApplicationEngine and load a QML file.

    ``qml`` may be a .qml file path. The file should ``import Md3``.
    """
    opts = opts or RunOptions()
    argv = list(sys.argv if argv is None else argv)
    qml_path = Path(qml).resolve()
    if not qml_path.is_file():
        raise FileNotFoundError(f"QML entry not found: {qml_path}")

    binding = detect_binding(opts.binding)
    if opts.require_qt6_for_md3 and binding.qt_major < 6:
        raise RuntimeError(
            "The Md3 QML module is built for Qt 6 and must be loaded with PySide6.\n"
            f"Detected {binding.name} (Qt {binding.qt_major}).\n"
            "  pip install PySide6\n"
            "PySide2 remains supported by this bootstrap API for future Qt5 stage-2 "
            "packages; set RunOptions.require_qt6_for_md3=False only for non-Md3 QML."
        )

    prefix = resolve_md3_prefix(opts.md3_prefix, start=qml_path.parent)
    import_paths = setup_native_paths(prefix, extra_import_paths=opts.extra_import_paths)
    # App directory so local qmldir / siblings resolve if needed
    import_paths.append(str(qml_path.parent))

    binding, qt = import_qt(binding)

    if opts.alpha_buffer:
        qt.QQuickWindow.setDefaultAlphaBuffer(True)

    app = qt.QGuiApplication(argv)
    qt.QCoreApplication.setOrganizationName(opts.organization)
    qt.QCoreApplication.setApplicationName(opts.application_name)
    qt.QCoreApplication.setApplicationVersion(opts.application_version)

    if opts.style:
        qt.QQuickStyle.setStyle(opts.style)

    desk = opts.desktop_file_name or opts.application_name
    desk = _sanitize_desktop_id(desk)
    # Qt6 API; ignore if missing on older bindings
    set_desk = getattr(app, "setDesktopFileName", None)
    if callable(set_desk):
        set_desk(desk)

    engine = qt.QQmlApplicationEngine()
    for p in import_paths:
        engine.addImportPath(p)

    url = qt.QUrl.fromLocalFile(str(qml_path))
    engine.load(url)
    roots = engine.rootObjects()
    if not roots:
        print(
            "Failed to load QML. Check MD3_PREFIX, that Md3 was built shared against "
            f"the same Qt major as {binding.name}, and that lib/qml/Md3 exists.",
            file=sys.stderr,
        )
        print(f"  binding={binding.name}  prefix={prefix}", file=sys.stderr)
        print(f"  importPaths={import_paths}", file=sys.stderr)
        return 1

    return app.exec() if hasattr(app, "exec") else app.exec_()
