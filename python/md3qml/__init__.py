"""Bootstrap helpers to load the packaged Md3 QML module from PySide6 / PySide2."""

from .app import Md3Application
from .binding import Binding, detect_binding, import_qt
from .capi import CRunConfig, load_md3_library, run_qml_file_c
from .doctor import doctor
from .fetch import fetch_md3_prefix
from .paths import bundled_prefix, resolve_md3_prefix, setup_native_paths
from .run import RunOptions, run

__all__ = [
    "Binding",
    "CRunConfig",
    "Md3Application",
    "RunOptions",
    "bundled_prefix",
    "detect_binding",
    "doctor",
    "fetch_md3_prefix",
    "import_qt",
    "load_md3_library",
    "resolve_md3_prefix",
    "run",
    "run_qml_file_c",
    "setup_native_paths",
]

__version__ = "1.0.0"
