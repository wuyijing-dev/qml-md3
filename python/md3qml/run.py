"""Run a QML application that imports the packaged Md3 module."""

from __future__ import annotations

import sys
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Dict, List, Optional, Sequence

from .paths import PathLike


@dataclass
class RunOptions:
    organization: str = "Md3"
    application_name: str = "Md3 App"
    application_version: str = "1.0.0"
    style: str = "Basic"
    alpha_buffer: bool = True
    desktop_file_name: str = ""
    """Windows AppUserModelID (informational for PySide path; C ABI sets via Md3)."""
    app_user_model_id: str = ""
    """Prefer PySide6 (None = auto)."""
    binding: Optional[str] = None
    """Shared Md3 install prefix (lib/qml). None = auto-discover / MD3_PREFIX."""
    md3_prefix: Optional[PathLike] = None
    """Require Qt6 / PySide6 when loading Md3 (default True)."""
    require_qt6_for_md3: bool = True
    extra_import_paths: Sequence[PathLike] = field(default_factory=list)
    """Values exposed on the QML root context before load."""
    context_properties: Dict[str, Any] = field(default_factory=dict)
    """If set, use engine.loadFromModule(uri, component) instead of a file path."""
    module_uri: str = ""
    module_component: str = "Main"
    """When prefix is missing, download a shared zip via md3qml.fetch (network)."""
    auto_fetch: bool = False
    fetch_version: str = "1.0.0"
    fetch_dest: str = "~/.md3/prefix"
    fetch_url: Optional[str] = None


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
    qml: Optional[PathLike] = None,
    *,
    argv: Optional[List[str]] = None,
    opts: Optional[RunOptions] = None,
) -> int:
    """
    Bootstrap QGuiApplication + QQmlApplicationEngine.

    Pass a ``.qml`` file path, or set ``opts.module_uri`` / ``module_component``.
    """
    from .app import Md3Application

    opts = opts or RunOptions()
    app = Md3Application(opts, argv=argv)
    if opts.module_uri:
        app.prepare_imports(start=Path.cwd())
        ok = app.load_module(opts.module_uri, opts.module_component or "Main")
    else:
        if qml is None:
            raise ValueError("qml path is required unless opts.module_uri is set")
        ok = app.load_file(qml)
    if not ok:
        print(
            "Failed to load QML. Check MD3_PREFIX / bundled _native and Qt ABI vs PySide.",
            file=sys.stderr,
        )
        print(f"  binding={app.binding.name}  prefix={app._prefix}", file=sys.stderr)
        print(f"  importPaths={app._import_paths}", file=sys.stderr)
        return 1
    return app.exec()
