"""Optional ctypes bridge to libMd3 C ABI (md3_capi.h) — kept in sync with Rust md3qml."""

from __future__ import annotations

import ctypes
import os
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import List, Optional, Sequence

from .paths import PathLike, resolve_md3_prefix


@dataclass
class CRunConfig:
    """Mirrors ``Md3RunConfig`` / Rust ``RunOptions`` (C ABI path)."""

    organization: str = "Md3"
    application_name: str = "Md3 App"
    application_version: str = "1.0.0"
    style: str = "Basic"
    desktop_file_name: str = ""
    app_user_model_id: str = ""
    qml_import_path: str = ""
    alpha_buffer: bool = True
    load_fonts: bool = True
    print_banner: bool = False


class _Md3RunConfig(ctypes.Structure):
    _fields_ = [
        ("organization", ctypes.c_char_p),
        ("application_name", ctypes.c_char_p),
        ("application_version", ctypes.c_char_p),
        ("style", ctypes.c_char_p),
        ("desktop_file_name", ctypes.c_char_p),
        ("app_user_model_id", ctypes.c_char_p),
        ("qml_import_path", ctypes.c_char_p),
        ("alpha_buffer", ctypes.c_int),
        ("load_fonts", ctypes.c_int),
        ("print_banner", ctypes.c_int),
    ]


def _lib_candidates(prefix: Path) -> List[Path]:
    out: List[Path] = []
    if sys.platform == "win32":
        out.extend(
            [
                prefix / "bin" / "Md3.dll",
                prefix / "lib" / "Md3.dll",
            ]
        )
    elif sys.platform == "darwin":
        out.extend(sorted((prefix / "lib").glob("libMd3*.dylib")))
    else:
        out.extend(sorted((prefix / "lib").glob("libMd3.so*")))
    return [p for p in out if p.is_file()]


def discover_qt_bin_dirs() -> List[Path]:
    """Locate Qt ``bin/`` (same order as Rust ``discover_qt_bin_dirs``)."""
    out: List[Path] = []
    seen: set[str] = set()

    def add(p: Path) -> None:
        try:
            p = p.resolve()
        except OSError:
            return
        if p.is_dir() and str(p) not in seen:
            seen.add(str(p))
            out.append(p)

    def try_bin(root: Path) -> None:
        if root.name.lower() == "bin":
            add(root)
        else:
            add(root / "bin")

    for key in ("QTDIR", "QT_DIR"):
        raw = os.environ.get(key, "").strip()
        if raw:
            try_bin(Path(raw))
            if out:
                return out

    qt6 = os.environ.get("Qt6_DIR", "").strip()
    if qt6:
        root = Path(qt6)
        try:
            # …/lib/cmake/Qt6 → kit prefix
            try_bin(root.parents[2])
        except IndexError:
            pass
        if out:
            return out

    cpp = os.environ.get("CMAKE_PREFIX_PATH", "")
    for part in cpp.split(os.pathsep):
        if part.strip():
            try_bin(Path(part.strip()))
            if out:
                return out

    for part in os.environ.get("PATH", "").split(os.pathsep):
        if not part:
            continue
        p = Path(part)
        if (p / "Qt6Core.dll").is_file() or (p / "Qt6Core.so").is_file():
            add(p)
            return out
    return out


def _qt_bin_dirs() -> List[Path]:
    return discover_qt_bin_dirs()


def _prepare_qt_env(prefix: Path) -> None:
    """Align PATH / plugin / QML import with Rust ``prepare_native_load``."""
    qml_import = prefix / "lib" / "qml"
    if qml_import.is_dir():
        cur = os.environ.get("QML2_IMPORT_PATH", "")
        s = str(qml_import)
        if not cur:
            os.environ["QML2_IMPORT_PATH"] = s
        elif s not in cur.split(os.pathsep):
            os.environ["QML2_IMPORT_PATH"] = s + os.pathsep + cur

    if sys.platform != "win32":
        return

    bins = discover_qt_bin_dirs()
    path = os.environ.get("PATH", "")
    for d in reversed([prefix / "bin", *bins]):
        if not d.is_dir():
            continue
        if hasattr(os, "add_dll_directory"):
            try:
                os.add_dll_directory(str(d))
            except OSError:
                pass
        if str(d) not in path.split(os.pathsep):
            path = str(d) + os.pathsep + path
        parent = d.parent
        plugins = parent / "plugins"
        if plugins.is_dir() and not os.environ.get("QT_PLUGIN_PATH"):
            os.environ["QT_PLUGIN_PATH"] = str(plugins)
        qt_qml = parent / "qml"
        if qt_qml.is_dir():
            cur = os.environ.get("QML2_IMPORT_PATH", "")
            s = str(qt_qml)
            if not cur:
                os.environ["QML2_IMPORT_PATH"] = s
            elif s not in cur.split(os.pathsep):
                os.environ["QML2_IMPORT_PATH"] = cur + os.pathsep + s
    os.environ["PATH"] = path


