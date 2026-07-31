"""Optional ctypes bridge to libMd3 C ABI (md3_capi.h) when a shared build is present."""

from __future__ import annotations

import ctypes
import os
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import List, Optional

from .paths import PathLike, resolve_md3_prefix


@dataclass
class CRunConfig:
    organization: str = "Md3"
    application_name: str = "Md3 App"
    application_version: str = "1.0.0"
    style: str = "Basic"
    desktop_file_name: str = ""
    app_user_model_id: str = ""
    qml_import_path: str = ""
    alpha_buffer: bool = True
    load_fonts: bool = True


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


def load_md3_library(prefix: Optional[PathLike] = None) -> ctypes.CDLL:
    root = resolve_md3_prefix(prefix)
    if sys.platform == "win32":
        bin_dir = root / "bin"
        if bin_dir.is_dir() and hasattr(os, "add_dll_directory"):
            os.add_dll_directory(str(bin_dir))
    for cand in _lib_candidates(root):
        try:
            return ctypes.CDLL(str(cand))
        except OSError:
            continue
    raise FileNotFoundError(f"Could not load libMd3 from {root}")


def run_qml_file_c(
    qml_file: PathLike,
    *,
    argv: Optional[List[str]] = None,
    config: Optional[CRunConfig] = None,
    md3_prefix: Optional[PathLike] = None,
) -> int:
    """
    Call ``md3_run_qml_file`` from the shared library (needs Qt on PATH / rpath).

    Prefer the PySide ``run()`` host for day-to-day apps; this path matches Rust/C hosts.
    """
    import sys as _sys

    qml_path = Path(qml_file).resolve()
    if not qml_path.is_file():
        raise FileNotFoundError(qml_path)

    cfg = config or CRunConfig()
    prefix = resolve_md3_prefix(md3_prefix, start=qml_path.parent)
    if not cfg.qml_import_path:
        cfg.qml_import_path = str(prefix / "lib" / "qml")

    lib = load_md3_library(prefix)
    fn = lib.md3_run_qml_file
    fn.argtypes = [ctypes.c_int, ctypes.POINTER(ctypes.c_char_p), ctypes.c_char_p, ctypes.POINTER(_Md3RunConfig)]
    fn.restype = ctypes.c_int

    args = list(_sys.argv if argv is None else argv)
    if not args:
        args = ["md3qml"]
    c_argv = (ctypes.c_char_p * len(args))(*[a.encode("utf-8") for a in args])

    def b(s: str) -> bytes:
        return s.encode("utf-8")

    c_cfg = _Md3RunConfig(
        organization=b(cfg.organization),
        application_name=b(cfg.application_name),
        application_version=b(cfg.application_version),
        style=b(cfg.style),
        desktop_file_name=b(cfg.desktop_file_name or cfg.application_name),
        app_user_model_id=b(cfg.app_user_model_id) if cfg.app_user_model_id else None,
        qml_import_path=b(cfg.qml_import_path),
        alpha_buffer=1 if cfg.alpha_buffer else 0,
        load_fonts=1 if cfg.load_fonts else 0,
    )
    return int(fn(len(args), c_argv, str(qml_path).encode("utf-8"), ctypes.byref(c_cfg)))