def load_md3_library(prefix: Optional[PathLike] = None) -> ctypes.CDLL:
    root = resolve_md3_prefix(prefix)
    _prepare_qt_env(root)
    for cand in _lib_candidates(root):
        try:
            return ctypes.CDLL(str(cand))
        except OSError:
            continue
    raise FileNotFoundError(
        f"Could not load libMd3 from {root} "
        "(set QTDIR to the Qt kit that built Md3, and rebuild if C ABI symbols are missing)"
    )


def _encode_cfg(cfg: CRunConfig) -> tuple[_Md3RunConfig, list[bytes]]:
    """Keep encoded bytes alive for the duration of the C call."""
    keep: list[bytes] = []

    def b(s: str) -> bytes:
        raw = s.encode("utf-8")
        keep.append(raw)
        return raw

    desk = cfg.desktop_file_name or cfg.application_name
    aumid = b(cfg.app_user_model_id) if cfg.app_user_model_id else None
    c_cfg = _Md3RunConfig(
        organization=b(cfg.organization),
        application_name=b(cfg.application_name),
        application_version=b(cfg.application_version),
        style=b(cfg.style),
        desktop_file_name=b(desk),
        app_user_model_id=aumid,
        qml_import_path=b(cfg.qml_import_path) if cfg.qml_import_path else None,
        alpha_buffer=1 if cfg.alpha_buffer else 0,
        load_fonts=1 if cfg.load_fonts else 0,
        print_banner=1 if cfg.print_banner else 0,
    )
    return c_cfg, keep


def run_qml_file_c(
    qml_file: PathLike,
    *,
    argv: Optional[List[str]] = None,
    config: Optional[CRunConfig] = None,
    md3_prefix: Optional[PathLike] = None,
) -> int:
    """
    Call ``md3_run_qml_file`` from the shared library (needs Qt on PATH / rpath).

    Same entry as Rust ``md3qml::run_qml_file``. Prefer PySide ``run()`` for day-to-day apps.
    """
    qml_path = Path(qml_file).resolve()
    if not qml_path.is_file():
        raise FileNotFoundError(qml_path)

    cfg = config or CRunConfig()
    prefix = resolve_md3_prefix(md3_prefix, start=qml_path.parent)
    if not cfg.qml_import_path:
        cfg.qml_import_path = str(prefix / "lib" / "qml")

    lib = load_md3_library(prefix)
    fn = lib.md3_run_qml_file
    fn.argtypes = [
        ctypes.c_int,
        ctypes.POINTER(ctypes.c_char_p),
        ctypes.c_char_p,
        ctypes.POINTER(_Md3RunConfig),
    ]
    fn.restype = ctypes.c_int

    args = list(sys.argv if argv is None else argv)
    if not args:
        args = ["md3qml"]
    c_argv = (ctypes.c_char_p * len(args))(*[a.encode("utf-8") for a in args])
    c_cfg, _keep = _encode_cfg(cfg)
    return int(fn(len(args), c_argv, str(qml_path).encode("utf-8"), ctypes.byref(c_cfg)))


def run_qml_module_c(
    module_uri: str,
    main_component: str = "Main",
    *,
    argv: Optional[List[str]] = None,
    config: Optional[CRunConfig] = None,
    md3_prefix: Optional[PathLike] = None,
) -> int:
    """Call ``md3_run_qml_module`` — mirrors Rust ``run_qml_module`` / C++ ``Md3::run``."""
    if not module_uri:
        raise ValueError("module_uri is required")

    cfg = config or CRunConfig()
    prefix = resolve_md3_prefix(md3_prefix)
    if not cfg.qml_import_path:
        cfg.qml_import_path = str(prefix / "lib" / "qml")

    lib = load_md3_library(prefix)
    fn = lib.md3_run_qml_module
    fn.argtypes = [
        ctypes.c_int,
        ctypes.POINTER(ctypes.c_char_p),
        ctypes.c_char_p,
        ctypes.c_char_p,
        ctypes.POINTER(_Md3RunConfig),
    ]
    fn.restype = ctypes.c_int

    args = list(sys.argv if argv is None else argv)
    if not args:
        args = ["md3qml"]
    c_argv = (ctypes.c_char_p * len(args))(*[a.encode("utf-8") for a in args])
    c_cfg, _keep = _encode_cfg(cfg)
    return int(
        fn(
            len(args),
            c_argv,
            module_uri.encode("utf-8"),
            (main_component or "Main").encode("utf-8"),
            ctypes.byref(c_cfg),
        )
    )


def version_string_c(md3_prefix: Optional[PathLike] = None) -> str:
    """Call ``md3_version_string`` — mirrors Rust ``version_string``."""
    lib = load_md3_library(md3_prefix)
    fn = lib.md3_version_string
    fn.argtypes = []
    fn.restype = ctypes.c_char_p
    raw = fn()
    if not raw:
        return ""
    return raw.decode("utf-8", errors="replace")
